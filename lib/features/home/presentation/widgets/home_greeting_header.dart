import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_spacing.dart';
import '../../../../app/theme/app_typography.dart';
import 'home_sample_data.dart';

/// Dashboard header: avatar, greeting and notification button.
///
/// Layout matches the reference: a 36dp blue avatar, two lines of greeting
/// text that take the remaining width, and a 37dp outlined bell button.
class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({
    super.key,
    this.userName = HomeSampleData.userName,
    this.initials,
    this.onNotificationsPressed,
  });

  /// First name, used in the greeting. Kept separate from [initials] because
  /// the design shows a first name in the text ("Good morning, Alex") but two
  /// letters in the avatar ("AL"), which cannot both come from one value.
  final String userName;

  /// Avatar initials. Falls back to [userName]'s own first and last initials
  /// when not supplied, which is only right when [userName] is a full name.
  final String? initials;

  /// Unused until notifications exist; a no-op keeps the target the right size
  /// and reachable by assistive tech.
  final VoidCallback? onNotificationsPressed;

  static const Key avatarKey = Key('home_header_avatar');
  static const Key bellKey = Key('home_header_bell');

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: AppSpacing.lg,
        right: AppSpacing.lg,
        top: AppSpacing.md,
        bottom: AppSpacing.lg,
      ),
      child: Row(
        children: [
          _Avatar(initials: initials ?? initialsOf(userName)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Welcome back',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Good morning, $userName',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.greetingName,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          _BellButton(onPressed: onNotificationsPressed),
        ],
      ),
    );
  }

  /// Initials for a name: the first letter of the first and last word, so
  /// "Alex Jordan" reads "AJ". A single word yields just its first letter,
  /// which is why the dashboard supplies [HomeGreetingHeader.initials]
  /// separately — see that field for why. Blank input yields an empty string
  /// rather than throwing.
  static String initialsOf(String name) {
    final words = name.trim().split(RegExp(r'\s+')).where((w) => w.isNotEmpty);
    if (words.isEmpty) return '';
    if (words.length == 1) return words.first.characters.first.toUpperCase();
    return (words.first.characters.first + words.last.characters.first)
        .toUpperCase();
  }
}

/// Blue circle holding the user's initials.
class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: HomeGreetingHeader.avatarKey,
      width: 36,
      height: 36,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        shape: BoxShape.circle,
      ),
      child: Text(initials, style: AppTypography.avatarInitials),
    );
  }
}

/// Outlined circular bell button.
class _BellButton extends StatelessWidget {
  const _BellButton({this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 37,
      height: 37,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.border),
      ),
      child: IconButton(
        key: HomeGreetingHeader.bellKey,
        onPressed: onPressed,
        padding: EdgeInsets.zero,
        iconSize: 20,
        color: AppColors.textPrimary,
        tooltip: 'Notifications',
        icon: const Icon(Ionicons.notifications_outline),
      ),
    );
  }
}
