import 'package:flutter_test/flutter_test.dart';
import 'package:dental_house/main.dart';

void main() {
  testWidgets('Carga inicial de login smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('DentalHouse'), findsWidgets);
    expect(find.text('Inicio de Sesión'), findsOneWidget);
  });
}
