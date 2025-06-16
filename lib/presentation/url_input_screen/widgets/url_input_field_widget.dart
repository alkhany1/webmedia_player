import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

class UrlInputFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isValid;
  final String? errorMessage;
  final VoidCallback onQrScan;

  const UrlInputFieldWidget({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.isValid,
    this.errorMessage,
    required this.onQrScan,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppTheme.darkTheme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: errorMessage != null
                  ? AppTheme.darkTheme.colorScheme.error
                  : isValid && controller.text.isNotEmpty
                      ? AppTheme.successColor
                      : Colors.transparent,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              TextField(
                controller: controller,
                focusNode: focusNode,
                keyboardType: TextInputType.url,
                textInputAction: TextInputAction.done,
                maxLines: 3,
                minLines: 1,
                style: AppTheme.darkTheme.textTheme.bodyLarge,
                textDirection: TextDirection.ltr,
                decoration: InputDecoration(
                  hintText: 'الصق رابط kool.to هنا',
                  hintStyle: AppTheme.darkTheme.textTheme.bodyLarge?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(4.w),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (controller.text.isNotEmpty)
                        IconButton(
                          onPressed: () => controller.clear(),
                          icon: CustomIconWidget(
                            iconName: 'clear',
                            color:
                                AppTheme.darkTheme.colorScheme.onSurfaceVariant,
                            size: 20,
                          ),
                        ),
                      IconButton(
                        onPressed: _pasteFromClipboard,
                        icon: CustomIconWidget(
                          iconName: 'content_paste',
                          color: AppTheme.darkTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                      IconButton(
                        onPressed: onQrScan,
                        icon: CustomIconWidget(
                          iconName: 'qr_code_scanner',
                          color: AppTheme.darkTheme.colorScheme.primary,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 1.h),

        // Validation feedback
        Row(
          children: [
            if (isValid && controller.text.isNotEmpty) ...[
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successColor,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Text(
                'رابط صحيح',
                style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.successColor,
                ),
              ),
            ] else if (errorMessage != null) ...[
              CustomIconWidget(
                iconName: 'error',
                color: AppTheme.darkTheme.colorScheme.error,
                size: 16,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  errorMessage!,
                  style: AppTheme.darkTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.darkTheme.colorScheme.error,
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Future<void> _pasteFromClipboard() async {
    try {
      final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
      if (clipboardData?.text != null) {
        controller.text = clipboardData!.text!;
      }
    } catch (e) {
      // Handle clipboard access error silently
    }
  }
}
