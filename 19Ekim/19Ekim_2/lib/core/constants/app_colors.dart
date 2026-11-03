// Flutter renk ve tema kütüphanesini ekler
import 'package:flutter/material.dart';

// Koyu temanın renklerini tutar, nesne oluşturulamaz
abstract final class AppColors {
  // Ana arka plan rengini belirler
  static const background = Color(0xFF0B1218);
  // Kartların yüzey rengini belirler
  static const surface = Color(0xFF141F27);
  // Yükseltilmiş yüzey rengini belirler
  static const elevatedSurface = Color(0xFF1B2932);
  // Ana vurgu rengini belirler
  static const accent = Color(0xFF61E4D3);
  // Soluk vurgu rengini belirler
  static const accentMuted = Color(0xFF244B4D);
  // Logo arka plan rengini belirler
  static const brandSurface = Color(0xFF17383B);
  // Antrenman alanının arka plan rengini belirler
  static const workoutSurface = Color(0xFF352B42);
  // Antrenman simgesinin rengini belirler
  static const workoutAccent = Color(0xFFD2A9FF);
  // Ana yazı rengini belirler
  static const textPrimary = Color(0xFFF3F7F7);
  // İkincil yazı rengini belirler
  static const textSecondary = Color(0xFF9EADB4);
  // Ayırıcı çizgi rengini belirler
  static const divider = Color(0xFF29363E);
  // Başarılı işlem rengini belirler
  static const success = Color(0xFF91E6A8);
}

// Açık temanın renklerini tutar, nesne oluşturulamaz
abstract final class AppColorsLight {
  // Ana arka plan rengini belirler
  static const background = Color(0xFFF5F8FA);
  // Kartların yüzey rengini belirler
  static const surface = Color(0xFFFFFFFF);
  // Yükseltilmiş yüzey rengini belirler
  static const elevatedSurface = Color(0xFFE9F0F3);
  // Ana vurgu rengini belirler
  static const accent = Color(0xFF00897B);
  // Soluk vurgu rengini belirler
  static const accentMuted = Color(0xFFE0F2F1);
  // Logo arka plan rengini belirler
  static const brandSurface = Color(0xFFD7F4F0);
  // Antrenman alanının arka plan rengini belirler
  static const workoutSurface = Color(0xFFF2EAF9);
  // Antrenman simgesinin rengini belirler
  static const workoutAccent = Color(0xFF7E38B7);
  // Ana yazı rengini belirler
  static const textPrimary = Color(0xFF122026);
  // İkincil yazı rengini belirler
  static const textSecondary = Color(0xFF5A717D);
  // Ayırıcı çizgi rengini belirler
  static const divider = Color(0xFFE1E8EC);
  // Başarılı işlem rengini belirler
  static const success = Color(0xFF1E8E42);
}

// Flutter temasına özel renk alanları ekler
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  // Constructor renk bilgilerinin tamamını zorunlu alır
  const AppThemeColors({
    // Ana vurgu rengini zorunlu tutar
    required this.accent,
    // Soluk vurgu rengini zorunlu tutar
    required this.accentMuted,
    // Logo arka plan rengini zorunlu tutar
    required this.brandSurface,
    // Antrenman arka plan rengini zorunlu tutar
    required this.workoutSurface,
    // Antrenman vurgu rengini zorunlu tutar
    required this.workoutAccent,
    // Yükseltilmiş yüzey rengini zorunlu tutar
    required this.elevatedSurface,
    // Ana yazı rengini zorunlu tutar
    required this.textPrimary,
    // İkincil yazı rengini zorunlu tutar
    required this.textSecondary,
    // Ayırıcı çizgi rengini zorunlu tutar
    required this.divider,
    // Başarı rengini zorunlu tutar
    required this.success,
    // İlerleme halkasının arka plan rengini zorunlu tutar
    required this.progressRingBackground,
  });
  // Ana vurgu rengini tutar
  final Color accent;
  // Soluk vurgu rengini tutar
  final Color accentMuted;
  // Logo arka plan rengini tutar
  final Color brandSurface;
  // Antrenman arka plan rengini tutar
  final Color workoutSurface;
  // Antrenman vurgu rengini tutar
  final Color workoutAccent;
  // Yükseltilmiş yüzey rengini tutar
  final Color elevatedSurface;
  // Ana yazı rengini tutar
  final Color textPrimary;
  // İkincil yazı rengini tutar
  final Color textSecondary;
  // Ayırıcı çizgi rengini tutar
  final Color divider;
  // Başarı rengini tutar
  final Color success;
  // İlerleme halkasının arka plan rengini tutar
  final Color progressRingBackground;
  // Koyu tema için özel renk nesnesi oluşturur
  static const dark = AppThemeColors(
    // Koyu temanın vurgu rengini alır
    accent: AppColors.accent,
    // Koyu temanın soluk vurgu rengini alır
    accentMuted: AppColors.accentMuted,
    // Koyu temanın logo rengini alır
    brandSurface: AppColors.brandSurface,
    // Koyu temanın antrenman yüzey rengini alır
    workoutSurface: AppColors.workoutSurface,
    // Koyu temanın antrenman vurgu rengini alır
    workoutAccent: AppColors.workoutAccent,
    // Koyu temanın yükseltilmiş yüzey rengini alır
    elevatedSurface: AppColors.elevatedSurface,
    // Koyu temanın ana yazı rengini alır
    textPrimary: AppColors.textPrimary,
    // Koyu temanın ikincil yazı rengini alır
    textSecondary: AppColors.textSecondary,
    // Koyu temanın çizgi rengini alır
    divider: AppColors.divider,
    // Koyu temanın başarı rengini alır
    success: AppColors.success,
    // İlerleme halkasının arka plan rengini belirler
    progressRingBackground: AppColors.elevatedSurface,
  );
  // Açık tema için özel renk nesnesi oluşturur
  static const light = AppThemeColors(
    // Açık temanın vurgu rengini alır
    accent: AppColorsLight.accent,
    // Açık temanın soluk vurgu rengini alır
    accentMuted: AppColorsLight.accentMuted,
    // Açık temanın logo rengini alır
    brandSurface: AppColorsLight.brandSurface,
    // Açık temanın antrenman yüzey rengini alır
    workoutSurface: AppColorsLight.workoutSurface,
    // Açık temanın antrenman vurgu rengini alır
    workoutAccent: AppColorsLight.workoutAccent,
    // Açık temanın yükseltilmiş yüzey rengini alır
    elevatedSurface: AppColorsLight.elevatedSurface,
    // Açık temanın ana yazı rengini alır
    textPrimary: AppColorsLight.textPrimary,
    // Açık temanın ikincil yazı rengini alır
    textSecondary: AppColorsLight.textSecondary,
    // Açık temanın çizgi rengini alır
    divider: AppColorsLight.divider,
    // Açık temanın başarı rengini alır
    success: AppColorsLight.success,
    // İlerleme halkası için açık renk belirler
    progressRingBackground: Color(0xFFE2EBEF),
  );
  // Üstteki copyWith metodunu yeniden yazar
  @override
  // Değişen renklerle yeni tema renkleri nesnesi oluşturur
  ThemeExtension<AppThemeColors> copyWith({
    // Yeni vurgu rengi isteğe bağlıdır
    Color? accent,
    // Yeni soluk vurgu rengi isteğe bağlıdır
    Color? accentMuted,
    // Yeni logo rengi isteğe bağlıdır
    Color? brandSurface,
    // Yeni antrenman yüzey rengi isteğe bağlıdır
    Color? workoutSurface,
    // Yeni antrenman vurgu rengi isteğe bağlıdır
    Color? workoutAccent,
    // Yeni yükseltilmiş yüzey rengi isteğe bağlıdır
    Color? elevatedSurface,
    // Yeni ana yazı rengi isteğe bağlıdır
    Color? textPrimary,
    // Yeni ikincil yazı rengi isteğe bağlıdır
    Color? textSecondary,
    // Yeni çizgi rengi isteğe bağlıdır
    Color? divider,
    // Yeni başarı rengi isteğe bağlıdır
    Color? success,
    // Yeni ilerleme halkası rengi isteğe bağlıdır
    Color? progressRingBackground,
  }) {
    // Güncellenmiş renklerle yeni nesne döndürür
    return AppThemeColors(
      // Yeni renk varsa onu yoksa mevcut rengi kullanır
      accent: accent ?? this.accent,
      // Yeni soluk vurgu rengi varsa onu kullanır
      accentMuted: accentMuted ?? this.accentMuted,
      // Yeni logo rengi varsa onu kullanır
      brandSurface: brandSurface ?? this.brandSurface,
      // Yeni antrenman yüzey rengi varsa onu kullanır
      workoutSurface: workoutSurface ?? this.workoutSurface,
      // Yeni antrenman vurgu rengi varsa onu kullanır
      workoutAccent: workoutAccent ?? this.workoutAccent,
      // Yeni yükseltilmiş yüzey rengi varsa onu kullanır
      elevatedSurface: elevatedSurface ?? this.elevatedSurface,
      // Yeni ana yazı rengi varsa onu kullanır
      textPrimary: textPrimary ?? this.textPrimary,
      // Yeni ikincil yazı rengi varsa onu kullanır
      textSecondary: textSecondary ?? this.textSecondary,
      // Yeni çizgi rengi varsa onu kullanır
      divider: divider ?? this.divider,
      // Yeni başarı rengi varsa onu kullanır
      success: success ?? this.success,
      // İlerleme halkasının yeni rengi varsa onu kullanır
      progressRingBackground:
          // Yeni renk yoksa mevcut rengi korur
          progressRingBackground ?? this.progressRingBackground,
    );
  }

  // Üstteki lerp metodunu yeniden yazar
  @override
  // İki tema arasındaki renk geçişini hesaplar
  ThemeExtension<AppThemeColors> lerp(
    // Geçiş yapılacak diğer temayı alır
    covariant ThemeExtension<AppThemeColors>? other,
    // Geçiş oranını alır
    double t,
  ) {
    // Gelen nesne AppThemeColors değilse çalışır
    if (other is! AppThemeColors) {
      // Mevcut renk nesnesini döndürür
      return this;
    }
    // Geçiş oranına göre yeni renk nesnesi oluşturur
    return AppThemeColors(
      // Ana vurgu rengini iki renk arasında hesaplar
      accent: Color.lerp(accent, other.accent, t) ?? accent,
      // Soluk vurgu rengini hesaplar
      accentMuted: Color.lerp(accentMuted, other.accentMuted, t) ?? accentMuted,
      // Logo renginin geçiş değerini hesaplar
      brandSurface:
          // Sonuç null olursa mevcut logo rengini kullanır
          Color.lerp(brandSurface, other.brandSurface, t) ?? brandSurface,
      // Antrenman yüzey renginin geçişini hesaplar
      workoutSurface:
          // Sonuç null olursa mevcut yüzey rengini kullanır
          Color.lerp(workoutSurface, other.workoutSurface, t) ?? workoutSurface,
      // Antrenman vurgu renginin geçişini hesaplar
      workoutAccent:
          // Sonuç null olursa mevcut vurgu rengini kullanır
          Color.lerp(workoutAccent, other.workoutAccent, t) ?? workoutAccent,
      // Yükseltilmiş yüzey renginin geçişini hesaplar
      elevatedSurface:
          // İki renk arasında geçiş yapar
          Color.lerp(elevatedSurface, other.elevatedSurface, t) ??
              // Sonuç null olursa mevcut rengi korur
              elevatedSurface,
      // Ana yazı renginin geçişini hesaplar
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t) ?? textPrimary,
      // İkincil yazı renginin geçişini hesaplar
      textSecondary:
          // Sonuç null olursa mevcut yazı rengini kullanır
          Color.lerp(textSecondary, other.textSecondary, t) ?? textSecondary,
      // Ayırıcı çizgi renginin geçişini hesaplar
      divider: Color.lerp(divider, other.divider, t) ?? divider,
      // Başarı renginin geçişini hesaplar
      success: Color.lerp(success, other.success, t) ?? success,
      // İlerleme halkasının arka plan rengini hesaplar
      progressRingBackground:
          // İki renk arasındaki geçişi başlatır
          Color.lerp(
                // Mevcut ilerleme halkası rengini alır
                progressRingBackground,
                // Diğer temanın ilerleme halkası rengini alır
                other.progressRingBackground,
                // Geçiş oranını kullanır
                t,
              ) ??
              // Sonuç null olursa mevcut rengi kullanır
              progressRingBackground,
    );
  }
}
