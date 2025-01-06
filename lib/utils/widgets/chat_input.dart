import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repore_chat/utils/app_colors.dart';
import 'package:repore_chat/utils/asset_paths.dart';
import 'package:repore_chat/utils/widgets/custom_textfield.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.onSend,
    required this.textController,
    super.key,
  });

  final void Function() onSend;
  final TextEditingController textController;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88.w,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Center(
            child: SizedBox(
              height: 56.w,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                child: CustomTextField(
                  controller: widget.textController,
                  minLines: 1,
                  maxLines: 5,
                  hint: 'Send a message...',
                  textCapitalization: TextCapitalization.sentences,
                  fillColor: AppColors.colorF9FAFB,
                  prefixIcon: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: Center(
                      child: SvgPicture.asset(
                        AssetPaths.icUploadMedia,
                        height: 20.w,
                        width: 20.w,
                      ),
                    ),
                  ),
                  suffixIcon: SizedBox(
                    width: 48.w,
                    height: 48.w,
                    child: Center(
                      child: InkWell(
                        onTap: widget.onSend,
                        child: SvgPicture.asset(
                          AssetPaths.icSend,
                          height: 24.w,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ),
                  
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
