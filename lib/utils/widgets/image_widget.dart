import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repore_chat/utils/asset_paths.dart';
import 'package:repore_chat/utils/enums.dart';

class StatusImage extends StatelessWidget {
  const StatusImage({
    super.key,
    required this.status,
  });

  final Status status;

  @override
  Widget build(BuildContext context) {
    return status == Status.read
        ? const SizedBox.shrink()
        : SvgPicture.asset(
            status == Status.waiting
                ? AssetPaths.icWaiting
                : status == Status.sent
                    ? AssetPaths.icSent
                    : status == Status.resend
                        ? AssetPaths.icFailed
                        : AssetPaths.icDelivered,
            width: 16.w,
            height: 16.w,
          );
  }
}
