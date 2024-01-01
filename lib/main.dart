import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Platform Code Demo',
      debugShowCheckedModeBanner: false,     // Don't show Debug string on Android App in debug mode.
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a blue toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Give the method channel a name
  // since it uses a domain name
  // it's more likely to be unique.
  // NOTE: Replace au.com.mydomain with your own domain name.

  // This is for part 1 mentioned in my LinkedIn article.
  // Platform method name.
  static const platformForBatteryLevelAPICall =
    MethodChannel('au.com.mydomain.batterylevel/battery');

  // Platform method name.
  // This is for part 2 mentioned in my LinkedIn article
  static const platformForComputationCall =
    MethodChannel('au.com.mydomain.batterylevel/computation');

  // Get battery level error string if no result - for part 1
  String _batteryLevel = 'Unknown battery level.';

  // Get computation result error string if no result - for part 2
  String _computationResult = 'Unknown computation result.';

  // This is for part 1 mentioned in my LinkedIn article
  // This method gets called when the 'Get Battery Level' button is pressed.
  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // Here we are calling asynchronously 
      // the platform method "getBatteryLevel" and 
      // hoping to get a result indicating 
      // the battery level percentage. 
      final result = 
        await platformForBatteryLevelAPICall.invokeMethod<int>('getBatteryLevel');
      batteryLevel = 'Battery level at $result % .';
    } on PlatformException catch (e) {
        // Something went off the rails.
        // Display error message.
        batteryLevel = "Failed to get battery level: '${e.message}'.";
    }

    setState(() {
      // Replace the battery level string with a new value.
      _batteryLevel = batteryLevel;
    });
  }

  // This is for part 2 mentioned in my LinkedIn article
  // This method gets called when the 'Get Computation Result'
  // button is pressed.
  // We are passing in two integer values which will be
  // put into a JSON structure which will then be passed
  // to the platform method 'getComputationResult'.
  Future<void> _getComputationResult(int x, int y) async {
    String computationResult;
    try {
      // Computation  data passed to the platform code
      // as JSON structure.
      Map<String, dynamic> compData = {
        'compData_1': x,
        'compData_2': y,
      };

      // Here we are calling asynchronously
      // the platform method "getComputationResult" and
      // hoping to get a result indicating
      // the computation result.
      final result =
        await platformForComputationCall.invokeMethod<int>('getComputationResult', compData);
      computationResult = 'Computation result is $result';
    } on PlatformException catch (e) {
      // Something went off the rails.
      // Display error message.
      computationResult = "Failed to computation result: '${e.message}'.";
    }

    setState(() {
      // Replace the computation result string with a new value.
      _computationResult = computationResult;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: _getBatteryLevel, // For part 1
              child: const Text('Get Battery Level'),
            ),
            Text(_batteryLevel),
            ElevatedButton(
                onPressed: () => _getComputationResult(4, 11),  // For part 2
                child: const Text('Get Computation Result')),
            Text(_computationResult),
          ],
        ),
      ),
    );
  }
}
