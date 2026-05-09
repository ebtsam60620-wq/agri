import 'package:agri/core/configs/colors_manager.dart';
import 'package:agri/notifiers.dart';
import 'package:agri/presentation/components/custom_back_btn.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveFeedScreen extends ConsumerStatefulWidget {
  const LiveFeedScreen({super.key});

  @override
  ConsumerState<LiveFeedScreen> createState() => _LiveFeedScreenState();
}

class _LiveFeedScreenState extends ConsumerState<LiveFeedScreen> {
  Room? _room;
  bool _connecting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _connect();
    });
  }

  Future<void> _connect() async {
    setState(() {
      _connecting = true;
      _error = null;
    });

    try {
      // Request permissions
      final cameraStatus = await Permission.camera.request();
      final micStatus = await Permission.microphone.request();

      if (cameraStatus.isDenied || micStatus.isDenied) {
        throw 'Camera or Microphone permission denied';
      }

      final activeModule = ref.read(device).activeModule;
      if (activeModule == null) throw 'No active module selected';

      final result = await ref
          .read(device.notifier)
          .getLiveToken(activeModule.moduleID);

      if (result == null) {
        throw 'Failed to get live token';
      }

      final room = Room();

      // Listener for events
      final listener = room.createListener();

      await room.connect(result.url, result.token);

      if (!mounted) return;
      setState(() {
        _room = room;
        _connecting = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _connecting = false;
      });
    }
  }

  @override
  void dispose() {
    _room?.disconnect();
    _room?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            if (_room != null)
              Center(child: _VideoView(room: _room!))
            else if (_connecting)
              const Center(
                child: CircularProgressIndicator(
                  color: ColorsManager.lightGreen,
                ),
              )
            else if (_error != null)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(_error!, style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _connect,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),

            // Header
            Positioned(
              top: 16,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  const SizedBox(width: 50, height: 50, child: CustomBackBtn()),
                  const SizedBox(width: 16),
                  const Text(
                    'Live Feed',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (_room != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VideoView extends StatefulWidget {
  final Room room;
  const _VideoView({required this.room});

  @override
  State<_VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<_VideoView> {
  VideoTrack? _videoTrack;

  @override
  void initState() {
    super.initState();
    _findVideoTrack();
    widget.room.addListener(_onRoomEvent);
  }

  @override
  void dispose() {
    widget.room.removeListener(_onRoomEvent);
    super.dispose();
  }

  void _onRoomEvent() {
    _findVideoTrack();
  }

  void _findVideoTrack() {
    VideoTrack? track;

    // Check remote participants
    for (var participant in widget.room.remoteParticipants.values) {
      for (var publication in participant.videoTrackPublications) {
        if (publication.track != null && publication.track is VideoTrack) {
          track = publication.track as VideoTrack;
          break;
        }
      }
      if (track != null) break;
    }

    if (track != _videoTrack) {
      setState(() {
        _videoTrack = track;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_videoTrack == null) {
      return const Text(
        'Waiting for video stream...',
        style: TextStyle(color: Colors.white70),
      );
    }

    return VideoTrackRenderer(_videoTrack!);
  }
}
