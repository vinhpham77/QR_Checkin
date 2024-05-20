import 'package:flutter/material.dart';
import 'package:qr_checkin/features/registration/dtos/attendance_user_dto.dart';
import 'package:qr_checkin/utils/data_utils.dart';

import '../../config/theme.dart';
import '../../utils/image_utils.dart';

class AttendanceItem extends StatefulWidget {
  final AttendanceUserDto attendanceUser;

  const AttendanceItem({super.key, required this.attendanceUser});

  @override
  State<AttendanceItem> createState() => _AttendanceItemState();
}

class _AttendanceItemState extends State<AttendanceItem> {
  String get sex {
    if (widget.attendanceUser.sex == null) {
      return 'Khác';
    } else if (widget.attendanceUser.sex!) {
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
                    getImageUrl(widget.attendanceUser.avatar),
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
                          widget.attendanceUser.fullName ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (widget.attendanceUser.fullName != null)
                          const SizedBox(width: 8),
                        Text(
                          '@${widget.attendanceUser.username}',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Email: ${widget.attendanceUser.email}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    Text(
                      'Check in: ${widget.attendanceUser.checkInAt != null ? formatDateTime(widget.attendanceUser.checkInAt!) : 'Chưa'}',
                      style: const TextStyle(
                        fontSize: 13,
                      ),
                    ),
                    if (widget.attendanceUser.isCheckOutRequired)
                      Text(
                        'Check out: ${widget.attendanceUser.checkOutAt != null ? formatDateTime(widget.attendanceUser.checkOutAt!) : 'Chưa'}',
                        style: const TextStyle(
                          fontSize: 13,
                        ),
                      ),
                  ],
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Ảnh check in'),
                          content: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 16, horizontal: 24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (widget.attendanceUser.qrCheckInImg !=
                                        null)
                                      Image.network(
                                        getImageUrl(widget
                                            .attendanceUser.qrCheckInImg!),
                                        width: 100,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/placeholder.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                        fit: BoxFit.cover,
                                      )
                                    else
                                      const Text('Chưa check in'),
                                    if (widget.attendanceUser.qrCheckInImg !=
                                            null &&
                                        widget.attendanceUser.isCaptureRequired)
                                      Image.network(
                                        getImageUrl(
                                            widget.attendanceUser.checkInImg),
                                        width: 140,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            'assets/images/placeholder.png',
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        loadingBuilder:
                                            (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        },
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(
                    Icons.join_left,
                    color: AppColors.pink,
                    size: 30,
                  ),
                ),
                if (widget.attendanceUser.isCheckOutRequired)
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Ảnh check out'),
                            content: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 24),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (widget.attendanceUser.qrCheckOutImg !=
                                          null)
                                        Image.network(
                                          getImageUrl(widget
                                              .attendanceUser.qrCheckOutImg!),
                                          width: 140,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                          fit: BoxFit.cover,
                                        )
                                      else
                                        const Text('Chưa check out'),
                                      if (widget.attendanceUser.qrCheckOutImg !=
                                              null &&
                                          widget
                                              .attendanceUser.isCaptureRequired)
                                        Image.network(
                                          getImageUrl(widget
                                              .attendanceUser.checkOutImg),
                                          width: 140,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return Image.asset(
                                              'assets/images/placeholder.png',
                                              fit: BoxFit.cover,
                                            );
                                          },
                                          loadingBuilder: (context, child,
                                              loadingProgress) {
                                            if (loadingProgress == null) {
                                              return child;
                                            } else {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          },
                                          fit: BoxFit.cover,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    icon: const Icon(
                      Icons.join_right,
                      color: AppColors.lightTurquoise,
                      size: 30,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
