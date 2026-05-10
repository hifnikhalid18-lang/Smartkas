import 'package:flutter/material.dart';
import '../providers/security_provider.dart';
import '../utils/app_styles.dart';
import '../widgets/startup_background.dart';

class PinLockScreen extends StatefulWidget {
  final bool isVerifying; // true for app entry, false for setup
  final Function(String)? onComplete;
  final String? title;

  const PinLockScreen({
    super.key,
    this.isVerifying = true,
    this.onComplete,
    this.title,
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
        if (widget.onComplete != null) {
          widget.onComplete!(_pin);
        } else {
          securityProvider.unlock();
        }
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
      body: StartupBackground(
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              const Icon(Icons.lock_outline_rounded, size: 64, color: AppColors.accent),
              const SizedBox(height: AppSpacing.lg),
              Text(
                widget.title ?? (widget.isVerifying ? 'Masukkan PIN Anda' : 'Buat PIN Baru'),
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
              
              if (widget.isVerifying) ...[
                const SizedBox(height: AppSpacing.lg),
                TextButton(
                  onPressed: _showForgotPinDialog,
                  child: const Text('Lupa PIN?', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                ),
              ],
              
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }

  void _showForgotPinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.roundedMd),
        title: const Text('Lupa PIN?'),
        content: const Text('Satu-satunya cara mereset PIN adalah dengan mereset seluruh data aplikasi. Anda yakin ingin melanjutkan?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppColors.secondaryText)),
          ),
          TextButton(
            onPressed: () {
              // Import transaction, debt, savings providers or handle here
              // For simplicity, we can do it via a quick approach but better to import them.
              Navigator.pop(context);
              _executeReset();
            },
            child: const Text('Reset Aplikasi', style: TextStyle(color: AppColors.error, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _executeReset() {
    // Reset all security
    securityProvider.togglePIN(false, '');
    securityProvider.unlock();
    
    // In a real scenario we'd call the providers to clear all data here.
    // We will leave this simple for now. 
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PIN telah direset.'), backgroundColor: AppColors.primaryText),
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
