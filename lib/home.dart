import 'package:flutter/material.dart';
import 'package:music_beta/tracks.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 800,
        width: 800,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bee2.jpg'),
                fit: BoxFit.cover)),

// color: Colors.yellow,
        child: Stack(
          children: [
            Positioned(
              left: 60,
              child: Container(
                  height: 100,
                  // color: Colors.red,
                  child: Center(
                    child: Text(
                      'WelCome To Bee_P!',
                      style: TextStyle(fontSize: 30, color: Colors.white),
                    ),
                  )),
            ),
            Positioned(
              top: 600,
              left: 115.0,
              child: Container(
                  height: 100,
                  // color: Colors.purple,
                  child: Center(
                    child: FloatingActionButton.extended(
                      label: Text(
                        "GET STARTED",
                        style: TextStyle(color: Colors.white),
                      ),
                      icon: Icon(
                        Icons.music_note_outlined,
                      ),
                      backgroundColor: Colors.red,
                      onPressed: () {
                        Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => Tracks()));
                      },
                    ),
                  )),
            ),
               Positioned(
              top: 670,
              left: 79,
              child: Container(
                  height: 100,
                  
                  // color: Colors.purple,
                  child: Center(
                    child: Text('Developed by Ajinas', style: TextStyle(color: Colors.white,  fontSize: 25.0),),
                  
                
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
