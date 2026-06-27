import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';

class ProtoAvatar extends StatelessWidget {
  final bool isSpeaking;

  const ProtoAvatar({super.key, this.isSpeaking = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Hologram Glow Effect
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00D4FF).withOpacity(0.2),
                  blurRadius: 50,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          ModelViewer(
            src: 'assets/models/robot_head.glb',
            alt: "Proto Avatar",
            autoRotate: true,
            disableZoom: true,
            backgroundColor: Colors.transparent,
            cameraControls: false,
            // Simple animation toggle via speaking state
            autoPlay: isSpeaking,
            animationName: isSpeaking ? "Talk" : "Idle",
          ),
        ],
      ),
    );
  }
}
