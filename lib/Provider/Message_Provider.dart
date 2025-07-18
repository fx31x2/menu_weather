import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageState extends Notifier {
  Map<String, dynamic> _message = {};
  
  @override
  Map<String, dynamic> build() {
    return _message;
  }

  Map<String, dynamic> get message => _message;

  void update(Map<String, dynamic> value) {
    _message = value;
  }
}

final messageProvider = Provider<MessageState> ((ref) => MessageState());