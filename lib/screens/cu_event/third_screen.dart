import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_checkin/features/ticket/dtos/ticket_type_dto.dart';

import '../../config/theme.dart';
import '../../features/event/dtos/event_dto.dart';

class ThirdScreen extends StatefulWidget {
  final EventDto event;

  const ThirdScreen({super.key, required this.event});

  @override
  State<ThirdScreen> createState() => ThirdScreenState();
}

class ThirdScreenState extends State<ThirdScreen> {
  late bool isTicketSeller;
  late List<TicketTypeDto> ticketTypes;
  late bool regisRequired;
  late bool approvalRequired;
  late bool captureRequired;
  late String checkinQrCode;
  late String? checkoutQrCode;
  late int? slots;
  final _formKey = GlobalKey<FormState>();

  bool get isValidForm => _formKey.currentState!.validate();
  late final TextEditingController _slotsController;
  TextEditingController ticketNameController = TextEditingController();
  TextEditingController ticketDescriptionController = TextEditingController();
  TextEditingController ticketPriceController = TextEditingController();
  TextEditingController ticketQuantityController = TextEditingController();

  @override
  void initState() {
    super.initState();

    isTicketSeller = widget.event.isTicketSeller;
    ticketTypes = [...widget.event.ticketTypes];
    regisRequired = widget.event.regisRequired;
    approvalRequired = widget.event.approvalRequired;
    captureRequired = widget.event.captureRequired;
    checkinQrCode = widget.event.checkinQrCode;
    checkoutQrCode = widget.event.checkoutQrCode;
    slots = widget.event.slots;
    _slotsController = TextEditingController(text: slots?.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Hình thức: ${isTicketSeller ? 'Bán vé' : 'Điểm danh'}',
                style: themeData.textTheme.bodyMedium!),
            Switch(
              value: isTicketSeller,
              onChanged: widget.event.id != 0
                  ? null
                  : (value) {
                      setState(() {
                        isTicketSeller = value;
                      });
                    },
            ),
          ],
        ),
        if (!isTicketSeller)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Yêu cầu check out', style: themeData.textTheme.bodyMedium!),
              // Switch
              Switch(
                value: checkoutQrCode != null,
                onChanged: (value) {
                  setState(() {
                    checkoutQrCode = value ? 'checkout' : null;
                  });
                },
              ),
            ],
          ),
        if (!isTicketSeller)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Yêu cầu chụp ảnh xác minh',
                  style: themeData.textTheme.bodyMedium!),
              // Switch
              Switch(
                value: captureRequired,
                onChanged: (value) {
                  setState(() {
                    captureRequired = value;
                  });
                },
              ),
            ],
          ),
        if (!isTicketSeller)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Yêu cầu đăng ký trước',
                  style: themeData.textTheme.bodyMedium!),
              // Switch
              Switch(
                value: regisRequired,
                onChanged: (value) {
                  setState(() {
                    regisRequired = value;
                  });
                },
              ),
            ],
          ),
        if (!isTicketSeller)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Phê duyệt lượt đăng ký',
                  style: themeData.textTheme.bodyMedium!),
              // Switch
              Switch(
                value: approvalRequired,
                onChanged: (value) {
                  setState(() {
                    approvalRequired = value;
                  });
                },
              ),
            ],
          ),
        if (!isTicketSeller)
          const SizedBox(height: 12),
        if (!isTicketSeller)
          Text('Số lượng người tham dự', style: themeData.textTheme.bodyMedium!),
        if (!isTicketSeller)
          const SizedBox(
            height: 8,
          ),
        if (!isTicketSeller)
          TextFormField(
            controller: _slotsController,
            decoration: const InputDecoration(
                filled: true, hintText: 'Để trống nếu không giới hạn số lượng'),
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            keyboardType: TextInputType.number,
            onEditingComplete: () {
              FocusScope.of(context).nextFocus();
            },
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return null;
              }

              int? number = int.tryParse(value);
              if (number! < 0) {
                return 'Số lượng phải lớn hơn 0';
              }

              slots = number;
              return null;
            },
          ),
        const SizedBox(height: 12),
        // show ticket type form
        if (isTicketSeller)
          Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
            0: FlexColumnWidth(1),
            1: FlexColumnWidth(2),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(1),
          }, children: [
            const TableRow(
              children: [
                TableCell(child: Text(' Loại vé')),
                TableCell(child: Text(' Mô tả')),
                TableCell(child: Text(' Giá')),
                TableCell(child: Text(' Số lượng')),
              ],
            ),
            for (int i = 0; i < ticketTypes.length; i++)
              TableRow(
                children: [
                  TableCell(
                    child: TextFormField(
                      initialValue: ticketTypes[i].name,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ticketTypes[i].name = value;
                      },
                    ),
                  ),
                  TableCell(
                    child: TextFormField(
                      initialValue: ticketTypes[i].description,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ticketTypes[i].description = value;
                      },
                    ),
                  ),
                  TableCell(
                    child: TextFormField(
                      initialValue: ticketTypes[i].price.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ticketTypes[i].price = double.parse(value);
                      },
                    ),
                  ),
                  TableCell(
                    child: TextFormField(
                      initialValue: ticketTypes[i].quantity.toString(),
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        filled: true,
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      onChanged: (value) {
                        ticketTypes[i].quantity = int.parse(value);
                      },
                    ),
                  ),
                ],
              ),
            TableRow(
              children: [
                TableCell(
                  child: TextFormField(
                    controller: ticketNameController,
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                    ),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                    controller: ticketDescriptionController,
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                    controller: ticketPriceController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
                TableCell(
                  child: TextFormField(
                    controller: ticketQuantityController,
                    keyboardType: TextInputType.number,
                    onFieldSubmitted: (String value) {
                      var ticket = TicketTypeDto(
                        id: 0,
                        eventId: widget.event.id,
                        name: ticketNameController.text,
                        description: ticketDescriptionController.text,
                        price: double.tryParse(ticketPriceController.text),
                        quantity: int.tryParse(ticketQuantityController.text),
                      );
                      setState(() {
                        ticketTypes.add(ticket);
                      });
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        ticketNameController.clear();
                        ticketDescriptionController.clear();
                        ticketPriceController.clear();
                        ticketQuantityController.clear();
                      });
                    },
                    decoration: const InputDecoration(
                      filled: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ]),
      ]),
    );
  }

  @override
  void dispose() {
    _slotsController.dispose();
    ticketNameController.dispose();
    ticketDescriptionController.dispose();
    ticketPriceController.dispose();
    ticketQuantityController.dispose();

    super.dispose();
  }
}
