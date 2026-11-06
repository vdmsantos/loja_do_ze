import 'package:flutter/material.dart';
import 'package:loja_do_ze/shared/app_colors.dart';

class AppElevatedButton extends StatelessWidget {
  const AppElevatedButton({
    super.key, required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {

    

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.azul,
        foregroundColor:  AppColors.branco,
      ),
      onPressed:
      onPressed,
      child: Text("Entrar"),
    );
  }
}
