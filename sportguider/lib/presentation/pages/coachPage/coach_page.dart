import 'package:auto_route/auto_route.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/search_button.dart';
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
  List<CoachEntity> _coaches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoaches();
  }

  Future<void> _loadCoaches() async {
    try {
      final snapshot = await databaseService.read(path: "Coaches");

      if (!mounted) return;

      if (snapshot != null) {
        final coachesList = <CoachEntity>[];

        // Проходим по всем детям в папке Coaches
        for (final child in snapshot.children) {
          final data = child.value as Map<dynamic, dynamic>?;
          if (data != null) {
            Role role_ = data['role'] == 'coach' ? Role.coach : Role.user;
            coachesList.add(
              CoachEntity(
                id: child.key ?? '',
                name: data['name']?.toString() ?? 'Без имени',
                email: data['email']?.toString() ?? '',
                phoneNumber: data['phoneNumber']?.toString() ?? '',
                role: role_,
                sport: data['favoriteSport']?.toString() ?? 'Не указан',
                description: data['description']?.toString(),
              ),
            );
          }
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
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),

            // Текст "Тренеры"
            Positioned(
              top: 50,
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

            // Виджет-кнопка "Поиск"
            Positioned(
              top: 5,
              right: 10,
              child: Row(
                children: [
                  CoachFilterButton(),
                  const SizedBox(width: 10),
                  SearchButton(),
                ],
              ),
            ),

            // Список тренеров
            Positioned(
              top: 100,
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
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _coaches.length,
                      itemBuilder: (context, index) {
                        final coach = _coaches[index];
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

class _CoachCard extends StatelessWidget {
  final CoachEntity coach;
  final VoidCallback onTap;

  const _CoachCard({required this.coach, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Аватарка-заглушка
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: AppColors.activeColor.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 32,
                  color: AppColors.activeColor,
                ),
              ),
              const SizedBox(width: 16),
              // Информация о тренере
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      coach.name ?? 'не указано',
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
                          Icons.phone,
                          size: 14,
                          color: AppColors.textSecondaryColor,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            coach.phoneNumber ?? 'Не указан',
                            style: GoogleFonts.roboto(
                              fontSize: 12,
                              color: AppColors.textSecondaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
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
