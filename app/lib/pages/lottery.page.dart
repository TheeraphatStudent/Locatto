import 'dart:async';
import 'dart:developer';

import 'package:app/components/Input.dart';
import 'package:app/components/Lottery.dart';
import 'package:app/components/MainLayout.dart';
import 'package:app/components/Dialogue.dart';
import 'package:app/config.dart';
import 'package:app/service/user.dart';
import 'package:app/style/theme.dart';
import 'package:flutter/material.dart';
import 'package:app/service/lottery/get.dart';
import 'package:app/service/lottery/post.dart';
import 'package:app/service/payment/post.dart';
import 'package:app/service/purchase/post.dart';
import 'package:app/type/lottery.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class LotteryPage extends StatefulWidget {
  const LotteryPage({super.key});

  @override
  _LotteryPageState createState() => _LotteryPageState();
}

class _LotteryPageState extends State<LotteryPage> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final Lotteryget _lotteryService = Lotteryget();
  final LotteryService _lotteryPostService = LotteryService();
  final PaymentPost _paymentService = PaymentPost();
  final PurchasePost _purchaseService = PurchasePost();
  final UserService _userService = UserService();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  final AppConfig _config = AppConfig();

  List<LotteryModel> _lotteries = [];
  int _page = 1;
  bool _hasNextPage = true;
  bool _isFetching = false;
  bool _isInitialLoading = true;
  bool _isLoadingMore = false;
  String _searchQuery = '';
  int? _uid;
  String? _error;

  Timer? _debounce;

  static const int _itemsPerPage = 20;
  static const int _searchItemsPerPage = 10;
  static const Duration _debounceDelay = Duration(milliseconds: 800);
  static const double _loadMoreThreshold = 200.0;

  @override
  void initState() {
    super.initState();
    _initializeScrollListener();
    _getUserId();
    _loadInitialData();
  }

  void _initializeScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - _loadMoreThreshold) {
        _loadMoreData();
      }
    });
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(_debounceDelay, () {
      if (query.trim() != _searchQuery) {
        log("Search query changed: $query");
        _performSearch(query.trim());
      }
    });
  }

  void _performSearch(String query) {
    log("Search work!");

    setState(() {
      _searchQuery = query;
      _lotteries.clear();
      _page = 1;
      _hasNextPage = true;
      _isInitialLoading = true;
      _error = null;
    });

    _fetchData();
  }

  Future<void> _getUserId() async {
    try {
      final uidString = await _storage.read(key: _config.getUserIdStorage());
      if (uidString != null) {
        setState(() {
          _uid = int.tryParse(uidString);
        });
      }
    } catch (e) {
      log('Error getting user ID: $e');
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isInitialLoading = true;
      _error = null;
    });
    await _fetchData();
  }

  Future<void> _loadMoreData() async {
    if (_isFetching || !_hasNextPage || _isLoadingMore) return;

    setState(() {
      _isLoadingMore = true;
    });
    await _fetchData();
  }

  Future<void> _fetchData() async {
    if (_isFetching) return;

    setState(() {
      _isFetching = true;
    });

    try {
      final itemsPerPage = _searchQuery.isEmpty
          ? _itemsPerPage
          : _searchItemsPerPage;

      final response = _searchQuery.isEmpty
          ? await _lotteryService.getLotteries(_page, itemsPerPage)
          : await _lotteryPostService.searchLottery(
              _searchQuery,
              _page,
              itemsPerPage,
            );

      // log("Lottery Fetch: ${response.toString()}");

      if (response != null && response['data'] != null) {
        dynamic rawData = response['data'];
        List<dynamic> data;

        if (rawData is List) {
          data = rawData;
        } else if (rawData is Map<String, dynamic> && rawData['data'] is List) {
          data = rawData['data'];
        } else {
          data = [];
        }

        List<LotteryModel> newItems = data
            .map((item) => LotteryModel.fromJson(item as Map<String, dynamic>))
            .toList();

        // log("New items: ${newItems.length}");

        setState(() {
          if (newItems.isEmpty) {
            _hasNextPage = false;
          } else {
            _lotteries.addAll(newItems);
            _page++;

            if (newItems.length < itemsPerPage) {
              _hasNextPage = false;
            }
          }
          _error = null;
        });
      } else {
        setState(() {
          _hasNextPage = false;
          if (_lotteries.isEmpty) {
            _error = 'ไม่พบข้อมูลลอตเตอรี่';
          }
        });
      }
    } catch (e) {
      log('Error fetching lotteries: $e');
      setState(() {
        _error = 'เกิดข้อผิดพลาดในการโหลดข้อมูล';
        _hasNextPage = false;
      });
    } finally {
      setState(() {
        _isFetching = false;
        _isInitialLoading = false;
        _isLoadingMore = false;
      });
    }
  }

  Future<void> _refresh() async {
    setState(() {
      _lotteries.clear();
      _page = 1;
      _hasNextPage = true;
      _error = null;
    });
    await _loadInitialData();
  }

  Future<void> _handleLotteryPurchase(String lid, String lotteryNumber) async {
    if (_uid == null) {
      _showErrorSnackbar('ไม่พบข้อมูลผู้ใช้ กรุณาเข้าสู่ระบบใหม่');
      return;
    }

    showPurchaseDialogue(context, (String amount) async {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      // try {
      final lotAmount = int.tryParse(amount) ?? 1;
      final revenue = lotAmount * 80.0;

      // Step 1: Create payment
      final userCredit = await _userService.getUserCredit();

      if (revenue > userCredit) {
        throw Exception('ขออภัย คุณมีเงินไม่เพียงพอ!');
      }

      await _paymentService.createPayment(uid: _uid!, revenue: revenue).then((
        response,
      ) async {
        log("Payment response: ${response.toString()}");
        final paymentData = response['data'];

        if (!paymentData['success']) {
          throw Exception(paymentData['message'] ?? 'Payment failed');
        }

        log("Payment create complete!");

        log(lid);
        log(lotteryNumber);

        final payid = paymentData['payment']['payid'];

        // Step 2: Create purchase
        final purchaseResponse = await _purchaseService.createPurchase(
          uid: _uid!,
          lid: int.parse(lid),
          lotAmount: lotAmount,
          payid: payid!,
        );

        log("Purchase response: ${purchaseResponse.toString()}");

        final purchaseData = purchaseResponse['data'];

        log("Purchase data: ${purchaseData.toString()}");

        if (!purchaseData['success']) {
          throw Exception(purchaseData['message'] ?? 'Purchase failed');
        }

        log("Purchase create complete!");

        await _userService.storeUserCredit(
          purchaseData['user']['credit'].toString() ?? '0',
        );

        final newCredit = await _userService.getUserCredit();
        Provider.of<UserProvider>(context, listen: false).updateCredit(newCredit);

        Navigator.of(context).pop();

        Navigator.pushNamed(
          context,
          '/success',
          arguments: {
            'purchase': purchaseData,
            // 'payment': paymentApiResponse,
            'lottery': lotteryNumber,
          },
        );
      });
      // } catch (e) {
      //   Navigator.of(context).pop();

      //   log('Purchase error: $e');
      //   _showErrorSnackbar(
      //     'เกิดข้อผิดพลาด: ${e.toString().replaceAll('Exception: ', '')}',
      //   );
      // }
    });
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        action: SnackBarAction(
          label: 'ลองใหม่',
          textColor: Colors.white,
          onPressed: _refresh,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.casino_outlined : Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'ไม่พบข้อมูลลอตเตอรี่'
                : 'ไม่พบผลการค้นหาสำหรับ "${_searchQuery}"',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'ลองดึงข้อมูลใหม่อีกครั้ง'
                : 'ไม่พบเลข $_searchQuery ลองหาด้วย8เลขอื่น',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: Text(_searchQuery.isEmpty ? 'รีเฟรช' : 'ล้างการค้นหา'),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            _error ?? 'เกิดข้อผิดพลาด',
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: _refresh,
            icon: const Icon(Icons.refresh),
            label: const Text('ลองใหม่'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text(
            'กำลังโหลดข้อมูล...',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainLayout(
      body: Column(
        children: [
          Input(
            controller: _searchController,
            labelText: "ค้นหาเลขเด็ด",
            variant: InputVariant.active,
            suffixIcon: Icons.search,
            onChanged: _onSearchChanged,
            onActionPressed: () {
              if (_searchController.text.trim().isNotEmpty) {
                _performSearch(_searchController.text.trim());
              }
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _isInitialLoading
                ? _buildLoadingIndicator()
                : _error != null
                ? _buildErrorState()
                : _lotteries.isEmpty
                ? _buildEmptyState()
                : RefreshIndicator(
                    onRefresh: _refresh,
                    child: GridView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 2.0,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: _lotteries.length + (_isLoadingMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _lotteries.length) {
                          return Container(
                            padding: const EdgeInsets.all(16.0),
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        }

                        final item = _lotteries[index];

                        return Lottery(
                          lotteryNumber: item.lotteryNumber,
                          isSelected: false,
                          onTap: (lotteryNumber) {
                            _handleLotteryPurchase(
                              item.lid.toString(),
                              item.lotteryNumber,
                            );
                          },
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
