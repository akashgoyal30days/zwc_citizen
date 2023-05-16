
import 'dart:typed_data';

class CertificateModel {
  final String imageURL, pdfURL;
  final Uint8List ImageBytes;
  const CertificateModel(
      {required this.ImageBytes, required this.imageURL, required this.pdfURL});
}
