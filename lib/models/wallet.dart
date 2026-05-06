import 'package:flutter/material.dart';

class WalletModel {
  final String id;
  final String name;
  final IconData icon;

  WalletModel({
    required this.id,
    required this.name,
    this.icon = Icons.account_balance_wallet_rounded,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon_code': icon.codePoint,
    };
  }

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'],
      name: json['name'],
      icon: IconData(json['icon_code'], fontFamily: 'MaterialIcons'),
    );
  }
}
