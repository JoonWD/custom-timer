# ⏱️ ChronoSync

ChronoSync es una aplicación de temporizador moderna, ligera y multiplataforma desarrollada en Flutter.  
Diseñada para ofrecer control preciso del tiempo, experiencia sonora personalizable y una interfaz limpia.

## ✨ Características

- ⏳ Temporizador con precisión en tiempo real
- 🔊 Control independiente de volumen:
  - UI Sounds
  - Alarm Sounds
- 🌙 Modo oscuro / claro dinámico
- 💾 Persistencia de configuración (SharedPreferences)
- 🎧 Motor de sonido con soporte de loop para alarmas
- 🖥️ Compatible con:
  - Windows
  - Linux
  - macOS

## 🧠 Enfoque técnico

- Flutter (Material 3)
- Provider (gestión de estado)
- Audioplayers (motor de sonido)
- Arquitectura modular:
  - `core/`
  - `ui/`
  - separación clara de lógica y presentación

## 🚀 Instalación

### Usuarios finales
Descarga el ejecutable desde la sección **Releases**:
> https://github.com/JoonWD/chronosync/releases

### Desarrolladores
```bash
git clone https://github.com/JoonWD/chronosync.git
cd chronosync
flutter pub get
flutter run
