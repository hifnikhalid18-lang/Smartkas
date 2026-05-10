import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:excel/excel.dart';
import '../models/transaction.dart';
import '../services/storage_service.dart';

class BackupExportService {
  // 1. MASTER BACKUP TO JSON
  static Future<void> masterBackup() async {
    try {
      final Map<String, dynamic> allData = await StorageService.getAllAppData();
      final String jsonString = jsonEncode({
        'appName': 'Smartkas',
        'backupDate': DateTime.now().toIso8601String(),
        'data': allData,
      });

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/smartkas_master_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)], text: 'Master Backup Smartkas (All Data)');
    } catch (e) {
      throw Exception('Gagal melakukan backup: $e');
    }
  }

  // 2. MASTER RESTORE FROM JSON
  static Future<bool> masterRestore() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        Map<String, dynamic> backupData = jsonDecode(content);
        
        if (backupData['appName'] != 'Smartkas') {
          return false;
        }

        await StorageService.restoreAllAppData(backupData['data']);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // 3. EXPORT TO PDF
  static Future<void> exportToPDF(List<TransactionModel> transactions, String walletName) async {
    final pdf = pw.Document();
    final formatter = DateFormat('dd/MM/yyyy');
    final currencyFormatter = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ');

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Laporan Keuangan Smartkas', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.Text('Buku Kas: $walletName'),
              pw.Text('Tanggal Cetak: ${formatter.format(DateTime.now())}'),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                context: context,
                data: <List<String>>[
                  <String>['Tanggal', 'Keterangan', 'Kategori', 'Tipe', 'Nominal'],
                  ...transactions.map((tx) => [
                    formatter.format(tx.date),
                    tx.title,
                    tx.category,
                    tx.type == TransactionType.pemasukan ? 'Masuk' : 'Keluar',
                    currencyFormatter.format(tx.amount),
                  ]),
                ],
              ),
            ],
          );
        },
      ),
    );

    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/smartkas_laporan_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    await Share.shareXFiles([XFile(file.path)], text: 'Laporan Keuangan PDF');
  }

  // 4. EXPORT TO EXCEL
  static Future<void> exportToExcel(List<TransactionModel> transactions, String walletName) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Laporan Smartkas'];
    excel.delete('Sheet1');

    CellStyle headerStyle = CellStyle(
      bold: true,
      italic: false,
      fontFamily: getFontFamily(FontFamily.Arial),
    );

    // Header
    var header = ['Tanggal', 'Keterangan', 'Kategori', 'Tipe', 'Nominal'];
    for (var i = 0; i < header.length; i++) {
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(header[i]);
      cell.cellStyle = headerStyle;
    }

    // Data
    final formatter = DateFormat('dd/MM/yyyy');
    for (var i = 0; i < transactions.length; i++) {
      var tx = transactions[i];
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(formatter.format(tx.date));
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(tx.title);
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = TextCellValue(tx.category);
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = TextCellValue(tx.type == TransactionType.pemasukan ? 'Masuk' : 'Keluar');
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = DoubleCellValue(tx.amount);
    }

    final tempDir = await getTemporaryDirectory();
    final fileName = '${tempDir.path}/smartkas_export_${DateTime.now().millisecondsSinceEpoch}.xlsx';
    var fileBytes = excel.save();
    if (fileBytes != null) {
      File(fileName)
        ..createSync(recursive: true)
        ..writeAsBytesSync(fileBytes);
      await Share.shareXFiles([XFile(fileName)], text: 'Ekspor Data Excel');
    }
  }
}
