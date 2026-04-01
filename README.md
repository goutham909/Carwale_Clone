# CarWale clone

Two ways to run this project — same idea as your **Blink Clone** (Flutter + iPhone iframe preview).

## 1. Flutter app (like Blink Clone)

Folder: **[`carwale_clone/`](carwale_clone/)**

- **Riverpod** + **go_router** + **StatefulShellRoute** (5 tabs: New, Used, Compare, News, Alerts)
- **`web/iphone_preview.html`** — device frame loads the built **`index.html`** in an iframe (same pattern as Blink)
- Mock data: **`assets/mock/catalog.json`**
- Build script: **`build_web_preview.ps1`**

```powershell
cd carwale_clone
.\build_web_preview.ps1
cd build\web
python -m http.server 8081
```

Then open **http://127.0.0.1:8081/iphone_preview.html** (8081 avoids clashing with Blink on 8080).

You need the [Flutter SDK](https://docs.flutter.dev/get-started/install) on your PATH.

Details: [`carwale_clone/README.md`](carwale_clone/README.md).

## 2. Static single-file (no Flutter)

- **`static_preview.html`** — original all-in-one HTML/CSS/JS + inline phone chrome  
- Or **`index.html`** at this folder root if you still use that copy

Double-click the file or open via `file:///...` — no build step.

## Repository

https://github.com/goutham909/Carwale_Clone
