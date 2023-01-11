import 'package:disease_application_bachelor_thesis/animation/animated_overlay.dart';
import 'package:disease_application_bachelor_thesis/animation/tween_animation.dart';
import 'package:disease_application_bachelor_thesis/widgets/fab_item.dart';
import 'package:flutter/material.dart';

class FabMenu extends StatefulWidget {
  List<FabItemData> items;
  FabMenu(this.items);

  @override
  State<FabMenu> createState() => FabMenuState();
}

class FabMenuState extends State<FabMenu> with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  bool _isFabMenuVisible = false;

  @override
  void initState() {
    _fabController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 260));

    _fabAnimation = _fabController.curvedTweenAnimation(
      begin: 0.0,
      end: 1.0,
    );

    super.initState();
  }

  @override
  void dispose() {
    _fabController.dispose();

    super.dispose();
  }

  void _toggleFabMenu() {
    _isFabMenuVisible = !_isFabMenuVisible;

    if (_isFabMenuVisible) {
      _fabController.forward();
    } else {
      _fabController.reverse();
    }
  }

  void onPress([Function? callback]) {
    _toggleFabMenu();

    callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return AnimatedOverlay(
      animation: _fabAnimation,
      color: Color.fromARGB(0, 255, 255, 255),
      onPress: _toggleFabMenu,
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.bottomRight,
        child: ExpandedAnimationFab(
          animation: _fabAnimation,
          onPress: _toggleFabMenu,
          items: widget.items,
        ),
      ),
    );
  }
}
