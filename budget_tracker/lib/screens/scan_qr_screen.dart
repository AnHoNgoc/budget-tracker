import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScanQrScreen extends StatefulWidget {
  const ScanQrScreen({super.key});

  @override
  State<ScanQrScreen> createState() => _ScanQrScreenState();
}

class _ScanQrScreenState extends State<ScanQrScreen> with WidgetsBindingObserver {
  late final MobileScannerController _scannerController;

  bool isFlashOn = false;
  bool isProcessing = false;
  bool isCameraDenied = false;

  /// Kích thước khung scan (PHẢI đồng bộ UI + scanWindow)
  final double scanSize = 300;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    _scannerController = MobileScannerController(
      formats: const [BarcodeFormat.qrCode],
    );

    _scannerController.addListener(() {
      final value = _scannerController.value;

      if (value.error != null &&
          value.error!.errorCode == MobileScannerErrorCode.permissionDenied &&
          !isCameraDenied) {
        if (!mounted) return;
        setState(() => isCameraDenied = true);
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;

    if (state == AppLifecycleState.resumed) {
      _scannerController.start();
    } else if (state == AppLifecycleState.paused) {
      _scannerController.stop();
    }
  }

  /// 👉 TÍNH CHÍNH XÁC VÙNG SCAN
  Rect _getScanWindow(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final scan = scanSize.w;

    final left = (size.width - scan) / 2;
    final top = (size.height - scan) / 2;

    return Rect.fromLTWH(left, top, scan, scan);
  }

  void _onDetect(String? data) {
    if (isProcessing || data == null) return;

    isProcessing = true;
    _scannerController.stop();

    _processScannedData(data);
  }

  Widget _buildPermissionDeniedUI() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C313A),
        foregroundColor: Colors.white,
        title: const Text('Camera Permission'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.camera_alt_outlined, size: 72.sp, color: Colors.grey),
              SizedBox(height: 24.h),
              Text(
                'Camera access is required',
                style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 12.h),
              Text(
                'Please enable camera access in Settings to scan QR codes.',
                style: TextStyle(fontSize: 14.sp, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32.h),
              SizedBox(
                width: double.infinity,
                height: 48.h,
                child: ElevatedButton(
                  onPressed: () => openAppSettings(),
                  child: const Text('Open Settings'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processScannedData(String data) async {
    String type = 'text';
    if (data.startsWith('BEGIN:VCARD')) {
      type = 'contact';
    } else if (data.startsWith('http://') || data.startsWith('https://')) {
      type = 'url';
    }

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.55,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(
                    type == 'url'
                        ? Icons.link
                        : type == 'contact'
                        ? Icons.contact_page
                        : Icons.text_snippet,
                  ),
                  SizedBox(width: 8.w),
                  const Text(
                    'Scanned Result',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(type.toUpperCase()),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: SelectableText(
                    data,
                    style: TextStyle(fontSize: 14.sp),
                  ),
                ),
              ),
              SizedBox(height: 20.h),
              if (type == 'url')
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchURL(data),
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open URL'),
                  ),
                ),
              if (type == 'url') SizedBox(height: 12.h),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => Share.share(data),
                      icon: const Icon(Icons.share),
                      label: const Text('Share'),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        isProcessing = false;
                        _scannerController.start();
                      },
                      icon: const Icon(Icons.qr_code_scanner),
                      label: const Text('Scan Again'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Widget _buildScannerUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: const Color(0xFF2C313A),
        foregroundColor: Colors.white,
        title: const Text('Scan QR Code'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              _scannerController.toggleTorch();
              setState(() => isFlashOn = !isFlashOn);
            },
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
          ),
        ],
      ),
      body: Stack(
        children: [
          /// CAMERA (GIỚI HẠN SCAN)
          MobileScanner(
            controller: _scannerController,
            scanWindow: _getScanWindow(context),
            fit: BoxFit.cover,
            onDetect: (capture) {
              final barcode = capture.barcodes.first;
              _onDetect(barcode.rawValue);
            },
          ),

          /// Overlay tối + lỗ
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _ScannerOverlayPainter()),
            ),
          ),

          /// Khung scan (đúng kích thước)
          Center(
            child: Container(
              width: scanSize.w,
              height: scanSize.w,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),

          /// Instruction text
          Positioned(
            bottom: 32.h,
            left: 24.w,
            right: 24.w,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                'Align the QR code inside the frame to scan.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white, fontSize: 14.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isCameraDenied) {
      return _buildPermissionDeniedUI();
    }
    return _buildScannerUI();
  }
}

/// ================= OVERLAY =================
class _ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final overlayPaint = Paint()..color = Colors.black.withOpacity(0.6);

    final holeSize = 300.w;
    final holeRect = Rect.fromCenter(
      center: size.center(Offset.zero),
      width: holeSize,
      height: holeSize,
    );

    canvas.saveLayer(Rect.fromLTWH(0, 0, size.width, size.height), Paint());

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), overlayPaint);

    canvas.drawRect(holeRect, Paint()..blendMode = BlendMode.clear);

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}