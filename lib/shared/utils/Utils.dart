import 'package:flutter/material.dart';

class Utils {
  // formata
  static String formatarPreco(double v) {
    return "R\$ " + v.toStringAsFixed(2).replaceAll(".", ",");
  }

  // valida
  static bool validaEmail(String email, int tipo) {
    if (tipo == 1) {
      // email
      if (email.contains("@") && email.contains("."))
        return true;
      else
        return false;
    } else if (tipo == 2) {
      // senha
      if (email.length >= 6)
        return true;
      else
        return false;
    } else if (tipo == 3) {
      // cpf
      if (email.length == 11)
        return true;
      else
        return false;
    }
    return false;
  }

  static Color cor(int i) {
    if (i == 1) return Color(0xFF6200EE);
    if (i == 2) return Color(0xFF03DAC6);
    if (i == 3) return Color(0xFFB00020);
    return Color(0xFF000000);
  }
}
