import 'dart:io';

import 'package:flutter/material.dart';

class PickImageProvider extends ChangeNotifier {
  File? _imageFile;
  File? get imageFile => _imageFile;
  void setImageFile(File? value) {
    _imageFile = value;
    notifyListeners();
  }

  bool _doesImageExist = false;
  bool get doesImageExist => _doesImageExist;
  void setDoesImageExist(bool value) {
    _doesImageExist = value;
    notifyListeners();
  }

  void clearAll() {
    _imageFile = null;
    _doesImageExist = false;
  }
}
