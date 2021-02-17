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

// appBar: AppBar(
//  title: Padding(
//    padding: const EdgeInsets.all(50.0),
//    child: Text(
//             'Bee_P',
//             style: TextStyle(color: Colors.black),
//           ),
//  ),



// ),


      body: Stack(

children: [

Container(
decoration: BoxDecoration(

image: DecorationImage(image: AssetImage('assets/images/bee1.jpg'),
fit: BoxFit.cover)


),
// child: RaisedButton(  onPressed: () {
  
//               Navigator.of(context)
  
//                   .push(MaterialPageRoute(builder: (context) => Tracks()));
  
//             },),

),

Container(
height: 100.0 ,
width: 600,
color: Colors.red.withOpacity(0.2),
child: Padding(
  padding: const EdgeInsets.fromLTRB(10, 20, 50, 0),
  child:   Text('Hello guys', ),
),

),

],


      ),
    
  
          

  

    );
  }
}
