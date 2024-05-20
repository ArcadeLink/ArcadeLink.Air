import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
class QrPage extends StatelessWidget {
  final String qrData;
  final int remainingTime;
  final int totalTime = 30;

  const QrPage({Key? key, required this.qrData, required this.remainingTime}) : super(key: key);

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
                      child: Container(
                        color: Colors.white,
                        child: QrImageView(data: qrData, size: 180, padding: const EdgeInsets.all(15)),
                      ),
                    ),
                  ],
                ),
                Text("剩余 $remainingTime 秒"),
                const SizedBox(
                  height: 20,
                ),
                LinearProgressIndicator(
                  value: remainingTime / totalTime,
                  color: Theme.of(context).progressIndicatorTheme.color,
                  backgroundColor: Colors.grey[200],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}