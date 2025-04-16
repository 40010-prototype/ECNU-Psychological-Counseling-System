import 'package:flutter/material.dart';

/// 督导 - 我的咨询师页面
class MyCounselorsPage extends StatefulWidget {
  const MyCounselorsPage({Key? key}) : super(key: key);

  @override
  State<MyCounselorsPage> createState() => _MyCounselorsPageState();
}

class _MyCounselorsPageState extends State<MyCounselorsPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '我的咨询师',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Center(
              child: Text(
                '这里将显示督导管理的咨询师列表',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ],
      ),
    );
  }
} 