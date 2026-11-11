import 'package:flutter/material.dart';

import 'app_colours.dart';
import 'app_text_styles.dart';
import 'crop_data.dart';
import 'crop_details_page.dart';

/// Full crop library with search and season filters. Tapping a crop opens
/// its details page.
class AllCropsPage extends StatefulWidget {
  const AllCropsPage({super.key});

  @override
  State<AllCropsPage> createState() => _AllCropsPageState();
}

class _AllCropsPageState extends State<AllCropsPage> {
  static const List<String> _seasons = ['All', 'Kharif', 'Rabi', 'Spring'];

  static const List<Color> _backgrounds = [
    AppColors.cardGreen,
    AppColors.cardYellow,
    AppColors.cardLavender,
    AppColors.cardBlue,
    AppColors.mint,
  ];

  final TextEditingController _searchController = TextEditingController();
  String _query = '';
  String _selectedSeason = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CropInfo> get _filteredCrops {
    final query = _query.trim().toLowerCase();
    return cropCatalog.where((crop) {
      final matchesQuery =
          query.isEmpty ||
          crop.name.toLowerCase().contains(query) ||
          crop.scientificName.toLowerCase().contains(query);
      final matchesSeason =
          _selectedSeason == 'All' ||
          crop.season.toLowerCase().contains(_selectedSeason.toLowerCase());
      return matchesQuery && matchesSeason;
    }).toList();
  }

  void _openCrop(CropInfo crop) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => CropDetailsPage(crop: crop)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final crops = _filteredCrops;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            const _TopBar(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
              child: TextField(
                key: const Key('crop-search-field'),
                controller: _searchController,
                onChanged: (value) => setState(() => _query = value),
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                  hintText: 'Search crops',
                  hintStyle: AppTextStyles.caption,
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textMuted,
                    size: 20,
                  ),
                  suffixIcon: _query.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.close_rounded,
                            color: AppColors.textMuted,
                            size: 18,
                          ),
                          onPressed: () {
                            _searchController.clear();
                            setState(() => _query = '');
                          },
                        ),
                  filled: true,
                  fillColor: AppColors.surface,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(color: AppColors.outline),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: AppColors.secondary,
                      width: 1.4,
                    ),
                  ),
                ),
                style: AppTextStyles.body,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 38,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _seasons.length,
                separatorBuilder: (_, _) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final season = _seasons[index];
                  final isSelected = season == _selectedSeason;
                  return GestureDetector(
                    key: Key('season-chip-$season'),
                    onTap: () => setState(() => _selectedSeason = season),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.outline,
                        ),
                      ),
                      child: Text(
                        season,
                        style: AppTextStyles.label.copyWith(
                          fontSize: 11,
                          color: isSelected
                              ? Colors.white
                              : AppColors.textMuted,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: crops.isEmpty
                  ? const _EmptyState()
                  : LayoutBuilder(
                      builder: (context, constraints) {
                        final width = constraints.maxWidth;
                        final columns = width >= 900
                            ? 4
                            : width >= 600
                            ? 3
                            : 2;
                        return GridView.builder(
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                          itemCount: crops.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: columns,
                                mainAxisExtent: 176,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                          itemBuilder: (context, index) {
                            final crop = crops[index];
                            return _CropLibraryCard(
                              crop: crop,
                              background:
                                  _backgrounds[index % _backgrounds.length],
                              onTap: () => _openCrop(crop),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 20, 12),
      child: Row(
        children: [
          Material(
            color: AppColors.surface,
            shape: const CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: () => Navigator.of(context).maybePop(),
              child: const SizedBox(
                width: 40,
                height: 40,
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textDark,
                  size: 20,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Crop Library', style: AppTextStyles.caption),
                Text(
                  'All Crops',
                  style: AppTextStyles.title.copyWith(fontSize: 20),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '${cropCatalog.length} crops',
            style: AppTextStyles.microLabel,
          ),
        ],
      ),
    );
  }
}

class _CropLibraryCard extends StatelessWidget {
  const _CropLibraryCard({
    required this.crop,
    required this.background,
    required this.onTap,
  });

  final CropInfo crop;
  final Color background;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        key: Key('crop-card-${crop.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: background,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(crop.emoji, style: const TextStyle(fontSize: 24)),
              ),
              const SizedBox(height: 10),
              Text(
                crop.name,
                style: AppTextStyles.cardTitle.copyWith(fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                crop.scientificName,
                style: AppTextStyles.caption.copyWith(fontSize: 9.5),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const Spacer(),
              Row(
                children: [
                  Expanded(child: _SeasonTag(season: crop.season)),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.coronavirus_rounded,
                    size: 11,
                    color: AppColors.textMuted,
                  ),
                  const SizedBox(width: 2),
                  Text(
                    '${crop.diseases.length}',
                    style: AppTextStyles.caption.copyWith(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
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
}

class _SeasonTag extends StatelessWidget {
  const _SeasonTag({required this.season});

  final String season;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.mint,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        season,
        style: AppTextStyles.caption.copyWith(
          fontSize: 8.5,
          color: AppColors.primaryDark,
          fontWeight: FontWeight.w600,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.surfaceMuted,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.search_off_rounded,
                color: AppColors.textMuted,
                size: 30,
              ),
            ),
            const SizedBox(height: 14),
            Text('No crops found', style: AppTextStyles.title),
            const SizedBox(height: 4),
            Text(
              'Try a different crop name or season.',
              textAlign: TextAlign.center,
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ),
    );
  }
}
