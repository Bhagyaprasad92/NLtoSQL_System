import 'package:flutter/material.dart';
import 'package:frontend/config/api_config.dart';
import '../models/student.dart';

class StudentCardWidget extends StatefulWidget {
  final Student student;
  final VoidCallback onTap;

  const StudentCardWidget({
    super.key,
    required this.student,
    required this.onTap,
  });

  @override
  State<StudentCardWidget> createState() => _StudentCardWidgetState();
}

class _StudentCardWidgetState extends State<StudentCardWidget> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(isHovered ? 1.02 : 1.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color:
                  isHovered ? const Color(0xFF111111) : const Color(0xFFEAEAEA),
              width: isHovered ? 1.5 : 1.0,
            ),
            boxShadow:
                isHovered
                    ? [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ]
                    : [],
          ),
          child: Column(
            children: [
              Expanded(
                flex: 4,
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(15),
                  ),
                  child: Container(
                    width: double.infinity,
                    color: const Color(0xFFFAFAFA),
                    child:
                        widget.student.photoUrl.isNotEmpty
                            ? Image.network(
                              ApiConfig.getImageUrl(widget.student.photoUrl),
                              fit: BoxFit.cover,
                              alignment: const Alignment(0, -0.6),
                              errorBuilder: (c, e, s) {
                                debugPrint(
                                  'Image load error for ${widget.student.rollNo}. URL: ${widget.student.photoUrl}',
                                );
                                debugPrint('Error details: $e');
                                return const Center(
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.black12,
                                    size: 50,
                                  ),
                                );
                              },
                            )
                            : const Center(
                              child: Icon(
                                Icons.person,
                                color: Colors.black12,
                                size: 50,
                              ),
                            ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    border: Border(top: BorderSide(color: Color(0xFFEAEAEA))),
                  ),
                  child: Center(
                    child: Text(
                      widget.student.rollNo.isNotEmpty
                          ? widget.student.rollNo
                          : '-',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Color(0xFF111111),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}