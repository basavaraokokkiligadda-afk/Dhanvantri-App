import '../../core/app_export.dart';
import '../widgets/category_tab_widget.dart';
import '../widgets/filter_bottom_sheet_widget.dart';
import '../widgets/medicine_card_widget.dart';
import '../widgets/prescription_upload_widget.dart';

class PharmacyHub extends StatefulWidget {
  const PharmacyHub({super.key});

  @override
  State<PharmacyHub> createState() => _PharmacyHubState();
}

class _PharmacyHubState extends State<PharmacyHub>
    with SingleTickerProviderStateMixin {
  late TabController _categoryTabController;
  int _cartItemCount = 3;
  String _searchQuery = '';
  final Map<String, int> _cartQuantities = {};

  final List<String> _categories = [
    'Wholesale',
    'General',
    'Apollo-type',
    'Med-tech',
  ];

  final List<Map<String, dynamic>> _medicineData = [
    {
      "id": "med_001",
      "name": "Paracetamol 500mg",
      "genericName": "Acetaminophen",
      "price": "\$50.00",
      "image": "https://images.unsplash.com/photo-1720266695691-4351694681ca",
      "semanticLabel":
          "White round tablets of Paracetamol 500mg in blister pack on white background",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "General",
    },
    {
      "id": "med_002",
      "name": "Amoxicillin 250mg",
      "genericName": "Amoxicillin Trihydrate",
      "price": "\$120.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1cae61885-1766495104259.png",
      "semanticLabel":
          "Pink and white capsules of Amoxicillin antibiotic medication in bottle",
      "prescriptionRequired": true,
      "availability": "In Stock",
      "category": "General",
    },
    {
      "id": "med_003",
      "name": "Cetirizine 10mg",
      "genericName": "Cetirizine Hydrochloride",
      "price": "\$80.00",
      "image": "https://images.unsplash.com/photo-1550572017-54b7f54d1f75",
      "semanticLabel":
          "White oval tablets of Cetirizine allergy medication in blister packaging",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "General",
    },
    {
      "id": "med_004",
      "name": "Metformin 500mg",
      "genericName": "Metformin Hydrochloride",
      "price": "\$95.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1bd577d62-1764656014822.png",
      "semanticLabel":
          "White round tablets of Metformin diabetes medication scattered on surface",
      "prescriptionRequired": true,
      "availability": "In Stock",
      "category": "Apollo-type",
    },
    {
      "id": "med_005",
      "name": "Omeprazole 20mg",
      "genericName": "Omeprazole Magnesium",
      "price": "\$110.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_15455fb24-1767514142934.png",
      "semanticLabel":
          "Purple and white capsules of Omeprazole acid reflux medication in container",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "General",
    },
    {
      "id": "med_006",
      "name": "Atorvastatin 10mg",
      "genericName": "Atorvastatin Calcium",
      "price": "\$150.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1121cae4d-1766846447320.png",
      "semanticLabel":
          "White oval tablets of Atorvastatin cholesterol medication in blister pack",
      "prescriptionRequired": true,
      "availability": "Low Stock",
      "category": "Apollo-type",
    },
    {
      "id": "med_007",
      "name": "Ibuprofen 400mg",
      "genericName": "Ibuprofen",
      "price": "\$65.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1f82ab8bc-1764710346045.png",
      "semanticLabel":
          "Orange coated tablets of Ibuprofen pain relief medication in bottle",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "Wholesale",
    },
    {
      "id": "med_008",
      "name": "Azithromycin 500mg",
      "genericName": "Azithromycin Dihydrate",
      "price": "\$180.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1443fd771-1765130053733.png",
      "semanticLabel":
          "White oval tablets of Azithromycin antibiotic in pharmaceutical packaging",
      "prescriptionRequired": true,
      "availability": "In Stock",
      "category": "General",
    },
    {
      "id": "med_009",
      "name": "Vitamin D3 1000IU",
      "genericName": "Cholecalciferol",
      "price": "\$75.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1af31a584-1767875351419.png",
      "semanticLabel":
          "Yellow soft gel capsules of Vitamin D3 supplement in clear bottle",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "Med-tech",
    },
    {
      "id": "med_010",
      "name": "Losartan 50mg",
      "genericName": "Losartan Potassium",
      "price": "\$130.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_173acfdcf-1764656015228.png",
      "semanticLabel":
          "White round tablets of Losartan blood pressure medication in blister pack",
      "prescriptionRequired": true,
      "availability": "In Stock",
      "category": "Apollo-type",
    },
    {
      "id": "med_011",
      "name": "Aspirin 75mg",
      "genericName": "Acetylsalicylic Acid",
      "price": "\$45.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_173acfdcf-1764656015228.png",
      "semanticLabel":
          "White round tablets of Aspirin blood thinner medication in container",
      "prescriptionRequired": false,
      "availability": "In Stock",
      "category": "Wholesale",
    },
    {
      "id": "med_012",
      "name": "Levothyroxine 100mcg",
      "genericName": "Levothyroxine Sodium",
      "price": "\$140.00",
      "image":
          "https://img.rocket.new/generatedImages/rocket_gen_img_1117a02a5-1764656015589.png",
      "semanticLabel":
          "Small white tablets of Levothyroxine thyroid medication in pharmaceutical bottle",
      "prescriptionRequired": true,
      "availability": "In Stock",
      "category": "Apollo-type",
    },
  ];

  @override
  void initState() {
    super.initState();
    _categoryTabController = TabController(
      length: _categories.length,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _categoryTabController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredMedicines {
    List<Map<String, dynamic>> filtered = _medicineData;

    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((medicine) {
        final name = (medicine["name"] as String).toLowerCase();
        final generic = (medicine["genericName"] as String).toLowerCase();
        final query = _searchQuery.toLowerCase();
        return name.contains(query) || generic.contains(query);
      }).toList();
    }

    final currentCategory = _categories[_categoryTabController.index];
    filtered = filtered
        .where((medicine) => medicine["category"] == currentCategory)
        .toList();

    return filtered;
  }

  void _updateCartQuantity(String medicineId, int quantity) {
    setState(() {
      if (quantity > 0) {
        _cartQuantities[medicineId] = quantity;
      } else {
        _cartQuantities.remove(medicineId);
      }
      _cartItemCount = _cartQuantities.values.fold(0, (sum, qty) => sum + qty);
    });
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheetWidget(
        onApplyFilters: (filters) {
          setState(() {
            // Filters applied
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        ),
        title: Container(
          height: 6.h,
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: 'Search medicines...',
              hintStyle: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
              prefixIcon: CustomIconWidget(
                iconName: 'search',
                color: theme.colorScheme.onSurfaceVariant,
                size: 20,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 3.w,
                vertical: 1.5.h,
              ),
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: CustomIconWidget(
                  iconName: 'shopping_cart',
                  color: theme.colorScheme.onSurface,
                  size: 24,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cart has $_cartItemCount items'),
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
              ),
              _cartItemCount > 0
                  ? Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: EdgeInsets.all(0.5.w),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.error,
                          shape: BoxShape.circle,
                        ),
                        constraints: BoxConstraints(
                          minWidth: 4.w,
                          minHeight: 4.w,
                        ),
                        child: Center(
                          child: Text(
                            _cartItemCount.toString(),
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.onError,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          IconButton(
            icon: CustomIconWidget(
              iconName: 'filter_list',
              color: theme.colorScheme.onSurface,
              size: 24,
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: theme.colorScheme.surface,
            child: CategoryTabWidget(
              categories: _categories,
              controller: _categoryTabController,
              onTabChanged: (index) {
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: PrescriptionUploadWidget(
                    onUploadComplete: (filePath) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Prescription uploaded: $filePath'),
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 3.w,
                      mainAxisSpacing: 2.h,
                    ),
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final medicine = _filteredMedicines[index];
                      final medicineId = medicine["id"] as String;
                      final currentQuantity = _cartQuantities[medicineId] ?? 0;

                      return MedicineCardWidget(
                        medicine: medicine,
                        currentQuantity: currentQuantity,
                        onQuantityChanged: (quantity) {
                          _updateCartQuantity(medicineId, quantity);
                        },
                      );
                    }, childCount: _filteredMedicines.length),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: _cartItemCount > 0
          ? FloatingActionButton.extended(
              onPressed: () {
                // Create cart items from quantities
                List<Map<String, dynamic>> cartItems = [];
                _cartQuantities.forEach((medicineId, quantity) {
                  if (quantity > 0) {
                    final medicine = _medicineData.firstWhere(
                      (m) => m['id'] == medicineId,
                      orElse: () => {},
                    );
                    if (medicine.isNotEmpty) {
                      // Parse price (remove $ and convert)
                      final priceStr =
                          medicine['price'].toString().replaceAll('\$', '');
                      final price = double.tryParse(priceStr) ?? 0.0;

                      cartItems.add({
                        'id': medicineId,
                        'name': medicine['name'],
                        'dosage': medicine['genericName'],
                        'quantity': quantity,
                        'price': price,
                      });
                    }
                  }
                });

                if (cartItems.isNotEmpty) {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.pharmacyCheckout,
                    arguments: {
                      'cartItems': cartItems,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No items in cart'),
                    ),
                  );
                }
              },
              backgroundColor: theme.colorScheme.primary,
              icon: CustomIconWidget(
                iconName: 'shopping_bag',
                color: theme.colorScheme.onPrimary,
                size: 20,
              ),
              label: Text(
                'Checkout ($_cartItemCount)',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            )
          : null,
    );
  }
}
