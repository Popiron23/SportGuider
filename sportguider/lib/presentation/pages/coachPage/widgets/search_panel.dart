import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/domain/entities/coach_entity.dart';
import 'package:sportguider/presentation/colors.dart';

class CoachSearchPanel extends StatefulWidget {
  const CoachSearchPanel({
    super.key,
    required this.coaches,
    required this.initialQuery,
    required this.onQueryChanged,
    required this.onCoachSelected,
  });

  final List<CoachEntity> coaches;
  final String initialQuery;
  final ValueChanged<String> onQueryChanged;
  final ValueChanged<CoachEntity> onCoachSelected;

  @override
  State<CoachSearchPanel> createState() => _CoachSearchPanelState();
}

class _CoachSearchPanelState extends State<CoachSearchPanel> {
  late final TextEditingController _searchController;
  late String _query;

  @override
  void initState() {
    super.initState();
    _query = widget.initialQuery;
    _searchController = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CoachEntity> _filter(List<CoachEntity> coaches) {
    if (_query.trim().isEmpty) {
      return coaches;
    }

    final q = _normalize(_query);
    return coaches.where((coach) {
      return _matchesNamePrefix(coach.name ?? '', q);
    }).toList();
  }

  String _normalize(String value) {
    return value.trim().toLowerCase();
  }

  bool _matchesNamePrefix(String value, String query) {
    return _splitNameParts(value).any((part) => part.startsWith(query));
  }

  List<String> _splitNameParts(String value) {
    return _normalize(value)
        .split(RegExp(r'[\s\-]+'))
        .where((part) => part.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filteredCoaches = _filter(widget.coaches);

    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.borderColor,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchController,
            autofocus: true,
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
              prefixIcon: Icon(Icons.search, color: AppColors.activeColor),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: AppColors.textSecondaryColor,
                      ),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _query = '');
                        widget.onQueryChanged('');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.softBlueColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (value) {
              setState(() => _query = value);
              widget.onQueryChanged(value);
            },
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: filteredCoaches.isEmpty
              ? Center(
                  child: Text(
                    'Ничего не найдено',
                    style: GoogleFonts.philosopher(
                      color: AppColors.textSecondaryColor,
                      fontSize: 16,
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filteredCoaches.length,
                  separatorBuilder: (_, __) => Divider(
                    color: AppColors.borderColor,
                    height: 1,
                  ),
                  itemBuilder: (context, index) {
                    final coach = filteredCoaches[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 0,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: AppColors.softBlueColor,
                        child: Icon(Icons.person, color: AppColors.activeColor),
                      ),
                      title: Text(
                        coach.name ?? 'Без имени',
                        style: GoogleFonts.philosopher(
                          fontSize: 16,
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        coach.sport,
                        style: GoogleFonts.philosopher(
                          fontSize: 13,
                          color: AppColors.textSecondaryColor,
                        ),
                      ),
                      trailing: Icon(
                        Icons.chevron_right,
                        color: AppColors.textSecondaryColor,
                      ),
                      onTap: () => widget.onCoachSelected(coach),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
