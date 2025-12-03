import 'package:flutter/material.dart';

class ToastMessage {
<<<<<<< HEAD
  static void show(
    BuildContext context, {
    required String message,
    bool success = true,
    Duration duration = const Duration(seconds: 2),
  }) {
    // Usa o ScaffoldMessenger, mais seguro que Overlay manual
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) {
      debugPrint("ToastMessage: context inválido");
      return;
    }

    final color = success ? Colors.green : Colors.redAccent;
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        duration: duration,
      ),
    );
=======
  static void show(BuildContext context,
      {required String message, bool success = true, Duration duration = const Duration(seconds: 2)}) {
    final color = success ? Colors.green : Colors.redAccent;
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => Positioned(
        top: 80,
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        child: Material(
          color: Colors.transparent,
          child: SlideTransition(
            position: Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0))
                .animate(CurvedAnimation(parent: ModalRoute.of(context)!.animation!, curve: Curves.easeOut)),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
    overlay.insert(entry);
    Future.delayed(duration, () => entry.remove());
>>>>>>> 9c82ab519e76e2aab86085aadf3acb3552d9df9c
  }
}