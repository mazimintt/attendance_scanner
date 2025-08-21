import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Homescreen extends StatelessWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          textAlign: TextAlign.center,
          'Welcome To \n COOU',
          style: TextStyle(
            color: Colors.green,
            fontWeight: FontWeight.bold
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextButton(onPressed: (){}, child: Text('SHOW PERSONAL DETAILS')),
            SizedBox(height: 10,),
            Container(
              constraints: BoxConstraints.expand(width: 150, height: 110),
              color: Colors.white,
              child: Stack(
                children: [
                  Positioned(
                    top: 0,
                      child: Icon(CupertinoIcons.book)),
                  Positioned(
                      child: Text('Courses You Teach')),
                  Positioned(
                    bottom: 0,
                      child: Text('Courses You Teach')),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
