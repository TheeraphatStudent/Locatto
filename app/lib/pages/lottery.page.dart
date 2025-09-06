import 'dart:async';
import 'dart:developer';

import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:app/components/MainLayout.dart';
import 'package:flutter/material.dart';
import 'package:app/service/lottery/get.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  _LotteryPageState createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {

  final ScrollController _scrollController = ScrollController();
  final Lotteryget _lotteryService = Lotteryget();

  List<dynamic> _lotteries = [];
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;
  String _searchQuery = '';

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _fetchNextPage();
      }
    });
    _fetchNextPage();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _searchQuery = query;
        _lotteries = [];
        _page = 1;
        _hasNextPage = true;
      });
      _fetchNextPage();
    });
  }

  Future<void> _fetchNextPage() async {
    if (_isFetching || !_hasNextPage) return;

    setState(() {
      _isFetching = true;
    });

    try {
      final newItems = _searchQuery.isEmpty
          ? await _lotteryService.getLotteries(_page, 10)
          : await _lotteryService.searchLotteries(_searchQuery, _page, 10);

      if (newItems['data'].isEmpty) {
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
            showActionsBadge: true,
            actionsBadgeCount: 1,
            actionsBadgeIcon: Icons.shopping_cart,
            onActionsBadgePressed: () {
              log("Cart opened!");
            },
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
                    log("pressed callback work!");
                    log(lotteryNumber);
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
