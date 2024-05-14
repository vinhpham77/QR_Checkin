import 'package:flutter/material.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/category/dtos/category_dto.dart';

class CategoryDropdown extends StatefulWidget {
  final String label;
  final List<CategoryDto> categories;
  final Function(CategoryDto) onSelected;

  const CategoryDropdown(
      {super.key,
      required this.categories,
      required this.onSelected,
      required this.label});

  @override
  State<CategoryDropdown> createState() => _CategoryDropdownState();
}

class _CategoryDropdownState extends State<CategoryDropdown> {
  final TextEditingController categoryController = TextEditingController();
  CategoryDto? selectedCategory;

  @override
  Widget build(BuildContext context) {
    final List<DropdownMenuEntry<CategoryDto>> categoryEntries =
        widget.categories.map((CategoryDto category) {
      return DropdownMenuEntry<CategoryDto>(
        value: category,
        labelWidget: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '#${category.name}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.black87,
              ),
              maxLines: 1,
            ),
            Text(
              category.description ?? '',
              style: const TextStyle(
                fontSize: 12,
                color: Colors.black45,
              ),
              softWrap: true,
            ),
          ],
        ),
        label: category.name,
      );
    }).toList();

    return DropdownMenu<CategoryDto>(
      controller: categoryController,
      menuHeight: 320,
      enableFilter: true,
      initialSelection: null,
      hintText: widget.label,
      dropdownMenuEntries: categoryEntries,
      inputDecorationTheme: themeData.inputDecorationTheme.copyWith(
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
          borderSide: const BorderSide(
            color: AppColors.transparent,
            width: 1,
            style: BorderStyle.none
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
          borderSide: const BorderSide(
            color: AppColors.transparent,
            width: 1,
            style: BorderStyle.none
          ),
        ),
        outlineBorder: const BorderSide(
            color: AppColors.transparent,
            width: 1,
            style: BorderStyle.none
        ),
      ),
      onSelected: (CategoryDto? category) {
        widget.onSelected(category!);
        setState(() {
          categoryController.text = '';
        });
      },
    );
  }
}
