import 'package:flutter/material.dart';

class StyledButton extends StatelessWidget {
  const StyledButton({
    super.key,
    required this.onPressed,
    required this.child,
  });

  final Widget child;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        foregroundColor: const Color(0xFF2B5FC7),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: const BorderSide(color: Color(0xFF2B5FC7), width: 2,)),
        textStyle: const TextStyle(
          fontFamily: 'SwankyAndMooMooCyrillic',
          fontSize: 22,
        ),
      ),
      onPressed: onPressed,
      child: child
    );
  }
}