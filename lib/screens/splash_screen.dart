import 'package:flutter/material.dart';
import 'package:task_management_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
   
    super.initState();

    Future.delayed(Duration(seconds: 3), (){
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/splash_image.png"),fit: BoxFit.cover
          ),
      ),
      
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
         Spacer(),
          Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.amber,
            ),
            
          ),
          SizedBox(height: 90,),
        ],
      )
    );
  }
}