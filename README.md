# Chatly

Real-time chat built with flutter and firebase

[chatly.surge.sh](https://chatly.surge.sh/)

![chatly](https://user-images.githubusercontent.com/26859947/121124061-49da7a00-c7f2-11eb-9d9a-7faac9555bf6.png)

[Slides](https://drive.google.com/file/d/1recG6vNjwrzPPotXuPLeawQU823KGiqP/view?usp=sharing)

### Get Starter Code

```bash
git clone https://github.com/mibrah42/Chatly.git -b starter-code
```

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  dio: ^4.0.0

dev_dependencies:
  flutter_launcher_icons: ^0.9.0
  flutter_native_splash: ^1.1.8+4
  lint: ^1.0.0
  flutter_test:
    sdk: flutter

flutter_icons:
  android: "launcher_icon"
  ios: true
  remove_alpha_ios: true
  image_path: "assets/images/cryptoapp_logo.png"
  adaptive_icon_background: "assets/images/cryptoapp_logo.png"
  adaptive_icon_foreground: "assets/images/cryptoapp_logo.png"

flutter_native_splash:
  color: "#171A1E"
  image: "assets/images/cryptoapp_logo.png"
  android: true
  ios: true
```

### Configuring assets

```yaml
  assets:
    - assets/images/
```

## Firebase web dependencies
```html
<script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-app.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-auth.js"></script>
<script src="https://www.gstatic.com/firebasejs/8.8.1/firebase-firestore.js"></script>
```
