import 'package:agri/core/configs/colors_manager.dart';
import 'package:flutter/material.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveFeedWidget extends StatefulWidget {
  const LiveFeedWidget({super.key});

  @override
  State<LiveFeedWidget> createState() => _LiveFeedWidgetState();
}

class _LiveFeedWidgetState extends State<LiveFeedWidget> {
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

      final room = Room();

      // Listener for events
      final listener = room.createListener();

      const url = 'wss://raspberrypi-6stefudf.livekit.cloud';
      const token =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJBUElRbnR2b05FTTROcW8iLCJzdWIiOiJuZWxsYSIsImV4cCI6MTc4MjkzNzg2NywibmJmIjoxNzgyMzgyMzEyLCJpYXQiOjE3ODIzODIzMTIsImlkZW50aXR5IjoibmVsbGEiLCJ2aWRlbyI6eyJyb29tSm9pbiI6dHJ1ZSwicm9vbSI6IlJhc3BiZXJyeXBpIiwiY2FuUHVibGlzaCI6dHJ1ZSwiY2FuU3Vic2NyaWJlIjp0cnVlLCJjYW5QdWJsaXNoRGF0YSI6dHJ1ZX19.mCtGHxD6_6swc153tQnsf4gjmdZmH3loeTg0Az33rRg';

      await room.connect(url, token);

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
    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: ColorsManager.black,
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
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
            )
          else
             const SizedBox.shrink(),
          
          if (_room != null)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
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
            ),
        ],
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
