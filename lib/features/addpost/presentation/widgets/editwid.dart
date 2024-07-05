import 'package:flutter/material.dart';
import 'package:iclick/features/addpost/data/models/dargable.dart';

class MenuIconWidget extends StatelessWidget {
  const MenuIconWidget({
    super.key,
    this.onTap,
    required this.icon,
  });

  final IconData icon;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
          color: Colors.blueGrey.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

class DragableWidget extends StatelessWidget {
  DragableWidget({
    super.key,
    required this.widgetId,
    required this.child,
    this.onPress,
    this.onLongPress,
  });

  final int widgetId;

  /// we font set the child as final
  /// so when we edit we can replace this with we child
  DragableWidgetChild child;
  final void Function(int, DragableWidgetChild)? onPress;
  final void Function(int)? onLongPress;
  final ValueNotifier<Offset> possition = ValueNotifier<Offset>(Offset.zero);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      key: UniqueKey(),
      valueListenable: possition,
      builder: (context, value, child) {
        return Transform(
          transform: Matrix4.identity()
            ..translate(
              value.dx,
              value.dy,
            ),
          child: child,
        );
      },
      child: GestureDetector(
        key: UniqueKey(),
        onTap: () {
          onPress?.call(widgetId, child);
        },
        onLongPress: () {
          onLongPress?.call(widgetId);
        },
        onPanUpdate: (details) {
          possition.value += details.delta;
        },
        child: _buildChild(child),
      ),
    );
  }

  Widget _buildChild(DragableWidgetChild child) {
    if (child is DragableWidgetTextChild) {
      return Text(
        child.text,
        key: UniqueKey(),
        textAlign: child.textAlign,
        style: child.textStyle?.copyWith(
          fontSize: child.fontSize,
          color: child.color,
          fontStyle: child.fontStyle,
          fontWeight: child.fontWeight,
        ),
      );
    }
    return Container();
  }
}
