extension StringExtension on String {
  String capitalize() {
    if (this == null || this.length == 0) {
      return '';
    }
    return '${this[0].toUpperCase()}${this.substring(1)}';
  }
}
