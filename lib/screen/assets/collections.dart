import 'package:flutter/material.dart';
import 'package:bouquetblossom/constants/app_colors.dart';
import 'package:bouquetblossom/services/flowers_service.dart';
import 'package:bouquetblossom/services/bouquets_service.dart';
import 'package:bouquetblossom/widgets/flower_card.dart';
import 'package:bouquetblossom/widgets/bouquet_card.dart';
import 'package:bouquetblossom/models/flower.dart';
import 'package:bouquetblossom/models/bouquet.dart';

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
    final List<Bouquet> allBouquets = BouquetsService().getAllBouquets();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: allBouquets.length,
        itemBuilder: (context, index) {
          return BouquetCard(
            bouquet: allBouquets[index],
            isUnlocked: true, // TODO: Vérifier si débloqué avec UserDataService
          );
        },
      ),
    );
  }

  // Collection des fleurs
  // Collection des fleurs
  Widget _flowersCollection() {
    final List<Flower> allFlowers = FlowersService().getAllFlowers();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: allFlowers.length,
        itemBuilder: (context, index) {
          return FlowerCard(
            flower: allFlowers[index],
            isUnlocked: true, // TODO: Vérifier si débloquée avec UserDataService
          );
        },
      ),
    );
  }
}
