import 'dart:async';
import 'dart:ffi';

import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';

import 'dart:convert';
import 'server_stub.dart' as stub;

class MyAppState extends ChangeNotifier {
  var monedaActual = 'EUR';

  void cambiarMonedaEntrada(moneda) {
    monedaActual = moneda;
    for (var i = 0; i < cantidadSalidas; i++) {
      if (monedaActual == monedaSalida[i]) {
        comprobacion = true;
        break;
      } else {
        comprobacion = false;
      }
    }
    notifyListeners();
  }

  var numeroEntrada = '';

  void introducirValor(valor) {
    numeroEntrada = valor;
    notifyListeners();
  }

  List<String> monedaSalida = ['USD', 'USD', 'USD', 'USD'];
  var cantidadSalidas = 1;
  List<String> numeroSalida = ['', '', '', ''];

  void anadirSalida() {
    if (cantidadSalidas < 4) {
      cantidadSalidas++;
      monedaSalida[cantidadSalidas - 1] = 'USD';
      numeroSalida[cantidadSalidas - 1] = '';
      notifyListeners();
    }
  }

  void quitarSalida() {
    if (cantidadSalidas != 1) {
      cantidadSalidas--;
      monedaSalida[cantidadSalidas] = 'USD';
      numeroSalida[cantidadSalidas] = '';
      notifyListeners();
    }
  }

  bool comprobacion = false;

  void cambiarMonedaSalida(moneda, index) {
    monedaSalida[index] = moneda;
    if (monedaSalida[index] == monedaActual) {
      comprobacion = true;
    } else {
      for (var i = 0; i < cantidadSalidas; i++) {
        if (monedaActual == monedaSalida[i]) {
          comprobacion = true;
          break;
        } else {
          comprobacion = false;
        }
      }
    }
    notifyListeners();
  }

  String buildSymbol() {
    var resultado = '';

    resultado = '$monedaActual/${monedaSalida[0]}';

    for (var i = 1; i < cantidadSalidas; i++) {
      resultado = '$resultado,$monedaActual/${monedaSalida[i]}';
    }

    return resultado;
  }

  Uri updateSymbol(Uri originalUri, String newSymbol) {
    Map<String, String> queryParameters = Map.from(originalUri.queryParameters);
    queryParameters['symbol'] = newSymbol;

    return originalUri.replace(queryParameters: queryParameters);
  }

  var uri = Uri(
      scheme: 'https',
      host: 'fcsapi.com',
      path: "/api-v3/forex/latest",
      queryParameters: {
        'symbol': "EUR/USD",
        'access_key': 'MY_API_KEY',
      });

  bool conexion = true;

  void convertirValor(valor) async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      conexion = false;
    } else {
      conexion = true;
      numeroEntrada = valor;

      var uriSymbol = buildSymbol();
      var updatedUri = updateSymbol(uri, uriSymbol);

      var response = await stub.get(updatedUri);
      var dataAsDartMap = jsonDecode(response.body);

      for (var i = 0; i < cantidadSalidas; i++) {
        var oValue = dataAsDartMap["response"][i]["o"];
        var relacion = double.parse(oValue);
        if (numeroEntrada == "") {
          numeroEntrada = "0";
        }
        var numeroEntradaFloat = double.parse(
            numeroEntrada); //parseos necesarios para hacer la operación
        var resultado = numeroEntradaFloat * relacion;
        numeroSalida[i] = resultado.toStringAsFixed(2);
      }
    }

    notifyListeners();
  }
}
