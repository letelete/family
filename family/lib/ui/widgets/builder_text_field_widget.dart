import 'package:family/ui/shared/colors.dart';
import 'package:family/ui/shared/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BuilderTextFieldWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final Function onEditingComplete;
  final FocusNode focusNode;
  final TextEditingController controller;
  final List<TextInputFormatter> inputFormatters;
  final bool autofocus;
  final TextAlign textAlign;
  final Color cursorColor;
  final InputDecoration inputDecoration;
  final TextStyle textStyle;
  final TextStyle hintStyle;

  const BuilderTextFieldWidget({
    Key key,
    this.hintText,
    this.onChanged,
    this.onEditingComplete,
    this.focusNode,
    this.controller,
    this.inputFormatters,
    this.autofocus,
    this.textAlign,
    this.cursorColor,
    this.inputDecoration,
    this.textStyle,
    this.hintStyle,
  })  : assert(hintText != null),
        assert(onChanged != null || controller != null,
            'At least one callback must be declared'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      onChanged: this.onChanged,
      focusNode: this.focusNode,
      autofocus: this.autofocus ?? true,
      inputFormatters: inputFormatters,
      onEditingComplete: this.onEditingComplete,
      textAlign: this.textAlign ?? TextAlign.center,
      style: this.textStyle ?? AppStyles.menuActiveContentText,
      cursorColor: this.cursorColor ?? AppColors.textSecondary,
      decoration: this.inputDecoration ??
          InputDecoration(
            hintText: this.hintText,
            border: InputBorder.none,
            hintStyle: this.hintStyle ?? AppStyles.menuDisabledContentText,
          ),
    );
  }
}
