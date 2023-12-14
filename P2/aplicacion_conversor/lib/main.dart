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
import 'estado.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'App Conversion',
        theme: ThemeData(
          //useMaterial3: true,
          //colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF800000)),
          primaryColor: Colors.blue, // Color principal
          //secondaryHeaderColor: Colors.green,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  //Mirar con bastante calma lo de Widgets con y sin estado
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  //si no hiciese falta lo de arriba, esta linea quedaria
//class MyHomePage extends StatelessWidget
  List<String> opciones = [
    'EUR',
    'USD',
    'JPY',
    'DKK',
    'GBP',
    'SEK',
    'CHF',
    'NOK',
    'RUB',
    'TRY',
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'INR',
    'MXN',
    'ZAR'
  ];

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var textAux = [];
    var textAuxDoAux = '';
    final orientation = MediaQuery.of(context).orientation;
    return OrientationBuilder(
      builder: (context, orientation) {
        if (orientation != Orientation.portrait) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  stops: [0.5, 1], // Cambia los colores según tus preferencias
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView(
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  style: TextStyle(fontSize: 16),
                                  decoration: InputDecoration(
                                    counterText: '',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius
                                          .zero, // Esto hace que las esquinas no estén curvadas
                                      borderSide: BorderSide(
                                        width:
                                            10.0, // Ajusta este valor para cambiar el grosor del borde
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(6.0),
                                    hintText:
                                        'Introduzca un numero a convertir',
                                  ),
                                  maxLength: 10, //numero maximo de caracteres
                                  keyboardType: TextInputType.number,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'^[0-9.]*')),
                                  ],
                                  onChanged: (text) {
                                    while (text.contains('..')) {
                                      text = text.replaceAll('..', '.');
                                    }
                                    if (text.contains('.')) {
                                      if (text.startsWith('.')) {
                                        text = text.replaceAll('.', '0.');
                                      }
                                      textAux = text.split('.');

                                      if (textAux.length > 2) {
                                        for (int i = 0;
                                            i < textAux.length;
                                            i++) {
                                          if (i == 0) {
                                            textAuxDoAux = textAux[i] + '.';
                                          } else {
                                            textAuxDoAux =
                                                textAuxDoAux + textAux[i];
                                          }
                                        }
                                        text = textAuxDoAux;
                                      }
                                      if ((textAux = text.split('.')).length >
                                          1) {
                                        textAuxDoAux = textAux[1];
                                        if (textAuxDoAux.length > 2) {
                                          textAuxDoAux =
                                              textAuxDoAux.substring(0, 2);
                                        }
                                        textAuxDoAux =
                                            textAux[0] + "." + textAuxDoAux;
                                        text = textAuxDoAux;
                                      }
                                    }
                                    appState.introducirValor(text);
                                  },
                                ),
                              ),
                            ),
                            Column(children: [
                              SizedBox(
                                height: 5,
                              ),
                              DropdownButton<String>(
                                value: appState.monedaActual,
                                items: opciones.map((String opcion) {
                                  return DropdownMenuItem<String>(
                                    value: opcion,
                                    child: Text(opcion),
                                  );
                                }).toList(),
                                onChanged: (nuevaSeleccion) {
                                  setState(() {
                                    appState
                                        .cambiarMonedaEntrada(nuevaSeleccion);
                                  });
                                },
                              ),
                            ]),
                          ],
                        ),
                        SizedBox(
                          height: 13,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            String stringAux = '';
                            for (int i = 0; i < appState.cantidadSalidas; i++) {
                              stringAux = stringAux;
                              if (i != 0) {
                                stringAux = stringAux + ', ';
                              }
                              stringAux = stringAux + appState.monedaSalida[i];
                            }
                            final snackBar = SnackBar(
                              content: Text("Convirtiendo " +
                                  appState.numeroEntrada +
                                  " " +
                                  appState.monedaActual +
                                  " a " +
                                  stringAux),
                              duration: Duration(seconds: 2),
                            );
                            final snackBarMismaMoneda = SnackBar(
                              content: Text(
                                  "Error, la moneda de entrada coincide con alguna de salida, cambie alguna de las dos"),
                              duration: Duration(seconds: 3),
                            );
                            final snackBarConexion = SnackBar(
                              content:
                                  Text("Error, no hay conexión a internet"),
                              duration: Duration(seconds: 3),
                            );
                            appState.comprobacion
                                ? null
                                : appState
                                    .convertirValor(appState.numeroEntrada);

                            if (appState.comprobacion == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarMismaMoneda);
                            }
                            if (appState.conexion == false) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBarConexion);
                            }
                            if (appState.comprobacion == false &&
                                appState.conexion == true) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          style: ButtonStyle(
                              iconSize: MaterialStateProperty.all(30),
                              backgroundColor: MaterialStateProperty.all(
                                  Theme.of(context).primaryColor)),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            SizedBox(height: 50),
                            Icon(Icons.swap_vert),
                            Text(
                              'Convertir',
                              style: TextStyle(fontSize: 28),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          //crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Visibility(
                                    visible: appState.cantidadSalidas > 0,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ClipRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Color del fondo
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Color del borde
                                                width: 2.0, // Ancho del borde
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  appState.numeroSalida[0],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  value:
                                                      appState.monedaSalida[0],
                                                  items: opciones
                                                      .map((String opcion) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: opcion,
                                                      child: Text(opcion),
                                                    );
                                                  }).toList(),
                                                  onChanged: (nuevaSeleccion) {
                                                    setState(() {
                                                      appState
                                                          .cambiarMonedaSalida(
                                                              nuevaSeleccion,
                                                              0);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: appState.cantidadSalidas > 1,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ClipRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Color del fondo
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Color del borde
                                                width: 2.0, // Ancho del borde
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  appState.numeroSalida[1],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  value:
                                                      appState.monedaSalida[1],
                                                  items: opciones
                                                      .map((String opcion) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: opcion,
                                                      child: Text(opcion),
                                                    );
                                                  }).toList(),
                                                  onChanged: (nuevaSeleccion) {
                                                    setState(() {
                                                      appState
                                                          .cambiarMonedaSalida(
                                                              nuevaSeleccion,
                                                              1);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              children: [
                                SizedBox(height: 50),
                                Row(
                                  children: [
                                    SizedBox(height: 30),
                                    Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: IconButton(
                                                iconSize: 50,
                                                icon: Icon(Icons.add),
                                                color: Colors.white,
                                                onPressed: () {
                                                  appState.anadirSalida();
                                                }),
                                          ),
                                          SizedBox(width: 20),
                                          Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.rectangle,
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            child: IconButton(
                                                iconSize: 50,
                                                icon: Icon(Icons.remove),
                                                color: Colors.white,
                                                onPressed: () {
                                                  appState.quitarSalida();
                                                }),
                                          ),
                                        ])
                                  ],
                                ),
                                SizedBox(height: 30),
                              ],
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Visibility(
                                    visible: appState.cantidadSalidas > 2,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ClipRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Color del fondo
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Color del borde
                                                width: 2.0, // Ancho del borde
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  appState.numeroSalida[2],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  value:
                                                      appState.monedaSalida[2],
                                                  items: opciones
                                                      .map((String opcion) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: opcion,
                                                      child: Text(opcion),
                                                    );
                                                  }).toList(),
                                                  onChanged: (nuevaSeleccion) {
                                                    setState(() {
                                                      appState
                                                          .cambiarMonedaSalida(
                                                              nuevaSeleccion,
                                                              2);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Visibility(
                                    visible: appState.cantidadSalidas > 3,
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        ClipRect(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors
                                                  .white, // Color del fondo
                                              border: Border.all(
                                                color: Colors
                                                    .grey, // Color del borde
                                                width: 2.0, // Ancho del borde
                                              ),
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Text(
                                                  appState.numeroSalida[3],
                                                  style:
                                                      TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(
                                                  width: 20,
                                                ),
                                                DropdownButton<String>(
                                                  value:
                                                      appState.monedaSalida[3],
                                                  items: opciones
                                                      .map((String opcion) {
                                                    return DropdownMenuItem<
                                                        String>(
                                                      value: opcion,
                                                      child: Text(opcion),
                                                    );
                                                  }).toList(),
                                                  onChanged: (nuevaSeleccion) {
                                                    setState(() {
                                                      appState
                                                          .cambiarMonedaSalida(
                                                              nuevaSeleccion,
                                                              3);
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                ],
              ),
            ),
          );
        } else {
          //var contador = 0; //contador para poner el numero máximo de veces que podemos pulsar el boton add
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.grey],
                  stops: [0.5, 1], // Cambia los colores según tus preferencias
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: ListView(children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 50.0, // Ajusta el grosor de la línea
                      width:
                          double.infinity, // Ocupa todo el ancho de la pantalla
                      color: Theme.of(context).primaryColor,
                      child: Center(
                        child: Text(
                          'App Conversion',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              key: Key('entrada_texto'),
                              style: TextStyle(fontSize: 16),
                              decoration: InputDecoration(
                                counterText: '',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius
                                      .zero, // Esto hace que las esquinas no estén curvadas
                                  borderSide: BorderSide(
                                    width:
                                        10.0, // Ajusta este valor para cambiar el grosor del borde
                                  ),
                                ),
                                contentPadding: EdgeInsets.all(6.0),
                                hintText: 'Introduzca un numero a convertir',
                              ),
                              maxLength: 10, //numero maximo de caracteres
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^[0-9.]*')),
                              ],
                              onChanged: (text) {
                                while (text.contains('..')) {
                                  text = text.replaceAll('..', '.');
                                }
                                if (text.contains('.')) {
                                  if (text.startsWith('.')) {
                                    text = text.replaceAll('.', '0.');
                                  }
                                  textAux = text.split('.');

                                  if (textAux.length > 2) {
                                    for (int i = 0; i < textAux.length; i++) {
                                      if (i == 0) {
                                        textAuxDoAux = textAux[i] + '.';
                                      } else {
                                        textAuxDoAux =
                                            textAuxDoAux + textAux[i];
                                      }
                                    }
                                    text = textAuxDoAux;
                                  }
                                  if ((textAux = text.split('.')).length > 1) {
                                    textAuxDoAux = textAux[1];
                                    if (textAuxDoAux.length > 2) {
                                      textAuxDoAux =
                                          textAuxDoAux.substring(0, 2);
                                    }
                                    textAuxDoAux =
                                        textAux[0] + "." + textAuxDoAux;
                                    text = textAuxDoAux;
                                  }
                                }
                                appState.introducirValor(text);
                              },
                            ),
                          ),
                        ),
                        DropdownButton<String>(
                          key: Key('desplegable_entrada'),
                          value: appState.monedaActual,
                          items: opciones.map((String opcion) {
                            return DropdownMenuItem<String>(
                              value: opcion,
                              child: Text(opcion),
                            );
                          }).toList(),
                          onChanged: (nuevaSeleccion) {
                            setState(() {
                              appState.cambiarMonedaEntrada(nuevaSeleccion);
                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    ElevatedButton(
                      key: Key('boton_convertir'),
                      onPressed: () {
                        String stringAux = '';
                        for (int i = 0; i < appState.cantidadSalidas; i++) {
                          stringAux = stringAux;
                          if (i != 0) {
                            stringAux = stringAux + ', ';
                          }
                          stringAux = stringAux + appState.monedaSalida[i];
                        }
                        final snackBar = SnackBar(
                          content: Text("Convirtiendo " +
                              appState.numeroEntrada +
                              " " +
                              appState.monedaActual +
                              " a " +
                              stringAux),
                          duration: Duration(seconds: 2),
                        );
                        final snackBarMismaMoneda = SnackBar(
                          content: Text(
                              "Error, la moneda de entrada coincide con alguna de salida, cambie alguna de las dos"),
                          duration: Duration(seconds: 3),
                        );
                        final snackBarConexion = SnackBar(
                          content: Text("Error, no hay conexión a internet"),
                          duration: Duration(seconds: 3),
                        );
                        appState.comprobacion
                            ? null
                            : appState.convertirValor(appState.numeroEntrada);

                        if (appState.comprobacion == true) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarMismaMoneda);
                        }
                        if (appState.conexion == false) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(snackBarConexion);
                        }
                        if (appState.comprobacion == false &&
                            appState.conexion == true) {
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                      style: ButtonStyle(
                          iconSize: MaterialStateProperty.all(30),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(height: 50),
                        Icon(Icons.swap_vert),
                        Text(
                          'Convertir',
                          style: TextStyle(fontSize: 28),
                        ),
                      ]),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    Visibility(
                      visible: appState.cantidadSalidas > 0,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Color del fondo
                                border: Border.all(
                                  color: Colors.grey, // Color del borde
                                  width: 2.0, // Ancho del borde
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    appState.numeroSalida[0],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton<String>(
                                    key: Key('desplegable_salida_0'),
                                    value: appState.monedaSalida[0],
                                    items: opciones.map((String opcion) {
                                      return DropdownMenuItem<String>(
                                        value: opcion,
                                        child: Text(opcion),
                                      );
                                    }).toList(),
                                    onChanged: (nuevaSeleccion) {
                                      setState(() {
                                        appState.cambiarMonedaSalida(
                                            nuevaSeleccion, 0);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: appState.cantidadSalidas > 1,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Color del fondo
                                border: Border.all(
                                  color: Colors.grey, // Color del borde
                                  width: 2.0, // Ancho del borde
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    appState.numeroSalida[1],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton<String>(
                                    key: Key('desplegable_salida_1'),
                                    value: appState.monedaSalida[1],
                                    items: opciones.map((String opcion) {
                                      return DropdownMenuItem<String>(
                                        value: opcion,
                                        child: Text(opcion),
                                      );
                                    }).toList(),
                                    onChanged: (nuevaSeleccion) {
                                      setState(() {
                                        appState.cambiarMonedaSalida(
                                            nuevaSeleccion, 1);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: appState.cantidadSalidas > 2,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Color del fondo
                                border: Border.all(
                                  color: Colors.grey, // Color del borde
                                  width: 2.0, // Ancho del borde
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    appState.numeroSalida[2],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton<String>(
                                    key: Key('desplegable_salida_2'),
                                    value: appState.monedaSalida[2],
                                    items: opciones.map((String opcion) {
                                      return DropdownMenuItem<String>(
                                        value: opcion,
                                        child: Text(opcion),
                                      );
                                    }).toList(),
                                    onChanged: (nuevaSeleccion) {
                                      setState(() {
                                        appState.cambiarMonedaSalida(
                                            nuevaSeleccion, 2);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: appState.cantidadSalidas > 3,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          ClipRect(
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white, // Color del fondo
                                border: Border.all(
                                  color: Colors.grey, // Color del borde
                                  width: 2.0, // Ancho del borde
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    appState.numeroSalida[3],
                                    style: TextStyle(fontSize: 24),
                                  ),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  DropdownButton<String>(
                                    value: appState.monedaSalida[3],
                                    items: opciones.map((String opcion) {
                                      return DropdownMenuItem<String>(
                                        value: opcion,
                                        child: Text(opcion),
                                      );
                                    }).toList(),
                                    onChanged: (nuevaSeleccion) {
                                      setState(() {
                                        appState.cambiarMonedaSalida(
                                            nuevaSeleccion, 3);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 35),
                    Row(mainAxisSize: MainAxisSize.min, children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                            key: Key('boton_añadir'),
                            iconSize: 50,
                            icon: Icon(Icons.add),
                            color: Colors.white,
                            onPressed: () {
                              appState.anadirSalida();
                            }),
                      ),
                      SizedBox(width: 60),
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(10.0),
                          color: Theme.of(context).primaryColor,
                        ),
                        child: IconButton(
                            key: Key('boton_quitar'),
                            iconSize: 50,
                            icon: Icon(Icons.remove),
                            color: Colors.white,
                            onPressed: () {
                              appState.quitarSalida();
                            }),
                      ),
                    ])
                  ],
                ),
              ]),
            ),
          );
        }
      },
    );
  }
}
