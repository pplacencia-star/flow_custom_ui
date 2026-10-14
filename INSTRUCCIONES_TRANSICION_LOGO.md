# Music-Nova — transición del logo al iniciar sesión

- Se reemplazó el icono de nota musical del formulario de acceso por `assets/icon/app_icon.png`.
- Al terminar la intro, el logo se desplaza y se reduce hasta la posición del logo en el formulario, sin un corte directo.
- Si la sesión ya está iniciada, se mantiene el acceso directo a la aplicación después de la intro.
- No se alteraron las funciones de QR, seguidores, biblioteca, reproductor o estilo glass.

## Ejecutar

```sh
flutter pub get
flutter run -d chrome
```

## Publicar en GitHub

Copia el contenido de esta carpeta a tu clon `Music-Nova-GitHub`, sin reemplazar su carpeta `.git`.

```sh
git add .
git commit -m "Animacion de logo hacia inicio de sesion"
git push origin main
```

Nota: La compilación no pudo verificarse en este entorno porque Flutter no está instalado.
