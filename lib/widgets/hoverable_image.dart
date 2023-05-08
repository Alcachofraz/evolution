import 'package:flutter/material.dart';

class Hoverable extends StatefulWidget {
  final Widget child;
  final void Function()? onTap;
  final void Function(bool)? onHold;
  final void Function(bool)? onHover;

  const Hoverable({
    super.key,
    required this.child,
    this.onTap,
    this.onHold,
    this.onHover,
  });

  @override
  State<Hoverable> createState() => _HoverableState();
}

class _HoverableState extends State<Hoverable> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        Positioned.fill(
          child: Material(
            color: Colors.transparent,
            child: GestureDetector(
              onLongPressUp: widget.onHold != null ? () => widget.onHold!(false) : null,
              onLongPress: widget.onHold != null ? () => widget.onHold!(true) : null,
              child: InkWell(
                splashColor: Colors.grey.withOpacity(0.2),
                onTap: widget.onTap,
                onHover: widget.onHover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
