import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';

class CollectionsPage extends StatefulWidget {
  const CollectionsPage({super.key});

  @override
  State<CollectionsPage> createState() => _CollectionsPageState();
}

class _CollectionsPageState extends State<CollectionsPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.lightBlue,
          // Onglets
          child: TabBar(
            controller: _tabController,
            labelColor: AppColors.darkBlue,
            unselectedLabelColor: AppColors.darkBlue.withValues(alpha: 0.6),
            indicatorColor: AppColors.sakuraPink,
            indicatorWeight: 3,
            labelStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Manrope',
            ),
            tabs: const [
              Tab(text: 'Bouquets'),
              Tab(text: 'Fleurs'),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: AppColors.lightBlue,
            child: TabBarView(
              controller: _tabController,
              children: [_bouquetsCollection(), _flowersCollection()],
            ),
          ),
        ),
      ],
    );
  }

  // Collection des bouquets
  Widget _bouquetsCollection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _bouquetCard();
        },
      ),
    );
  }

  // Collection des fleurs
  Widget _flowersCollection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: 4,
        itemBuilder: (context, index) {
          return _flowerCard();
        },
      ),
    );
  }

  // Card d'un bouquet
  Widget _bouquetCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.sakuraPink, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_florist, size: 60, color: AppColors.sakuraPink),
            SizedBox(height: 8),
            Text(
              'Bouquet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.darkBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Card d'une fleur
  Widget _flowerCard() {
    final List<String> flowers = [
      'assets/images/sakura.webp',
      'assets/images/poppy.webp',
      'assets/images/lily.webp',
      'assets/images/sunflower.webp',
    ];

    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.matchaGreen, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            //TODO : mettre les fleurs récoltées
            flowers[3],
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.error_outline,
                size: 50,
                color: Colors.red,
              );
            },
          ),
        ),
      ),
    );
  }
}
