import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/filter_button.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  final DatabaseService databaseService = DatabaseService();
  final TextEditingController _searchController = TextEditingController();

  List<CoachEntity> _coaches = [];
  List<Sport> _selectedSports = [];
  String _searchQuery = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoaches();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCoaches() async {
    try {
      final snapshot = await databaseService.read(path: 'Coaches');

      if (!mounted) {
        return;
      }

      if (snapshot != null) {
        final coachesList = <CoachEntity>[];

        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>?;
          if (data == null) {
            continue;
          }

          final role = data['role'] == 'coach' ? Role.coach : Role.user;
          final displayName = data['displayName']?.toString();
          final specialization = data['specialization']?.toString();

          coachesList.add(
            CoachEntity(
              id: child.key ?? '',
              name: (displayName != null && displayName.isNotEmpty)
                  ? displayName
                  : data['name']?.toString() ?? 'Без имени',
              email: data['email']?.toString() ?? '',
              phoneNumber: data['phoneNumber']?.toString() ?? '',
              role: role,
              sport: (specialization != null && specialization.isNotEmpty)
                  ? specialization
                  : data['favoriteSport']?.toString() ?? 'Не указан',
              description: data['description']?.toString(),
            ),
          );
        }

        setState(() {
          _coaches = coachesList;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  List<CoachEntity> get _visibleCoaches {
    return _coaches.where((coach) {
      final matchesSearch =
          _searchQuery.trim().isEmpty ||
          _matchesNamePrefix(coach.name ?? '', _searchQuery);
      if (!matchesSearch) {
        return false;
      }

      if (_selectedSports.isEmpty) {
        return true;
      }

      final coachSport = _normalize(coach.sport);
      return _selectedSports.any((sport) {
        final keywords = <String>{
          _normalize(sport.ru),
          sport.name.toLowerCase(),
          ...?_sportKeywords[sport],
        };
        return keywords.any(
          (keyword) => keyword.isNotEmpty && coachSport.contains(keyword),
        );
      });
    }).toList();
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  bool _matchesNamePrefix(String value, String query) {
    final normalizedQuery = _normalize(query);
    if (normalizedQuery.isEmpty) {
      return true;
    }

    return _splitNameParts(value).any((part) => part.startsWith(normalizedQuery));
  }

  List<String> _splitNameParts(String value) {
    return _normalize(value)
        .split(RegExp(r'[\s\-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final visibleCoaches = _visibleCoaches;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),
            Positioned(
              top: 5,
              left: 10,
              child: FloatingActionButton(
                onPressed: _loadCoaches,
                backgroundColor: AppColors.activeColor,
                shape: const CircleBorder(),
                child: SvgPicture.asset(
                  'assets/images/svg/update.svg',
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 5,
              right: 10,
              child: CoachFilterButton(
                initialSportTypes: _selectedSports,
                onApply: (selectedSports) {
                  setState(() {
                    _selectedSports = selectedSports;
                  });
                },
              ),
            ),
            Positioned(
              top: 14,
              left: 80,
              right: 80,
              child: SizedBox(
                height: 44,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                  style: GoogleFonts.philosopher(
                    fontSize: 16,
                    color: AppColors.textPrimaryColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Поиск тренера...',
                    hintStyle: GoogleFonts.philosopher(
                      fontSize: 16,
                      color: AppColors.textSecondaryColor,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: AppColors.activeColor,
                      size: 22,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: Icon(
                              Icons.clear,
                              color: AppColors.textSecondaryColor,
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: AppColors.softBlueColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 70,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Тренеры',
                  style: GoogleFonts.philosopher(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.activeColor,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              bottom: 0,
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _coaches.isEmpty
                  ? Center(
                      child: Text(
                        'Тренеры не найдены',
                        style: GoogleFonts.philosopher(
                          fontSize: 18,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    )
                  : visibleCoaches.isEmpty
                  ? Center(
                      child: Text(
                        'Ничего не найдено',
                        style: GoogleFonts.philosopher(
                          fontSize: 18,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: visibleCoaches.length,
                      itemBuilder: (context, index) {
                        final coach = visibleCoaches[index];
                        return _CoachCard(
                          coach: coach,
                          onTap: () => _navigateToCoachProfile(coach),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToCoachProfile(CoachEntity coach) {
    context.router.push(CoachProfileRoute(account: coach));
  }
}

const Map<Sport, Set<String>> _sportKeywords = {
  Sport.basketball: {'баскетбол', 'basketball'},
  Sport.football: {'футбол', 'football', 'soccer'},
  Sport.tennis: {'теннис', 'tennis'},
  Sport.hockey: {'хоккей', 'hockey'},
  Sport.box: {'бокс', 'boxing'},
  Sport.athletics: {
    'лёгкая атлетика',
    'легкая атлетика',
    'athletics',
    'офп',
    'функциональная подготовка',
  },
  Sport.volleyball: {'волейбол', 'volleyball'},
  Sport.swimming: {'плавание', 'swimming'},
  Sport.cycling: {'велоспорт', 'cycling'},
  Sport.skiing: {'лыжи', 'лыжный спорт', 'ski'},
  Sport.martialArts: {
    'единобор',
    'mma',
    'самбо',
    'дзюдо',
    'карате',
    'taekwondo',
  },
};

class _CoachCard extends StatelessWidget {
  const _CoachCard({required this.coach, required this.onTap});

  final CoachEntity coach;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.activeColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.activeColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.name ?? 'Не указано',
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      coach.sport,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.email,
                          size: 14,
                          color: AppColors.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            coach.email ?? 'Не указана',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: AppColors.textSecondaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AppColors.textSecondaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
