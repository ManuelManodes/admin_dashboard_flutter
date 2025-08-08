import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MenuItem extends StatefulWidget {
  final IconData icon;
  final String text;
  final bool isActive;
  final Function onPressed;

  const MenuItem({
    Key? key,
    required this.icon,
    required this.text,
    this.isActive = false,
    required this.onPressed,
  }) : super(key: key);

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _MenuItemState extends State<MenuItem> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 250),
      color: isHovered
          ? Colors.white.withValues(alpha: 0.15)
          : widget.isActive
          ? Colors.white.withValues(alpha: 0.12)
          : Colors.transparent,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.isActive ? null : () => widget.onPressed(),
          splashColor: Colors.white.withValues(alpha: 0.2),
          highlightColor: Colors.white.withValues(alpha: 0.1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (_) => setState(() => isHovered = true),
              onExit: (_) => setState(() => isHovered = false),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    transform: isHovered
                        ? Matrix4.translationValues(3, 0, 0)
                        : Matrix4.translationValues(0, 0, 0),
                    child: Icon(
                      widget.icon,
                      color: isHovered || widget.isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.4),
                      size: isHovered ? 22 : 20,
                    ),
                  ),
                  SizedBox(width: isHovered ? 12 : 10),
                  AnimatedDefaultTextStyle(
                    duration: Duration(milliseconds: 200),
                    style: GoogleFonts.roboto(
                      fontSize: 16,
                      fontWeight: isHovered || widget.isActive
                          ? FontWeight.w500
                          : FontWeight.w400,
                      color: isHovered || widget.isActive
                          ? Colors.white
                          : Colors.white.withValues(alpha: 0.8),
                    ),
                    child: Text(widget.text),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
