import 'package:flutter/foundation.dart';

class LinkProvider extends ChangeNotifier {
  List<String> _links = [];
  List<String> get links => _links;

  void addLink(String link) {
    _links.add(link);
    notifyListeners();
  }
  void clearAllLinks(){
    _links.clear();
    notifyListeners();
  }
}
