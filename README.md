# Infinity-Hue 🎨✨  
**A Flutter Text-to-Image Generator powered by AUTOMATIC1111 WebUI API**

<p align="left">
  <a href="https://flutter.dev"><img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.x-blue.svg?logo=flutter"></a>
  <a href="https://dart.dev"><img alt="Dart" src="https://img.shields.io/badge/Dart-3.x-0175C2.svg?logo=dart"></a>
  <img alt="Platforms" src="https://img.shields.io/badge/Platforms-Android | iOS | Web | Desktop-informational">
  <a href="LICENSE"><img alt="License" src="https://img.shields.io/badge/License-MIT-green.svg"></a>
</p>

> Infinity-Hue is a cross-platform Flutter app for generating images from text prompts.  
> It connects to a local or remote **AUTOMATIC1111 Stable Diffusion WebUI** with `--api` enabled.

---

## ✨ Features

- 🧠 **Prompt → Image** via AUTOMATIC1111 `/sdapi/v1/*` endpoints  
- 🛠️ **Adjustable params**: steps, CFG scale, sampler, seed, size, etc.  
- 💾 **Save & share** generated images  
- 📱 **Flutter UI** that targets Android, iOS, Web, and Desktop  
- 🧱 **Clean structure** — easy to extend with new endpoints/features

> ⚠️ **Status:** Work in progress. PRs and ideas are welcome!

---

## 🧩 Architecture (High Level)

- **Frontend:** Flutter (Dart)  
- **Backend:** Your **AUTOMATIC1111 WebUI** instance with `--api` enabled  
- **Transport:** HTTP/JSON

## 🚀 Quick Start

### 1) Prerequisites
- Flutter SDK installed → https://flutter.dev/docs/get-started/install  
- A running **AUTOMATIC1111** instance with API enabled (examples):
  ```bash
  # Linux/macOS
  ./webui.sh --api --listen
  # (Recommended) protect the API:
  ./webui.sh --api --listen --api-auth username:password

  # Windows (PowerShell)
  .\webui.bat --api --listen --api-auth username:password

