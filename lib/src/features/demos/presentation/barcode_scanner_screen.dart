import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeScannerScreen extends HookConsumerWidget {
  const BarcodeScannerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final controller = useMemoized(
      () => MobileScannerController(
        detectionSpeed: DetectionSpeed.noDuplicates,
        formats: const [
          BarcodeFormat.qrCode,
          BarcodeFormat.code128,
          BarcodeFormat.code39,
          BarcodeFormat.code93,
          BarcodeFormat.ean13,
          BarcodeFormat.ean8,
          BarcodeFormat.upcA,
          BarcodeFormat.upcE,
        ],
      ),
    );

    final scannedBarcodes = useState<List<Barcode>>([]);
    final isScanning = useState(true);

    useEffect(() {
      return controller.dispose;
    }, [controller]);

    void handleBarcode(BarcodeCapture capture) {
      final barcodes = capture.barcodes;
      if (barcodes.isNotEmpty && isScanning.value) {
        scannedBarcodes.value = [...barcodes, ...scannedBarcodes.value];
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barcode Scanner'),
        actions: [
          IconButton(
            icon: Icon(isScanning.value ? Icons.pause : Icons.play_arrow),
            tooltip: isScanning.value ? 'Pause Scanning' : 'Resume Scanning',
            onPressed: () async {
              isScanning.value = !isScanning.value;
              if (isScanning.value) {
                await controller.start();
              } else {
                await controller.stop();
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            tooltip: 'Switch Camera',
            onPressed: controller.switchCamera,
          ),
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Clear History',
            onPressed: () => scannedBarcodes.value = [],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              children: [
                MobileScanner(
                  controller: controller,
                  onDetect: handleBarcode,
                  errorBuilder: (context, error, child) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: theme.colorScheme.error,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Camera Error',
                            style: theme.textTheme.titleLarge,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            error.errorDetails?.message ?? 'Unknown error',
                            style: theme.textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                if (!isScanning.value)
                  const ColoredBox(
                    color: Colors.black54,
                    child: Center(
                      child: Icon(
                        Icons.pause_circle_filled,
                        size: 80,
                        color: Colors.white,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: ColoredBox(
              color: theme.colorScheme.surfaceContainerHighest,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.history, color: theme.colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'Scanned Barcodes (${scannedBarcodes.value.length})',
                          style: theme.textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1),
                  Expanded(
                    child: scannedBarcodes.value.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.qr_code_scanner,
                                  size: 64,
                                  color: theme.colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No barcodes scanned yet',
                                  style: theme.textTheme.bodyLarge?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Point your camera at a barcode or QR code',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    color: theme.colorScheme.outline,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(16),
                            itemCount: scannedBarcodes.value.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 8),
                            itemBuilder: (context, index) {
                              final barcode = scannedBarcodes.value[index];
                              return Card(
                                child: ListTile(
                                  leading: Icon(
                                    _getIconForFormat(barcode.format),
                                    color: theme.colorScheme.primary,
                                  ),
                                  title: Text(
                                    barcode.displayValue ?? 'No data',
                                    style: const TextStyle(
                                      fontFamily: 'monospace',
                                    ),
                                  ),
                                  subtitle: Text(
                                    _getFormatName(barcode.format),
                                    style: theme.textTheme.bodySmall,
                                  ),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.copy),
                                    tooltip: 'Copy to Clipboard',
                                    onPressed: () {
                                      // TODO: Implement clipboard copy
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        const SnackBar(
                                          content: Text('Copied to clipboard'),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getIconForFormat(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return Icons.qr_code_2;
      case BarcodeFormat.code128:
      case BarcodeFormat.code39:
      case BarcodeFormat.code93:
        return Icons.barcode_reader;
      case BarcodeFormat.ean13:
      case BarcodeFormat.ean8:
      case BarcodeFormat.upcA:
      case BarcodeFormat.upcE:
        return Icons.shopping_cart;
      default:
        return Icons.qr_code_scanner;
    }
  }

  String _getFormatName(BarcodeFormat format) {
    switch (format) {
      case BarcodeFormat.qrCode:
        return 'QR Code';
      case BarcodeFormat.code128:
        return 'Code 128';
      case BarcodeFormat.code39:
        return 'Code 39';
      case BarcodeFormat.code93:
        return 'Code 93';
      case BarcodeFormat.ean13:
        return 'EAN-13';
      case BarcodeFormat.ean8:
        return 'EAN-8';
      case BarcodeFormat.upcA:
        return 'UPC-A';
      case BarcodeFormat.upcE:
        return 'UPC-E';
      default:
        return 'Unknown';
    }
  }
}
