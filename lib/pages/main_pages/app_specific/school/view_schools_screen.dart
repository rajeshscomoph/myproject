import 'package:flutter/material.dart';
import 'package:myproject/components/appbar_component.dart';
import 'package:myproject/models/school.dart';
import 'package:myproject/pages/main_pages/app_specific/school/add_school_screen.dart';
import 'package:myproject/services/DB/isar_services.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'school_detail_screen.dart';

class ViewSchoolsScreen extends StatefulWidget {
  final IsarService isarService;

  const ViewSchoolsScreen({super.key, required this.isarService});

  @override
  State<ViewSchoolsScreen> createState() => _ViewSchoolsScreenState();
}

class _ViewSchoolsScreenState extends State<ViewSchoolsScreen> {
  List<School> _schools = [];
  List<School> _filteredSchools = [];
  final Set<int> _selectedIds = {};

  bool _isLoading = true;
  String? _error;

  String _searchQuery = '';
  String _selectedType = 'All';
  String _sortOption = 'Name';

  final List<String> _schoolTypes = ['All', 'Govt', 'Private', 'Other'];
  final List<String> _sortOptions = ['Name', 'Code'];

  @override
  void initState() {
    super.initState();
    _loadSchools();
  }

  Future<void> _loadSchools() async {
    try {
      final data = await widget.isarService.getAllSchools();
      setState(() {
        _schools = data;
        _applyFilters();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    List<School> filtered = _schools.where((s) {
      final matchType = _selectedType == 'All' || s.schoolType == _selectedType;
      final query = _searchQuery.toLowerCase();
      final matchQuery =
          s.schoolName.toLowerCase().contains(query) ||
          s.schoolCode.toString().contains(query) ||
          s.schoolType.toLowerCase().contains(query) ||
          s.principalName.toLowerCase().contains(query);
      return matchType && matchQuery;
    }).toList();

    if (_sortOption == 'Name') {
      filtered.sort((a, b) => a.schoolName.compareTo(b.schoolName));
    } else {
      filtered.sort((a, b) => a.schoolCode.compareTo(b.schoolCode));
    }

    setState(() {
      _filteredSchools = filtered;
    });
  }

  Future<void> _deleteSelected() async {
    final idsToDelete = _selectedIds.toList();
    await widget.isarService.deleteMultipleSchools(idsToDelete);
    setState(() {
      _schools.removeWhere((s) => _selectedIds.contains(s.id));
      _filteredSchools.removeWhere((s) => _selectedIds.contains(s.id));
      _selectedIds.clear();
    });
  }

  Future<void> _deleteSchool(int id) async {
    await widget.isarService.deleteSchool(id);
    setState(() {
      _schools.removeWhere((s) => s.id == id);
      _applyFilters();
    });
  }

  void _toggleSelection(int id) {
    setState(() {
      if (_selectedIds.contains(id)) {
        _selectedIds.remove(id);
      } else {
        _selectedIds.add(id);
      }
    });
  }

  bool get _selectionMode => _selectedIds.isNotEmpty;
  bool get _singleSelection => _selectedIds.length == 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 8.h,
        automaticallyImplyLeading: !_selectionMode,
        backgroundColor: colorScheme.secondary,
        title: _selectionMode
            ? Text(
                '${_selectedIds.length} selected',
                style: TextStyle(color: colorScheme.onSecondary),
              )
            : appbarComponent(context).title,
        actions: _selectionMode
            ? [if (_singleSelection)
            IconButton(
              icon: const Icon(Icons.edit),
              color: colorScheme.onSecondary,
              onPressed: () {
                final selectedId = _selectedIds.first;
                final selectedSchool =
                    _schools.firstWhere((s) => s.id == selectedId);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddSchoolScreen(
                      isarService: widget.isarService,
                      existingSchool: selectedSchool,
                    ),
                  ),
                ).then((_) {
                  _loadSchools(); // refresh after update
                });
              },
            ),
               
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: colorScheme.onSecondary,
                  onPressed: () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Delete'),
                        content: Text(
                          'Are you sure you want to delete ${_selectedIds.length} schools?',
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

                    if (confirm == true) await _deleteSelected();
                  },
                ),
              ]
            : [],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text('Error: $_error'))
          : Column(
              children: [
                SizedBox(height: 10.sp),
                Padding(
                  padding: EdgeInsets.all(10.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Search bar
                      TextField(
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(),
                          hintText: 'Search school',
                        ),
                        onChanged: (value) {
                          _searchQuery = value;
                          _applyFilters();
                        },
                      ),
                      SizedBox(height: 10.sp),
                      // Chip filters
                      Wrap(
                        spacing: 8.sp,
                        children: _schoolTypes.map((type) {
                          final isSelected = _selectedType == type;
                          final icon = type == 'Govt'
                              ? Icons.apartment
                              : type == 'Private'
                              ? Icons.school
                              : type == 'Other'
                              ? Icons.help_outline
                              : Icons.list;

                          return ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  icon,
                                  size: 18,
                                  color: isSelected ? Colors.white : null,
                                ),
                                const SizedBox(width: 4),
                                Text(type),
                              ],
                            ),
                            selected: isSelected,
                            onSelected: (_) {
                              setState(() {
                                _selectedType = type;
                                _applyFilters();
                              });
                            },
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            labelStyle: TextStyle(
                              color: isSelected ? Colors.white : null,
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 10.sp),
                      // Sorting dropdown
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Text("Sort by: "),
                          DropdownButton<String>(
                            value: _sortOption,
                            items: _sortOptions.map((opt) {
                              return DropdownMenuItem(
                                value: opt,
                                child: Text(opt),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                _sortOption = value;
                                _applyFilters();
                              }
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _filteredSchools.isEmpty
                      ? const Center(child: Text('No schools found.'))
                      : ListView.builder(
                          itemCount: _filteredSchools.length,
                          itemBuilder: (context, index) {
                            final s = _filteredSchools[index];
                            final selected = _selectedIds.contains(s.id);

                            return Dismissible(
                              key: Key(s.id.toString()),
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                ),
                              ),
                              confirmDismiss: (_) async {
                                return await showDialog(
                                  context: context,
                                  builder: (_) => AlertDialog(
                                    title: const Text('Delete School'),
                                    content: const Text(
                                      'Are you sure you want to delete this school?',
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: const Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              onDismissed: (_) => _deleteSchool(s.id),
                              child: GestureDetector(
                                onLongPress: () => _toggleSelection(s.id),
                                onTap: () {
                                  if (_selectionMode) {
                                    _toggleSelection(s.id);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            SchoolDetailScreen(school: s),
                                      ),
                                    );
                                  }
                                },
                                child: Card(
                                  margin: EdgeInsets.symmetric(
                                    horizontal: 10.sp,
                                    vertical: 6.sp,
                                  ),
                                  color: selected
                                      ? colorScheme.primary.withOpacity(0.15)
                                      : null,
                                  child: ListTile(
                                    leading: _selectionMode
                                        ? Checkbox(
                                            value: selected,
                                            onChanged: (_) =>
                                                _toggleSelection(s.id),
                                          )
                                        : null,
                                    title: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            s.schoolName,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                        ),
                                        Text(' (${s.schoolType})'),
                                      ],
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text('Principal: ${s.principalName}'),
                                        Text('Phone: ${s.phone1}'),
                                      ],
                                    ),
                                    trailing: Text('Code: ${s.schoolCode}'),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 20.sp),
                  child: const Text(
                    '* Long-press a school to select or left swipe for delete',
                    style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                  ),
                ),
              ],
            ),
    );
  }
}
