import 'package:flutter/material.dart';
import 'pin_lock_screen.dart';
import '../providers/security_provider.dart';
import '../utils/app_styles.dart';

class PinSetupScreen extends StatefulWidget {
  final bool isChanging;

  const PinSetupScreen({super.key, this.isChanging = false});

  @override
  State<PinSetupScreen> createState() => _PinSetupScreenState();
}

class _PinSetupScreenState extends State<PinSetupScreen> {
  String? _firstPin;
  bool _confirmMode = false;
  late bool _verifyingOld;

  @override
  void initState() {
    super.initState();
    _verifyingOld = widget.isChanging;
  }

  void _handlePinComplete(String pin) {
    if (_verifyingOld) {
      setState(() {
        _verifyingOld = false;
        // Proceed to set new PIN
      });
      return;
    }
    if (!_confirmMode) {
      setState(() {
        _firstPin = pin;
        _confirmMode = true;
      });
    } else {
      if (pin == _firstPin) {
        _saveAndExit(pin);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PIN tidak cocok. Silakan ulangi.'),
            backgroundColor: AppColors.error,
          ),
        );
        setState(() {
          _firstPin = null;
          _confirmMode = false;
        });
      }
    }
  }

  Future<void> _saveAndExit(String pin) async {
    if (widget.isChanging) {
      await securityProvider.updatePIN(pin);
    } else {
      await securityProvider.togglePIN(true, pin);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.isChanging ? 'PIN berhasil diubah' : 'PIN berhasil diaktifkan'),
          backgroundColor: AppColors.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isChanging 
            ? (_verifyingOld ? 'Masukkan PIN Lama' : 'Ubah PIN Baru') 
            : 'Atur PIN Keamanan'),
      ),
      body: PinLockScreen(
        isVerifying: _verifyingOld,
        title: _verifyingOld ? 'Masukkan PIN Lama' : (_confirmMode ? 'Konfirmasi PIN Baru' : 'Buat PIN Baru'),
        onComplete: _handlePinComplete,
      ),
    );
  }
}
