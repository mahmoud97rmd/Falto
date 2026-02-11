import 'package:http/http.dart' as http;
import 'dart:convert';

class TelegramBot {
  final String token;
  final String? chatId;

  TelegramBot(this.token, {this.chatId});

  Future<void> sendMessage(String message) async {
    if (chatId == null) return;

    final url = 'https://api.telegram.org/bot$token/sendMessage';
    await http.post(
      Uri.parse(url),
      body: {
        'chat_id': chatId,
        'text': message,
      },
    );
  }

  Future<void> sendAlert(String symbol, String type, double price) async {
    final message = '[$type] $symbol @ $price';
    await sendMessage(message);
  }
}
