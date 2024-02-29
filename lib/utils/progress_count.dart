import 'package:flutter/material.dart';

String downloadProgressIndicator(ImageChunkEvent? loadingProgress) {
  if (loadingProgress == null) return "";
  return loadingProgress.expectedTotalBytes != null
      ? "${((loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!) * 100).toInt().toString()} %"
      : "";
}

String downloadProgressIndicatorForFile(double totalBytes) {
  return "${totalBytes.toInt()} %";
}
