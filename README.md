<h1 align="center">Guia Digital — Assistente</h1>

<p align="center">
  <em>Acessibilidade na mobilidade urbana</em>
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white" />
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white" />
  <img alt="Android" src="https://img.shields.io/badge/Android-API%2021%2B-3DDC84?logo=android&logoColor=white" />
  <img alt="License" src="https://img.shields.io/badge/license-Proprietary-lightgrey" />
  <img alt="Nylo" src="https://img.shields.io/badge/Nylo-5.x-blueviolet" />
</p>

---

## Sobre o projeto

O **Guia Digital Assistente** é um aplicativo móvel (Android/iOS) desenvolvido em Flutter, focado em **acessibilidade e mobilidade urbana**. O app combina **câmera em tempo real** e **mapa de localização** para registrar e documentar pontos de interesse, barreiras arquitetônicas e trajetos acessíveis pela cidade, servindo como assistente visual para pessoas com deficiência e para equipes que auditam a acessibilidade do espaço público.

O projeto é mantido pela [TIVIC](http://www.tivic.com.br) como parte do programa **Via Verde**.

### Principais funcionalidades

- **Autenticação** de usuários com sessão persistente (via Nylo `Auth`).
- **Câmera traseira** em preview fullscreen, com gravação de vídeo e salvamento em armazenamento externo.
- **Mini‑mapa** sobreposto à câmera, usando **OpenStreetMap** (sem custos de tile).
- **Interface moderna e acessível**, com suporte a tema claro/escuro, `Semantics` para leitores de tela e tipografia Montserrat.
- **Arquitetura baseada no [Nylo Framework](https://nylo.dev)**: providers, rotas com guards, controllers, modelos e camada de API (Dio).

---

## Stack

| Camada | Tecnologia |
|---|---|
| Framework | [Flutter](https://flutter.dev) |
| Linguagem | [Dart](https://dart.dev) |
| Micro‑framework | [Nylo Framework 5.x](https://nylo.dev) |
| Rede | [Dio](https://pub.dev/packages/dio) + `pretty_dio_logger` |
| Mapa | [flutter_map](https://pub.dev/packages/flutter_map) + OpenStreetMap |
| Câmera | [camera](https://pub.dev/packages/camera) |
| Permissões | [permission_handler](https://pub.dev/packages/permission_handler) |
| Persistência de arquivos | [document_file_save_plus](https://pub.dev/packages/document_file_save_plus) |
| Fontes | [google_fonts](https://pub.dev/packages/google_fonts) (Montserrat) |

---

## Pré-requisitos

- **Flutter SDK** compatível com Dart `>=3.1.3 <4.0.0`. Recomendado Flutter 3.22+.
- **Android Studio** (ou Android SDK CLI) com:
  - Android SDK Platform 35
  - Android SDK Build‑Tools
  - Um emulador ou dispositivo físico Android 5.0+ (API 21)
- **JDK 17** (Gradle 8.11 / AGP 8.9 exigem 17+).
- **Git** para clonar o repositório.

Verifique seu ambiente:

```bash
flutter doctor -v
```

> Para iOS: Xcode 15+ e CocoaPods (a configuração nativa iOS precisa ser revisada antes do primeiro build).

---

## Como rodar o projeto

### 1. Clone o repositório

```bash
git clone https://github.com/tivic-pdi/via-verde-assistente-app.git
cd via-verde-assistente-app
```

### 2. Crie o arquivo de ambiente

Na raiz do projeto, crie um arquivo `.env` com as variáveis abaixo. As variáveis de **tema** são lidas em `lib/config/theme.dart` e precisam estar presentes para o Nylo montar a lista de temas da aplicação — se alguma faltar, o app inicializa sem tema válido e pode crashar.

Conteúdo mínimo do `.env`:

```env
# Debug
APP_DEBUG=false

# Temas (obrigatórios - lidos por lib/config/theme.dart)
LIGHT_THEME_ID=light_theme
DARK_THEME_ID=dark_theme

# Identificação do app (usado no diálogo "Sobre")
APP_NAME=Guia Digital

# API (preencha com o endpoint do backend)
API_BASE_URL=https://api.exemplo.com.br

# Opcionais (têm default no código)
DEFAULT_LOCALE=pt
AUTH_USER_KEY=AUTH_USER
```

| Variável | Obrigatória | Default | Usada em |
|---|:---:|---|---|
| `APP_DEBUG` | não | `false` | `base_api_service.dart`, `api_service.dart` |
| `LIGHT_THEME_ID` | **sim** | — | `config/theme.dart` |
| `DARK_THEME_ID` | **sim** | — | `config/theme.dart`, `home_page.dart`, `bootstrap/app.dart` |
| `APP_NAME` | recomendado | — | `auth_controller.dart`, `home_controller.dart` |
| `API_BASE_URL` | **sim** (em runtime) | — | `app/networking/api_service.dart` |
| `DEFAULT_LOCALE` | não | `en` | `config/localization.dart` |
| `AUTH_USER_KEY` | não | `AUTH_USER` | `config/storage_keys.dart` |

> O `.env` **não** deve ser commitado (já está em uso pelo `flutter_dotenv`). Mantenha um `.env.example` sincronizado para documentar as variáveis esperadas.

### 3. Instale as dependências

```bash
flutter pub get
```

### 4. Rode o app

```bash
# Lista os devices disponíveis
flutter devices

# Roda em modo debug no device conectado
flutter run

# Ou especificando o device
flutter run -d emulator-5554
```

### 5. Build de release (Android)

```bash
flutter build apk --release
# ou App Bundle para a Play Store:
flutter build appbundle --release
```

O APK fica em `build/app/outputs/flutter-apk/app-release.apk`.

---

## Estrutura do projeto

```
lib/
├── app/
│   ├── controllers/           # Lógica de apresentação por página (AuthController, HomeController)
│   ├── events/                # Eventos do Nylo (LoginEvent, LogoutEvent)
│   ├── models/                # Modelos de domínio (Usuario)
│   ├── networking/            # Dio + interceptors + API services
│   └── providers/             # Bootstrapping: AppProvider, AuthProvider, RouteProvider, EventProvider
├── bootstrap/                 # Inicialização do Nylo (app.dart, boot.dart, helpers)
├── config/                    # Configurações (tema, fontes, eventos, decoders, storage keys)
├── resources/
│   ├── pages/                 # Telas do app
│   │   ├── auth/              # Tela de login
│   │   └── home/              # Tela principal (câmera + mapa)
│   ├── themes/                # Temas claro/escuro e tokens de cor
│   └── widgets/               # Widgets reutilizáveis
└── routes/                    # Definição de rotas e guards
    ├── router.dart
    └── guards/
        └── auth_route_guard.dart
public/
├── assets/
│   ├── app_icon/              # Ícone do app (icon.png)
│   ├── fonts/                 # Fontes Montserrat
│   └── images/                # Imagens estáticas
lang/                          # Arquivos de internacionalização
android/                       # Configuração nativa Android (Gradle 8.11, AGP 8.9, Kotlin 2.1)
ios/                           # Configuração nativa iOS
```

---

## Fluxo do app

```
┌─────────────┐     ┌─────────────┐     ┌─────────────┐
│  SessionPage│ ──► │  AuthPage   │ ──► │  HomePage   │
│ (redirect)  │     │  (login)    │     │  (câmera +  │
│             │     │             │     │   mapa)     │
└─────────────┘     └─────────────┘     └─────────────┘
                          │                    │
                          │                    ▼
                          │              [Auth.logout()]
                          └──────────────────────┘
```

- `SessionPage` é a rota inicial — decide se manda para login ou home.
- `AuthPage` autentica e persiste o usuário via `Auth.set()`.
- `HomePage` é protegida pelo `AuthRouteGuard` e mostra a câmera traseira + mini-mapa OSM.
- Botão de logout na `HomePage` chama `Auth.logout()` e retorna ao `AuthPage`.

---

## Permissões

As permissões declaradas em `android/app/src/main/AndroidManifest.xml`:

| Permissão | Uso |
|---|---|
| `INTERNET` | Requisições HTTP (API + tiles OSM) |
| `ACCESS_FINE_LOCATION` | Localização precisa (GPS) |
| `ACCESS_COARSE_LOCATION` | Localização aproximada (fallback) |
| `WRITE_EXTERNAL_STORAGE` | Salvar vídeos gravados |
| `CAMERA` (runtime) | Preview e gravação de vídeo |

No iOS, lembre-se de adicionar em `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Utilizamos a câmera para registrar pontos de acessibilidade.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Utilizamos sua localização para exibir o mapa.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Utilizamos o microfone durante a gravação de vídeo.</string>
```

---

## Scripts úteis

```bash
# Gerar ícones do app a partir de public/assets/app_icon/icon.png
dart run flutter_launcher_icons

# Analisar código
flutter analyze

# Rodar os testes
flutter test

# Limpar build
flutter clean && flutter pub get
```

---

## Convenções

- **Branches**: `main` (produção), `dev` (desenvolvimento), `feature/*`, `fix/*`, `chore/*`.
- **Commits**: Português, no imperativo — ex: `adiciona tela de login moderna`, `corrige crash ao abrir câmera`. Opcional seguir [Conventional Commits](https://www.conventionalcommits.org/).
- **Code style**: `flutter analyze` deve passar sem warnings antes do PR.

---

## Troubleshooting

<details>
<summary><strong>Build falha com <code>Unsupported class file major version 65</code></strong></summary>

Java 21 exige Gradle 8+ e AGP 8.3+. O projeto já está configurado com Gradle 8.11 / AGP 8.9 / Kotlin 2.1. Se ainda ocorrer, confirme que o JDK apontado pelo Flutter é 17+:

```bash
flutter doctor -v | findstr Java
```

</details>

<details>
<summary><strong>Câmera não aparece no emulador</strong></summary>

No AVD, configure `hw.camera.back=virtualscene` em `~/.android/avd/<nome>.avd/config.ini` e faça **Cold Boot**.

</details>

<details>
<summary><strong>Mapa não carrega (tiles ficam cinza)</strong></summary>

Verifique a permissão `INTERNET` e se o device tem conexão. O `flutter_map` requer `userAgentPackageName` — já está configurado para `com.via_verde_assistente.guia_digital`.

</details>

<details>
<summary><strong>Erro <code>Namespace not specified</code> em plugins Android</strong></summary>

O `android/build.gradle` já injeta um namespace fallback dinamicamente para plugins antigos. Se surgir em um plugin novo, basta rodar `flutter clean && flutter pub get`.

</details>

---

## Roadmap

- [ ] Integrar com API real de autenticação (hoje o login é apenas local).
- [ ] Implementar biometria (local_auth) na tela de login.
- [ ] Galeria de vídeos gravados com preview.
- [ ] Upload dos registros para backend.
- [ ] Marcação de pontos de acessibilidade no mapa.
- [ ] Suporte completo a iOS (Info.plist + build release).
- [ ] Testes de widget e integração.

---

## Licença

Propriedade da **TIVIC**. Uso restrito ao escopo do programa Via Verde.

Website: [www.tivic.com.br](http://www.tivic.com.br)
