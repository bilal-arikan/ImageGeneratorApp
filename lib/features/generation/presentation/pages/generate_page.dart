import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class GeneratePage extends ConsumerWidget {
  const GeneratePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resim Oluştur'),
      ),
      body: const Center(
        child: Text('Resim Oluşturma Sayfası'),
      ),
    );
  }
}
