import 'package:flutter/foundation.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_riverpod/flutter_riverpod.dart';

final loadingProvider = ChangeNotifierProvider((ref) => Loading());

class Loading extends ChangeNotifier {
  bool _loading = false;
  bool get loading => _loading;

  void start() {
    _loading = true;
    notifyListeners();
  }

  void stop() {
    _loading = false;
    notifyListeners();
  }

  void end() {
    _loading = false;
  }
}
