import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weatherapp/features/weather/presentation/bloc/weather_bloc.dart';

import '../../../../injections_container.dart';

class WeatherPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Information'),
      ),
      body: SingleChildScrollView(child: buildBody(context)),
    );
  }

  BlocProvider<WeatherBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WeatherBloc>(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 10,
            ),
            Container(
              height: MediaQuery.of(context).size.height / 3,
              child: BlocBuilder<WeatherBloc, WeatherState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return Center(
                      child: Text(
                        'Empieza a buscar!',
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else if (state is Loading) {
                    return Center(child: CircularProgressIndicator());
                  } else if (state is Loaded) {
                    return Center(
                      child: Column(children: <Widget>[
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          'El clima de hoy en ${state.weather.location.name}',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '${state.weather.current.tempc}°C',
                          style: TextStyle(
                            fontSize: 45,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Con vientos de ${state.weather.current.windkph} KPH',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'Con una humedad de  ${state.weather.current.humidity}%',
                          style: TextStyle(fontSize: 25),
                          textAlign: TextAlign.center,
                        ),
                      ]),
                    );
                  } else if (state is Error) {
                    return Center(
                      child: Text(
                        state.message,
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 20,
            ),
            WeatherControl()
          ],
        ),
      ),
    );
  }
}

class WeatherControl extends StatefulWidget {
  @override
  _WeatherControlState createState() => _WeatherControlState();
}

class _WeatherControlState extends State<WeatherControl> {
  final controller = TextEditingController();
  String inputStr;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 50,
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Ingrese una Ciudad",
            ),
            onSubmitted: (_) {
              dispatchConcreteEvent();
              inputStr = '';
            },
            onChanged: (value) {
              inputStr = value;
            },
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 50,
          child: RaisedButton(
              color: Theme.of(context).accentColor,
              textTheme: ButtonTextTheme.primary,
              child: Text('Obtener el Clima'),
              onPressed: dispatchConcreteEvent),
        ),
      ],
    );
  }

  void dispatchConcreteEvent() {
    controller.clear();
    BlocProvider.of<WeatherBloc>(context)
        .add(GetWeatherForConcreteCity(inputStr));
  }
}
