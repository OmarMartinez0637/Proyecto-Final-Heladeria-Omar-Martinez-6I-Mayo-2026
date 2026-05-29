import 'package:flutter/material.dart';

class TabProvider with ChangeNotifier {
  int _currentIndex = 0;

  int get currentIndex => _currentIndex;

  void setIndex(int index) {
    _currentIndex = index;
    notifyListeners(); // Notifica a la barra y al body para actualizarse juntos
  }
}