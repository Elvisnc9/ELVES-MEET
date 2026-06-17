# Elves Meet

> A real-time video calling application built with Flutter, Serverpod, and Agora — supporting Google Sign-In, room creation, and peer-to-peer video calls.

---

## Overview

Elves Meet is a Google Meet–style video calling app. Users can sign in with Google, create a meeting room that generates a shareable code (e.g. `abc-mnop-xyz`), and invite others to join by entering that code. Video calls are powered by Agora RTC, authenticated tokens are generated server-side by Serverpod, and Flutter drives the entire mobile client.

The project is split into three Dart packages:

| Package | Role |
|---|---|
| `pluse_server` | Serverpod backend — endpoints, auth, token generation |
| `pluse_client` | Auto-generated Serverpod client — shared models + RPC stubs |
| `pluse_flutter` | Flutter mobile app |

---

## Architecture

```
┌─────────────────────────────┐
│        Flutter App          │
│  (pluse_flutter)            │
│                             │
│  Riverpod providers         │
│  ┌──────────┐ ┌──────────┐  │
│  │AuthProv. │ │CallProv. │  │
│  └────┬─────┘ └────┬─────┘  │
│       │             │        │
└───────┼─────────────┼────────┘
        │  RPC calls  │  RPC calls
        ▼             ▼
┌─────────────────────────────┐
│     Serverpod Server        │
│  (pluse_server :8080)       │
│                             │
│  ┌─────────────────────┐   │
│  │  GoogleIdpEndpoint  │   │  ◄── validates Google ID token
│  │  AgoraEndpoint      │   │  ◄── signs & returns Agora token
│  │  JwtRefreshEndpoint │   │  ◄── rotates access tokens
│  └────────┬────────────┘   │
│           │                 │
│  ┌────────▼────────────┐   │
│  │    PostgreSQL DB    │   │
│  │    (port 8090)      │   │
│  └─────────────────────┘   │
└─────────────────────────────┘
        │
        │  Agora token
        ▼
┌─────────────────────────────┐
│     Agora RTC Network       │
│  (video / audio channels)   │
└─────────────────────────────┘
```

---

## Project Structure

```
.
├── pluse_server/                  # Serverpod backend
│   ├── bin/
│   │   └── main.dart              # Entry point
│   ├── config/
│   │   ├── development.yaml       # Dev server config (host, ports, DB)
│   │   ├── production.yaml        # Prod server config
│   │   ├── staging.yaml
│   │   ├── test.yaml
│   │   ├── generator.yaml         # Serverpod code-gen config
│   │   └── passwords.yaml         # Secrets — NOT committed (see .gitignore)
│   ├── lib/
│   │   ├── server.dart            # Serverpod bootstrap & auth init
│   │   └── src/
│   │       ├── agora/
│   │       │   ├── agora_endpoint.dart       # getToken endpoint
│   │       │   └── agora_token_builder.dart  # AccessToken2 implementation
│   │       ├── auth/
│   │       │   ├── email_idp_endpoint.dart   # Email sign-in endpoint
│   │       │   ├── google_idp_endpoint.dart  # Google sign-in endpoint
│   │       │   └── jwt_refresh_endpoint.dart # Token refresh endpoint
│   │       ├── greetings/
│   │       │   ├── greeting.spy.yaml         # Model definition
│   │       │   └── greeting_endpoint.dart    # Example endpoint
│   │       └── generated/                    # Auto-generated — do not edit
│   ├── migrations/                # Database migration history
│   ├── test/integration/          # Integration tests
│   ├── docker-compose.yaml        # PostgreSQL + Redis services
│   ├── Dockerfile                 # Production Docker build
│   └── pubspec.yaml
│
├── pluse_client/                  # Auto-generated Serverpod client
│   └── lib/
│       └── src/protocol/
│           ├── client.dart        # RPC endpoint stubs
│           ├── protocol.dart      # Serialization manager
│           └── agora/
│               └── gora_token_response.dart
│
└── pluse_flutter/                 # Flutter mobile app
    └── lib/
        ├── main.dart              # App entry — client init, ProviderScope
        ├── app/
        │   └── appshell.dart      # Root navigator / screen switcher
        ├── core/
        │   ├── enums.dart         # AuthStatus enum
        │   └── theme/
        │       ├── app_colors.dart
        │       └── app_theme.dart
        ├── models/
        │   ├── meeting_model.dart
        │   └── user_model.dart
        ├── providers/
        │   ├── auth_provider.dart        # Google sign-in, sign-out, state
        │   ├── call_provider.dart        # Agora engine lifecycle
        │   └── navigation_controller.dart # Screen routing via Riverpod
        ├── screens/
        │   ├── homeScreen.dart    # Recent calls list + FABs
        │   ├── callScreen.dart    # Live video call UI
        │   ├── codeSearch.dart    # "Join with a code" screen
        │   ├── createroom.dart    # Bottom sheet — create & share room
        │   ├── onboardiing.dart   # Onboarding carousel + auth buttons
        │   └── profile.dart       # Settings / sign-out
        └── widget/
            ├── authButton.dart
            ├── loader.dart
            └── home_widget/
                ├── drawer.dart
                ├── fabButton.dart
                └── topbar.dart
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Mobile client | Flutter 3.x (Dart 3.8+) |
| State management | Riverpod 2 (`flutter_riverpod`) |
| Backend framework | Serverpod 3.4.9 |
| Database | PostgreSQL 16 (via Docker) |
| Cache / pub-sub | Redis 6 (via Docker) |
| Auth | Google Sign-In via Serverpod Auth IDP |
| Video / audio | Agora RTC Engine (`agora_rtc_engine`) |
| Fonts | Space Grotesk (Google Fonts) |
| Animations | `flutter_animate`, Lottie |

---

## Prerequisites

Make sure the following are installed before you begin:

- **Flutter** SDK ≥ 3.8.0 — [install guide](https://docs.flutter.dev/get-started/install)
- **Dart** SDK ≥ 3.8.0 (bundled with Flutter)
- **Docker Desktop** (or Docker + Docker Compose) — for PostgreSQL and Redis
- **Serverpod CLI** — `dart pub global activate serverpod_cli`
- An **Agora account** with an App ID and App Certificate — [console.agora.io](https://console.agora.io)
- A **Google Cloud project** with OAuth 2.0 credentials configured for your app

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/your-org/elves-meet.git
cd elves-meet
```

### 2. Start the database and Redis

From the `pluse_server` directory:

```bash
cd pluse_server
docker compose up --build --detach
```

This starts:
- PostgreSQL on `localhost:8090` (mapped from container port 5432)
- Redis on `localhost:8091` (mapped from container port 6379)

The database name is `pluse` and the test database is `pluse_test`. Credentials are defined in `docker-compose.yaml`.

### 3. Configure passwords / secrets

Create `pluse_server/config/passwords.yaml` (this file is in `.gitignore` and must never be committed):

```yaml
# Serverpod shared service password
serviceSecret: your-long-random-service-secret

# Google OAuth client secret JSON (download from Google Cloud Console)
# Paste the entire JSON string as a single-line value
googleClientSecret: '{"web":{"client_id":"...","client_secret":"...","..."}}'

# Agora credentials
agoraAppId: your-agora-app-id
agoraAppCertificate: your-agora-app-certificate

# Database password (must match docker-compose.yaml)
database: fDciX085PaMBCK6J553J9hKoaYQCv5_c

# Redis password (must match docker-compose.yaml)
redis: RyABkRQ-KsizIgTO72yXwPIEI23dDbiY
```

### 4. Run database migrations

With Docker running and `passwords.yaml` in place:

```bash
cd pluse_server
dart bin/main.dart --apply-migrations
```

Or use the Serverpod script shorthand defined in `pubspec.yaml`:

```bash
dart run serverpod_cli start
```

This applies all pending migrations under `pluse_server/migrations/` and creates all required tables.

### 5. Start the Serverpod server

```bash
cd pluse_server
dart bin/main.dart
```

The server starts on:
- API: `http://localhost:8080`
- Insights: `http://localhost:8081`
- Web: `http://localhost:8082`

### 6. Run the Flutter app

Update the server host in `pluse_flutter/lib/main.dart` to your machine's local IP (not `localhost`, since the emulator/device needs to reach your machine):

```dart
final client = Client('http://192.168.x.x:8080/')
  ..authSessionManager = FlutterAuthSessionManager();
```

Then:

```bash
cd pluse_flutter
flutter pub get
flutter run
```

---

## Configuration

### Server config

`pluse_server/config/development.yaml` controls the server's public host and ports. Update `publicHost` to your machine's LAN IP when testing on a physical device:

```yaml
apiServer:
  port: 8080
  publicHost: 192.168.x.x   # change this
  publicPort: 8080
  publicScheme: http
```

The database section must match your Docker Compose setup:

```yaml
database:
  host: localhost
  port: 5432           # Docker maps 8090→5432; use 5432 if connecting from server process
  name: elves-meet
  user: postgres
```

> Note: The Docker Compose file maps `8090:5432`. The server process connects directly to the container, so use port `5432` in the config when the server runs on the same machine as Docker. Adjust if running the server inside Docker itself.

### Passwords / secrets

All secrets live in `config/passwords.yaml` (see step 3 above). Serverpod reads them via `session.passwords['keyName']`. Never hardcode secrets in Dart source files.

### Google Sign-In setup

1. Go to [Google Cloud Console](https://console.cloud.google.com) → APIs & Services → Credentials.
2. Create an **OAuth 2.0 Client ID** for a Web application (the server validates the ID token server-side).
3. Create a second OAuth 2.0 Client ID for **Android** (or iOS) with your app's package name and SHA-1 fingerprint.
4. Download the web client's JSON and paste it as `googleClientSecret` in `passwords.yaml`.
5. Set your **server client ID** in `pluse_flutter/lib/providers/auth_provider.dart`:

```dart
await GoogleSignIn.instance.initialize(
  serverClientId: 'YOUR_WEB_CLIENT_ID.apps.googleusercontent.com',
);
```

### Agora setup

1. Create a project at [console.agora.io](https://console.agora.io).
2. Enable **App Certificate** for your project (required for token auth).
3. Copy the **App ID** and **App Certificate** into `passwords.yaml` under `agoraAppId` and `agoraAppCertificate`.

The server generates an AccessToken2 for each join request via `AgoraEndpoint.getToken`. The token is scoped to the channel name and a UID derived from the user's auth UUID, and expires after one hour.

---

## Key Features

- **Google Sign-In** — full OAuth flow through Serverpod Auth IDP; tokens are stored server-side and refreshed automatically via JWT rotation.
- **Create a room** — generates a random Google Meet–style code (e.g. `abc-mnop-xyz`). The code is the Agora channel name; no server-side room record is needed since Agora creates channels on first join.
- **Join by code** — enter any valid channel code to join an existing call.
- **Live video call** — full-duplex video via Agora RTC with camera/mic controls and speaker toggle.
- **Recent calls list** — home screen shows past calls with channel name, date, participant count, and avatar initials.
- **Profile & sign-out** — settings screen with sign-out that clears both the Serverpod session and the local Google Sign-In state.

---

## App Flow

```
App launch
    │
    ▼
AppShell reads isLoggedInProvider
    │
    ├── authenticated ──► HomeScreen
    │
    └── unauthenticated ─► OnboardingScreen
              │
              └── "Continue with Gmail" tapped
                        │
                        ▼
                   Google Sign-In flow
                        │
                        ├── success ──► LoadingScreen (2.5s) ──► HomeScreen
                        │
                        └── failure ──► Error snackbar (stays on Onboarding)

HomeScreen
    │
    ├── Tap "Create Room" FAB
    │       └── generateChannelName() → CreateRoomPanel (bottom sheet)
    │               ├── "Copy Code" → clipboard
    │               └── "Join Now" → joinChannel() → CallScreen
    │
    ├── Tap "Join Room" FAB or search bar
    │       └── CodeSearchScreen → enter code → joinChannel() → CallScreen
    │
    └── Tap recent call tile
            └── joinChannel(channelName) → CallScreen

CallScreen
    ├── mic toggle
    ├── camera toggle
    ├── speaker toggle
    └── end call → goToHome()
```

---

## State Management

The app uses **Riverpod 2** with a mix of `StateProvider`, `StateNotifierProvider`, and `Provider`.

| Provider | Type | Purpose |
|---|---|---|
| `authProvider` | `StateNotifierProvider<AuthNotifier, AuthStatus>` | Google sign-in, sign-out, auth state |
| `isLoggedInProvider` | `Provider<bool>` | Reads `authSessionManager.isAuthenticated` |
| `callStateProvider` | `StateNotifierProvider<CallStateNotifier, CallState>` | Agora engine, channel join/leave, toggles |
| `rootScreenProvider` | `StateProvider<RootScreen>` | Which root screen is active |
| `navigationProvider` | `Provider<NavigationController>` | Imperative navigation helper |
| `drawerOpenProvider` | `StateProvider<bool>` | Home screen drawer open/close |
| `createRoomPanelProvider` | `StateProvider<bool>` | Bottom sheet visibility |
| `createdChannelProvider` | `StateProvider<String?>` | The generated channel name |

---

## Server Endpoints

All endpoints are defined under `pluse_server/lib/src/` and registered in `lib/src/generated/endpoints.dart`.

### `AgoraEndpoint` — `agora`

**`getToken(channelName: String) → AgoraTokenResponse`**

Requires authentication. Generates an Agora AccessToken2 for the authenticated user and the requested channel. Returns `appId`, `token`, `uid`, and `channelName`. The UID is derived deterministically from the user's auth UUID (last 8 hex chars → int), so the same user always gets the same UID.

### `GoogleIdpEndpoint` — `googleIdp`

**`login(idToken, accessToken?) → AuthSuccess`**

Validates the Google ID token against Google's public keys (using the server-side client secret). On success, creates or retrieves the user account and returns a Serverpod JWT access token + refresh token pair.

### `EmailIdpEndpoint` — `emailIdp`

Standard email/password registration and login flow provided by `serverpod_auth_idp_server`. Supports full registration (with email verification), password reset, and login.

### `JwtRefreshEndpoint` — `jwtRefresh`

**`refreshAccessToken(refreshToken) → AuthSuccess`**

Rotates the refresh token and issues a new access token. Called automatically by the Serverpod Flutter client when an access token expires.

### `GreetingEndpoint` — `greeting`

**`hello(name: String) → Greeting`**

Example endpoint shipped with the Serverpod starter. Returns `"Hello {name}"` with a timestamp. Used for testing that the server is reachable.

---

## Authentication

Authentication is handled by `serverpod_auth_idp_server` (version 3.4.9). The flow:

1. The Flutter app calls `GoogleSignIn.instance.authenticate()` to get a Google ID token.
2. The ID token is sent to `googleIdp.login()` on the server.
3. The server validates the token using the Google client secret and either creates a new `AuthUser` + `UserProfile` or retrieves the existing one.
4. The server returns an `AuthSuccess` containing a short-lived JWT access token and a long-lived refresh token.
5. `FlutterAuthSessionManager.updateSignedInUser(authSuccess)` stores the tokens locally.
6. All subsequent endpoint calls automatically include the Bearer token in headers.
7. When the access token expires, `JwtRefreshEndpoint.refreshAccessToken` is called transparently by the client.

Sign-out calls both `client.auth.signOutDevice()` (server-side token revocation) and `client.authSessionManager.signOutDevice()` (local token deletion), followed by `GoogleSignIn.instance.signOut()`.

---

## Video Calls (Agora)

The call lifecycle is managed by `CallStateNotifier` in `call_provider.dart`:

```
joinChannel(channelName)
    │
    ├── 1. Request camera + microphone permissions
    ├── 2. Fetch Agora token from server (client.agora.getToken)
    ├── 3. Create RtcEngine and initialize with appId
    ├── 4. Register event handlers (onJoinChannelSuccess, onUserJoined, onUserOffline)
    ├── 5. Enable video + start preview
    └── 6. engine.joinChannel(token, channelId, uid, options)

endCall()
    ├── engine.leaveChannel()
    └── engine.release()
```

The `CallScreen` renders:
- Remote video full-screen via `AgoraVideoView` with `VideoViewController.remote`
- Local video in a top-right PiP overlay via `VideoViewController` (uid: 0)
- Control bar at the bottom with mic, camera, and end-call buttons

The channel profile is set to `channelProfileCommunication` (suitable for small group calls). The client role is `clientRoleBroadcaster`, meaning all participants both send and receive video.

---

## Navigation

Navigation uses a flat `RootScreen` enum rather than Flutter's `Navigator` stack, switched via an `AnimatedSwitcher` in `AppShell`. This avoids back-stack complexity for a single-purpose call app.

```dart
enum RootScreen {
  onboarding,
  loading,
  home,
  profile,
  codeSearch,
  call,
}
```

`NavigationController` (accessed via `ref.read(navigationProvider)`) provides named methods like `goToHome()`, `callScreen(meetingId)`, `openCodeSearch()`, etc. — so screens never manipulate `rootScreenProvider` directly.

Overlays (the create-room bottom sheet, the drawer) are rendered inside the root `Stack` in `AppShell` and toggled via their own `StateProvider<bool>` providers, keeping them independent of the screen stack.

---

## Database & Migrations

Serverpod manages the schema through versioned migration files in `pluse_server/migrations/`. Each migration folder is named with a timestamp and contains:

- `migration.sql` — the incremental SQL diff to apply
- `definition.sql` — the full schema at that version
- `definition.json` / `migration.json` — machine-readable versions used by Serverpod tooling

Current migration versions:
- `20260323104343461` — initial schema (all auth tables, Serverpod system tables)
- `20260609201033877` — adds anonymous, Facebook, GitHub, and Microsoft account tables from `serverpod_auth_idp` 3.x upgrade; adds `time` index on `serverpod_session_log`

To create a new migration after changing a model:

```bash
cd pluse_server
serverpod create-migration
```

To apply pending migrations on startup:

```bash
dart bin/main.dart --apply-migrations
```

---

## Generating Code

Serverpod generates the client package and server endpoint dispatcher from your model YAML files and endpoint classes. Run this whenever you add or change an endpoint or model:

```bash
cd pluse_server
serverpod generate
```

This updates:
- `pluse_server/lib/src/generated/` — server-side protocol, endpoints dispatcher
- `pluse_client/lib/src/protocol/` — client-side models and RPC stubs

The client package (`pluse_client`) is referenced by `pluse_flutter` via a path dependency. Never edit generated files manually.

---

## Running Tests

### Unit / integration tests (server)

The integration tests use a real database connection. Make sure the test database is running (started alongside the main database by `docker compose up`):

```bash
cd pluse_server
dart test test/integration/
```

Tests use `withServerpod` from `serverpod_test`, which wraps each test case in a database transaction that is rolled back automatically.

### Flutter widget tests

```bash
cd pluse_flutter
flutter test
```

---

## Deployment

### Server (Docker)

A multi-stage `Dockerfile` is included in `pluse_server/`. It compiles the server to a native executable and copies the binary, config files, migrations, and web assets into a minimal Alpine image.

```bash
cd pluse_server
docker build -t elves-meet-server .
docker run \
  -e runmode=production \
  -e serverid=default \
  -e logging=normal \
  -e role=monolith \
  -p 8080:8080 \
  elves-meet-server
```

For production, update `config/production.yaml` with your domain names and ensure `passwords.yaml` (or environment-injected secrets) is available in the container at `/config/passwords.yaml`.

### Flutter app

```bash
cd pluse_flutter

# Android
flutter build apk --release

# iOS
flutter build ipa --release
```

Before releasing, update the server URL in `main.dart` to your production API endpoint (e.g. `https://api.yourapp.com/`).

---

## Known Limitations & TODOs

- **Recent calls are mock data.** The home screen currently shows hardcoded `_dummyCalls`. A real implementation would persist call history server-side (a `calls` table with participants, channel name, and timestamp) and fetch it on home screen load.
- **Participant names are initials only.** The avatar stack shows initials derived from dummy data. Real implementation would look up `UserProfile.fullName` from the server for each participant who joined a channel.
- **No call history server endpoint.** The `AgoraEndpoint` only issues tokens; it does not record who joined or when. A future `CallHistoryEndpoint` would store and retrieve this.
- **No push notifications.** Users are not notified when someone creates a room they were invited to. This would require FCM/APNs integration.
- **Facebook sign-in is a stub.** The "Continue with Facebook" button in the onboarding screen has an empty `onTap` handler. The server has the `FacebookAccount` table from the auth IDP upgrade but no `FacebookIdpEndpoint` is wired up yet.
- **Single-host dev config.** The server's `publicHost` in `development.yaml` is currently a hardcoded LAN IP. Consider using `dart-define` or a `.env` file to inject this at build time.
- **No screen sharing.** Agora supports screen sharing; it has not been implemented in the call controls UI.
- **Redis is disabled.** `redis.enabled: false` in the config means no distributed caching or pub-sub. Enable it for multi-instance server deployments.
