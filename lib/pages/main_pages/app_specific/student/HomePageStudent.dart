import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/components/school_info_card.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/models/student.dart';
import 'package:myproject/pages/main_pages/app_specific/student/student_demographics_screen.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class HomePageAfterSection extends StatefulWidget {
  final int schoolCode;
  final String className;
  final String section;
  final IsarService isarService;

  const HomePageAfterSection({
    super.key,
    required this.schoolCode,
    required this.className,
    required this.section,
    required this.isarService,
  });

  @override
  State<HomePageAfterSection> createState() => _HomePageAfterSectionState();
}

class _HomePageAfterSectionState extends State<HomePageAfterSection> {
  late School school;
  bool isLoading = true;

  final List<String> _examinationOptions = [
    'All',
    'Examined',
    'Absent',
    'Refused',
    'Referred',
  ];
  String _selectedExamination = 'All';
  final TextEditingController _searchController = TextEditingController();
  List<Student> _allStudents = [];
  List<Student> _filteredStudents = [];

  final int _pageSize = 20;
  int _currentPage = 1;
  late ScrollController _scrollController;
  List<Student> _paginatedStudents = [];
  final String contactInfo = "Help Line: 011-26593140";
  final String copyright = "© 2025 Community Ophthalmology";

  int get _totalPages => (_filteredStudents.length / _pageSize)
      .ceil()
      .clamp(1, double.infinity)
      .toInt();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    _loadSchool();
    _searchController.addListener(_applyFilters);
  }

  Future<void> _loadSchool() async {
    final fetchedSchool = await widget.isarService.getSchoolByCode(
      widget.schoolCode,
    );
    if (fetchedSchool != null) {
      setState(() {
        school = fetchedSchool;
        isLoading = false;
      });
      _loadStudents();
    }
  }

  Future<void> _loadStudents() async {
    final db = await widget.isarService.db;
    final students = await db.students.where().findAll();

    setState(() {
      _allStudents = students
          .where(
            (s) =>
                s.school.value?.schoolCode == widget.schoolCode &&
                s.className == widget.className &&
                s.section == widget.section,
          )
          .toList();
    });

    _applyFilters();
  }

  void _applyFilters() {
    final query = _searchController.text.trim().toLowerCase();

    final results = _allStudents.where((student) {
      final matchesSearch =
          student.name.toLowerCase().contains(query) ||
          student.rollNumber.toString().contains(query);

      final matchesExam = _selectedExamination == 'All'
          ? true
          : _selectedExamination == 'Referred'
          ? _isRefractionReferred(student)
          : student.examination == _selectedExamination;

      return matchesSearch && matchesExam;
    }).toList();

    setState(() {
      _filteredStudents = results;
      _currentPage = 1;
      _updatePaginatedList();
    });
  }

bool _isRefractionReferred(Student student) {
    const refractionReasons = [
      'Yes, as child uses glasses/ Contact Lens',
      'Yes Unaided Vision <6/9 in any eye',
    ];
    return refractionReasons.contains(student.referred);
  }

  void _updatePaginatedList() {
    final start = (_currentPage - 1) * _pageSize;
    final end = (_currentPage * _pageSize).clamp(0, _filteredStudents.length);
    _paginatedStudents = _filteredStudents.sublist(start, end);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreStudents();
    }
  }

  void _loadMoreStudents() {
    final nextPage = _currentPage + 1;
    final startIndex = _pageSize * _currentPage;
    final endIndex = startIndex + _pageSize;
    final newItems = _filteredStudents
        .skip(startIndex)
        .take(_pageSize)
        .toList();

    if (newItems.isNotEmpty) {
      setState(() {
        _paginatedStudents.addAll(newItems);
        _currentPage = nextPage;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: appbarComponent(context),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.sp, 12.sp, 16.sp, 10.sp),
                children: [
                  SchoolInfoCard(
                    school: school,
                    className: widget.className,
                    section: widget.section,
                  ),

                  SizedBox(height: 3.h),

                  _buildStudentActions(context, colorScheme),
                  SizedBox(height: 4.h),
                  Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.support_agent,
                          size: 20.sp,
                          color: colorScheme.secondary,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          contactInfo,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.secondary),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          copyright,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: colorScheme.onSurface.withOpacity(0.6),
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  final Set<int> _selectedIds = {};
  
  get student => null;

  Map<String, int> _getStatusCounts() {
    final counts = <String, int>{
      'All': _allStudents.length,
      'Examined': 0,
      'Absent': 0,
      'Refused': 0,
      'Referred': 0, // new
    };

    for (final student in _allStudents) {
      final status = student.examination;
      if (counts.containsKey(status)) {
        counts[status] = counts[status]! + 1;
      }

      if (_isRefractionReferred(student)) {
        counts['Referred'] = counts['Referred']! + 1;
      }
    }

    return counts;
  }

  Widget _buildStudentActions(BuildContext context, ColorScheme colorScheme) {
    final selectionMode = _selectedIds.isNotEmpty;
    final statusCounts = _getStatusCounts();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ElevatedButton.icon(
          onPressed: () async {
            Navigator.push(
  context,
  MaterialPageRoute(
    builder: (_) => StudentDemographicScreen(
      className: widget.className,
      section: widget.section,
      school: school,
      isarService: widget.isarService,
      existingStudent: student,
    ),
  ),
);
            await _loadStudents(); // Refresh after return
          },
          icon: const Icon(Icons.person_add),
          label: const Text('Add Student'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 14.sp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.sp),
            ),
          ),
        ),

        SizedBox(height: 2.h),

        TextField(
          controller: _searchController,
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(),
            hintText: 'Search by name or roll number',
          ),
        ),
        SizedBox(height: 1.5.h),

        Wrap(
          spacing: 8.sp,
          children: _examinationOptions.map((status) {
            final isSelected = _selectedExamination == status;
            final icon = status == 'Examined'
                ? Icons.check_circle
                : status == 'Absent'
                ? Icons.cancel
                : status == 'Refused'
                ? Icons.block
                : Icons.list;
            return ChoiceChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 18, color: isSelected ? Colors.white : null),
                  const SizedBox(width: 4),
                  Text('$status (${statusCounts[status] ?? 0})'),
                ],
              ),
              selected: isSelected,
              onSelected: (_) {
                setState(() {
                  _selectedExamination = status;
                  _applyFilters();
                });
              },
              selectedColor: colorScheme.primary,
              labelStyle: TextStyle(color: isSelected ? Colors.white : null),
            );
          }).toList(),
        ),

        SizedBox(height: 2.h),
        if (_filteredStudents.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 1
                      ? () => setState(() {
                          _currentPage--;
                          _updatePaginatedList();
                        })
                      : null,
                ),
                Text('Page $_currentPage of $_totalPages'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < _totalPages
                      ? () => setState(() {
                          _currentPage++;
                          _updatePaginatedList();
                        })
                      : null,
                ),
              ],
            ),
          ),
        SizedBox(height: 1.h),
        if (_filteredStudents.isEmpty)
          const Text('No matching students found.')
        else
          ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _paginatedStudents.length,
            itemBuilder: (context, index) {
              final student = _paginatedStudents[index];
              final selected = _selectedIds.contains(student.id);

              return Dismissible(
                key: Key(student.id.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 20),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Delete Student'),
                      content: Text(
                        'Are you sure you want to delete ${student.name}?',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );
                  return confirm ?? false;
                },
                onDismissed: (_) async {
                  await widget.isarService.deleteStudent(student.id);
                  await _loadStudents();
                },
                child: GestureDetector(
                  onLongPress: () {
                    setState(() => _selectedIds.add(student.id));
                  },
                  onTap: () {
                    if (_selectedIds.isNotEmpty) {
                      setState(() {
                        if (selected) {
                          _selectedIds.remove(student.id);
                        } else {
                          _selectedIds.add(student.id);
                        }
                      });
                    }
                  },
                  child: Card(
                    color: selected
                        ? colorScheme.primary.withOpacity(0.2)
                        : null,
                    child: ListTile(
                      leading: _selectedIds.isNotEmpty
                          ? Checkbox(
                              value: selected,
                              onChanged: (_) {
                                setState(() {
                                  if (selected) {
                                    _selectedIds.remove(student.id);
                                  } else {
                                    _selectedIds.add(student.id);
                                  }
                                });
                              },
                            )
                          : null,
                      title: Text('Student Name: ${student.name}'),
                      subtitle: Text('Roll No: ${student.rollNumber}'),
                      trailing: Text('Status: ${student.examination}'),
                    ),
                  ),
                ),
              );
            },
          ),
        if (_filteredStudents.isNotEmpty)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: _currentPage > 1
                      ? () => setState(() {
                          _currentPage--;
                          _updatePaginatedList();
                        })
                      : null,
                ),
                Text('Page $_currentPage of $_totalPages'),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: _currentPage < _totalPages
                      ? () => setState(() {
                          _currentPage++;
                          _updatePaginatedList();
                        })
                      : null,
                ),
              ],
            ),
          ),
        SizedBox(height: 1.h),
        if (selectionMode)
          Padding(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Wrap(
              spacing: 0.5.w,
              runSpacing: 1.h,
              alignment: WrapAlignment.spaceBetween,
              children: [
                
                if (_selectedIds.length == 1)
                  SizedBox(
                    width: 90.w / (_selectedIds.length == 1 ? 2:2 ),
                    height: 9.h,

                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Update'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 15.sp),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Edit'),
                            content: const Text(
                              'Are you sure you want to update the selected student?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Update'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          final studentId = _selectedIds.first;
                          final student = _filteredStudents.firstWhere(
                            (s) => s.id == studentId,
                          );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => StudentDemographicScreen(
                                className: widget.className,
                                section: widget.section,
                                school: school,
                                isarService: widget.isarService,
                                existingStudent:
                                    student, // This should be handled in your StudentDetailScreen
                              ),
                            ),
                          ).then((_) async {
                            
                            await _loadStudents(); // Reload after update
                            setState(() => _selectedIds.clear());
                          });

                        }
                      },
                    ),
                  ),
                if (_selectedIds.isNotEmpty)
                  SizedBox(
                    width: _selectedIds.length == 1 ? 90.w / 2 : 90.w,
                    height: 9.h,

                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.delete),
                      label: Text('Delete (${_selectedIds.length})'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15.sp),
                      ),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Confirm Delete'),
                            content: Text(
                              'Are you sure you want to delete ${_selectedIds.length} selected student(s)?',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              ElevatedButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Delete'),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          await widget.isarService.deleteMultipleStudents(
                            _selectedIds.toList(),
                          );
                          await _loadStudents();
                          setState(() => _selectedIds.clear());
                        }
                      },
                    ),
                  ),
              ],
            ),
          ),
        SizedBox(height: 2.h),

        const Text(
          '* Long-press a Student to select for updating & Deleting or left swipe for delete',
        ),
      ],
    );
  }
}