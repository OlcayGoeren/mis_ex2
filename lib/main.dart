import 'dart:async';
import 'package:csv/csv.dart';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(const MyApp());
}

// Teste an echtem Device

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          textTheme: const TextTheme(
            bodyText2: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          primarySwatch: Colors.blue,
        ),
        home: const Accelerometers());
  }
}

class Accelerometers extends StatefulWidget {
  const Accelerometers({Key? key}) : super(key: key);
  @override
  State<Accelerometers> createState() => _Accelerometers();
}

class _Accelerometers extends State<Accelerometers> {
  double x = 0.0;
  double y = 0.0;
  double z = 0.0;
  List<dynamic> associateList = [
    {"number": 1, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 2, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 3, "lat": "14.97534313396318", "lon": "101.22998536005622"},
    {"number": 4, "lat": "14.97534313396318", "lon": "101.22998536005622"}
  ];
  List<List<dynamic>> rows = [];

  bool loop = true;
  var _streamSubscriptions = <StreamSubscription<dynamic>>[];
  @override
  Widget build(BuildContext context) {
    void grow() {
      List<dynamic> row = [];
      row.add("x");
      row.add("y");
      row.add("z");
      rows.add(row);

      setState(() {
        loop = false;
      });
      _streamSubscriptions
          .add(accelerometerEvents.listen((AccelerometerEvent event) {
        List<dynamic> row = [];
        row.add(event.x);
        row.add(event.y);
        row.add(event.z);
        rows.add(row);
        setState(() {
          x = event.x;
          y = event.y;
          z = event.z;
        });
      }));
    }

    void stop() {
      setState(() {
        loop = true;
      });
      _streamSubscriptions[0].cancel();
      _streamSubscriptions = <StreamSubscription<dynamic>>[];
      String csv = const ListToCsvConverter().convert(rows);
      Share.share(csv);
    }

    return SafeArea(
        child: Container(
            color: Colors.blueGrey,
            child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "X: " + x.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "Y: " + y.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      "Z: " + z.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    const Spacer(),
                    ButtonTheme(
                      minWidth: double.infinity,
                      height: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.blue)),
                        onPressed: () {
                          loop ? grow() : stop();
                        },
                        child: Center(
                            child: Text(
                          loop ? "START" : "STOP",
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                        )),
                      ),
                    ),
                  ],
                ))));
  }
}
