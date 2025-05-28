import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran/views/widgets/aya_card.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import '../viewmodels/quran_viewmodel.dart';

class SuraDetailScreen extends StatefulWidget {
  final int suraId;
  final int initialAya;

  const SuraDetailScreen(
      {super.key, required this.suraId, this.initialAya = 1});

  @override
  State<SuraDetailScreen> createState() => _SuraDetailScreenState();
}

class _SuraDetailScreenState extends State<SuraDetailScreen> {
  final ItemScrollController scrollController = ItemScrollController();

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<QuranViewModel>(context, listen: false);
    viewModel.loadAyatBySura(widget.suraId).then((_) {
      scrollController.scrollTo(
        index: widget.initialAya - 1,
        duration: const Duration(milliseconds: 500),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('سوره ${widget.suraId}'),
      ),
      body: Consumer<QuranViewModel>(
        builder: (context, vm, child) {
          if (vm.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return ScrollablePositionedList.builder(
            itemCount: vm.ayat.length,
            itemScrollController: scrollController,
            itemBuilder: (context, index) {
              return AyahCard(ayah: vm.ayat[index]);
            },
          );
        },
      ),
    );
  }
}
