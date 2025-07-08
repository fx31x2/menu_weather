import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_weather/components/chat_form.dart';
import 'package:menu_weather/components/menu.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:menu_weather/components/message_item.dart';
import 'package:menu_weather/utils/utils.dart';

class ChatPage extends HookWidget {
  const ChatPage({
      super.key,
    });

  @override
  Widget build(BuildContext context) {
    const ai = User(id: 'gemini');
    const user = User(id: 'user');

    TextEditingController chatController = TextEditingController();
    ScrollController scrollController = ScrollController();

    final chat = useState<ChatSession?>(null);
    final messages = useState<List<Message>>([]);
    

    void addMessage(User author, String text) {
      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

      final message = TextMessage(author: author, id: timeStamp, text: text);
      messages.value = [...messages.value, message];

      // 画面下に飛ばす
      debugPrint(scrollController.hasClients.toString());
      if(scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }

    Future<void> onSendMessage(PartialText text) async {
      addMessage(user, text.text);

      final content = Content.text(text.text);

      try {
        final res = await chat.value?.sendMessage(content);
        final message = res?.text;
        addMessage(ai, message!);
      } on Exception catch (e) {
        final isOverloaded = e.toString().contains('overloaded');
        final message = isOverloaded
          ? '混雑しています。しばらくしてからもう一度お試しください。'
          : 'エラーが発生しました。';
        
        addMessage(ai, message);
      }
    }

    Future<void> init() async {
      const prompt = '''
        貴方は料理人です。
        自炊の献立を考えるのを補助してください。
        日本語で播州弁で話してください。
        最初はあなたから話しかけてください。
        最初に話す言葉は「何食べたい？」だけ表示してください。
        献立以外の雑談を入力されたら、雑談は出来ない旨を伝えてください。
        長文の場合は良い感じに改行して読みやすくしてください。
        出力は
        {
          'message' : '何食べたい？',
          ingredients: [
            {
              'name' : 'じゃがいも',
              'amount' : '2個',
              'price' : 100
            },
            {
              'name' : 'にんじん',
              'amount' : '1/4個',
              'price' : 50
            }
          ]
        }
        の形式で行い、
        messageのvalueにテキスト、
        timestampのvalueに送信した時間を入れてください。
        ingredientsは料理が決まったら材料を入れてください。
        nameには材料の名前、amountには材料の個数、priceには値段を出力してください。
        出力は1人分の分量と値段でお願いします。
        料理が決まらない場合はingredients内は空のまま返してください。
        レスポンスには'は1つもつけないでください。
      ''';

      final res = await chat.value?.sendMessage(Content.text(prompt));
      final message = res?.text;
      addMessage(ai, message!);
    }

    useEffect(() {
      final model = GenerativeModel(
        model: 'gemini-1.5-flash',
        apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
        generationConfig: GenerationConfig(
          responseMimeType: 'application/json'
        )
      );

      chat.value = model.startChat();
      init();

      return null;
    }, []);

    return Scaffold(
      drawer: Menu(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          SizedBox(
            height: screenHeight(context) * 0.87,
            child: ListView.builder(
              controller: scrollController,
              itemCount: messages.value.length,
              itemBuilder: (context, index) {
                final message = messages.value[index];
                final user = messages.value[index].author;

                String text = '';

                if(user.id == 'gemini') {
                  Map<String, dynamic> item = jsonDecode(message.toJson()['text']);
                  text = item['message'];

                  debugPrint(item['ingredients'].toString());
                } else {
                  text = message.toJson()['text'];
                }
                

                return messageItem(text, user);
              }
            ),
          ),
          Expanded(
            child: Center(
              child: ChatForm(
                textController: chatController,
                hintText: 'メッセージを入力',
                onSubmitted: (value) {
                  onSendMessage(PartialText(text: chatController.text));
                }
              )
            ),
          )
        ],
      ),
    );
  }
}