import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final selectedCityProvider = NotifierProvider<SelectedCityNotifier, String>(SelectedCityNotifier.new);

class SelectedCityNotifier extends Notifier<String> {
  static const _key = 'cw_selected_city';

  @override
  String build() {
    Future.microtask(_hydrate);
    return 'Hyderabad';
  }

  Future<void> _hydrate() async {
    final p = await SharedPreferences.getInstance();
    state = p.getString(_key) ?? 'Hyderabad';
  }

  Future<void> setCity(String city) async {
    state = city;
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, city);
  }
}

final savedCarIdsProvider = NotifierProvider<SavedCarIdsNotifier, List<String>>(SavedCarIdsNotifier.new);

class SavedCarIdsNotifier extends Notifier<List<String>> {
  static const _key = 'cw_saved_car_ids';

  @override
  List<String> build() {
    Future.microtask(_hydrate);
    return const [];
  }

  Future<void> _hydrate() async {
    final p = await SharedPreferences.getInstance();
    state = List<String>.from(p.getStringList(_key) ?? const []);
  }

  Future<void> toggle(String carId) async {
    final next = List<String>.from(state);
    if (next.contains(carId)) {
      next.remove(carId);
    } else {
      next.add(carId);
    }
    state = next;
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_key, next);
  }

  bool contains(String carId) => state.contains(carId);

  Future<void> clear() async {
    state = const [];
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}
