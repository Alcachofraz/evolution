import 'package:diacritic/diacritic.dart';

extension StringExtension on String {
  String removeAccentuation() {
    return removeDiacritics(this);
  }
}
