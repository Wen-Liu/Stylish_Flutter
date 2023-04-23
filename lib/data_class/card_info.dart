class CardInfo {
  String number;
  String dueMonth;
  String dueYear;
  String ccv;

  CardInfo({
    this.number = "4242424242424242",
    this.dueYear = "23",
    this.dueMonth = "12",
    this.ccv = "123",
  });

  @override
  String toString() {
    return 'CardInfo{Number: $number, DueMonth: $dueMonth}';
  }
}
