import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FooterInfoComponent extends StatelessWidget {
  final String contactInfo;
  final String copyright;

  const FooterInfoComponent({
    super.key,
    required this.contactInfo,
    required this.copyright,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: [
        Center(
          child: Text(
            contactInfo,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: colorScheme.secondary),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: 1.h),
        Center(
          child: Text(
            copyright,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurface.withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
