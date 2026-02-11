import 'package:flutter/material.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';
import '../drawing/undo_redo_drawing_manager.dart';

/// =======================
/// Drawing Tool Types
/// =======================
enum DrawTool {
  none,
  trendline,
  horizontal,
  box,
}

/// =======================
/// Data Classes
/// =======================
abstract class DrawShape {
  void paint(Canvas canvas, Paint paint);
}

class TrendlineShape extends DrawShape {
  final Offset start;
  final Offset end;

  TrendlineShape(this.start, this.end);

  @override
  void paint(Canvas canvas, Paint paint) {
    canvas.drawLine(start, end, paint);
  }
}

class HorizontalShape extends DrawShape {
  final double y;

  HorizontalShape(this.y);

  @override
  void paint(Canvas canvas, Paint paint) {
    canvas.drawLine(Offset(0, y), Offset(canvasSize.width, y), paint);
  }

  static Size canvasSize = Size.zero;
}

class BoxShape extends DrawShape {
  final Offset start;
  final Offset end;

  BoxShape(this.start, this.end);

  @override
  void paint(Canvas canvas, Paint paint) {
    final rect = Rect.fromPoints(start, end);
    canvas.drawRect(rect, paint);
  }
}

/// =======================
/// Drawing Controller (Merged with UndoRedo)
/// =======================
class DrawingToolController {
  final UndoRedoManager _undoRedo = UndoRedoManager();
  final List<DrawShape> _shapes = [];

  DrawTool currentTool = DrawTool.none;
  Offset? startPoint;

  List<DrawShape> get shapes => List.unmodifiable(_shapes);

  void setTool(DrawTool tool) {
    currentTool = tool;
  }

  void onTapDown(Offset position) {
    if (currentTool == DrawTool.none) return;
    startPoint = position;
  }

  void onTapUp(Offset position) {
    if (startPoint == null || currentTool == DrawTool.none) return;

    DrawShape shape;
    switch (currentTool) {
      case DrawTool.trendline:
        shape = TrendlineShape(startPoint!, position);
        break;
      case DrawTool.horizontal:
        shape = HorizontalShape(position.dy);
        break;
      case DrawTool.box:
        shape = BoxShape(startPoint!, position);
        break;
      default:
        return;
    }

    _shapes.add(shape);
    _undoRedo.execute(DrawingCommand("shape", shape));
    startPoint = null;
  }

  void undo() {
    final cmd = _undoRedo.undo();
    if (cmd != null && cmd.data is DrawShape) {
      _shapes.remove(cmd.data);
    }
  }

  void redo() {
    final cmd = _undoRedo.redo();
    if (cmd != null && cmd.data is DrawShape) {
      _shapes.add(cmd.data);
    }
  }

  void clearAll() {
    _shapes.clear();
    _undoRedo.clear();
  }
}

/// =======================
/// Painter + Interaction
/// =======================
class DrawingToolsPainter extends CustomPainter {
  final List<DrawShape> shapes;

  DrawingToolsPainter(this.shapes);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.redAccent
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    for (var shape in shapes) {
      shape.paint(canvas, paint);
    }
  }

  @override
  bool shouldRepaint(covariant DrawingToolsPainter oldDelegate) =>
      oldDelegate.shapes != shapes;
}

/// =======================
/// Integrated Widget
/// =======================
class DrawingOverlay extends StatefulWidget {
  final Widget child;
  final DrawingToolController controller;

  const DrawingOverlay({
    required this.child,
    required this.controller,
  });

  @override
  _DrawingOverlayState createState() => _DrawingOverlayState();
}

class _DrawingOverlayState extends State<DrawingOverlay> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) =>
          widget.controller.onTapDown(details.localPosition),
      onPanUpdate: (details) => widget.controller.onTapUp(details.localPosition),
      child: Stack(
        children: [
          widget.child,
          CustomPaint(
            size: Size.infinite,
            painter: DrawingToolsPainter(widget.controller.shapes),
          ),
        ],
      ),
    );
  }
}

/// =======================
/// Repaint Boundary Helper
/// =======================
class ChartWithDrawing extends StatelessWidget {
  final List<Candle> candles;
  final DrawingToolController controller;
  final CustomPainter chartPainter;

  const ChartWithDrawing({
    required this.candles,
    required this.controller,
    required this.chartPainter,
  });

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: DrawingOverlay(
        controller: controller,
        child: CustomPaint(
          size: Size.infinite,
          painter: chartPainter,
        ),
      ),
    );
  }
}
