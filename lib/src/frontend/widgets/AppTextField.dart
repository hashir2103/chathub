import 'package:chathub/src/frontend/styles/baseStyle.dart';
import 'package:chathub/src/frontend/styles/textfieldstyle.dart';
import 'package:chathub/src/frontend/styles/textstyle.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AppTextField extends StatefulWidget {
  final String hintText;
  final IconData prefixIcon;
  final TextInputType textInputType;
  final bool obsecureText;
  final void Function(String) onChanged;
  final String errorText;
  final String initialText;
  final Function() suffixPressed;
  final Function() prefixPressed;
  final FocusNode focusNode;
  final TextEditingController controller;

  var suffixIcon;

  AppTextField({
    @required this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.textInputType = TextInputType.text,
    this.obsecureText = false,
    this.onChanged,
    this.errorText,
    this.initialText,
    this.suffixPressed,
    this.prefixPressed,
    this.controller, this.focusNode,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  String text;
  
  // bool displayCupertionErrorBorder;
  // @override
  // void initState() {
  //   _controller = TextEditingController();
  //   if (widget.initialText != null) _controller.text = widget.initialText;
  //   _focusNode = FocusNode();
  //   _focusNode.addListener(_handleFocusChange);
  //   displayCupertionErrorBorder = false;
  //   super.initState();
  // }

  // void _handleFocusChange() {
  //   if (_focusNode.hasFocus == false && widget.errorText != null) {
  //     displayCupertionErrorBorder = true;
  //   } else {
  //     displayCupertionErrorBorder = false;
  //   }
  //   widget.onChanged(_controller.text);
  // }

  @override
  void dispose() {
    widget.controller.dispose();
    // _focusNode.removeListener(_handleFocusChange);
    widget.focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: BaseStyle.textFieldPadding,
      child: TextField(
        focusNode: widget.focusNode,
        controller: widget.controller,
        keyboardType: widget.textInputType,
        cursorColor: Colors.white,
        style: TextFieldStyle.text,
        obscureText: widget.obsecureText,
        onChanged: widget.onChanged,
        decoration: InputDecoration(
          hintText: widget.hintText,
          hintStyle: TextStyles.suggestion,
          border: InputBorder.none,
          prefixIcon: IconButton(
            icon: BaseStyle.myIcon(widget.prefixIcon),
            onPressed: widget.prefixPressed,
          ),
          suffixIcon: IconButton(
            icon: BaseStyle.myIcon(widget.suffixIcon),
            onPressed: widget.suffixPressed,
          ),
          // focusedBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: AppColor.iconColors.withOpacity(0.7), width: 1.5),
          //     borderRadius: BorderRadius.circular(BaseStyle.borderRaduisTextField)),
          // enabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: AppColor.iconColors.withOpacity(0.7), width: 1.5),
          //     borderRadius: BorderRadius.circular(BaseStyle.borderRaduisTextField)),
          // disabledBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: AppColor.iconColors.withOpacity(0.7), width: 1.5),
          //     borderRadius: BorderRadius.circular(BaseStyle.borderRaduisTextField)),
          // errorBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: AppColor.iconColors.withOpacity(0.7), width: 1.5),
          //     borderRadius: BorderRadius.circular(BaseStyle.borderRaduisTextField)),
          // focusedErrorBorder: OutlineInputBorder(
          //     borderSide: BorderSide(
          //         color: AppColor.iconColors.withOpacity(0.7), width: 1.5),
          //     borderRadius: BorderRadius.circular(BaseStyle.borderRaduisTextField)),
        ),
      ),
    );
  }
}
