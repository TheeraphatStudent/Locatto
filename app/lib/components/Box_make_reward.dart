import 'dart:developer';

import 'package:app/components/List.dart';
import 'package:flutter/material.dart';

import 'package:app/service/lottery/get.dart';
import 'package:app/service/lottery/post.dart';
import 'package:flutter/rendering.dart'; // Import LotteryService

class Box_make_reward extends StatefulWidget {
  const Box_make_reward({super.key});

  @override
  State<Box_make_reward> createState() => _Box_make_rewardState();
}

class _Box_make_rewardState extends State<Box_make_reward> {
  static const double _loadMoreThreshold = 200.0;
  static const int _pageSize = 20;

  final TextEditingController numberController =
      TextEditingController(); // Controller สำหรับ TextField

  List<LotteryData> _lotteryData = [];
  bool _isLoading = false;
  int _currentPage = 0;

  final ScrollController _scrollController = ScrollController();
  final Lotteryget _lotteryServiceGet = Lotteryget();

  @override
  void initState() {
    super.initState();
    _initializeScrollListener();
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    numberController.dispose();
    super.dispose();
  }

  void _initializeScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - _loadMoreThreshold) {
        if (!_isLoading) {
          _loadMoreData();
        }
      }
    });
  }

  void _loadInitialData() async {
    setState(() {
      _isLoading = true;
      _currentPage = 0;
      _lotteryData = [];
    });

    try {
      // Load the first page directly
      final response = await _lotteryServiceGet.getLotteries(
        _currentPage,
        _pageSize,
      );

      log("Lottery: ${response.toString()}");

      final List<dynamic> lotteries = response['data'] ?? [];

      setState(() {
        _lotteryData = lotteries
            .map(
              (lottery) =>
                  LotteryData(lottery: lottery['lottery_number'] ?? '-'),
            )
            .toList();
        _isLoading = false;
        _currentPage = 1;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('Failed to load initial data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูล: $e')),
      );
    }
  }

  void _loadMoreData() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _lotteryServiceGet.getLotteries(
        _currentPage,
        _pageSize,
      );
      final List<dynamic> lotteries = response['data'] ?? [];

      setState(() {
        _lotteryData.addAll(
          lotteries
              .map(
                (lottery) =>
                    LotteryData(lottery: lottery['lottery_number'] ?? '-'),
              )
              .toList(),
        );
        _isLoading = false;
        _currentPage++;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      log('Failed to load more data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('เกิดข้อผิดพลาดในการโหลดข้อมูลเพิ่มเติม: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // width: MediaQuery.of(context).size.width * 0.9,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "สร้างรางวัล (สุ่มตามจำนวน)",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 12),

              // TextField สำหรับกรอกจำนวน
              TextField(
                controller: numberController, // เชื่อมต่อกับ Controller
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "จำนวน",
                  suffixText: "ใบ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ปุ่มดำเนินการและยกเลิก
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context); // ยกเลิกและกลับไปหน้าก่อนหน้า
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "ยกเลิก",
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        try {
                          if (numberController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('กรุณากรอกจำนวน')),
                            );
                            return;
                          }
                          final int count = int.parse(
                            numberController.text,
                          ); // ดึงค่าจาก TextField
                          final lotteryService =
                              LotteryService(); // สร้าง instance ของ LotteryService
                          final response = await lotteryService
                              .generateLotteries(count); // เรียก API
                          log('Lotteries generated: $response');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'สร้างรางวัลสำเร็จ: ${response['message']}',
                              ),
                            ),
                          );
                          // Reload data after generating new lotteries
                          _loadInitialData();
                        } catch (e) {
                          log('Failed to generate lotteries: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('เกิดข้อผิดพลาด: $e')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(color: Colors.redAccent),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      child: const Text(
                        "ดำเนินการ",
                        style: TextStyle(fontSize: 20, color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Expanded(
        //   child: SingleChildScrollView(
        //     scrollDirection: Axis.horizontal,
        //     controller: _scrollController,
        //     child: ,
        //   ),
        // ),
        LotteryList(
          lotteryList: _lotteryData,
          scrollController: _scrollController,
        ),
      ],
    );
  }
}
