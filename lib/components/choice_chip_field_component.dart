import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ChoiceChipFieldComponent<T> extends StatelessWidget {
  final String label;
  final List<T> options;
  final T? selected;
  final void Function(T) onSelected;
  final String Function(T) labelBuilder;

  const ChoiceChipFieldComponent({
    super.key,
    required this.label,
    required this.options,
    required this.selected,
    required this.onSelected,
    required this.labelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17.sp),
          ),
          SizedBox(height: 0.5.h),
          Wrap(
            spacing: 8.sp,
            children: options.map((option) {
              final isSelected = option == selected;
              return ChoiceChip(
                label: Text(labelBuilder(option)),
                selected: isSelected,
                onSelected: (_) => onSelected(option),
                selectedColor: Theme.of(context).colorScheme.primary,
                labelStyle: TextStyle(color: isSelected ? Colors.white : null),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
