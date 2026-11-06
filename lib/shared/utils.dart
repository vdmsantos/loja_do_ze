import 'package:flutter/material.dart';

class Utils {
  // formata
  static String formata(double v) {
    return "R\$ " + v.toStringAsFixed(2).replaceAll(".", ",");
  }

  // valida
  static bool valida(String s, int tipo) {
    if (tipo == 1) {
      // email
      if (s.contains("@") && s.contains("."))
        return true;
      else
        return false;
    } else if (tipo == 2) {
      // senha
      if (s.length >= 6)
        return true;
      else
        return false;
    } else if (tipo == 3) {
      // cpf
      if (s.length == 11)
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
