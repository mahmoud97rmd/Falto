import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfReport {
  static Future<List<int>> generate(List<String> lines) async {
    final pdf = pw.Document();
    pdf.addPage(pw.Page(build: (_) {
      return pw.Column(children: lines.map((l) => pw.Text(l)).toList());
    }));
    return pdf.save();
  }
}
