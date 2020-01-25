import 'package:amigo_secretov2/utilities/sharedPreferences.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('saving value to shared preferences', () async {
    final shared = UserState();

    await shared.read();

    expect(shared.value, false);
  });
}
