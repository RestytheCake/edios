import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  @override
  Widget build(BuildContext context) {

    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/images/patterndark.png"),
                fit: BoxFit.cover
            ),
          ),
          width: deviceWidth,
          height: deviceHeight,
          child: Column(
            children: [
              // Top Banner
              Container(
                width: deviceWidth,
                height: deviceHeight * 0.30,
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 20, 10, 10),
                      alignment: Alignment.centerLeft,
                      child: const Text(
                        'Announcements',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22
                        ),
                      ),
                    ), // Title
                    Container(
                        height: deviceHeight * 0.2,
                        child: const Text('Stream-builder')


                    ),
                  ],
                ),
              ),
              Container( // Title 2
                padding: const EdgeInsets.fromLTRB(20, 0, 10, 0),
                alignment: Alignment.centerLeft,
                child: const Text(
                  'Daily Posts',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22
                  ),
                ),
              ),

              Container(
                child: const Text('Stream-Builder 2'),
              ),
            ],
          ),
        )
    );
  }
}