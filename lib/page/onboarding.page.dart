import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFA615D),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.pets,
                size: 50,
                color: Colors.white,
              ),
            ),
            
            SizedBox(height: 20),
            
            Text(
              'Locatto',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.yellow,
              ),
            ),
            
            SizedBox(height: 50),
         
            
            
            SizedBox(height: 10),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'จะเลขไหนก็  ',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '80',
                  style: TextStyle(
                    fontSize: 60,
                    //fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  'บาท',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            
            SizedBox(height: 80),
           
            GestureDetector(
              onTap: () {
                print('ไปหน้า Login');
                
              },
              child: Text(
                'มีบัญชีแล้ว?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.yellow,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.yellow,
                ),
              ),
            ),
            
            SizedBox(height: 30),
            
           
            ElevatedButton(
              onPressed: () {
                print('/Register');
                
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 150, vertical: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Text(
                'สมัครเลย',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFA615D),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}