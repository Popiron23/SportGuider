import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/core/enums/role.dart';
import 'package:sportguider/core/enums/sport.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:sportguider/domain/entities/location_entity.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/routes/router.gr.dart';

class ModalBodyView extends StatefulWidget {
  const ModalBodyView({super.key, required this.location});

  final LocationEntity location;

  @override
  State<ModalBodyView> createState() => _ModalBodyViewState();
}

class _ModalBodyViewState extends State<ModalBodyView> {
  final _db = DatabaseService();

  List<_CoachRow> _coaches = [];
  String _createdBy = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCoaches();
  }

  Future<void> _loadCoaches() async {
    final results = await Future.wait([
      _db.read(path: 'places/${widget.location.id}'),
      _db.read(path: 'Coaches'),
    ]);

    final orgSnapshot = results[0];
    final coachesSnapshot = results[1];

    String createdBy = '';
    if (orgSnapshot != null && orgSnapshot.value is Map) {
      final data = Map<String, dynamic>.from(orgSnapshot.value as Map);
      createdBy = (data['createdBy'] as String?) ?? '';
    }

    final coaches = <_CoachRow>[];
    if (coachesSnapshot != null) {
      for (final child in coachesSnapshot.children) {
        final data = child.value as Map<dynamic, dynamic>?;
        if (data == null) continue;

        final orgId = data['organizationId']?.toString() ?? '';
        if (orgId != widget.location.id) continue;

        final displayName = data['displayName']?.toString();
        final rawName = data['name']?.toString() ?? '';
        final name =
            (displayName != null && displayName.isNotEmpty)
                ? displayName
                : (rawName.isNotEmpty ? rawName : 'Тренер');

        coaches.add(_CoachRow(
          id: child.key ?? '',
          name: name,
          email: data['email']?.toString() ?? '',
          phoneNumber: data['phoneNumber']?.toString() ?? '',
          favoriteSport: data['specialization']?.toString() ??
              data['favoriteSport']?.toString() ?? '',
        ));
      }
    }

    // creator first
    coaches.sort((a, b) {
      if (a.id == createdBy) return -1;
      if (b.id == createdBy) return 1;
      return 0;
    });

    if (!mounted) return;
    setState(() {
      _coaches = coaches;
      _createdBy = createdBy;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // drag handle
            Center(
              child: Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.borderColor,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // name + sport badge
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.location.name,
                    style: GoogleFonts.philosopher(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.activeColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    widget.location.sport.ru,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.activeColor,
                    ),
                  ),
                ),
              ],
            ),

            // address
            if (widget.location.address != null &&
                widget.location.address!.isNotEmpty) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(
                    Icons.place_outlined,
                    size: 16,
                    color: AppColors.textSecondaryColor,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      widget.location.address!,
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],

            // description
            if (widget.location.description != null &&
                widget.location.description!.isNotEmpty) ...[
              const SizedBox(height: 16),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  widget.location.description!,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // coaches section
            Text(
              'Тренеры',
              style: GoogleFonts.philosopher(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 12),

            if (_isLoading)
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CircularProgressIndicator(
                    color: AppColors.activeColor,
                    strokeWidth: 2.5,
                  ),
                ),
              )
            else if (_coaches.isEmpty)
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.person_off_outlined,
                      color: AppColors.textSecondaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Пока нет прикреплённых тренеров',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: _coaches
                    .map((coach) => _CoachTile(
                          coach: coach,
                          isCreator: coach.id == _createdBy,
                          onTap: () {
                            final account = CoachEntity(
                              id: coach.id,
                              name: coach.name,
                              email: coach.email,
                              phoneNumber: coach.phoneNumber,
                              role: Role.coach,
                              sport: coach.favoriteSport,
                            );
                            context.router.push(
                              CoachProfileRoute(account: account),
                            );
                          },
                        ))
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _CoachRow {
  final String id;
  final String name;
  final String email;
  final String phoneNumber;
  final String favoriteSport;

  const _CoachRow({
    required this.id,
    required this.name,
    this.email = '',
    this.phoneNumber = '',
    this.favoriteSport = '',
  });
}

class _CoachTile extends StatelessWidget {
  final _CoachRow coach;
  final bool isCreator;
  final VoidCallback onTap;

  const _CoachTile({
    required this.coach,
    required this.isCreator,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCreator
            ? AppColors.activeColor.withValues(alpha: 0.07)
            : AppColors.backgroundColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isCreator ? AppColors.activeColor.withValues(alpha: 0.3) : AppColors.borderColor,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isCreator
                  ? AppColors.activeColor.withValues(alpha: 0.15)
                  : AppColors.softBlueColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person_rounded,
              size: 22,
              color: isCreator ? AppColors.activeColor : AppColors.textSecondaryColor,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  coach.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                if (isCreator) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Создатель точки',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.activeColor,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isCreator)
            Icon(Icons.star_rounded, color: AppColors.activeColor, size: 20),
        ],
      ),
    ),
    );
  }
}
