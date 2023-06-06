
import 'package:flutter/material.dart';

class HomeScreenState extends StatefulWidget{
  const HomeScreenState({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreenState>{

  @override
  void initState(){
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Screen"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        backgroundColor: Colors.blueGrey,
        elevation: 5,
      ),
      body: Container(),
    );
  }
}