# 📖 BibliApp

Aplicación móvil de lectura bíblica desarrollada en **Flutter** para **Android** e **iOS**. Permite leer la Biblia (versión Reina-Valera 1960), mantener el hábito diario con rachas, llevar estadísticas de lectura, guardar notas y referencias personales, y programar un plan de lectura con recordatorios.

---

## ✨ Características

### 🔥 Rachas de lectura
- Seguimiento de días consecutivos de lectura.
- Racha actual y racha más larga alcanzada.
- Registro automático al cumplir la lectura del día.

### 📊 Estadísticas de lectura
- Tiempo total leído (diario, semanal y mensual).
- Capítulos y libros leídos.
- Progreso general de lectura de la Biblia.
- Historial de días leídos.

### 📝 Notas y referencias
- Notas personalizadas asociadas a un versículo o pasaje.
- Guardado de referencias bíblicas para consultarlas después.
- Edición, eliminación y búsqueda de notas.

### 🔐 Login con Firebase
- Inicio de sesión y registro con Firebase Authentication.
- Sincronización de rachas, notas y referencias en Firebase.
- Los datos se conservan al cambiar de dispositivo.

### 🔔 Notificaciones de recordatorio
- Recordatorios locales para no perder la racha.
- Se activan según el plan de lectura configurado.

### 🗓️ Plan de lectura
- Configuración **por cada día de la semana** (lunes a domingo):
  - **Hora** del recordatorio.
  - **Duración** de la lectura (en minutos).
  - Posibilidad de activar o desactivar cada día.
- Las notificaciones se programan automáticamente según el plan.

---

## 🛠️ Tecnologías

| Área | Tecnología |
|------|------------|
| Framework | Flutter (gestionado con FVM) |
| Lenguaje | Dart |
| Gestión de estado | Cubit (`flutter_bloc`) |
| Arquitectura | Clean Architecture |
| Base de datos local | Almacenamiento local (rachas, notas, referencias, plan) |
| Backend | Firebase (Authentication y base de datos) |
| Notificaciones | Notificaciones locales programadas |
| Texto bíblico | `RV1960.json` (Reina-Valera 1960) |
| Plataformas | Android e iOS |

---

## 🏗️ Arquitectura

El proyecto sigue **Clean Architecture**, separando la lógica de la interfaz:

```
lib/
├── core/            # Tema, constantes, utilidades, componentes reutilizables
├── data/            # Fuentes de datos (local, Firebase, RV1960.json), modelos, repositorios impl.
├── domain/          # Entidades, contratos de repositorios, casos de uso
└── presentation/    # Pantallas, widgets, Cubits
```

Principios:
- Lógica de negocio separada de la UI.
- Estado manejado con **Cubit**.
- Uso mayoritario de `StatelessWidget`.
- Componentes reutilizables.
- Tema centralizado: colores, tamaños de texto, espaciados y fuentes.

---

## 🚀 Instalación y ejecución

### Requisitos
- [FVM](https://fvm.app/) instalado.
- Android Studio y/o Xcode.
- Un proyecto de Firebase configurado.

### Pasos

```bash
# 1. Clonar el repositorio
git clone <url-del-repositorio>
cd bibliapp

# 2. Instalar la versión de Flutter del proyecto
fvm install
fvm use

# 3. Instalar dependencias
fvm flutter pub get

# 4. Ejecutar la app
fvm flutter run
```

> Todos los comandos de Flutter/Dart se ejecutan con `fvm` antepuesto.

---

## 🔥 Configuración de Firebase

1. Crea un proyecto en la [consola de Firebase](https://console.firebase.google.com/).
2. Registra las apps de **Android** e **iOS**.
3. Descarga y agrega los archivos de configuración:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
4. Activa **Authentication** con los métodos de acceso que quieras usar.
5. Configura la base de datos para la sincronización de datos.

---

## 📂 Texto bíblico

El archivo `RV1960.json` se encuentra en la raíz del proyecto y se copia a la capa de datos para ser consumido por la aplicación.

---

## 🧪 Comandos útiles

```bash
fvm flutter analyze     # Analizar el código
fvm flutter test        # Ejecutar pruebas
fvm flutter build apk   # Compilar Android
fvm flutter build ios   # Compilar iOS
```

---

## 🗺️ Hoja de ruta

- [ ] Lectura de la Biblia (libros, capítulos y versículos)
- [ ] Login con Firebase
- [ ] Rachas de lectura
- [ ] Estadísticas de lectura
- [ ] Notas y referencias
- [ ] Plan de lectura semanal (hora y duración por día)
- [ ] Notificaciones de recordatorio
- [ ] Sincronización con Firebase

---

## 📄 Licencia

Por definir.