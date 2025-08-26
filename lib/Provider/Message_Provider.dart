import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageState extends Notifier<Map<String, dynamic>> {
  @override
  Map<String, dynamic> build() {
    return {};
  }

  void setMessage(Map<String, dynamic> value) {
    state = Map<String, dynamic>.from(value);
  }

  void setCheckBox(int index, bool value) {
    final List<Map<String, dynamic>> ingredients =
        List<Map<String, dynamic>>.from(state['ingredients'] ?? []);
    if (index < 0 || index >= ingredients.length) return;

    final updatedIngredients = List<Map<String, dynamic>>.from(ingredients);
    final updatedItem = Map<String, dynamic>.from(updatedIngredients[index]);
    updatedItem['checkbox'] = value;
    updatedIngredients[index] = updatedItem;

    state = {
      ...state,
      'ingredients': updatedIngredients,
    };
  }
}

final messageProvider = NotifierProvider<MessageState, Map<String, dynamic>>(
  MessageState.new,
);