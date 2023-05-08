extension StringExtension on String {
  String capitalize() {
    List<String> words = split(' ');
    String ret = '';
    for (String word in words) {
      ret += "${word[0].toUpperCase()}${word.substring(1).toLowerCase()}";
    }
    return ret;
  }
}
