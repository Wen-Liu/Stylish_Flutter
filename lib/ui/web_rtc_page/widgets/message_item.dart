class MessageItem {
  String message;
  String time = "${DateTime.now().hour}:${DateTime.now().minute}";
  bool isMyself = false;

  MessageItem({this.message = "", this.isMyself = false});
}
