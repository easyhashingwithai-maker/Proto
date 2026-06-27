import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/settings.dart';
import 'package:isar/isar.dart';

class SettingsService {
  final Isar _isar;
  final _secureStorage = const FlutterSecureStorage();

  SettingsService(this._isar);

  Future<UserSettings> getSettings() async {
    final settings = await _isar.userSettings.where().findFirst();
    if (settings != null) return settings;

    // Create default settings if not exists
    final defaultSettings = UserSettings();
    await _isar.writeTxn(() => _isar.userSettings.put(defaultSettings));
    return defaultSettings;
  }

  Future<void> updateSettings(UserSettings settings) async {
    await _isar.writeTxn(() => _isar.userSettings.put(settings));

    // Store sensitive keys in secure storage
    if (settings.geminiApiKey != null) {
      await _secureStorage.write(key: 'gemini_key', value: settings.geminiApiKey);
    }
    if (settings.groqApiKey != null) {
      await _secureStorage.write(key: 'groq_key', value: settings.groqApiKey);
    }
    if (settings.githubPAT != null) {
      await _secureStorage.write(key: 'github_pat', value: settings.githubPAT);
    }
  }

  Future<String?> getSecureKey(String key) async {
    return await _secureStorage.read(key: key);
  }
}
