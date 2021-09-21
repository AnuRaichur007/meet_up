import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class Menu extends StatelessWidget {
  @override
  Widget interest(image, Caption) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.black),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(200.0),
          ))),
      onPressed: () {},
      child: Column(
        children: [
          Image(
            height: 275,
            image: AssetImage(image),
          ),
          Text(
            Caption,
            style: TextStyle(fontSize: 25.0, color: Colors.teal),
          ),
        ],
      ),
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Center(
          child: Text(
            'Pick your Interest!',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.teal.shade800,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(8),
        crossAxisSpacing: 70,
        mainAxisSpacing: 50,
        crossAxisCount: 1,
        children: <Widget>[
          interest('Images/Sports.png', 'Sports'),
          interest('Images/Arts.png', 'Arts'),
          interest('Images/Movies.png', 'Movies'),
          interest('Images/Music.png', 'Music'),
          interest('Images/Technology.png', 'Technology'),
          interest('Images/Science.png', 'Science'),
        ],
      ),
    );
  }
}
