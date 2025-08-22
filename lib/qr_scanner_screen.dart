import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  String? scannedCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("QR Scanner"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black87, width: 4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: MobileScanner(
                  onDetect: (capture) {
                    for (final barcode in capture.barcodes) {
                      setState(() {
                        scannedCode = barcode.rawValue;
                      });
                      debugPrint("Scanned: ${barcode.rawValue}");
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            scannedCode == null
                ? "Scan a QR code..."
                : "Result: $scannedCode",
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
