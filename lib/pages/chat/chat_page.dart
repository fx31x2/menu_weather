import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:menu_weather/Provider/IsOpenMenu.dart';
import 'package:menu_weather/Provider/IsSent.dart';
import 'package:menu_weather/Provider/Message_Provider.dart';
import 'package:menu_weather/components/chat_form.dart';
import 'package:menu_weather/components/menu.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:menu_weather/components/message_item.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';

class ChatPage extends HookConsumerWidget {
  const ChatPage({
      super.key,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const ai = User(id: 'gemini');
    const user = User(id: 'user');

    TextEditingController chatController = TextEditingController();
    ScrollController scrollController = ScrollController();

    final chat = useState<ChatSession?>(null);
    final messages = useState<List<Message>>([]);
    
    final messageState = ref.watch(messageProvider);

    // メニューが開いているかどうか
    final isOpenMenu = useState<bool>(false);

    // メッセージを追加する関数
    void addMessage(User author, String text) {
      
      ref.read(isSentProvider.notifier).state = false;

      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

      final message = TextMessage(author: author, id: timeStamp, text: text);
      messages.value = [...messages.value, message];

      // 画面下に飛ばす
      if(scrollController.hasClients) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    }

    // geminiにプロンプトを送信する関数
    Future<void> onSendMessage(PartialText text) async {
      addMessage(user, text.text);

      final content = Content.text(text.text);

      try {
        // geminiにメッセージを送信
        ref.read(isSentProvider.notifier).state = true;
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

    // geminiに初期プロンプトを送りつける関数
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
          'dishname' : '',
          ingredients: [
            {
              'name' : '',
              'amount' : '',
              'price' : ,
              'checkbox : 
            },
            {
              'name' : '',
              'amount' : '',
              'price' : ,
              'checkbox' : 
            }
          ],
          'recipes' : [
          {
              'name' : '',
              '1' : '',
              '2' : '',
              '3' : ''
            }
          ]
        },
        の形式で行い、
        messageのvalueにテキスト、
        ingredientsは料理が決まったら材料を入れてください。
        dishnameには決まった料理名を入れてください。
        recipesのnameには決まった料理名を入れて、手順を順番に入れ、keyはインクリメントで増やしてください。
        レシピが決まってない場合はrecipes内は空のまま返してください。
        checkboxには初期値としてfalseを入れてください。
        nameには材料の名前、amountには材料の個数、priceには値段を出力してください。
        出力は1人分の分量と値段でお願いします。
        料理が決まらない場合はingredients内は空のまま返してください。
        レスポンスには'は1つもつけないでください。
      ''';

      final res = await chat.value?.sendMessage(Content.text(prompt));
      final message = res?.text;
      addMessage(ai, message!);
    }

    // initStateみたいなもん
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

    // メッセージが更新されたらbuyList更新
    useEffect(() {
      Map<String, dynamic> item;
      // messagesの一番後ろの値のvalueを変換
      if(messages.value[messages.value.length - 1].author.id == 'gemini') {
        item = jsonDecode(messages.value[messages.value.length - 1].toJson()['text']);
        messageState.update(item);
      }

      debugPrint(messageState.message.toString());
      return null;
    }, [messages.value]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          ListView.builder(
            controller: scrollController,
            itemCount: messages.value.length,
            itemBuilder: (context, index) {
              final message = messages.value[index];
              final user = messages.value[index].author;
                  
              // textにaiかuserのチャット文を代入して出力
              String text = '';
                  
              if(user.id == 'gemini') {
                Map<String, dynamic> item = jsonDecode(message.toJson()['text']);
                text = item['message'];
              } else {
                text = message.toJson()['text'];
              }
                  
              return messageItem(text, user, ref);
            }
          ),

          // chatbar
          Align(
            alignment: Alignment(0, 0.92),
            child: ChatForm(
              textController: chatController,
              hintText: 'メッセージを入力',
              onSubmitted: (value) {
                onSendMessage(PartialText(text: chatController.text));
              }
            ),
          ),

          (isOpenMenu.value) ? 
            Menu() : 
            Container(),

          // drawer
          Container(
            child: IconButton(
              onPressed: () {
                isOpenMenu.value = !isOpenMenu.value;
                ref.read(isOpenMenuProvider.notifier).state = isOpenMenu.value;
                debugPrint('onclicked!\n ${isOpenMenu.value}');
              },
              icon: Icon(
                isOpenMenu.value ? Icons.close : Icons.menu,
                size: 30, 
                color: isOpenMenu.value ? Colors.white : Colors.black
              )
            ),
          ),
        ]
      ),
    );
  }
}