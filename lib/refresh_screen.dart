import 'package:db/sdtList.dart';
import 'package:flutter/material.dart';

class refreshScreen extends StatefulWidget {
  const refreshScreen({super.key});

  @override
  State<refreshScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<refreshScreen> {
  @override
  void initState() {
    gotoList();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 219, 184),
      // appBar: AppBar(backgroundColor: Color.fromARGB(255, 201, 245, 144),),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Text('Loading',style:TextStyle(color: Colors.yellow) ,),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> gotoList() async {
    await Future.delayed(
      Duration(milliseconds: 400),
      () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => StudentList()));
      },
    );
  }
}
