import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:aplicacion_conversor/main.dart' as app;
import 'package:aplicacion_conversor/estado.dart' as app2;
import 'package:mockito/mockito.dart';
import 'dart:async';

void main() {
  testWidgets('Aumentar cantidad de salidas y luego disminuirla',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app2.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app2.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    expect(appState.cantidadSalidas, 1);

    var botonFinder = find.byKey(Key('boton_añadir'));

    await tester.tap(botonFinder);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    expect(appState.cantidadSalidas, 2);

    botonFinder = find.byKey(Key('boton_quitar'));

    await tester.tap(botonFinder);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    expect(appState.cantidadSalidas, 1);

    await tester.pump(Duration(seconds: 1));
  });

  testWidgets('Cambiar moneda de entrada y de salida (mismo funcionamiento)',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app2.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app2.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    expect(appState.monedaActual, 'EUR');

    var desplegableFinder = find.byKey(Key('desplegable_entrada'));

    await tester.tap(desplegableFinder);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    await tester.tap(find.text('BRL'));

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    expect(appState.monedaActual, 'BRL');

    expect(appState.monedaSalida[0], 'USD');

    desplegableFinder = find.byKey(Key('desplegable_salida_0'));

    await tester.tap(desplegableFinder);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    await tester.tap(find.text('NOK'));

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    expect(appState.monedaSalida[0], 'NOK');

    await tester.pump(Duration(seconds: 1));
  });

  testWidgets('Introducir valor y convertirlo', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app2.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app2.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    expect(appState.numeroEntrada, '');

    var entradaFinder = find.byKey(Key('entrada_texto'));

    await tester.enterText(entradaFinder, '123');

    await tester.pump();

    await tester.pump(Duration(seconds: 2));

    expect(appState.numeroEntrada, '123');

    expect(appState.numeroSalida[0], '');

    var conversionFinder = find.byKey(Key('boton_convertir'));

    await tester.tap(conversionFinder);

    await tester.pump(Duration(seconds: 10));

    expect(appState.numeroSalida[0], '130.24');

    await tester.pump(Duration(seconds: 1));
  });

  testWidgets('Error moneda de entrada igual que moneda de salida',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app2.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app2.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    expect(appState.monedaActual, 'EUR');

    expect(appState.monedaSalida[0], 'USD');

    var desplegableFinder = find.byKey(Key('desplegable_salida_0'));

    await tester.tap(desplegableFinder);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    await tester.tap(find.text('EUR').last);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    expect(appState.comprobacion, true);

    await tester.pump(Duration(seconds: 1));
  });

  testWidgets('Test completo', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app2.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app2.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    expect(appState.numeroEntrada, '');

    var entradaFinder = find.byKey(Key('entrada_texto'));

    await tester.enterText(entradaFinder, '123');

    await tester.pump();

    await tester.pump(Duration(seconds: 2));

    expect(appState.numeroEntrada, '123');

    expect(appState.numeroSalida[0], '');

    expect(appState.numeroSalida[1], '');

    expect(appState.numeroSalida[2], '');

    var botonFinder = find.byKey(Key('boton_añadir'));

    await tester.tap(botonFinder);

    await tester.pumpAndSettle();

    await tester.tap(botonFinder);

    await tester.pumpAndSettle();

    var desplegableFinder1 = find.byKey(Key('desplegable_salida_1'));

    await tester.tap(desplegableFinder1);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    await tester.tap(find.text('DKK'));

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    var desplegableFinder2 = find.byKey(Key('desplegable_salida_2'));

    await tester.tap(desplegableFinder2);

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    await tester.tap(find.text('NOK'));

    await tester.pumpAndSettle();

    await tester.pump(Duration(seconds: 2));

    var conversionFinder = find.byKey(Key('boton_convertir'));

    await tester.tap(conversionFinder);

    await tester.pump(Duration(seconds: 10));

    expect(appState.numeroSalida[0], '130.24');

    expect(appState.numeroSalida[1], '917.78');

    expect(appState.numeroSalida[2], '1431.19');

    await tester.pump(Duration(seconds: 1));
  });

  // En caso de querer ejecutar este test habria que desconectar el wifi manualmente
  // antes de ejecutarlo

  /*testWidgets('Error de conexion', (WidgetTester tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => app.MyAppState(),
        child: MaterialApp(
          home: app.MyHomePage(),
        ),
      ),
    );

    var appState = Provider.of<app.MyAppState>(
        tester.element(find.byType(app.MyHomePage)),
        listen: false);

    var convertirFinder = find.byKey(Key('boton_convertir'));

    await tester.tap(convertirFinder);

    await tester.pumpAndSettle();

    expect(appState.conexion, false);
  });*/
}
