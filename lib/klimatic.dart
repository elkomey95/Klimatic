import 'package:flutter/material.dart';
import 'utel.dart' as utel;
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String _city;

  void showStuff() async {
    Map data = await getWeather(utel.appId, utel.defaultCity);

  }

  Future _goToNextScreen(BuildContext context) async {
    Map results = await Navigator.of(context)
        .push(new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new NextScreen();
    }));
    if (results != null && results.containsKey("enter")) {
      _city = results['enter'];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text("Weather Today"),
        centerTitle: true,
        backgroundColor: Colors.red,
        actions: <Widget>[
          new IconButton(
              icon: new Icon(Icons.menu),
              onPressed: () => _goToNextScreen(context))
        ],
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/umbrella.png",
              width: 470.0,
              height: 1200.0,
              fit: BoxFit.fill,
            ),
          ),
          new Container(
            alignment: Alignment.topRight,
            margin: const EdgeInsets.fromLTRB(0.0, 10.9, 20.9, 0.0),
            child: new Text(
              "${_city == null ? utel.defaultCity : _city}",
              style: new TextStyle(
                  fontStyle: FontStyle.italic,
                  fontSize: 22.9,
                  color: Colors.white),

            ),
          ),
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),
          new Container(
            margin: const EdgeInsets.fromLTRB(30.0, 290.0, 0.0, 0.0),
            child: updateTempWidget(_city),
          )
        ],
      ),
    );
  }

  Future<Map> getWeather(String appId, String city) async {
    String url;

    url = 'http://api.openweathermap.org/data/2.5/weather?q=$city&appid='
        '${utel.appId}&units=metric';
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }

  Widget updateTempWidget(String city) {
    return new FutureBuilder(
      future: getWeather(utel.appId, city == null ? utel.defaultCity : city),
      builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
        if (snapshot.hasData) {
          Map content = snapshot.data;
          return new Container(
              margin: const EdgeInsets.fromLTRB(16.0, 85.0, 0.0, 0.0),
            child: new Column(
              children: <Widget>[
                new ListTile(
                    title: new Text(
                      content["main"]["temp"].toString() + "°C",
                      style: new TextStyle(
                          color: Colors.white,
                          fontSize: 37.9,
                          fontWeight: FontWeight.w600,
                          fontStyle: FontStyle.normal),
                    ),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()}\n"
                            "Min: ${content['main']['temp_min'].toString()} °C\n"
                            "Max: ${content['main']['temp_max'].toString()} °C ",
                        style: new TextStyle(
                            color: Colors.white70,
                            fontStyle: FontStyle.normal,
                            fontSize: 17.0),
                      ),
                    ))
              ],
            ),
          );
        }
        else
          return new Container(
            margin: const EdgeInsets.fromLTRB(16.0, 85.0, 0.0, 0.0),
            child: new Text("--°C",
              style: new TextStyle(
                  color: Colors.white,
                  fontSize: 37.9,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal),
            ),
          );
      },
    );
  }
}

class NextScreen extends StatelessWidget {
  final _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset(
              "images/white_snow.png",
              fit: BoxFit.fill,
              width: 490.0,
              height: 1200.0,
            ),
          ),
          new ListView(
            children: <Widget>[
              new ListTile(
                title: new TextField(

                  keyboardType: TextInputType.text,
                  controller: _cityController,
                  decoration: new InputDecoration(
                      hintText: "Enter your city"),

                ),
              ),
              new ListTile(
                title: new FlatButton(
                    onPressed: () {
                      if (double.parse(_city) == double.nan ){
                        Navigator.pop(context, {'enter': _cityController.text});
                      }
                       },
                    color: Colors.redAccent,
                    textColor: Colors.white70,
                    child: new Text("Get Weather")),
              )
            ],
          )
        ],
      ),
    );
  }
}
