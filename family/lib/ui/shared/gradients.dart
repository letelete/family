import 'package:flutter/material.dart';

class Gradients {
  static const LinearGradient backgroundSolid = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.5, 1],
    colors: const [
      const Color.fromRGBO(0, 0, 0, 1),
      const Color.fromRGBO(68, 2, 2, 1),
    ],
  );

  static const LinearGradient backgroundTransparent = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.5, 1],
    colors: const [
      const Color.fromRGBO(0, 0, 0, 0.94),
      const Color.fromRGBO(68, 0, 0, 0.84),
    ],
  );

  static const LinearGradient familyPhotoCover = LinearGradient(
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
    stops: const [0.5, 1],
    colors: const [
      const Color.fromRGBO(0, 0, 0, 1),
      const Color.fromRGBO(0, 0, 0, 0),
    ],
  );
}
