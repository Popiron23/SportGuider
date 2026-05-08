import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sportguider/database_service.dart';
import 'package:sportguider/domain/entities/account_entity.dart';
import 'package:sportguider/firebase_service.dart';
import 'package:sportguider/presentation/colors.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/filter_button.dart';
import 'package:sportguider/presentation/pages/coachPage/widgets/search_button.dart';
import 'package:sportguider/presentation/pages/profile/profile_customization_storage.dart';
import 'package:sportguider/routes/router.gr.dart';

@RoutePage()
class FriendPage extends StatefulWidget {
  const FriendPage({super.key});

  @override
  State<FriendPage> createState() => _FriendPageState();
}

class _FriendPageState extends State<FriendPage> {
  final DatabaseService _db = DatabaseService();
  StreamSubscription<User?>? _authSub;
  String _currentUserId = '';

  bool _isLoading = true;
  bool _showAllUsers = false;

  Set<String> _friendIds = {};
  List<_FriendCardData> _friends = [];
  List<_FriendCardData> _allUsers = [];

  @override
  void initState() {
    super.initState();
    _authSub = FirebaseService.auth.authStateChanges().listen((user) {
      final newId = user?.uid ?? '';
      if (_currentUserId != newId) {
        _currentUserId = newId;
        _loadFriends();
      }
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }

  Future<void> _loadFriends() async {
    if (_currentUserId.isEmpty) {
      setState(() {
        _friends = [];
        _allUsers = [];
        _friendIds = {};
        _isLoading = false;
      });
      return;
    }
    setState(() => _isLoading = true);
    try {
      final ids = await ProfileCustomizationStorage.readUserFriends(
        _currentUserId,
      );
      final friendIdsSet = ids.toSet();

      final snapshot = await _db.read(path: 'Users');

      if (!mounted) return;

      final allUsersList = <_FriendCardData>[];
      final friendsList = <_FriendCardData>[];

      if (snapshot != null) {
        for (final child in snapshot.children) {
          if (child.key == _currentUserId) continue;
          final data = child.value as Map<dynamic, dynamic>?;
          if (data == null) continue;

          final displayName = data['displayName']?.toString();
          final name = data['name']?.toString();
          final sport = data['favoriteSport']?.toString();

          final card = _FriendCardData(
            id: child.key ?? '',
            displayName: (displayName != null && displayName.isNotEmpty)
                ? displayName
                : (name != null && name.isNotEmpty)
                ? name
                : 'Без имени',
            favoriteSport: (sport != null && sport.isNotEmpty)
                ? sport
                : 'Не указан',
          );

          allUsersList.add(card);
          if (friendIdsSet.contains(child.key)) {
            friendsList.add(card);
          }
        }
      }

      setState(() {
        _friendIds = friendIdsSet;
        _friends = friendsList;
        _allUsers = allUsersList;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addFriend(String friendId) async {
    if (_currentUserId.isEmpty) return;
    await ProfileCustomizationStorage.addUserFriend(_currentUserId, friendId);
    if (!mounted) return;
    setState(() {
      _friendIds.add(friendId);
      final card = _allUsers.firstWhere((u) => u.id == friendId);
      if (!_friends.any((f) => f.id == friendId)) {
        _friends = [..._friends, card];
      }
    });
  }

  Future<void> _removeFriend(String friendId) async {
    if (_currentUserId.isEmpty) return;
    await ProfileCustomizationStorage.removeUserFriend(
      _currentUserId,
      friendId,
    );
    if (!mounted) return;
    setState(() {
      _friendIds.remove(friendId);
      _friends = _friends.where((f) => f.id != friendId).toList();
    });
  }

  void _navigateToUserProfile(_FriendCardData user) {
    context.router.push(
      UserProfileRoute(
        account: AccountEntity(id: user.id, name: user.displayName),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: !_showAllUsers
          ? FloatingActionButton(
              onPressed: () => setState(() => _showAllUsers = true),
              backgroundColor: AppColors.successColor,
              shape: const CircleBorder(),
              child: const Icon(Icons.person_add, color: Colors.white),
            )
          : null,
      body: SafeArea(
        child: Stack(
          children: [
            Container(color: Colors.white),

            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  _showAllUsers ? 'Все пользователи' : 'Друзья',
                  style: GoogleFonts.philosopher(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: AppColors.activeColor,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 5,
              left: 10,
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: _loadFriends,
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
                  if (_showAllUsers) ...[
                    const SizedBox(width: 10),
                    FloatingActionButton(
                      onPressed: () => setState(() => _showAllUsers = false),
                      backgroundColor: AppColors.textSecondaryColor,
                      shape: const CircleBorder(),
                      child: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),

            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBody(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!_showAllUsers) {
      if (_friends.isEmpty) return _buildEmptyFriends();
      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _friends.length,
        itemBuilder: (_, i) => _FriendCard(
          user: _friends[i],
          showToggle: false,
          isFriend: true,
          onTap: () => _navigateToUserProfile(_friends[i]),
          onToggleFriend: () => _removeFriend(_friends[i].id),
        ),
      );
    }

    if (_allUsers.isEmpty) {
      return Center(
        child: Text(
          'Пользователи не найдены',
          style: GoogleFonts.philosopher(
            fontSize: 18,
            color: AppColors.textSecondaryColor,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: _allUsers.length,
      itemBuilder: (_, i) {
        final isFriend = _friendIds.contains(_allUsers[i].id);
        return _FriendCard(
          user: _allUsers[i],
          showToggle: true,
          isFriend: isFriend,
          onTap: () => _navigateToUserProfile(_allUsers[i]),
          onToggleFriend: () => isFriend
              ? _removeFriend(_allUsers[i].id)
              : _addFriend(_allUsers[i].id),
        );
      },
    );
  }

  Widget _buildEmptyFriends() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: AppColors.textSecondaryColor,
            ),
            const SizedBox(height: 16),
            Text(
              'У вас пока нет друзей',
              style: GoogleFonts.philosopher(
                fontSize: 20,
                color: AppColors.textPrimaryColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Найдите людей, разделяющих ваши спортивные интересы',
              style: GoogleFonts.roboto(
                fontSize: 14,
                color: AppColors.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => setState(() => _showAllUsers = true),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.activeColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Найти друзей',
                style: GoogleFonts.philosopher(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FriendCardData {
  final String id;
  final String displayName;
  final String favoriteSport;

  const _FriendCardData({
    required this.id,
    required this.displayName,
    required this.favoriteSport,
  });
}

class _FriendCard extends StatelessWidget {
  final _FriendCardData user;
  final bool showToggle;
  final bool isFriend;
  final VoidCallback onTap;
  final VoidCallback onToggleFriend;

  const _FriendCard({
    required this.user,
    required this.showToggle,
    required this.isFriend,
    required this.onTap,
    required this.onToggleFriend,
  });

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
                      user.displayName,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      user.favoriteSport,
                      style: GoogleFonts.roboto(
                        fontSize: 14,
                        color: AppColors.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              if (showToggle)
                IconButton(
                  icon: Icon(
                    isFriend ? Icons.person_remove : Icons.person_add,
                    color: isFriend
                        ? AppColors.dangerColor
                        : AppColors.successColor,
                  ),
                  onPressed: onToggleFriend,
                ),
              Icon(Icons.chevron_right, color: AppColors.textSecondaryColor),
            ],
          ),
        ),
      ),
    );
  }
}
