import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../widgets/crop_cycles_header.dart';
import '../widgets/crop_cycles_empty.dart';
import '../widgets/crop_cycles_list.dart';
import '../widgets/crop_cycles_add_button.dart';

class CropCyclesScreen extends ConsumerStatefulWidget {
  const CropCyclesScreen({super.key});

  @override
  ConsumerState<CropCyclesScreen> createState() => _CropCyclesScreenState();
}

class _CropCyclesScreenState extends ConsumerState<CropCyclesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  Future<void> _onRefresh() async {
    final activeModule = ref.read(device).activeModule;
    if (activeModule != null) {
      await ref
          .read(cropCycleProvider.notifier)
          .fetchCropCycles(activeModule.moduleID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(cropCycleProvider);
    final cropCycles = state.cropCycles;

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _onRefresh,
                color: ColorsManager.primary,
                child: state.status == Requestenum.loading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: ColorsManager.primary,
                        ),
                      )
                    : cropCycles.isEmpty
                        ? const CropCyclesEmpty()
                        : CropCyclesList(cropCycles: cropCycles),
              ),
            ),
            const CropCyclesAddButton(),
          ],
        ),
      ),
    );
  }
}
