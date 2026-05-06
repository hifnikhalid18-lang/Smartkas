import 'package:flutter/material.dart';
import '../providers/security_provider.dart';
import '../utils/app_styles.dart';

class PinLockScreen extends StatefulWidget {
  final bool isVerifying; // true for app entry, false for setup
  final Function(String)? onComplete;

  const PinLockScreen({
    super.key,
    this.isVerifying = true,
    this.onComplete,
  });

  @override
  State<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends State<PinLockScreen> {
  String _pin = '';
  String _errorMessage = '';

  void _onKeyPress(String value) {
    if (_pin.length < 4) {
      setState(() {
        _pin += value;
        _errorMessage = '';
      });
      
      if (_pin.length == 4) {
        _processPIN();
      }
    }
  }

  void _onDelete() {
    if (_pin.isNotEmpty) {
      setState(() {
        _pin = _pin.substring(0, _pin.length - 1);
        _errorMessage = '';
      });
    }
  }

  Future<void> _processPIN() async {
    if (widget.isVerifying) {
      final isValid = await securityProvider.verifyPIN(_pin);
      if (isValid) {
        securityProvider.unlock();
      } else {
        setState(() {
          _pin = '';
          _errorMessage = 'PIN Salah. Silakan coba lagi.';
        });
      }
    } else {
      if (widget.onComplete != null) {
        widget.onComplete!(_pin);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(flex: 2),
            const Icon(Icons.lock_outline_rounded, size: 64, color: AppColors.accent),
            const SizedBox(height: AppSpacing.lg),
            Text(
              widget.isVerifying ? 'Masukkan PIN Anda' : 'Buat PIN Baru',
              style: AppTextStyles.title,
            ),
            const SizedBox(height: AppSpacing.sm),
            const Text(
              'Aplikasi ini dilindungi keamanan PIN',
              style: AppTextStyles.caption,
            ),
            const SizedBox(height: AppSpacing.xl),
            
            // PIN Indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: index < _pin.length 
                        ? AppColors.accent 
                        : AppColors.secondaryText.withOpacity(0.2),
                    border: Border.all(
                      color: index < _pin.length ? AppColors.accent : AppColors.border,
                      width: 2,
                    ),
                  ),
                );
              }),
            ),
            
            if (_errorMessage.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text(_errorMessage, style: AppTextStyles.caption.copyWith(color: AppColors.error)),
            ],
            
            const Spacer(flex: 1),
            
            // Numeric Keypad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
              child: Column(
                children: [
                  _buildKeypadRow(['1', '2', '3']),
                  _buildKeypadRow(['4', '5', '6']),
                  _buildKeypadRow(['7', '8', '9']),
                  _buildKeypadRow([null, '0', 'delete']),
                ],
              ),
            ),
            const Spacer(flex: 2),
          ],
        ),
      ),
    );
  }

  Widget _buildKeypadRow(List<String?> keys) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: keys.map((key) {
          if (key == null) return const SizedBox(width: 70);
          
          if (key == 'delete') {
            return IconButton(
              onPressed: _onDelete,
              icon: const Icon(Icons.backspace_outlined, color: AppColors.secondaryText),
              iconSize: 28,
            );
          }
          
          return InkWell(
            onTap: () => _onKeyPress(key),
            borderRadius: BorderRadius.circular(40),
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border, width: 1.5),
              ),
              child: Center(
                child: Text(
                  key,
                  style: AppTextStyles.title.copyWith(fontSize: 24),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
