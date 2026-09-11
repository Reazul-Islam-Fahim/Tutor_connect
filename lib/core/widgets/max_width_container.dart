import 'package:flutter/material.dart';

/// Mirrors the original web prototype's `max-width: 430px` phone-frame
/// convention. On phones the app fills the width edge-to-edge (fluid); on
/// tablets/foldables/desktop-width windows it centres the content in a
/// phone-proportioned column instead of stretching every card and button
/// uncomfortably wide.
class MaxWidthContainer extends StatelessWidget {
  const MaxWidthContainer({
    super.key,
    required this.child,
    this.maxWidth = 480,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      heightFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}
