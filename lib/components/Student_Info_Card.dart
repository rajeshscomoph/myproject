import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:myproject/models/student.dart';

class StudentInfoCard extends StatefulWidget {
  final Student student;
  final void Function(String newExamination)? onExaminationChanged;

  const StudentInfoCard({
    super.key,
    required this.student,
    this.onExaminationChanged,
  });

  @override
  State<StudentInfoCard> createState() => _StudentInfoCardState();
}

class _StudentInfoCardState extends State<StudentInfoCard> {

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.sp)),
      child: Padding(
        padding: EdgeInsets.all(12.sp),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoTile(Icons.person_outline, 'Name', widget.student.name),
            _infoTile(
              Icons.confirmation_number,
              'Enrollment No.',
              widget.student.enrollNo,
            ),
            _infoTile(
              Icons.format_list_numbered,
              'Roll No.',
              widget.student.rollNumber.toString(),
            ),
            _infoTile(Icons.wc, 'Gender', widget.student.gender),
            _infoTile(Icons.wc, 'Examination Status', widget.student.examination)
          ],
        ),
      ),
    );
  }

  Widget _infoTile(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 17.sp, color: Colors.blueGrey),
          SizedBox(width: 2.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 16.sp, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
