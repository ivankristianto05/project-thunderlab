import 'package:flutter/material.dart';
import 'package:kontena_pos/core/app_export.dart';
import 'package:kontena_pos/core/theme/custom_text_style.dart';

class CustomTextFormField extends StatelessWidget {
  CustomTextFormField(
      {Key? key,
      this.alignment,
      this.width,
      this.controller,
      this.focusNode,
      this.autofocus = true,
      this.textStyle,
      this.textAlign,
      this.obscureText = false,
      this.textInputAction = TextInputAction.next,
      this.textInputType = TextInputType.text,
      this.maxLines,
      this.hintText,
      this.hintStyle,
      this.prefix,
      this.prefixConstraints,
      this.suffix,
      this.onTapOutside,
      this.onTap,
      this.suffixConstraints,
      this.contentPadding,
      this.borderDecoration,
      this.fillColor,
      this.filled = true,
      this.validator,
      this.onEditingComplete})
      : super(
          key: key,
        );

  final Alignment? alignment;

  final double? width;

  final TextEditingController? controller;

  final FocusNode? focusNode;

  final bool? autofocus;

  final TextStyle? textStyle;

  final TextAlign? textAlign;

  final bool? obscureText;

  final TextInputAction? textInputAction;

  final TextInputType? textInputType;

  final int? maxLines;

  final String? hintText;

  final TextStyle? hintStyle;

  final Widget? prefix;

  final BoxConstraints? prefixConstraints;

  final Widget? suffix;

  final BoxConstraints? suffixConstraints;

  final EdgeInsets? contentPadding;

  final InputBorder? borderDecoration;

  final Color? fillColor;

  final bool? filled;

  final onTapOutside;

  final GestureTapCallback? onTap;

  final FormFieldValidator<String>? validator;

  final onEditingComplete;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: textFormFieldWidget,
          )
        : textFormFieldWidget;
  }

  Widget get textFormFieldWidget => SizedBox(
        width: width ?? double.maxFinite,
        child: TextFormField(
          controller: controller,
          focusNode: focusNode ?? FocusNode(),
          autofocus: autofocus!,
          style: textStyle ?? theme.textTheme.bodySmall,
          obscureText: obscureText!,
          textInputAction: textInputAction,
          keyboardType: textInputType,
          onEditingComplete: onEditingComplete,
          onTapOutside: onTapOutside,
          onTap: onTap,
          maxLines: maxLines ?? 1,
          decoration: decoration,
          validator: validator,
          textAlign: textAlign ?? TextAlign.start,
        ),
      );
  InputDecoration get decoration => InputDecoration(
        hintText: hintText ?? "",
        hintStyle: hintStyle ?? CustomTextStyles.bodySmallBluegray100,
        prefixIcon: prefix,
        prefixIconConstraints: prefixConstraints,
        suffixIcon: suffix,
        suffixIconConstraints: suffixConstraints,
        isDense: true,
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(
              horizontal: 8.h,
              vertical: 15.v,
            ),
        fillColor: fillColor ?? theme.colorScheme.primaryContainer,
        filled: filled,
        border: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.h),
              borderSide: BorderSide(
                color: theme.colorScheme.background,
                width: 2,
              ),
            ),
        enabledBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.h),
              borderSide: BorderSide(
                color: theme.colorScheme.background,
                width: 2,
              ),
            ),
        focusedBorder: borderDecoration ??
            OutlineInputBorder(
              borderRadius: BorderRadius.circular(2.h),
              borderSide: BorderSide(
                color: theme.colorScheme.background,
                width: 2,
              ),
            ),
      );
}

/// Extension on [CustomTextFormField] to facilitate inclusion of all types of border style etc
extension TextFormFieldStyleHelper on CustomTextFormField {
  static OutlineInputBorder get outlineGrayTL5 => OutlineInputBorder(
        borderRadius: BorderRadius.circular(5.h),
        borderSide: BorderSide(
          color: theme.colorScheme.background,
          width: 2,
        ),
      );
}
