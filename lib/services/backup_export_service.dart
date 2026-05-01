import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import '../models/transaction.dart';
import '../providers/transaction_provider.dart';

class BackupExportService {
  // 1. Backup to JSON
  static Future<void> backupData(List<TransactionModel> transactions) async {
    try {
      final List<Map<String, dynamic>> jsonData = 
          transactions.map((tx) => tx.toJson()).toList();
      final String jsonString = jsonEncode(jsonData);

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/kasku_backup_${DateTime.now().millisecondsSinceEpoch}.json');
      await file.writeAsString(jsonString);

      await Share.shareXFiles([XFile(file.path)], text: 'Backup Data KasKu');
    } catch (e) {
      throw Exception('Gagal melakukan backup: $e');
    }
  }

  // 2. Restore from JSON
  static Future<bool> restoreData() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        List<dynamic> jsonData = jsonDecode(content);
        
        List<TransactionModel> transactions = jsonData
            .map((item) => TransactionModel.fromJson(item))
            .toList();

        // Update provider data
        for (var tx in transactions) {
          transactionProvider.addTransaction(tx);
        }
        // Note: This adds to existing. If we want to replace, we need clearAll first.
        // The user said "menggantikan data lama"
        
        transactionProvider.clearAllTransactions();
        for (var tx in transactions) {
          transactionProvider.addTransaction(tx);
        }
        
        return true;
      }
      return false;
    } catch (e) {
      throw Exception('Gagal melakukan restore: $e');
    }
  }

  // 3. Export to CSV
  static Future<void> exportToCSV(List<TransactionModel> transactions) async {
    try {
      final DateFormat formatter = DateFormat('dd-MM-yyyy HH:mm');
      
      // Header CSV
      String csvContent = 'Tanggal,Tipe,Nominal,Keterangan\n';
      
      // Data Rows
      for (var tx in transactions) {
        String type = tx.type == TransactionType.pemasukan ? 'Pemasukan' : 'Pengeluaran';
        csvContent += '${formatter.format(tx.date)},$type,${tx.amount},"${tx.title}"\n';
      }

      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/kasku_export_${DateTime.now().millisecondsSinceEpoch}.csv');
      await file.writeAsString(csvContent);

      await Share.shareXFiles([XFile(file.path)], text: 'Ekspor Data KasKu (CSV)');
    } catch (e) {
      throw Exception('Gagal melakukan ekspor: $e');
    }
  }
}
