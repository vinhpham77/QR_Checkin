import 'package:flutter/material.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../widgets/avatar.dart';
import '../../widgets/editor.dart';

class FirstScreen extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const FirstScreen({super.key, required this.formKey});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  final QuillEditorController controller = QuillEditorController();

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Ảnh bìa',
        style: themeData.textTheme.bodyMedium!,
        textAlign: TextAlign.center,
      ),
      const SizedBox(
        height: 8,
      ),
      Center(
        child: Column(
          children: [
            InkWell(
              onTap: () {},
              child: Container(
                padding: const EdgeInsets.all(AppSizes.fieldRadius),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                  border: Border.all(
                    color: AppColors.black,
                    width: 1,
                  ),
                ),
                child: const Avatar(
                  size: 80,
                  imageUrl: '',
                  fallBackIcon: Icons.add_a_photo,
                ),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            // button
            ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.lightTurquoise,
                  minimumSize: const Size(48, 32),
                  maximumSize: const Size(200, 40),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
                  ),
                ),
                child: Text('Chọn ảnh',
                    style: themeData.textTheme.labelMedium!
                        .copyWith(color: Colors.black))),
          ],
        ),
      ),
      Text('Tên sự kiện', style: themeData.textTheme.bodyMedium!),
      const SizedBox(
        height: 8,
      ),
      TextFormField(
        decoration: const InputDecoration(filled: true),
        onEditingComplete: () {
          FocusScope.of(context).unfocus();
          controller.requestFocus();
        },
        maxLength: 100,
        buildCounter: (context,
                {required currentLength, required isFocused, maxLength}) =>
            null,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Vui lòng nhập tên sự kiện';
          }

          return null;
        },
      ),
      const SizedBox(height: 18),
      Text('Mô tả sự kiện', style: themeData.textTheme.bodyMedium!),
      const SizedBox(
        height: 8,
      ),
      SizedBox(
        height: 400,
        child: Editor(hintText: '', controller: controller),
      ),
    ]);
  }

  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  void unFocusEditor() => controller.unFocus();
}
