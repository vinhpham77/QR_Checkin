import 'package:flutter/material.dart';
import 'package:qr_checkin/features/registration/dtos/registration_user_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../config/theme.dart';
import '../../utils/image_utils.dart';

class AcceptedRegistrationItem extends StatefulWidget {
  final RegistrationUserDto registrationUser;

  const AcceptedRegistrationItem({super.key, required this.registrationUser});

  @override
  State<AcceptedRegistrationItem> createState() =>
      _AcceptedRegistrationItemState();
}

class _AcceptedRegistrationItemState extends State<AcceptedRegistrationItem> {
  String get sex {
    if (widget.registrationUser.sex == null) {
      return 'Khác';
    } else if (widget.registrationUser.sex!) {
      return 'Nam';
    } else {
      return 'Nữ';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      hoverColor: Colors.black12,
      focusColor: Colors.black12,
      highlightColor: Colors.black12,
      onTap: () {},
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.only(right: 12),
                  height: 76,
                  width: 76,
                  child: Image.network(
                    getImageUrl(widget.registrationUser.avatar),
                    errorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        'assets/images/placeholder.png',
                        fit: BoxFit.cover,
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                    fit: BoxFit.cover,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          widget.registrationUser.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.registrationUser.fullName != null)
                          const SizedBox(width: 8),
                        Text(
                          '@${widget.registrationUser.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Email: ${widget.registrationUser.email}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Đăng ký: ${formatDateTime(widget.registrationUser.createdAt!)}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Phê duyệt: ${formatDateTime(widget.registrationUser.acceptedAt!)}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
