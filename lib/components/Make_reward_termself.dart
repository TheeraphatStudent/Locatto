import 'package:flutter/material.dart';

class MakeRewardTermself extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: RewardPage(),
    );
  }
}

class RewardPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 231, 223),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 249, 246, 246),
            borderRadius: BorderRadius.circular(15),
            border: Border.all(color: Colors.white!),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'สร้างรางวัล (สุ่มตามจำนวน)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              
              SizedBox(height: 20),
              
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Text('จำนวน' ,style:TextStyle(fontWeight: FontWeight.bold)),
                    Expanded(
                      child: TextField(
                        textAlign: TextAlign.center,
                        decoration: InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Text('ใบ',style: TextStyle(fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              
              SizedBox(height: 20),
              
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFFA615D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text('ยกเลิก', style: TextStyle(color: Colors.white ,fontWeight:FontWeight.bold,fontSize: 20)),
                    ),
                  ),
                  
                  SizedBox(width: 40),
                  
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: BorderSide(color: Colors.white),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      child: Text('ดำเนินการ', style: TextStyle(color: Color(0xFFFA615D),fontWeight: FontWeight.bold,fontSize: 20)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}