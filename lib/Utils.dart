import 'package:flutter/material.dart';
import 'colors.dart';

class Utils {
  // formata
  static String formata(double valor) {
    return formataMoeda(valor);
  }

  static String formataMoeda(double valor) {
    return "R\$ ${valor.toStringAsFixed(2).replaceAll('.', ',')}";
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
    if (i == 1) return colorPurple;
    if (i == 2) return colorTeal;
    if (i == 3) return colorRed;
    return colorBlack;
  }
}
