import 'package:barcode_widget/barcode_widget.dart' hide BarcodeType;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../domain/entities/loyalty_card.dart';
import '../providers/loyalty_cards_usecase_providers.dart';
import 'card_number_display.dart';

/// Фабрика визуального кода (ТЗ 6.3.21.5): ean13/code128/pdf417 —
/// barcode_widget, qr — qr_flutter, manual и ошибки генерации — крупный номер.
/// Жёсткое правило: фон ВСЕГДА белый, код ВСЕГДА чёрный (считывание кассиром).
/// Имя BarcodeType у пакета barcode своё — скрываем его импортом (hide),
/// чтобы работал наш enum из domain/entities/loyalty_card.dart.
class BarcodeWidgetFactory extends ConsumerWidget {
  const BarcodeWidgetFactory({super.key, required this.card});

  final LoyaltyCard card;

  Widget _fallback(BuildContext context, WidgetRef ref) {
    final formatted = ref
        .read(formatCardNumberForDisplayUseCaseProvider)
        .call(card.cardNumber ?? card.barcodeData);
    return CardNumberDisplay(number: formatted);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formatted = ref
        .watch(formatCardNumberForDisplayUseCaseProvider)
        .call(card.cardNumber ?? card.barcodeData);
    switch (card.barcodeType) {
      case BarcodeType.ean13:
        return BarcodeWidget(
          barcode: Barcode.ean13(),
          data: card.barcodeData,
          width: 280,
          height: 180,
          color: Colors.black,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          errorBuilder: (context, error) => _fallback(context, ref),
        );
      case BarcodeType.code128:
        return BarcodeWidget(
          barcode: Barcode.code128(),
          data: card.barcodeData,
          width: 280,
          height: 180,
          color: Colors.black,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          errorBuilder: (context, error) => _fallback(context, ref),
        );
      case BarcodeType.pdf417:
        return BarcodeWidget(
          barcode: Barcode.pdf417(),
          data: card.barcodeData,
          width: 280,
          height: 180,
          color: Colors.black,
          backgroundColor: Colors.white,
          padding: const EdgeInsets.all(24),
          errorBuilder: (context, error) => _fallback(context, ref),
        );
      case BarcodeType.qr:
        return Container(
          color: Colors.white,
          padding: const EdgeInsets.all(24),
          child: QrImageView(
            data: card.barcodeData,
            version: QrVersions.auto,
            size: 300,
            backgroundColor: Colors.white,
          ),
        );
      case BarcodeType.manual:
        return CardNumberDisplay(number: formatted);
    }
  }
}