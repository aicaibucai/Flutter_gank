extension DateUtilExtenson on DateTime {
  String toSimpleDate() {
    return "${this.year}-${this.month}-${this.day}";
  }
}
