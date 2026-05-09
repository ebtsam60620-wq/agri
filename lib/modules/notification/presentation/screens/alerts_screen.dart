import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/modules/notification/data/model/notification_model.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax_plus/iconsax_plus.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final activeModule = ref.read(device).activeModule;
      if (activeModule != null) {
        ref.read(notificationProvider.notifier).fetchAlerts(activeModule.moduleID);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationProvider);

    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const SizedBox(width: 50, height: 50, child: CustomBackBtn()),
              const SizedBox(height: 24),
              const Text(
                'Smart Alert',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A2B), // Dark green
                ),
              ),
              const SizedBox(height: 24),
              Expanded(
                child: state.status == Requestenum.loading
                    ? const Center(child: CircularProgressIndicator())
                    : state.alerts.isEmpty
                        ? const Center(child: Text('No alerts at the moment.'))
                        : ListView.builder(
                            itemCount: state.alerts.length,
                            itemBuilder: (context, index) {
                              final alert = state.alerts[index];
                              return AlertCard(alert: alert);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AlertCard extends StatelessWidget {
  final NotificationModel alert;

  const AlertCard({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final sensors = (alert.metadata?['sensors'] as List?) ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7FCF9), // Very light green/white
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alert.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A2B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      alert.body,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4A4A4A),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: alert.isCritical ? Colors.red : Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    if (alert.shortValue != null)
                      AlertChip(sensor: {'label': 'Status', 'value': alert.shortValue}),
                    ...sensors.map((s) => AlertChip(sensor: s as Map<String, dynamic>)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Color(0xFF333333),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  IconsaxPlusLinear.volume_high,
                  size: 20,
                  color: Color(0xFFDFF587),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AlertChip extends StatelessWidget {
  final Map<String, dynamic> sensor;

  const AlertChip({super.key, required this.sensor});

  @override
  Widget build(BuildContext context) {
    final label = sensor['label'] ?? 'Unknown';
    final value = sensor['value'] ?? '';
    final unit = sensor['unit'] ?? '';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF8BB546), // Muted green
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getIcon(label),
          const SizedBox(width: 6),
          Text(
            '$label ($value $unit)',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _getIcon(String label) {
    IconData iconData = IconsaxPlusLinear.info_circle;
    if (label.contains('Nitrogen') || label.contains('N2')) {
      return const Text('N₂', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold));
    } else if (label.contains('moisture')) {
      iconData = IconsaxPlusLinear.cloud_drizzle;
    } else if (label.contains('pH')) {
      iconData = IconsaxPlusLinear.refresh_2;
    }
    return Icon(iconData, size: 14, color: Colors.white);
  }
}
