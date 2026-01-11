import 'package:flutter/material.dart';

class LanguageSelectorWidget extends StatelessWidget {
  final String selectedLanguage;
  final Function(String)? onLanguageSelected;
  final Function(String)? onLanguageChanged;
  final List<LanguageOption>? languages;

  const LanguageSelectorWidget({
    super.key,
    required this.selectedLanguage,
    this.onLanguageSelected,
    this.onLanguageChanged,
    this.languages,
  });

  List<LanguageOption> _getLanguages() {
    return languages ??
        [
          const LanguageOption(code: 'en', name: 'English', flag: '🇺🇸'),
          const LanguageOption(code: 'es', name: 'Spanish', flag: '🇪🇸'),
          const LanguageOption(code: 'fr', name: 'French', flag: '🇫🇷'),
          const LanguageOption(code: 'de', name: 'German', flag: '🇩🇪'),
          const LanguageOption(code: 'hi', name: 'Hindi', flag: '🇮🇳'),
        ];
  }

  void _handleLanguageChange(String? newValue) {
    if (newValue != null) {
      onLanguageSelected?.call(newValue);
      onLanguageChanged?.call(newValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageList = _getLanguages();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedLanguage,
          icon: Icon(Icons.arrow_drop_down,
              color: Theme.of(context).primaryColor),
          isExpanded: true,
          items: languageList.map((LanguageOption language) {
            return DropdownMenuItem<String>(
              value: language.code,
              child: Row(
                children: [
                  Text(language.flag, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Text(language.name),
                ],
              ),
            );
          }).toList(),
          onChanged: _handleLanguageChange,
        ),
      ),
    );
  }
}

class LanguageOption {
  final String code;
  final String name;
  final String flag;

  const LanguageOption({
    required this.code,
    required this.name,
    required this.flag,
  });
}
