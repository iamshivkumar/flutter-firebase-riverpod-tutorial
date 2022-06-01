import 'package:flutter/material.dart';

class AppSnackbar {
  final BuildContext context;

  AppSnackbar(this.context);

  ThemeData get _theme => Theme.of(context);

  TextTheme get _styles => _theme.textTheme;

  ColorScheme get _scheme => _theme.colorScheme;

  void error(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: _styles.bodyLarge!.copyWith(
            color: _scheme.onErrorContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _scheme.errorContainer,
      ),
    );
  }

    void message(Object e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "$e",
          style: _styles.bodyLarge!.copyWith(
            color: _scheme.onTertiaryContainer,
          ),
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: _scheme.tertiaryContainer,
      ),
    );
  }
}
