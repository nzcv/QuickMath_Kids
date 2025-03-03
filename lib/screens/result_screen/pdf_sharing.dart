import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';


class QuizPDFGenerator {
  static Future<File> generateQuizPDF({
    required List<String> answeredQuestions,
    required List<bool> answeredCorrectly,
    required int totalTime,
  }) async {
    final pdf = pw.Document();
    
    final correctAnswers = answeredCorrectly.where((correct) => correct).length;
    final totalQuestions = answeredQuestions.length;
    final score = totalQuestions > 0 
        ? ((correctAnswers / totalQuestions) * 100).toStringAsFixed(1) 
        : '0';
    final minutes = totalTime ~/ 60;
    final seconds = totalTime % 60;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (context) => [
          pw.Header(
            level: 0,
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('QuickMath Kids - Quiz Report',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 10),
                pw.Text(
                  DateTime.now().toString().split('.')[0],
                  style: const pw.TextStyle(
                    fontSize: 14,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ),

          pw.Container(
            padding: const pw.EdgeInsets.all(10),
            margin: const pw.EdgeInsets.symmetric(vertical: 20),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.blue),
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
            ),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Quiz Summary',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    )),
                pw.SizedBox(height: 10),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Time Taken',
                        '$minutes:${seconds.toString().padLeft(2, '0')}'),
                    _buildSummaryItem('Score', '$score%'),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSummaryItem('Total Questions', totalQuestions.toString()),
                    _buildSummaryItem('Correct Answers', correctAnswers.toString()),
                  ],
                ),
              ],
            ),
          ),

          pw.Header(
            level: 1,
            text: 'Detailed Questions & Answers',
            textStyle: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 10),

          ...List.generate(answeredQuestions.length, (index) {
            return pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 10),
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: answeredCorrectly[index] 
                      ? PdfColors.green 
                      : PdfColors.red,
                  width: 0.5,
                ),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(5)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Container(
                        width: 24,
                        height: 24,
                        decoration: pw.BoxDecoration(
                          color: answeredCorrectly[index] 
                              ? PdfColors.green 
                              : PdfColors.red,
                          shape: pw.BoxShape.circle,
                        ),
                        alignment: pw.Alignment.center,
                        child: pw.Text(
                          (index + 1).toString(),
                          style: pw.TextStyle(
                            color: PdfColors.white,
                            fontWeight: pw.FontWeight.bold,
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 10),
                      pw.Expanded(
                        child: pw.Text(
                          answeredQuestions[index],
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/quiz_results.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static pw.Widget _buildSummaryItem(String label, String value) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          label,
          style: const pw.TextStyle(
            color: PdfColors.grey700,
            fontSize: 12,
          ),
        ),
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 14,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
      ],
    );
  }
}