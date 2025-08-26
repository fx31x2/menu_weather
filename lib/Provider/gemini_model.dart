import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final geminiModelProvider = Provider<GenerativeModel>((ref) {
  return GenerativeModel(
    model: 'gemini-1.5-flash',
    apiKey: dotenv.env['GEMINI_API_KEY'] ?? '',
    generationConfig: GenerationConfig(
      responseMimeType: 'application/json'
    )
  );
});

// 共有の ChatSession を提供するプロバイダ
final chatSessionProvider = StateProvider<ChatSession?>((ref) {
  final model = ref.read(geminiModelProvider);
  return model.startChat();
});