import 'package:flutter/material.dart';

import 'HomePage.dart';
import 'ShowPage.dart';

class RoutingPage extends StatefulWidget {
  const RoutingPage({Key? key}) : super(key: key);

  @override
  State<RoutingPage> createState() => _RoutingPageState();
}

class _RoutingPageState extends State<RoutingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
    );
  }

  Widget getBody() {
    var size= MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomePage()));
              },
              child: Container(
                  height: 60,
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.lightBlue),
                  child: const Center(
                    child: Text('Upload Image', style: TextStyle(fontSize: 15)),
                  )
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShowPage()));
              },
              child: Container(
                  height: 60,
                  width: 100,
                  margin: const EdgeInsets.only(right: 10),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: Colors.lightBlue),
                  child: const Center(
                    child: Text('Show Image', style: TextStyle(fontSize: 15)),
                  )
              ),
            ),
          ]
        )
      )
    );
  }
}
