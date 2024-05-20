import 'dart:async';
import 'package:aircade/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:otp/otp.dart';

class QrPage extends StatefulWidget {
  final int totalTime = 30;

  const QrPage({Key? key}) : super(key: key);

  @override
  _QrPageState createState() => _QrPageState();
}

class _QrPageState extends State<QrPage> {
  late Timer _timer;
  final ValueNotifier<String> _otp = ValueNotifier<String>('');
  final ValueNotifier<int> _remainingTime = ValueNotifier<int>(30);
  String? _secret;

  @override
  void initState() {
    super.initState();
    _getSecret();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime.value <= 0) {
        _remainingTime.value = widget.totalTime;
        if (_secret != null) {
          _otp.value = OTP.generateTOTPCodeString(_secret!, DateTime.now().toUtc().millisecondsSinceEpoch, length: 8);
        }
      } else {
        _remainingTime.value--;
      }
    });
  }

  Future<void> _getSecret() async {
    final userService = Provider.of<UserService>(context, listen: false);
    final user = await userService.getUserInfo();
    _secret = user['secret'];
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(20.0); // 定义圆角半径

    return Padding(
      padding: const EdgeInsets.all(100.0),
      child: Center(
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: borderRadius), // 给卡片添加圆角
          child: ClipRRect( // 使用 ClipRRect 裁剪子组件
            borderRadius: borderRadius, // 使用和卡片相同的圆角半径
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: ValueListenableBuilder<String>(
                        valueListenable: _otp,
                        builder: (context, otp, child) {
                          return Container(
                            color: Colors.white,
                            child: QrImageView(data: otp, size: 180, padding: const EdgeInsets.all(15)),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _remainingTime,
                  builder: (context, remainingTime, child) {
                    return Text("剩余 $remainingTime 秒");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                ValueListenableBuilder<int>(
                  valueListenable: _remainingTime,
                  builder: (context, remainingTime, child) {
                    return LinearProgressIndicator(
                      value: remainingTime / widget.totalTime,
                      color: Theme.of(context).progressIndicatorTheme.color,
                      backgroundColor: Colors.grey[200],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}