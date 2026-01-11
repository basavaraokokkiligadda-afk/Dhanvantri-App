import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

/// Flexible image widget that handles network, asset, and file images
class CustomImageWidget extends StatelessWidget {
  final String? imagePath;
  final String? url;
  final String? userImage;
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final String? semanticLabel;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CustomImageWidget({
    super.key,
    this.imagePath,
    this.url,
    this.userImage,
    this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.semanticLabel,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    final imageSource = imagePath ?? url ?? userImage ?? imageUrl;

    if (imageSource == null || imageSource.isEmpty) {
      return _buildErrorWidget();
    }

    // Network image
    if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,
        width: width,
        height: height,
        fit: fit ?? BoxFit.cover,
        semanticLabel: semanticLabel,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return placeholder ?? _buildPlaceholder();
        },
        errorBuilder: (context, error, stackTrace) {
          return errorWidget ?? _buildErrorWidget();
        },
      );
    }

    // Asset image
    return Image.asset(
      imageSource,
      width: width,
      height: height,
      fit: fit ?? BoxFit.cover,
      semanticLabel: semanticLabel,
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildErrorWidget();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Icon(
        Icons.image_not_supported,
        size: 4.h,
        color: Colors.grey[400],
      ),
    );
  }
}
