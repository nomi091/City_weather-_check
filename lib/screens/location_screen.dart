import 'package:flutter/material.dart';

import '../services/weather.dart';
import '../utilities/constants.dart';
import 'city_screen.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();
  late int temperature;
  late String countryName;
  late String WeatherIcon;
  late String Message;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI(widget.locationWeather);
  }

  void updateUI(dynamic weatherData) {
    if (weatherData == null) {
      temperature = 0;
      WeatherIcon = 'ERROR';
      Message = 'Unable to get Weather data';
      countryName = '';
      return;
    }
    var condition = weatherData['weather'][0]['id'];
    double temp = weatherData['main']['temp'].toDouble();
    temperature = temp.toInt();
    countryName = weatherData['name'];
    print(temperature);
    WeatherIcon = weather.getWeatherIcon(condition);
    Message = weather.getMessage(temperature);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            // image: DecorationImage(
            //   image: const AssetImage('images/location_background.jpg'),
            //   fit: BoxFit.cover,
            //   colorFilter: ColorFilter.mode(
            //       Colors.white.withOpacity(0.8), BlendMode.dstATop),
            // ),
            ),
        constraints: const BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () async {
                      var weatherData = await weather.getLocationWeather();
                      updateUI(weatherData);
                    },
                    child: const Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      var TypedName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CityScreen(),
                        ),
                      );
                      if (TypedName != null) {
                        var weatherData =
                            await weather.getCityWeather(TypedName);
                        updateUI(weatherData);
                      }
                    },
                    child: const Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      WeatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              Text(
                "$Message in $countryName",
                textAlign: TextAlign.right,
                style: kMessageTextStyle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
