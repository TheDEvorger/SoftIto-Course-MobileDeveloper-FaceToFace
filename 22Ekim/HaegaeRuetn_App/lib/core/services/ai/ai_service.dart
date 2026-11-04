// Vazife modelini projeye ekler
import '../../models/habit.dart';
// Sohbet mesajı modelini projeye ekler
import 'ai_message.dart';
// Rehber kişiliklerini projeye ekler
import 'ai_persona.dart';
// Bağlantı olmadığında kullanılacak işlemi hazırlar
// Yapay zekâ mesajlaşmasının giriş ve çıkış türlerini belirler
abstract class AiService {
  // Kullanıcı mesajını işleyip uygun AI yanıtını getirir
  Future<AiMessage> sendMessage({
    // history parametresini zorunlu alır
    required List<AiMessage> history,
    // AI yanıtının kullanılacağı rehber kişiliğini alır ve zorunludur
    required AiPersona persona,
    // user soru parametresini zorunlu alır
    required String userPrompt,
    // Öneride eşleştirilebilecek vazife listesini alır ve zorunludur
    required List<Habit> availableHabits,
    // Kullanıcı izinli alışkanlık özetini alır, verilmezse null olabilir
    String? contextSummary,
    // Yanıtların sade Türkçe olmasını belirler
    bool plainTurkish = false,
    // Kullanıcının rehbere verdiği özel talimatları alır, verilmezse null olabilir
    String? customInstructions,
  });
}
