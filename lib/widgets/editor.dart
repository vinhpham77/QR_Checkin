import 'package:flutter/material.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../config/theme.dart';

class Editor extends StatefulWidget {
  final String hintText;
  final QuillEditorController controller;

  const Editor({super.key, required this.hintText, required this.controller});

  @override
  State<Editor> createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  bool hasFocused = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
            border: hasFocused
                ? Border.all(color: AppColors.red, width: 1.2)
                : Border.all(color: AppColors.black, width: 1.2),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
            child: Column(
                children: [
                  Expanded(
                    child: QuillHtmlEditor(
                      onFocusChanged: (focus) {
                        setState(() {
                          hasFocused = focus;
                        });
                      },
                      text: '',
                      hintText: widget.hintText,
                      controller: widget.controller,
                      minHeight: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      hintTextPadding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
                      textStyle: themeData.textTheme.bodyLarge!,
                      hintTextStyle: themeData.textTheme.bodyLarge!.copyWith(color: AppColors.lightGray),
                      hintTextAlign: TextAlign.start,
                      backgroundColor: _backgroundColor,
                      inputAction: InputAction.newline,
                      loadingBuilder: (context) => const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: AppColors.red,
                            )),
                    ),
                  ),
                  ToolBar(
                    toolBarColor: _toolbarColor,
                    iconSize: 25,
                    iconColor: _toolbarIconColor,
                    activeIconColor: Colors.greenAccent.shade400,
                    controller: widget.controller,
                    crossAxisAlignment: WrapCrossAlignment.start,
                    direction: Axis.horizontal,
                    toolBarConfig: const [
                      ToolBarStyle.bold,
                      ToolBarStyle.italic,
                      ToolBarStyle.underline,
                      ToolBarStyle.color,
                      ToolBarStyle.redo,
                      ToolBarStyle.undo,
                      ToolBarStyle.listBullet,
                      ToolBarStyle.listOrdered,
                      ToolBarStyle.align,
                      ToolBarStyle.size,
                      ToolBarStyle.addTable,
                      ToolBarStyle.editTable,
                      ToolBarStyle.image,
                      ToolBarStyle.video,
                    ],
                  ),
                ],
              ),
          ),
        ),
      ),
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await widget.controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await widget.controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await widget.controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await widget.controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await widget.controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => widget.controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => widget.controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => widget.controller.unFocus();
}