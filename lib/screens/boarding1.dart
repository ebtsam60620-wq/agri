import 'package:agri/core/utils/extension_methods.dart';
import 'package:flutter/material.dart';

class Boarding1 extends StatelessWidget {
  const Boarding1({super.key});

  @override
  Widget build(BuildContext context) {
    const imagePath = 'assets/images/img.jpeg';
    
    return Scaffold(
      // We use extendBodyBehindAppBar if you have an AppBar, 
      // but for a clean boarding screen, body is enough.
      body: Container(
        // Force the container to take up all available space
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover, // This is the magic line that fills the space
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'TRACK YOUR \nFARM\n USING IOT SENSORS',
                style: TextStyle(
                  fontSize: 28, 
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Changed to white for better visibility on images
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Monitor your crops in real-time.', 
                style: TextStyle(fontSize: 16, color: Colors.white.withBlue(0.8.toAlpha)),
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to Boarding2
                  },
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}