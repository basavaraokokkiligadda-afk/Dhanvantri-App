
import '../../../core/app_export.dart';

class MedicineCardWidget extends StatelessWidget {
  final Map<String, dynamic> medicine;
  final int currentQuantity;
  final Function(int) onQuantityChanged;

  const MedicineCardWidget({
    super.key,
    required this.medicine,
    required this.currentQuantity,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isPrescriptionRequired = medicine["prescriptionRequired"] as bool;
    final availability = medicine["availability"] as String;

    Color availabilityColor = theme.colorScheme.tertiary;
    if (availability == "Low Stock") {
      availabilityColor = const Color(0xFFF59E0B);
    } else if (availability == "Out of Stock") {
      availabilityColor = theme.colorScheme.error;
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(12),
                ),
                child: CustomImageWidget(
                  imageUrl: medicine["image"] as String,
                  width: double.infinity,
                  height: 15.h,
                  fit: BoxFit.cover,
                  semanticLabel: medicine["semanticLabel"] as String,
                ),
              ),
              isPrescriptionRequired
                  ? Positioned(
                      top: 1.h,
                      right: 2.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 2.w,
                          vertical: 0.5.h,
                        ),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomIconWidget(
                              iconName: 'medical_services',
                              color: theme.colorScheme.onError,
                              size: 12,
                            ),
                            SizedBox(width: 1.w),
                            Text(
                              'Rx',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: theme.colorScheme.onError,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine["name"] as String,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 0.5.h),
                  Text(
                    medicine["genericName"] as String,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 1.h),
                  Row(
                    children: [
                      Container(
                        width: 1.5.w,
                        height: 1.5.w,
                        decoration: BoxDecoration(
                          color: availabilityColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 1.w),
                      Text(
                        availability,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: availabilityColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        medicine["price"] as String,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      currentQuantity > 0
                          ? Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () =>
                                        onQuantityChanged(currentQuantity - 1),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.w),
                                      child: CustomIconWidget(
                                        iconName: 'remove',
                                        color: theme.colorScheme.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    currentQuantity.toString(),
                                    style: theme.textTheme.labelLarge?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () =>
                                        onQuantityChanged(currentQuantity + 1),
                                    child: Padding(
                                      padding: EdgeInsets.all(1.w),
                                      child: CustomIconWidget(
                                        iconName: 'add',
                                        color: theme.colorScheme.primary,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : InkWell(
                              onTap: () => onQuantityChanged(1),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 2.w,
                                  vertical: 1.h,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: CustomIconWidget(
                                  iconName: 'add_shopping_cart',
                                  color: theme.colorScheme.onPrimary,
                                  size: 16,
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
