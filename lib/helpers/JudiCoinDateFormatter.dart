String formatDateTime(DateTime date) {
  String _leadingZero(int value) {
    if (value < 9) {
      return '0$value';
    }
    return '$value';
  }

  return '${_leadingZero(date.hour)}:${_leadingZero(date.minute)} ${_leadingZero(date.day)}/${_leadingZero(date.month)}/${date.year}';
}
