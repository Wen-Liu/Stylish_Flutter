import 'package:flutter/material.dart';
import 'package:stylish/extensions.dart';
import 'dart:core';
import 'dart:async';
import '../widgets/message_item.dart';
import 'signaling.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class DataChannelSample extends StatefulWidget {
  static String tag = 'call_sample';
  final String host;

  const DataChannelSample({super.key, required this.host});

  @override
  _DataChannelSampleState createState() => _DataChannelSampleState();
}

class _DataChannelSampleState extends State<DataChannelSample> {
  Signaling? _signaling;
  List<dynamic> _peers = [];
  List<dynamic> _peersFiltered = [];
  final List<MessageItem> _messages = [];
  String? _selfId;
  bool _inCalling = false;
  RTCDataChannel? _dataChannel;
  Session? _session;

  // Timer? _timer;

  bool _waitAccept = false;
  late BuildContext _showInviteDialogContext;
  String currentMsg = "";
  TextEditingController _textEditingController = TextEditingController();

  @override
  initState() {
    super.initState();
    _connect(context);
  }

  @override
  deactivate() {
    super.deactivate();
    _signaling?.close();
    // _timer?.cancel();
  }

  Future<bool?> _showAcceptDialog(BuildContext buildContext) {
    return showDialog<bool?>(
      context: buildContext,
      builder: (buildContext) {
        return AlertDialog(
          title: Text("Someone want chat with you"),
          content: Text("accept?"),
          actions: <Widget>[
            MaterialButton(
              child: Text(
                'Reject',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () => Navigator.of(buildContext).pop(false),
            ),
            MaterialButton(
              child: Text(
                'Accept',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () => Navigator.of(buildContext).pop(true),
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showInviteDialog() {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        _showInviteDialogContext = context;
        return AlertDialog(
          title: Text("Wait Accept"),
          content: Text("waiting"),
          actions: <Widget>[
            TextButton(
              child: Text("cancel"),
              onPressed: () {
                Navigator.of(context).pop(false);
                // _hangUp();
              },
            ),
          ],
        );
      },
    );
  }

  void _connect(BuildContext context) async {
    _signaling ??= Signaling(widget.host, context)..connect();

    _signaling?.onDataChannelMessage = (_, dc, RTCDataChannelMessage data) {
      setState(() {
        if (data.isBinary) {
          print(
              'DataChannelSample Got binary [' + data.binary.toString() + ']');
        } else {
          _messages.add(MessageItem(
            message: data.text,
            isMyself: false,
          ));
          // _text = data.text;
        }
      });
    };

    _signaling?.onDataChannel = (_, channel) {
      _dataChannel = channel;
    };

    _signaling?.onSignalingStateChange = (SignalingState state) {
      switch (state) {
        case SignalingState.ConnectionClosed:
        case SignalingState.ConnectionError:
        case SignalingState.ConnectionOpen:
          break;
      }
    };

    _signaling?.onCallStateChange = (Session session, CallState state) async {
      print(
          'DataChannelSample Session pid=${session.pid}, sid=${session.sid}, CallState ${state.name}');
      switch (state) {
        case CallState.CallStateNew:
          setState(() {
            _session = session;
          });
          // _timer = Timer.periodic(Duration(seconds: 3), _handleDataChannelTest);
          break;
        case CallState.CallStateBye:
          if (_waitAccept) {
            print('DataChannelSample peer reject');
            _waitAccept = false;
            Navigator.of(_showInviteDialogContext).pop(false);
          }
          setState(() {
            _inCalling = false;
          });
          // _timer?.cancel();
          _dataChannel = null;
          _inCalling = false;
          _session = null;
          // _text = '';
          break;
        case CallState.CallStateInvite:
          _waitAccept = true;
          _showInviteDialog();
          break;
        case CallState.CallStateConnected:
          if (_waitAccept) {
            _waitAccept = false;
            Navigator.of(_showInviteDialogContext).pop();
          }
          setState(() {
            _inCalling = true;
          });
          break;
        case CallState.CallStateRinging:
          bool? accept = await _showAcceptDialog(context);
          print('DataChannelSample CallState.CallStateRinging accept=$accept');
          if (accept!) {
            _accept();
            setState(() {
              _inCalling = true;
            });
          } else {
            _reject();
          }

          break;
      }
    };

    _signaling?.onPeersUpdate = ((event) {
      setState(() {
        _selfId = event['self'];
        _peers = event['peers'];
        _peersFiltered = event['peers'];
      });
    });
  }

  _handleDataChannelTest(String text) async {
    // String text = 'Say hello ${timer.tick} times, from [$_selfId]';
    // _dataChannel
    //     ?.send(RTCDataChannelMessage.fromBinary(Uint8List(timer.tick + 1)));
    _dataChannel?.send(RTCDataChannelMessage(text));
  }

  _invitePeer(context, peerId) async {
    if (peerId != _selfId) {
      _signaling?.invite(peerId, 'data', false);
    }
  }

  _accept() {
    if (_session != null) {
      print("DataChannelSample _accept  ${_session!.sid}");
      _signaling?.accept(_session!.sid, 'data');
    }
  }

  _reject() {
    print("DataChannelSample _reject");
    if (_session != null) {
      _signaling?.reject(_session!.sid);
    }
  }

  _hangUp() {
    print("DataChannelSample _hangUp");
    _signaling?.bye(_session!.sid);
  }

  _buildRow(context, peer) {
    var self = (peer['id'] == _selfId);
    return ListBody(children: <Widget>[
      ListTile(
        title: Text(self
            ? peer['name'] + ', ID: ${peer['id']} ' + ' [Your self]'
            : peer['name'] + ', ID: ${peer['id']} '),
        onTap: () => _invitePeer(context, peer['id']),
        trailing: Icon(Icons.sms),
        subtitle: Text('[' + peer['user_agent'] + ']'),
      ),
      Divider()
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Data Channel [Your ID ($_selfId)]"),
      ),
      // floatingActionButton: _inCalling
      //     ? FloatingActionButton(
      //         onPressed: _hangUp,
      //         tooltip: 'Hangup',
      //         child: Icon(Icons.call_end),
      //       )
      //     : null,
      body: _inCalling
          ? Column(
              children: [
                ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(10.0),
                    itemCount: (_messages.length),
                    itemBuilder: (context, i) {
                      return MsgView(messages: _messages[i]);
                    }).expanded(),
                Row(
                  children: [
                    TextField(
                      controller: _textEditingController,
                      onSubmitted: (String value) async {
                        await sendMsg(value);
                      },
                      onChanged: (String value) {
                        currentMsg = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Message',
                        // You can customize the appearance of the placeholder text using the `hintStyle` property
                        hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ).addAllPadding(10).expanded(),
                    IconButton(
                      onPressed: () async {
                        await sendMsg(currentMsg);
                      },
                      icon: const Icon(Icons.send),
                      color: Colors.blue,
                    )
                  ],
                )
              ],
            )
          : Column(
            children: [
              Card(
                child: TextField(
                  onChanged: (String value) {
                    _peersFiltered = _peers.where((element) => element['id'].contains(value)).toList();
                  },
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    // You can customize the appearance of the placeholder text using the `hintStyle` property
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  ),
                ).addAllPadding(5),
              ).addAllPadding(5),
              ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.all(0.0),
                  itemCount: (_peersFiltered != null ? _peersFiltered.length : 0),
                  itemBuilder: (context, i) {
                    return _buildRow(context, _peersFiltered[i]);
                  }).expanded(),
            ],
          ),
    );
  }

  Future<void> sendMsg(String value) async {
    _textEditingController.clear();
    _messages.add(MessageItem(message: value, isMyself: true));
    await _handleDataChannelTest(value);
    currentMsg = "";
  }
}

class MsgView extends StatelessWidget {
  const MsgView({
    super.key,
    required MessageItem messages,
  }) : _message = messages;

  final MessageItem _message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          _message.isMyself ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Card(
          child: Row(
            children: [
              Text(
                _message.message,
                style: TextStyle(fontSize: 20),
              ).addAllPadding(5),
              Text(
                _message.time,
                style: TextStyle(fontSize: 10),
              ).addPadding(top: 10, right: 5),
            ],
          ),
        )
      ],
    );
    // } else {
    //   return Row(
    //     children: [
    //       Card(
    //         child: Text(
    //           _message.message,
    //           style: TextStyle(fontSize: 20),
    //         ).addAllPadding(10),
    //       ),
    //       const SizedBox(height: 1).expanded(),
    //     ],
    //   );
    // }
  }
}
