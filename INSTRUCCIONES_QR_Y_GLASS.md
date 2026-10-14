# Music-Nova: QR, perfiles y diseño glass

1. Ejecuta `flutter pub get` para instalar `qr_flutter` y `mobile_scanner`.
2. En Firebase Console > Firestore Database > Reglas, publica el contenido de `firestore.rules`. Las playlists privadas siguen protegidas.
3. Inicia sesión en DOS cuentas distintas. En Cuenta > Mi QR de seguimiento se publica el perfil y se muestra su QR. Desde Cuenta > Escanear y seguir, escanea el QR de la otra cuenta y pulsa Seguir.
4. Las playlists existentes se crean privadas (`isPublic: false`), por lo que no aparecerán en perfiles ajenos hasta que pulses el icono de candado junto a cada playlist en Biblioteca. Hazlo solo para las playlists que quieras compartir. El resto permanece privado.
5. Para Android: `flutter build apk --debug`. Para Chrome: `flutter run -d chrome`. El escaneo requiere permiso de cámara y, en web, HTTPS o localhost.
6. El ZIP no contiene dependencias descargadas ni un APK precompilado. No se pudo ejecutar Flutter aquí: comprueba la compilación en tu equipo o GitHub Actions.
