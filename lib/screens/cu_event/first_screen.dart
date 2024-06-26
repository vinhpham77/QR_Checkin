import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/config/theme.dart';
import 'package:qr_checkin/features/category/data/category_api_client.dart';
import 'package:qr_checkin/features/category/data/category_repository.dart';
import 'package:qr_checkin/widgets/category_dropdown.dart';
import 'package:qr_checkin/widgets/category_item.dart';
import 'package:quill_html_editor/quill_html_editor.dart';

import '../../config/http_client.dart';
import '../../config/router.dart';
import '../../features/category/bloc/category_bloc.dart';
import '../../features/category/dtos/category_dto.dart';
import '../../features/event/dtos/event_dto.dart';
import '../../features/image/bloc/image_bloc.dart';
import '../../features/image/data/image_api_client.dart';
import '../../features/image/data/image_repository.dart';
import '../../utils/image_utils.dart';
import '../../widgets/custom_image.dart';
import '../../widgets/editor.dart';

class FirstScreen extends StatefulWidget {
  EventDto event;

  FirstScreen({super.key, required this.event});

  @override
  State<FirstScreen> createState() => FirstScreenState();
}

class FirstScreenState extends State<FirstScreen> {
  late int id;
  late String? backgroundImage;
  late final TextEditingController _nameController;
  late final QuillEditorController _descriptionController;
  late List<CategoryDto> selectedCategories;
  late List<CategoryDto> _categories = [];
  late CategoryBloc _categoryBloc;
  late ImageBloc _imageBloc;
  final _nameKey = GlobalKey<FormFieldState>();
  final _nameFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  bool get isValidForm => _formKey.currentState!.validate();

  String get name => _nameController.text;

  Future<String> get description => _descriptionController.getText();

  @override
  void initState() {
    super.initState();
    id = widget.event.id;
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = QuillEditorController();
    selectedCategories = [...widget.event.categories];
    backgroundImage = widget.event.backgroundImage;

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        _nameKey.currentState!.validate();
      }
    });

    _categoryBloc = CategoryBloc(CategoryRepository(CategoryApiClient(dio)));
    _imageBloc = ImageBloc(ImageRepository(ImageApiClient(dio)));
    _categoryBloc.add(CategoryFetchStarted());
    _imageBloc.add(ImageInitialStart());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: MultiBlocProvider(
        providers: [
          BlocProvider.value(value: _categoryBloc),
          BlocProvider.value(value: _imageBloc),
        ],
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Ảnh nền',
            style: themeData.textTheme.bodyMedium!,
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 8,
          ),
          Center(
            child: BlocListener<ImageBloc, ImageState>(
              listener: (context, state) {
                if (state is ImageUploadFailure) {
                  final snackBar = SnackBar(
                    content: Text(state.message),
                    action: SnackBarAction(
                      label: 'Đóng',
                      onPressed: () {
                        router.pop();
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: BlocBuilder<ImageBloc, ImageState>(
                bloc: _imageBloc,
                builder: (context, state) {
                  if (state is ImageUploading) {
                    _buildBackground(true);
                  }

                  if (state is ImageUploadSuccess) {
                    backgroundImage = state.imageName;
                  }

                  return _buildBackground(false);
                },
              ),
            ),
          ),
          Text('Tên sự kiện', style: themeData.textTheme.bodyMedium!),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            key: _nameKey,
            decoration: const InputDecoration(filled: true),
            onTapOutside: (event) {
              _nameFocusNode.unfocus();
            },
            controller: _nameController,
            focusNode: _nameFocusNode,
            maxLength: 100,
            buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) =>
                null,
            validator: (value) {
              if (value!.trim().isEmpty) {
                return 'Vui lòng nhập tên sự kiện';
              }

              return null;
            },
          ),
          const SizedBox(height: 18),
          Text('Danh mục', style: themeData.textTheme.bodyMedium!),
          const SizedBox(
            height: 8,
          ),
          Container(
            height: 58,
            padding: const EdgeInsets.only(bottom: 6),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.black,
                  width: 1,
                ),
              ),
            ),
            child: BlocListener<CategoryBloc, CategoryState>(
              bloc: _categoryBloc,
              listener: (context, state) {
                if (state is CategoryFetchFailure) {
                  final snackBar = SnackBar(
                    content: Text(state.message),
                    action: SnackBarAction(
                      label: 'Đóng',
                      onPressed: () {
                        router.pop();
                      },
                    ),
                  );

                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
              child: BlocBuilder<CategoryBloc, CategoryState>(
                bloc: _categoryBloc,
                builder: (context, state) {
                  if (state is CategoryFetching) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is CategoryFetchSuccess) {
                    _categories = state.categories;
                    _categories.removeWhere((element) =>
                        selectedCategories.any((e) => e.id == element.id));
                  }

                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (var category in selectedCategories)
                        CategoryItem(
                          category: category.name,
                          onDelete: () => removeSelection(context, category),
                        ),
                      if (selectedCategories.length < 3)
                        CategoryDropdown(
                            categories: _categories,
                            onSelected: (CategoryDto category) {
                              setState(() {
                                selectedCategories.add(category);
                                _categories.remove(category);
                              });
                            },
                            label: selectedCategories.isEmpty
                                ? 'Có thể thêm lên đến ba danh mục...'
                                : "Thêm danh mục khác..."),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text('Mô tả sự kiện', style: themeData.textTheme.bodyMedium!),
          const SizedBox(
            height: 8,
          ),
          SizedBox(
            height: 400,
            child: Editor(
                text: widget.event.description ?? '',
                hintText: '',
                controller: _descriptionController),
          ),
        ]),
      ),
    );
  }

  void setHtmlText(String? text) async {
    await _descriptionController.setText(text ?? '');
  }

  void unFocusEditor() => _descriptionController.unFocus();

  void removeSelection(BuildContext context, CategoryDto category) {
    setState(() {
      selectedCategories.remove(category);
      _categories.add(category);
    });
  }

  Widget _buildBackground(bool isLoading) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
            border: Border.all(
              color: AppColors.black,
              width: 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppSizes.fieldRadius),
            child: CustomImage(
              size: 140,
              imageName: backgroundImage,
              fallBackIcon: Icons.photo,
            ),
          ),
        ),
        const SizedBox(
          height: 4,
        ),
        Stack(
          children: [
            ElevatedButton(
                onPressed: isLoading ? null : () => getImage(_imageBloc),
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
            if (isLoading)
              const Positioned.fill(
                child: Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _nameFocusNode.dispose();
    _categoryBloc.close();
    _imageBloc.close();
    _nameKey.currentState?.dispose();
    super.dispose();
  }
}
