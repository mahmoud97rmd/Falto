import 'package:flutter/material.dart';
import '../../features/market/data/streaming/tick_aggregator.dart';

/// Zoom & Pan Controller
class ChartViewportController extends ChangeNotifier {
  double scale = 1.0;
  double offsetX = 0.0;

  void zoom(double delta) {
    scale = (scale * delta).clamp(0.5, 5.0);
    notifyListeners();
  }

  void pan(double delta) {
    offsetX += delta;
    notifyListeners();
  }
}

/// Crosshair Data
class CrosshairData {
  final Offset position;
  final Candle candle;

  CrosshairData(this.position, this.candle);
}

/// Chart Interaction Widget
class ZoomPanCrosshairWidget extends StatefulWidget {
  final Widget child;
  final List<Candle> candles;
  final Function(CrosshairData?) onCrosshairUpdate;
  final ChartViewportController controller;

  ZoomPanCrosshairWidget({
    required this.child,
    required this.candles,
    required this.onCrosshairUpdate,
    required this.controller,
  });

  @override
  _ZoomPanCrosshairWidgetState createState() => _ZoomPanCrosshairWidgetState();
}

class _ZoomPanCrosshairWidgetState extends State<ZoomPanCrosshairWidget> {
  Offset? _crosshairPos;
  Candle? _currentCandle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {
        widget.controller.zoom(details.scale);
      },
      onHorizontalDragUpdate: (details) {
        widget.controller.pan(details.delta.dx);
      },
      onLongPressStart: (details) {
        _updateCrosshair(details.localPosition);
      },
      onLongPressMoveUpdate: (details) {
        _updateCrosshair(details.localPosition);
      },
      onLongPressEnd: (_) {
        _updateCrosshair(null);
      },
      child: Stack(
        children: [
          widget.child,
          if (_crosshairPos != null && _currentCandle != null)
            Positioned(
              left: _crosshairPos!.dx,
              top: _crosshairPos!.dy,
              child: _CrosshairOverlay(candle: _currentCandle!),
            ),
        ],
      ),
    );
  }

  void _updateCrosshair(Offset? pos) {
    if (pos == null) {
      setState(() {
        _crosshairPos = null;
        _currentCandle = null;
      });
      widget.onCrosshairUpdate(null);
      return;
    }
    final list = widget.candles;
    if (list.isEmpty) return;

    // Snap to nearest candle
    double minDist = double.infinity;
    Candle? nearest;
    for (var c in list) {
      // assume equal spacing horizontally
      final idx = list.indexOf(c);
      final x = idx * (MediaQuery.of(context).size.width / list.length) * widget.controller.scale - widget.controller.offsetX;
      final dist = (x - pos.dx).abs();
      if (dist < minDist) {
        minDist = dist;
        nearest = c;
      }
    }

    setState(() {
      _crosshairPos = pos;
      _currentCandle = nearest;
    });
    if (nearest != null) {
      widget.onCrosshairUpdate(CrosshairData(pos, nearest));
    }
  }
}

/// Crosshair Overlay Painter
class _CrosshairOverlay extends StatelessWidget {
  final Candle candle;

  const _CrosshairOverlay({required this.candle});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black.withOpacity(0.7),
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("T: \${candle.openTime}", style: TextStyle(color: Colors.white, fontSize: 12)),
            Text("O: \${candle.open}", style: TextStyle(color: Colors.white, fontSize: 12)),
            Text("H: \${candle.high}", style: TextStyle(color: Colors.white, fontSize: 12)),
            Text("L: \${candle.low}", style: TextStyle(color: Colors.white, fontSize: 12)),
            Text("C: \${candle.close}", style: TextStyle(color: Colors.white, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}
