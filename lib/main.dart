import 'package:flutter/material.dart';

import 'features/weather/presentation/pages/weather_page.dart';
import 'injections_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Info',
      theme: ThemeData(
        primaryColor: Colors.cyan[600],
        accentColor: Colors.cyan[800],
      ),
      home: WeatherPage(),
    );
  }
}
