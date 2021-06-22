import 'package:flutter/material.dart';
import '../util/utils.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
  String cityEntered = defaultCity;

  Future nextPage(BuildContext context) async {
    Map data = await Navigator.of(context)
        .push(MaterialPageRoute(builder: (BuildContext context) {
      return City();
    }));
    if (data.containsKey('city') && data['city'] != '') {
      setState(() {
        cityEntered = data['city'];
      });
    } else {
      setState(() {
        cityEntered = defaultCity;
      });
    }
  }

  // void showData() async {
  //   Map data;
  //   data = await getData(apiKey, cityEntered);
  //   debugPrint(data.toString());
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () => nextPage(context),
          ),
        ],
        title: Text('Klimatic',
            style: GoogleFonts.pattaya(
              textStyle: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white54,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: Image.asset(
              'images/umbrella.png',
              height: 900,
              fit: BoxFit.fill,
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 20, 30, 0),
            child: Text(
              cityEntered,
              style: cityStyle(),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Image.asset('images/light_rain.png'),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(50, 450, 0, 0),
            child: displayData(),
          ),
        ],
      ),
    );
  }

  TextStyle cityStyle() {
    return TextStyle(
      color: Colors.white,
      fontStyle: FontStyle.italic,
      fontSize: 30,
    );
  }

  TextStyle dataStyle() {
    return TextStyle(fontSize: 40, color: Colors.white);
  }

  Future<Map> getData(String apiKey, String city) async {
    String apiUrl =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";
    http.Response res = await http.get(Uri.parse(apiUrl));
    return json.decode(res.body);
  }

  Widget displayData() {
    return FutureBuilder(
      future: getData(apiKey, cityEntered),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data['cod'] == 200) {
          Map data = snapshot.data;
          print(data);
          return Container(
            child: Column(
              children: [
                ListTile(
                  title: Text(
                    '${data['main']['temp'].toString()}° C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  subtitle: Text(
                    'Humidity: ${data['main']['humidity']}\nMin: ${data['main']['temp_min']}\nMax: ${data['main']['temp_max']}',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                )
              ],
            ),
          );
        } else {
          print('else');
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Container(
              child: Column(
                children: [
                  ListTile(
                    title: Text(
                      '\"No such city found\"',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        }
      },
    );
  }
}

class City extends StatefulWidget {
  @override
  _CityState createState() => _CityState();
}

class _CityState extends State<City> {
  TextEditingController cityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Text('Klimatic',
            style: GoogleFonts.pattaya(
              textStyle: TextStyle(color: Colors.black, fontSize: 25),
            )),
        backgroundColor: Colors.white54,
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          ListView(
            children: [
              Image.asset(
                'images/city.jpg',
                fit: BoxFit.fill,
                height: 800,
              ),
            ],
          ),
          ListView(children: [
            ListTile(
              title: TextField(
                style: TextStyle(color: Colors.white),
                controller: cityController,
                decoration: InputDecoration(
                  hintText: 'enter city',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                ),
              ),
            ),
            ListTile(
              title: ElevatedButton(
                child: Text('show weather report'),
                onPressed: () {
                  Navigator.pop(context, {'city': cityController.text});
                },
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
