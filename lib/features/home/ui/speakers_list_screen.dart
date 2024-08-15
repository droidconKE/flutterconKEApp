import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SpeakerListScreen extends StatelessWidget {
  const SpeakerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text('Speakers'),
      ),
    );
  }
}
