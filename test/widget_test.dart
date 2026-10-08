import 'package:flutter_test/flutter_test.dart';
import 'package:flow_custom_ui/main.dart';

void main() {
  testWidgets('Carga inicial de MusicNovaApp', (WidgetTester tester) async {
    await tester.pumpWidget(const MusicNovaApp());
  });
}
