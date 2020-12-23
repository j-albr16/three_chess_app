import 'package:flutter/material.dart';

import '../helpers/constants.dart';


class ChessTextField extends StatelessWidget {
//  always more or less same
  final Size size;
  final TextEditingController controller;
  final ThemeData theme;
  final FocusNode focusNode;

// individula
  final Widget suffixIcon;
  final String helperText;
  final String errorText;
  final String labelText;
  final TextInputType textInputType;
  final int maxLines;
  final bool obscuringText;
  final Function onSubmitted;
  final String hintText;

  ChessTextField({
    this.obscuringText,
    this.textInputType,
    this.focusNode,
    this.hintText,
    this.labelText,
    this.suffixIcon,
    this.theme,
    this.controller,
    this.errorText,
    this.helperText,
    this.maxLines,
    this.onSubmitted,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        onTap: () => focusNode.requestFocus(),
        keyboardType: textInputType,
        maxLines: maxLines,
        onSubmitted: (String text)  => onSubmitted(text) ,
        obscureText: obscuringText,
        style: textStyle(theme),
        textInputAction: TextInputAction.done,
        decoration: inputDecoration(
          errorText: errorText,
          hintText: hintText,
          helperText: helperText,
          icon: suffixIcon,
          labelText: labelText,
          theme: theme,
        ),
      ),
    );
  }

  static TextStyle textStyle(ThemeData theme) {
    return theme.textTheme.bodyText1
        .copyWith(color: theme.colorScheme.onBackground);
  }

  static InputDecoration inputDecoration(
      {ThemeData theme,
      String helperText,
      String errorText,
      String hintText,
      String labelText,
      Widget icon}) {
    return InputDecoration(
      // Border
      errorBorder: border(theme.colorScheme.error, 2),
      disabledBorder: border(theme.colorScheme.background, 2),
      enabledBorder: border(theme.colorScheme.primaryVariant, 2),
      focusedBorder: border(theme.colorScheme.primary, 2),
      focusedErrorBorder: border(theme.colorScheme.primaryVariant, 2),
      // text
      helperText: helperText,
      hintText: hintText,
      errorText: errorText,
      labelText: labelText,
      // Color
      focusColor: theme.colorScheme.primaryVariant.withOpacity(0.4),
      fillColor: theme.colorScheme.background.withOpacity(0.4),
      // Icon
      suffixIcon: icon,
      contentPadding: EdgeInsets.all(3),
      // bool
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  static OutlineInputBorder border(Color color, double width) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(cornerRadius)),
      borderSide: BorderSide(
        width: width,
        color: color,
        style: BorderStyle.solid,
      ),
    );
  }
}
