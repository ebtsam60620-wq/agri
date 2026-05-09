import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/core/utils/request_enum.dart';
import 'package:agri/modules/device_model/data/model/sensor_status.dart';
import 'package:agri/modules/device_model/presentation/widgets/field_conditions_skeletons.dart';
import 'package:agri/notifiers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class FieldConditionsScreen extends ConsumerStatefulWidget {
  const FieldConditionsScreen({super.key});

  @override
  ConsumerState<FieldConditionsScreen> createState() =>
      _FieldConditionsScreenState();
}

class _FieldConditionsScreenState extends ConsumerState<FieldConditionsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    final activeModule = ref.read(device).activeModule;
    if (activeModule != null) {
      await ref
          .read(fieldConditionsProvider.notifier)
          .refreshAll(activeModule.moduleID);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsManager.scaffoldBgColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: ColorsManager.primary,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [_buildHeader(), _buildTabBar()],
                ),
              ),
              SliverFillRemaining(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _SystemTab(),
                    _SensorTab(
                      searchQuery: _searchQuery,
                      onSearch: (q) => setState(() => _searchQuery = q),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
      child: const Text(
        'Field Conditions',
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w700,
          color: ColorsManager.textBlack,
          letterSpacing: -0.5,
        ),
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TabBar(
        controller: _tabController,
        labelColor: ColorsManager.primary,
        unselectedLabelColor: Colors.grey.shade500,
        labelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        unselectedLabelStyle: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 15,
        ),
        indicatorColor: ColorsManager.primary,
        indicatorSize: TabBarIndicatorSize.label,
        indicatorWeight: 2.5,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(text: 'System'),
          Tab(text: 'Sensor'),
        ],
      ),
    );
  }
}

// ──────────────────────────── SYSTEM TAB ────────────────────────────

class _SystemTab extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SystemTab> createState() => _SystemTabState();
}

class _SystemTabState extends ConsumerState<_SystemTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetch();
    });
  }

  void _fetch() {
    final activeModule = ref.read(device).activeModule;
    if (activeModule != null) {
      ref
          .read(fieldConditionsProvider.notifier)
          .fetchLatestReading(activeModule.moduleID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fieldConditionsProvider);

    if (state.systemStatus == Requestenum.loading) {
      return const SystemTabSkeleton();
    }

    if (state.systemStatus == Requestenum.error &&
        state.latestReading == null) {
      return Center(child: Text(state.errorMessage ?? 'Error loading reading'));
    }

    final reading = state.latestReading;
    if (reading == null) {
      return const Center(child: Text('No system readings available.'));
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _TemperatureCard(temperature: reading.temperatureC ?? 0.0),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  value: '${reading.humidityPct?.toStringAsFixed(1) ?? '0'}%',
                  label: 'Humidity',
                  indicatorColor: const Color(0xFF4CAF50),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  value: '${reading.tankLevelPct?.toStringAsFixed(1) ?? '0'}%',
                  label: 'Tank Level',
                  indicatorColor: const Color(0xFF2196F3),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  value: reading.ph?.toStringAsFixed(2) ?? '0',
                  label: 'pH',
                  indicatorColor: const Color(0xFFFF9800),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _MetricCard(
                  value: '${reading.ecMsCm?.toStringAsFixed(2) ?? '0'} mS/cm',
                  label: 'EC',
                  indicatorColor: const Color(0xFF9C27B0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _MetricCard(
                  value: '${reading.tdsPpm?.toStringAsFixed(0) ?? '0'} ppm',
                  label: 'TDS',
                  indicatorColor: const Color(0xFF607D8B),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(child: SizedBox()),
            ],
          ),
        ],
      ),
    );
  }
}

class _TemperatureCard extends StatelessWidget {
  final double temperature;

  const _TemperatureCard({required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Temperature',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Text(
                  '${temperature >= 0 ? '+' : ''}${temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: ColorsManager.textBlack,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.thermostat, color: Colors.orange, size: 52),
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final String value;
  final String label;
  final Color indicatorColor;

  const _MetricCard({
    required this.value,
    required this.label,
    required this.indicatorColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: ColorsManager.textBlack,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────── SENSOR TAB ────────────────────────────

class _SensorTab extends ConsumerStatefulWidget {
  final String searchQuery;
  final ValueChanged<String> onSearch;

  const _SensorTab({required this.searchQuery, required this.onSearch});

  @override
  ConsumerState<_SensorTab> createState() => _SensorTabState();
}

class _SensorTabState extends ConsumerState<_SensorTab> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetch();
    });
  }

  void _fetch() {
    final activeModule = ref.read(device).activeModule;
    if (activeModule != null) {
      ref
          .read(fieldConditionsProvider.notifier)
          .fetchSensors(activeModule.moduleID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(fieldConditionsProvider);

    if (state.sensorStatus == Requestenum.loading) {
      return const SensorTabSkeleton();
    }

    final filtered = widget.searchQuery.isEmpty
        ? state.sensors
        : state.sensors
              .where(
                (s) => s.sensorType.toLowerCase().contains(
                  widget.searchQuery.toLowerCase(),
                ),
              )
              .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _buildSearchBar(),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Sensor List',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: ColorsManager.textBlack,
                ),
              ),
              Text(
                'View All',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: filtered.isEmpty
              ? const Center(child: Text('No sensors found'))
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) =>
                      _SensorCard(sensor: filtered[index]),
                ),
        ),
      ],
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        onChanged: widget.onSearch,
        decoration: InputDecoration(
          hintText: 'Search here....',
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}

class _SensorCard extends StatelessWidget {
  final SensorStatus sensor;

  const _SensorCard({required this.sensor});

  @override
  Widget build(BuildContext context) {
    final isActive = sensor.status.toLowerCase() == 'active';
    final lastSeen = sensor.lastSeenAt != null
        ? DateFormat('dd MMM, hh:mm a').format(sensor.lastSeenAt!)
        : 'N/A';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: ColorsManager.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  _sensorIcon(sensor.sensorType),
                  color: ColorsManager.primary,
                  size: 18,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sensor.sensorType,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                        color: ColorsManager.textBlack,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _ValueBadge(
                value: sensor.lastValueText ?? 'N/A',
                color: const Color(0xFFFF9800),
              ),
              const SizedBox(width: 8),
              Text(
                lastSeen,
                style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFE8F5E9)
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      isActive ? 'Active' : 'Inactive',
                      style: TextStyle(
                        fontSize: 11,
                        color: isActive
                            ? Colors.green.shade700
                            : Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _sensorIcon(String type) {
    switch (type.toLowerCase()) {
      case 'soil moisture':
        return Icons.water_drop_outlined;
      case 'soil ph':
        return Icons.science_outlined;
      case 'air humidity':
        return Icons.air;
      case 'luminosity':
        return Icons.light_mode_outlined;
      case 'flow rate':
        return Icons.waves;
      case 'conductivity':
        return Icons.electric_bolt_outlined;
      case 'air quality':
        return Icons.cloud_outlined;
      default:
        return Icons.sensors;
    }
  }
}

class _ValueBadge extends StatelessWidget {
  final String value;
  final Color color;

  const _ValueBadge({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        value,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
    );
  }
}
