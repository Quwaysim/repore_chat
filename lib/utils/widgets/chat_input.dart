import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:repore_chat/utils/app_colors.dart';
import 'package:repore_chat/utils/asset_paths.dart';
import 'package:repore_chat/utils/widgets/custom_textfield.dart';

class ChatInput extends StatefulWidget {
  const ChatInput({
    required this.onSend,
    super.key,
  });

  final void Function(String message) onSend;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  final _textController = TextEditingController();
  bool _canSend = false;

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _handleSend() {
    if (_textController.text.trim().isEmpty) return;
    widget.onSend(_textController.text.trim());
    _textController.clear();
    setState(() {
      _canSend = false;
    });
  }

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
                  controller: _textController,
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
                        onTap: _canSend ? _handleSend : null,
                        child: SvgPicture.asset(
                          AssetPaths.icSend,
                          height: 24.w,
                          width: 24.w,
                        ),
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _canSend = value.trim().isNotEmpty;
                    });
                  },
                  onSubmitted: (_) {
                    if (_canSend) _handleSend();
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
