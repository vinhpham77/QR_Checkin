import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_checkin/features/event/dtos/order_filter_dto.dart';
import 'package:qr_checkin/features/event/dtos/search_criteria.dart';
import 'package:qr_checkin/utils/theme_ext.dart';

import '../../config/http_client.dart';
import '../../config/router.dart';
import '../../config/theme.dart';
import '../../features/category/bloc/category_bloc.dart';
import '../../features/category/data/category_api_client.dart';
import '../../features/category/data/category_repository.dart';
import '../../features/category/dtos/category_dto.dart';

class SearchScreen extends StatefulWidget {

  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _keywordKey = GlobalKey<FormFieldState>();
  late CategoryBloc _categoryBloc;
  final _keywordFocusNode = FocusNode();
  late final _keywordController = TextEditingController();
  CategoryDto? selectedCategory;
  List<CategoryDto> _categories = [];
  final _searchFilters = [
    {
      'name': 'Tên',
      'value': 'name',
    },
    {
      'name': 'Mô tả',
      'value': 'description',
    },
    {
      'name': 'Địa điểm',
      'value': 'location',
    },
    {
      'name': 'Tổ chức',
      'value': 'created_by',
    }
  ];
  final _orderFilters = <OrderFilterDto>[
    OrderFilterDto(
      name: 'Mới nhất',
      value: 'created_at',
      isAsc: false,
    ),
    OrderFilterDto(
      name: 'Cũ nhất',
      value: 'created_at',
      isAsc: true,
    ),
    OrderFilterDto(
      name: 'A-Z',
      value: 'name',
      isAsc: true,
    ),
    OrderFilterDto(
      name: 'Z-A',
      value: 'name',
      isAsc: false,
    ),
    OrderFilterDto(
      name: 'Gần nhất',
      value: 'distance',
      isAsc: true,
    ),
    OrderFilterDto(
      name: 'Xa nhất',
      value: 'distance',
      isAsc: false,
    ),
  ];
  final _selectedFilters = <Map<String, String>>[];
  var _selectedOrder = OrderFilterDto(
    name: 'Mới nhất',
    value: 'created_at',
    isAsc: false,
  );
  final _orderController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _selectedFilters.addAll(_searchFilters);

    _keywordFocusNode.addListener(() {
      if (!_keywordFocusNode.hasFocus) {
        _keywordKey.currentState!.validate();
      }
    });

    _categoryBloc = CategoryBloc(CategoryRepository(CategoryApiClient(dio)));
    _categoryBloc.add(CategoryFetchStarted());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _categoryBloc,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Tìm kiếm'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            TextFormField(
              key: _keywordKey,
              decoration:
                  const InputDecoration(filled: true, labelText: 'Từ khoá'),
              controller: _keywordController,
              focusNode: _keywordFocusNode,
              maxLength: 50,
              buildCounter: (context,
                      {required currentLength,
                      required isFocused,
                      maxLength}) =>
                  null,
            ),
            const SizedBox(height: 9),
            Wrap(
              spacing: 5.0,
              children: _searchFilters.map((var item) {
                return FilterChip(
                  label: Text(item['name']!),
                  selected: _selectedFilters.contains(item),
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedFilters.add(item);
                      } else {
                        _selectedFilters.remove(item);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Row(children: [
              DropdownMenu<OrderFilterDto>(
                initialSelection: _selectedOrder,
                controller: _orderController,
                requestFocusOnTap: true,
                label: const Text('Sắp xếp'),
                onSelected: (OrderFilterDto? value) {
                  if (value != null) {
                    setState(() {
                      _selectedOrder = value;
                    });
                  }
                },
                inputDecorationTheme: const InputDecorationTheme(
                  filled: true,
                ),
                dropdownMenuEntries: _orderFilters
                    .map<DropdownMenuEntry<OrderFilterDto>>(
                        (OrderFilterDto order) {
                  return DropdownMenuEntry<OrderFilterDto>(
                    value: order,
                    label: order.name,
                  );
                }).toList(),
              ),
              const SizedBox(width: 18),
              BlocListener<CategoryBloc, CategoryState>(
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
                    if (state is CategoryFetchSuccess) {
                      _categories = state.categories;
                    }

                    return DropdownMenu<CategoryDto>(
                      requestFocusOnTap: true,
                      width: 180,
                      label: const Text('Danh mục'),
                      onSelected: (CategoryDto? value) {
                        if (value != null) {
                          setState(() {
                            selectedCategory = value;
                          });
                        }
                      },
                      inputDecorationTheme: const InputDecorationTheme(
                        filled: true,
                      ),
                      dropdownMenuEntries: _categories
                          .map<DropdownMenuEntry<CategoryDto>>(
                              (CategoryDto category) {
                        return DropdownMenuEntry<CategoryDto>(
                          value: category,
                          label: category.name,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ]),
            const SizedBox(height: 18),
            FilledButton(
              onPressed: () {
                router.push(RouteName.eventList, extra: SearchCriteria(
                  title: 'Kết quả tìm kiếm',
                  keyword: _keywordController.text,
                  fields: _selectedFilters.map((e) => e['value']!).toList(),
                  categoryId: selectedCategory?.id,
                  sortField: _selectedOrder.value,
                  isAsc: _selectedOrder.isAsc,
                ));
              },
              style: FilledButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              child: Text('Tìm kiếm', style: themeData.textTheme.labelLarge?.copyWith(color: Colors.white)),
            ),
          ]),
        ),
      ),
    );
  }
}
