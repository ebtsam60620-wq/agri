import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';

import '../../data/models/crop_cycle.dart';

class AddCropCycleScreen extends ConsumerStatefulWidget {
  final CropCycle? cropCycle;

  const AddCropCycleScreen({super.key, this.cropCycle});

  @override
  ConsumerState<AddCropCycleScreen> createState() => _AddCropCycleScreenState();
}

class _AddCropCycleScreenState extends ConsumerState<AddCropCycleScreen> {
  final _cycleNameCtrl = TextEditingController();
  final _areaCtrl = TextEditingController();
  final _cropNameCtrl = TextEditingController();
  DateTime? _sowingDate;
  DateTime? _harvestDate;
  final _formKey = GlobalKey<FormState>();

  bool get isUpdate => widget.cropCycle != null;

  @override
  void initState() {
    super.initState();
    if (isUpdate) {
      _cycleNameCtrl.text = widget.cropCycle!.cycleName;
      _areaCtrl.text = widget.cropCycle!.growingAreaM2?.toString() ?? '';
      _cropNameCtrl.text = widget.cropCycle!.cropName;
      _sowingDate = widget.cropCycle!.sowingDate;
      _harvestDate = widget.cropCycle!.expectedHarvestDate;
    }
  }

  @override
  void dispose() {
    _cycleNameCtrl.dispose();
    _areaCtrl.dispose();
    _cropNameCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(bool isSowing) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) => Theme(
        data: ThemeData(
          colorScheme: const ColorScheme.light(primary: ColorsManager.primary),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        if (isSowing) {
          _sowingDate = picked;
        } else {
          _harvestDate = picked;
        }
      });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_sowingDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a sowing date')),
      );
      return;
    }

    if (isUpdate) {
      ref.read(cropCycleProvider.notifier).updateCropCycle(
        cycleId: widget.cropCycle!.id,
        cycleName: _cycleNameCtrl.text.trim(),
        cropName: _cropNameCtrl.text.trim(),
        growingAreaM2: double.tryParse(_areaCtrl.text.trim()),
        sowingDate: _sowingDate!,
        expectedHarvestDate: _harvestDate,
      );
    } else {
      final activeModule = ref.read(device).activeModule;
      if (activeModule == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No active module found')),
        );
        return;
      }

      ref.read(cropCycleProvider.notifier).createCropCycle(
        moduleId: activeModule.moduleID,
        cycleName: _cycleNameCtrl.text.trim(),
        cropName: _cropNameCtrl.text.trim(),
        growingAreaM2: double.tryParse(_areaCtrl.text.trim()),
        sowingDate: _sowingDate!,
        expectedHarvestDate: _harvestDate,
      );
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(cropCycleProvider, (previous, next) {
      final status = isUpdate ? next.updateStatus : next.addStatus;
      final prevStatus = isUpdate ? previous?.updateStatus : previous?.addStatus;

      if (prevStatus != Requestenum.success && status == Requestenum.success) {
        Navigator.pop(context);
      } else if (prevStatus != Requestenum.error && status == Requestenum.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.errorMessage ?? 'Error saving crop cycle')),
        );
      }
    });

    final isLoading = isUpdate 
        ? ref.watch(cropCycleProvider).updateStatus == Requestenum.loading
        : ref.watch(cropCycleProvider).addStatus == Requestenum.loading;

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildField('Crop Cycle Name', 'Enter crop cycle name', _cycleNameCtrl),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildField('Growing Area', '______m²', _areaCtrl, keyboardType: TextInputType.number)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildField('Crop', 'Name of crop', _cropNameCtrl)),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(child: _buildDateField('Sowing Date', _sowingDate, true)),
                          const SizedBox(width: 12),
                          Expanded(child: _buildDateField('Expected Harvest', _harvestDate, false)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            _buildDoneButton(isLoading),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: Row(
        children: [
          const CustomBackBtn(),
          const SizedBox(width: 14),
          Text(
            isUpdate ? 'Update Crop Cycle' : 'Add New Crop Cycle',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: ColorsManager.textBlack,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField(
    String label,
    String hint,
    TextEditingController controller, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: ColorsManager.textBlack,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade200),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: ColorsManager.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, DateTime? date, bool isSowing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: ColorsManager.textBlack),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () => _pickDate(isSowing),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? _formatDate(date) : 'DD/MM/YYYY',
                    style: TextStyle(
                      color: date != null ? ColorsManager.textBlack : Colors.grey.shade400,
                      fontSize: 14,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                Icon(Icons.calendar_today_outlined, color: Colors.grey.shade400, size: 18),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDoneButton(bool isLoading) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      child: SizedBox(
        width: double.infinity,
        height: 52,
        child: ElevatedButton(
          onPressed: isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorsManager.primary,
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          child: isLoading 
              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
              : Text(isUpdate ? 'Update' : 'Add', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
