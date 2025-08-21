import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';

class UploadSuccessCard extends StatefulWidget {
  final String? imagePath;
  final void Function()? onClose;

  const UploadSuccessCard({
    super.key,
    this.imagePath,
    this.onClose,
  });

  @override
  State<UploadSuccessCard> createState() => _UploadSuccessCardState();
}

class _UploadSuccessCardState extends State<UploadSuccessCard>
    with TickerProviderStateMixin {
  late final AnimationController _checkController;
  bool _showImage = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();

    _checkController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));

    _checkController.forward().whenComplete(() async {
      await Future.delayed(const Duration(milliseconds: 100));
      if (!mounted) return;
      setState(() => _showImage = true);

      await Future.delayed(const Duration(milliseconds: 450));
      if (!mounted) return;
      setState(() => _showText = true);
    });
  }

  @override
  void dispose() {
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(40, 20, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: SizedBox(
        height: 56,
        width: double.infinity,
        child: Stack(
          children: [
            Center(
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: _showImage ? 0 : 1,
                child: IgnorePointer(
                  ignoring: _showImage,
                  child: AnimatedCheck(
                    progress: _checkController,
                    size: 60,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              alignment: _showImage ? Alignment.centerLeft : Alignment.center,
              child: AnimatedOpacity(
                // hide the row until the image phase begins
                duration: const Duration(milliseconds: 150),
                opacity: _showImage ? 1 : 0,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        AnimatedScale(
                          duration: const Duration(milliseconds: 350),
                          curve: Curves.easeOutBack,
                          scale: _showImage ? 1 : 0.85,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.imagePath!,
                              height: 48,
                              width: 48,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: -8,
                          right: -8,
                          child: GestureDetector(
                            onTap: widget.onClose,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    AnimatedOpacity(
                      duration: const Duration(milliseconds: 350),
                      opacity: _showText ? 1 : 0,
                      child: AnimatedSlide(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        offset: _showText ? Offset.zero : const Offset(0.15, 0),
                        child: Text(
                          'Uploaded!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.green.shade600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
