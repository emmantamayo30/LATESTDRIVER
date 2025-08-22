import 'dart:io';
import 'package:flutter/material.dart';

class ProfileModel extends ChangeNotifier {
  String _name = 'Han Noah';
  String _phoneNumber = '';
  String? _photoPath; // null -> use default asset

  String get name => _name;
  String get phoneNumber => _phoneNumber;

  /// Returns an ImageProvider suitable for CircleAvatar.backgroundImage
  ImageProvider get avatarImage {
    final String? path = _photoPath;
    if (path == null) {
      return const NetworkImage('https://i.imgur.com/4ZQZpQv.jpeg');
    }
    if (path.startsWith('assets/')) {
      return AssetImage(path);
    }
    return FileImage(File(path));
  }

  void updateProfile({String? name, String? phoneNumber, String? photoPath}) {
    if (name != null) _name = name;
    if (phoneNumber != null) _phoneNumber = phoneNumber;
    if (photoPath != null) _photoPath = photoPath;
    notifyListeners();
  }
}


