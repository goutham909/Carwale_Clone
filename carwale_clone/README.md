# CarWale Clone (Flutter)

Same workflow as [Blink Clone](https://github.com/goutham909/blink_clone): **Flutter web** app + **`web/iphone_preview.html`** iframe shell + mock **JSON** in `assets/mock/`.

## Prerequisites

- [Flutter SDK](https://docs.flutter.dev/get-started/install) with web enabled (`flutter config --enable-web`).

## Build & preview (iPhone frame)

```powershell
cd carwale_clone
.\build_web_preview.ps1
cd build\web
python -m http.server 8081
```

Open **http://127.0.0.1:8081/iphone_preview.html**

Or full-page app: **http://127.0.0.1:8081/index.html**

(Port **8081** is used so it does not conflict with Blink Clone on **8080**.)

## Dev (hot reload)

```powershell
flutter pub get
flutter run -d chrome
```

## Project layout

| Path | Role |
|------|------|
| `lib/features/` | New, Used, Compare, News, Alerts, Search, Car detail |
| `lib/routing/` | `go_router` + `StatefulShellRoute` (5 tabs) |
| `lib/providers/` | Riverpod + `catalogProvider` |
| `assets/mock/catalog.json` | Cars, news, notifications, comparisons |
| `web/iphone_preview.html` | Device frame + iframe → `index.html` |

## Static HTML (no Flutter)

The parent folder also has **`static_preview.html`** — the original single-file version; open it directly in a browser.
