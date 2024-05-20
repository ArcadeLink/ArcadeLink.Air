import 'package:flutter/material.dart';

class VideoPage extends StatelessWidget {
  const VideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('咕咕咕...', style: Theme.of(context).textTheme.titleMedium!
        .copyWith(color: Theme.of(context).colorScheme.secondary),)
    );
  }
}