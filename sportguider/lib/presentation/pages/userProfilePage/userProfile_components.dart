part of 'userProfile_page.dart';

class _StableEditorSheet extends StatelessWidget {
  final String title;
  final String subtitle;
  final String saveLabel;
  final VoidCallback onSave;
  final Widget child;

  const _StableEditorSheet({
    required this.title,
    required this.subtitle,
    required this.saveLabel,
    required this.onSave,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return FractionallySizedBox(
      heightFactor: 0.86,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SafeArea(
          top: false,
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(20, 14, 20, 24 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 52,
                    height: 5,
                    decoration: BoxDecoration(
                      color: AppColors.borderColor,
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  style: GoogleFonts.philosopher(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.45,
                    color: AppColors.textSecondaryColor,
                  ),
                ),
                const SizedBox(height: 24),
                child,
                const SizedBox(height: 28),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                      onSave();
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.activeColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: Text(
                      saveLabel,
                      style: GoogleFonts.philosopher(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StableEditorLabel extends StatelessWidget {
  final String title;

  const _StableEditorLabel({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.philosopher(
        fontSize: 22,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimaryColor,
      ),
    );
  }
}

class _StableEditorField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  const _StableEditorField({
    required this.controller,
    required this.hintText,
    this.minLines = 1,
    this.maxLines = 1,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    final resolvedKeyboardType = keyboardType ?? TextInputType.multiline;
    final resolvedTextCapitalization =
        resolvedKeyboardType == TextInputType.emailAddress ||
            resolvedKeyboardType == TextInputType.phone
        ? TextCapitalization.none
        : textCapitalization;

    return TextField(
      controller: controller,
      keyboardType: resolvedKeyboardType,
      textCapitalization: resolvedTextCapitalization,
      minLines: minLines,
      maxLines: maxLines,
      style: TextStyle(
        fontSize: 16,
        color: AppColors.textPrimaryColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: AppColors.textSecondaryColor),
        filled: true,
        fillColor: AppColors.backgroundColor,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: AppColors.activeColor, width: 1.5),
        ),
      ),
    );
  }
}
