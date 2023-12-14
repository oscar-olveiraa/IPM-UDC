// UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
import 'package:flutter/services.dart' show rootBundle;

import 'dart:convert';
import 'dart:io';
import 'dart:math';

// Available currencies:
// EUR
// USD
// JPY
// DKK
// GBP
// SEK
// CHF
// NOK
// RUB
// TRY
// AUD
// BRL
// CAD
// CNY
// INR
// MXN
// ZAR

class StubResponse {
  final bool ok;
  final int statusCode;
  final String body;
  StubResponse(this.ok, this.statusCode, this.body);
}

Future<StubResponse> get(Uri uri) async {
  print("-- Using stub server ---");

  // UNCOMMENT THIS LINE WHEN USING THE STUB IN A FLUTTER PROJECT
  var stringData = await rootBundle.loadString('assets/exchangeRates.json');

  // COMMENT THESE TWO LINES WHEN USING THE STUB
  //var file = File("assets/exchangeRates.json"); // COMMENT IN FLUTTER PROJECT
  //var stringData = await file.readAsString();   // COMENNT IN FLUTTER PROJECT

  var staticData = jsonDecode(stringData);

  var response = [];
  var symbolAsString = uri.queryParameters['symbol'];
  if (symbolAsString != null) {
    var symbolList = symbolAsString.split(",");
    for (var symbol in symbolList) {
      var currencies = symbol.split("/");
      var exchangeRates = staticData[currencies[0]];
      if (exchangeRates != null) {
        var data = exchangeRates["response"].firstWhere(
            (exchangeRate) => exchangeRate["s"] == symbol,
            orElse: () => {});
        if (data.isNotEmpty) {
          response.add(data);
        }
      }
    }
  }
  var body = {};
  if (response.isNotEmpty) {
    body = {
      "status": true,
      "code": 200,
      "msg": "Successfuly",
      "response": response,
      "info": staticData["EUR"]["info"]
    };
  } else {
    body = {
      "status": false,
      "code": 113,
      "msg":
          "Sorry, Something wrong, or an invalid value. Please try again or check your required parameters.",
      "info": {"credit_count": 0}
    };
  }
  var rng = Random();
  return Future.delayed(Duration(seconds: rng.nextInt(5)))
      .then((value) => StubResponse(true, 200, jsonEncode(body)));
}
