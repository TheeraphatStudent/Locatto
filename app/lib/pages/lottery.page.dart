import 'dart:async';
import 'dart:developer';

import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Dialogue.dart';
import 'package:app/config.dart';
import 'package:flutter/material.dart';
import 'package:app/service/lottery/get.dart';
import 'package:app/service/payment/post.dart';
import 'package:app/service/purchase/post.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  _LotteryPageState createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  final ScrollController _scrollController = ScrollController();
  final Lotteryget _lotteryService = Lotteryget();
  final PaymentPost _paymentService = PaymentPost();
  final PurchasePost _purchaseService = PurchasePost();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppConfig _config = AppConfig();

  List<dynamic> _lotteries = [];
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;
  String _searchQuery = '';
  int? _uid;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();
        _debounce = Timer(const Duration(milliseconds: 1500), () {
          _fetchNextPage();
        });
      }
    });

    _getUserId();
    _fetchNextPage();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      log("On search work! -> $query");

      setState(() {
        _searchQuery = query;
        _lotteries = [];
        _page = 1;
        _hasNextPage = true;
      });
      _fetchNextPage();
    });
  }

  Future<void> _getUserId() async {
    final uidString = await _storage.read(key: _config.getUserIdStorage());
    if (uidString != null) {
      setState(() {
        _uid = int.tryParse(uidString);
      });
    }
  }

  Future<void> _handleLotteryPurchase(String lid, String lotteryNumber) async {
    if (_uid == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบใหม่')),
      );
      return;
    }

    showPurchaseDialogue(context, (String amount) async {
      try {
        final lotAmount = int.tryParse(amount) ?? 1;
        final revenue = lotAmount * 80.0;

        // Step 1: Create payment
        final paymentResponse = await _paymentService.createPayment(
          uid: _uid!,
          revenue: revenue,
        );

        if (paymentResponse['statusCode'] != 200) {
          throw Exception('Payment failed: ${paymentResponse['message']}');
        }

        final payid = paymentResponse['payid'];

        // Step 2: Create purchase
        final purchaseResponse = await _purchaseService.createPurchase(
          uid: _uid!,
          lid: int.parse(lid),
          lotAmount: lotAmount,
          payid: payid,
        );

        if (purchaseResponse['statusCode'] != 200) {
          throw Exception('Purchase failed: ${purchaseResponse['message']}');
        }

        // Step 3: Navigate to success page
        Navigator.pushNamed(
          context,
          '/success',
          arguments: {
            'purchase': purchaseResponse,
            'payment': paymentResponse,
            'lottery': lotteryNumber,
          },
        );
      } catch (e) {
        log('Purchase error: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('เกิดข้อผิดพลาด: $e')));
      }
    });
  }

  Future<void> _fetchNextPage() async {
    if (_isFetching || !_hasNextPage) return;

    setState(() {
      _isFetching = true;
    });

    try {
      final newItems = _searchQuery.isEmpty
          ? await _lotteryService.getLotteries(_page, 20)
          : await _lotteryService.searchLotteries(_searchQuery, _page, 10);

      // log("Lottery fetch: ${newItems.toString()}");
      // log("Items: ${newItems.toString()}");

      if (newItems.isEmpty) {
        _hasNextPage = false;
      } else {
        _lotteries.addAll(newItems['data']);
        _page++;
      }
    } catch (e) {
      log('Error fetching lotteries: $e');
    } finally {
      setState(() {
        _isFetching = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          Input(
            labelText: "ค้นหาเลขเด็ด",
            variant: InputVariant.active,
            suffixIcon: Icons.search,
            // showActionsBadge: true,
            // actionsBadgeCount: 1,
            // actionsBadgeIcon: Icons.shopping_cart,
            // onActionsBadgePressed: () {
            //   log("Cart opened!");
            // },
            onActionPressed: () => {_onSearchChanged(_searchQuery)},
            onChanged: _onSearchChanged,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.builder(
              controller: _scrollController,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 2.0,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _lotteries.length,
              itemBuilder: (context, index) {
                final item = _lotteries[index];
                return Lottery(
                  lotteryNumber: item['lottery_number'],
                  isSelected: false,
                  onTap: (lotteryNumber) {
                    _handleLotteryPurchase(
                      item['lid'].toString(),
                      item['lottery_number'],
                    );
                  },
                );
              },
            ),
          ),
          if (_isFetching)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
