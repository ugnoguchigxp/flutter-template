# flutter_template

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Mock API Server

- `mockServer/` 配下に FastAPI 製のモックサーバーを用意しています。
- 別ターミナルで `cd mockServer && make run` を実行し、ポート `8081` で起動してください。
- Flutter アプリをモックサーバーに接続する際は、起動コマンドに `--dart-define=API_BASE_URL=http://127.0.0.1:8081` を付与します。
  - Android エミュレーターは `http://10.0.2.2:8081` を指定してください。
