import 'package:db/addstd.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    gotoLogin();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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

  Future<void> gotoLogin() async {
   await Future.delayed(
      Duration(seconds: 2),
      () {
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (context) => ScreenOne()));
      },
    );
  }
}
