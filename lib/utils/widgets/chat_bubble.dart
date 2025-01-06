import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:repore_chat/utils/app_colors.dart';
import 'package:repore_chat/utils/enums.dart';
import 'package:repore_chat/utils/widgets/image_widget.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({
    super.key,
    required this.message,
    required this.userName,
    required this.time,
    required this.status,
    required this.isMe,
    required this.role,
  });
  final String userName;
  final String time;
  final String message;
  final Status status;
  final bool isMe;
  final Role role;

  String get _userInitial {
    if (userName.isEmpty) return '?';
    return userName[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20.w),
      child: Row(
        textDirection: isMe ? TextDirection.rtl : TextDirection.ltr,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox.square(
            dimension: 24.w,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.color00B4D8.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8.w),
              ),
              child: Center(
                child: Text(
                  _userInitial,
                  style: TextStyle(
                    color: AppColors.color00B4D8,
                    fontSize: 14.sp,
                  ),
                ),
              ),
            ),
          ),
          Gap(4.w),
          Column(
            crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 240.w,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: role == Role.admin
                        ? AppColors.adminColor
                        : role == Role.customer
                            ? AppColors.customerColor
                            : AppColors.agentColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.w),
                      topRight: Radius.circular(20.w),
                      bottomLeft: Radius.circular(20.w),
                      bottomRight: Radius.circular(20.w),
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              userName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: role == Role.customer ? AppColors.color475467 : Colors.white,
                                fontSize: 14.sp,
                              ),
                            ),
                            Text(
                              time,
                              style: TextStyle(
                                color: role == Role.customer ? AppColors.color475467 : Colors.white,
                                fontSize: 12.sp,
                              ),
                            ),
                          ],
                        ),
                        Gap(8.w),
                        Text(
                          message,
                          style: TextStyle(
                            color: role == Role.customer ? AppColors.color475467 : Colors.white,
                            fontSize: 14.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Gap(4.w),
              Row(
                children: [
                  Text(
                    status.name[0].toUpperCase() + status.name.substring(1),
                    style: TextStyle(
                      color: AppColors.color475467,
                      fontSize: 12.sp,
                    ),
                  ),
                  Gap(2.w),
                  StatusImage(status: status),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
