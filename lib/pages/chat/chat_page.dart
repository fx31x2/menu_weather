import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:menu_weather/Provider/gemini_model.dart';

import 'package:menu_weather/components/chat_form.dart';
import 'package:menu_weather/components/menu.dart';

import 'package:menu_weather/Provider/IsOpenMenu.dart';
import 'package:menu_weather/Provider/IsSent.dart';
import 'package:menu_weather/Provider/Message_Provider.dart';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:menu_weather/components/message_item.dart';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:menu_weather/components/navigation_button.dart';
import 'package:menu_weather/utils/utils.dart';

import 'package:menu_weather/database/database_service.dart';


class ChatPage extends HookConsumerWidget {
  const ChatPage({
      super.key,
    });

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    late Future<List<Leftover>> _leftovers;
    _leftovers = DatabaseService.instance.getLeftovers();

    late Future<List<Allergy>> _allergy;
    _allergy = DatabaseService.instance.getAllergy();

    final leftoversFuture = useState<Future<List<Leftover>>>(
      DatabaseService.instance.getLeftovers()
    );

    final allergyFuture = useState<Future<List<Allergy>>>(
      DatabaseService.instance.getAllergy()
    );

    final allergy = useMemoized(() => DatabaseService.instance.getAllergy());
    final allsnap = useFuture(allergy);

    final leftover = useMemoized(() => DatabaseService.instance.getLeftovers());
    final leftsnap = useFuture(leftover);

    const ai = User(id: 'gemini');
    const user = User(id: 'user');

    TextEditingController chatController = TextEditingController();
    ScrollController scrollController = ScrollController();

    final chat = useState<ChatSession?>(null);
    final messages = useState<List<Message>>([]);
    
    final messageState = ref.watch(messageProvider);

    // gemini_model は chatSessionProvider に集約

    // メニューが開いているかどうか
    final isOpenMenu = useState<bool>(false);

    // 一番下にスクロールする関数（ビルド完了後に実行）
    void scrollToBottom() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!scrollController.hasClients) return;
        final position = scrollController.position.maxScrollExtent;
        scrollController.animateTo(
          position,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeOut,
        );
      });
    }

    // メッセージを追加する関数
    void addMessage(User author, String text) {
      final timeStamp = DateTime.now().millisecondsSinceEpoch.toString();

      final message = TextMessage(author: author, id: timeStamp, text: text);
      messages.value = [...messages.value, message];

      // 画面下に飛ばす（ビルド完了後）
      scrollToBottom();
    }

    // geminiにプロンプトを送信する関数
    Future<void> onSendMessage(PartialText text) async {
      addMessage(user, text.text);

      final content = Content.text(text.text);

      try {
        // geminiにメッセージを送信
        ref.read(isSentProvider.notifier).state = true;
        // 読み込み中インジケータ用のプレースホルダーを追加
        addMessage(ai, '');

        final res = await chat.value?.sendMessage(content);
        final message = res?.text ?? '';

        // プレースホルダー（最後のAIメッセージ）を実レスポンスで置き換え
        if (messages.value.isNotEmpty &&
            messages.value[messages.value.length - 1].author.id == 'gemini') {
          final last = messages.value[messages.value.length - 1];
          final updated = TextMessage(
            author: last.author,
            id: last.id,
            text: message,
          );
          messages.value = [
            ...messages.value.sublist(0, messages.value.length - 1),
            updated,
          ];
        } else {
          // 念のため（想定外の場合）は追加
          addMessage(ai, message);
        }

        ref.read(isSentProvider.notifier).state = false;
      } on Exception catch (e) {
        final isOverloaded = e.toString().contains('overloaded');
        final message = isOverloaded
          ? '混雑しています。しばらくしてからもう一度お試しください。'
          : 'エラーが発生しました。';

        // すでにプレースホルダーがあれば置き換え、なければ追加
        if (messages.value.isNotEmpty &&
            messages.value[messages.value.length - 1].author.id == 'gemini' &&
            (messages.value[messages.value.length - 1] as TextMessage).text.isEmpty) {
          final last = messages.value[messages.value.length - 1];
          final updated = TextMessage(
            author: last.author,
            id: last.id,
            text: message,
          );
          messages.value = [
            ...messages.value.sublist(0, messages.value.length - 1),
            updated,
          ];
        } else {
          addMessage(ai, message);
        }

        ref.read(isSentProvider.notifier).state = false;
      }
    }


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

    // geminiに初期プロンプトを送りつける関数
    Future<void> init() async {


      

      final res = await chat.value?.sendMessage(Content.text(prompt));
      final message = res?.text;

      addMessage(ai, message!);
    }

    // initStateみたいなもん
    useEffect(() {
      // 共有セッションに差し替え
      chat.value = ref.read(chatSessionProvider);
      init();



      return null;
    }, []);

    useEffect(() {
      // 余りもの初期読み込み

      if (leftsnap.hasData && leftsnap.data!.isNotEmpty) {
        final leftNames = leftsnap.data!.map((l) => l.name).join(', ');
        sendMessage("$leftNamesが余りものです。こちらの食材を使用した料理を積極的に提供してください。", ref);
      }


      // アレルギー初期読み込み
      if (allsnap.hasData && allsnap.data!.isNotEmpty) {
        final allergyNames = allsnap.data!.map((a) => a.name).join(', ');
        print("\na\nb\nc\nd\n$allergyNames\na\nb\nc\nd");
        sendMessage("$allergyNamesがアレルギーなので、何が何でも材料に加えないでください。", ref);
      } 
      return null;
    },[allsnap.hasData]);

    // メッセージが更新されたらbuyList更新
    useEffect(() {
      if (messages.value.isNotEmpty &&
          messages.value[messages.value.length - 1].author.id == 'gemini') {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final lastText = messages.value[messages.value.length - 1]
              .toJson()['text']
              .toString();
          // JSONのみ処理
          if (lastText.trim().isNotEmpty) {
            try {
              final item = jsonDecode(lastText);
              ref.read(messageProvider.notifier).setMessage(item);
            } catch (_) {
              // JSONでない場合は無視
            }
          }
        });
      }

      debugPrint(messageState.toString());
      // メッセージが更新されるたびに最下部へ
      scrollToBottom();
      return null;
    }, [messages.value]);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Column(
            children: [
              NavigationButton(
                func: () {
                  isOpenMenu.value = !isOpenMenu.value;
                  ref.read(isOpenMenuProvider.notifier).state = isOpenMenu.value;
                  debugPrint('onclicked!\n ${isOpenMenu.value}');
                },
                icon: Icon(
                  isOpenMenu.value ? Icons.close : Icons.menu,
                  size: 30, 
                  color: isOpenMenu.value ? Colors.white : Colors.black
                ),
              ),
              Expanded(
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: messages.value.length,
                  itemBuilder: (context, index) {
                    final message = messages.value[index];
                    final user = messages.value[index].author;
                        
                    // textにaiかuserのチャット文を代入して出力
                    String text = '';
                    final rawText = message.toJson()['text']?.toString() ?? '';

                    if (user.id == 'gemini') {
                      if (rawText.trim().isEmpty) {
                        // プレースホルダー（JumpingDots表示用）
                        text = '';
                      } else {
                        try {
                          final decoded = jsonDecode(rawText);
                          if (decoded is Map<String, dynamic> && decoded['message'] is String) {
                            text = decoded['message'] as String;
                          } else {
                            // 想定外の構造やJSONでない場合はそのまま表示
                            text = rawText;
                          }
                        } catch (_) {
                          // JSONでなければそのまま表示
                          text = rawText;
                        }
                      }
                    } else {
                      text = rawText;
                    }
                        
                    return messageItem(text, user, ref);
                  }
                ),
              ),
              
              // chatbar
              Container(
                margin: EdgeInsets.only(bottom: 30),
                decoration: BoxDecoration(
                  // color: Colors.red
                ),
                child: ChatForm(
                  textController: chatController,
                  hintText: 'メッセージを入力',
                  onSubmitted: (value) {
                    onSendMessage(PartialText(text: chatController.text));
                  }
                ),
              ),
            ],
          ),

          IgnorePointer(
            ignoring: !isOpenMenu.value,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                if (isOpenMenu.value) {
                  isOpenMenu.value = false;
                  ref.read(isOpenMenuProvider.notifier).state = false;
                }
              },
              child: SizedBox(
                height: screenHeight(context),
                width: screenWidth(context),
              ),
            ),
          ),

          (isOpenMenu.value) ? 
            Menu() : 
            Container(),

          // drawer
          (isOpenMenu.value) ?
          NavigationButton(
            func: () {
              isOpenMenu.value = !isOpenMenu.value;
              ref.read(isOpenMenuProvider.notifier).state = isOpenMenu.value;
              debugPrint('onclicked!\n ${isOpenMenu.value}');
            },
            icon: Icon(
              isOpenMenu.value ? Icons.close : Icons.menu,
              size: 30, 
              color: isOpenMenu.value ? Colors.white : Colors.black
            )
          ) : Container()
        ]
      ),
    );
  }
}