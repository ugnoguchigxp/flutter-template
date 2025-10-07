# Coding Standards - Flutter B2B Template (2025)

## 📋 概要

このドキュメントは、Flutter B2Bアプリケーション開発における統一的なコーディング規約を定義します。

## 🛠️ 導入済みツール

### 1. 静的解析ツール

```yaml
dev_dependencies:
  flutter_lints: ^5.0.0          # Flutter公式Lintルール
  custom_lint: ^0.7.3            # カスタムLintフレームワーク
  riverpod_lint: ^2.3.13         # Riverpod専用Lint
```

### 2. コード品質チェック

```bash
# 静的解析実行
flutter analyze

# カスタムLint実行（Riverpod）
dart run custom_lint

# すべてのチェックを実行
flutter analyze && dart run custom_lint
```

## 📏 コーディング規約

### 1. **エラー防止（必須）**

#### ✅ Future処理
```dart
// ❌ Bad: 未awaitのFuture
void loadData() {
  fetchFromApi(); // Warning: discarded_futures
}

// ✅ Good: 明示的にawaitまたはunawaited
import 'package:flutter/foundation.dart';

Future<void> loadData() async {
  await fetchFromApi();
}

// または
void loadData() {
  unawaited(fetchFromApi());
}
```

#### ✅ Stream/Subscription管理
```dart
// ✅ Good: 必ずcloseする
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  late StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();
    _subscription = stream.listen((data) {});
  }

  @override
  void dispose() {
    _subscription.cancel(); // 必須
    super.dispose();
  }
}
```

### 2. **コードスタイル**

#### ✅ クォート
```dart
// ✅ Good: シングルクォート使用
const String name = 'John Doe';

// ❌ Bad: ダブルクォート
const String name = "John Doe";
```

#### ✅ トレーリングカンマ
```dart
// ✅ Good: 複数行の引数にはカンマ必須
Widget build(BuildContext context) {
  return Container(
    width: 100,
    height: 100,
    color: Colors.blue, // ← カンマ必須
  );
}
```

#### ✅ インポート順序
```dart
// ✅ Good: 正しい順序
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../models/user.dart';
import '../services/api.dart';
```

### 3. **型安全性（Strict Mode）**

#### ✅ 暗黙的キャスト禁止
```dart
// analysis_options.yaml設定
analyzer:
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false

// ❌ Bad: 暗黙的キャスト
Object value = getValue();
String name = value; // Error!

// ✅ Good: 明示的キャスト
Object value = getValue();
String name = value as String;
```

#### ✅ dynamic禁止
```dart
// ❌ Bad: dynamic使用
dynamic result = await api.fetch();

// ✅ Good: 適切な型またはObject
Object result = await api.fetch();
// または
Map<String, dynamic> result = await api.fetch();
```

### 4. **Null Safety**

#### ✅ Null演算子の活用
```dart
// ❌ Bad: 冗長なnullチェック
String? name;
if (name != null) {
  print(name);
} else {
  print('Unknown');
}

// ✅ Good: null演算子使用
String? name;
print(name ?? 'Unknown');
```

#### ✅ 不要なnullチェック回避
```dart
// ❌ Bad: 不要なnullチェック
String name = 'John';
if (name != null) { // 警告: unnecessary_null_checks
  print(name);
}

// ✅ Good: nullチェック不要
String name = 'John';
print(name);
```

### 5. **Widget設計**

#### ✅ Key使用
```dart
// ✅ Good: Widgetにはkey使用
class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) => Container();
}
```

#### ✅ 最適なWidget選択
```dart
// ❌ Bad: 不要なContainer
Container(
  color: Colors.blue,
  child: Text('Hello'),
)

// ✅ Good: ColoredBox使用
ColoredBox(
  color: Colors.blue,
  child: Text('Hello'),
)

// ❌ Bad: Container for spacing
Container(
  width: 20,
  height: 20,
)

// ✅ Good: SizedBox使用
SizedBox(
  width: 20,
  height: 20,
)
```

### 6. **Immutability（不変性）**

#### ✅ finalの活用
```dart
// ✅ Good: ローカル変数にfinal
void calculate() {
  final result = compute();
  print(result);
}

// ✅ Good: クラスフィールドにfinal
class User {
  const User({required this.name});

  final String name;
}
```

#### ✅ const使用
```dart
// ✅ Good: Immutableクラスはconst
class AppConfig {
  const AppConfig({
    required this.apiUrl,
    required this.timeout,
  });

  final String apiUrl;
  final int timeout;
}

// 使用時
const config = AppConfig(
  apiUrl: 'https://api.example.com',
  timeout: 30,
);
```

### 7. **Riverpod ベストプラクティス**

#### ✅ Provider命名規則
```dart
// ✅ Good: 末尾にProvider
final userRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepository();
});

final currentUserProvider = FutureProvider<User?>((ref) async {
  final repo = ref.watch(userRepositoryProvider);
  return repo.getCurrentUser();
});
```

#### ✅ Provider依存関係
```dart
// ✅ Good: ref.watch で依存関係を明示
final userDataProvider = FutureProvider<UserData>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final api = ref.watch(apiClientProvider);

  return api.fetchUser(userId);
});
```

### 8. **セキュリティ**

#### ✅ Web API使用制限
```dart
// ❌ Bad: Flutterアプリでdart:html使用
import 'dart:html'; // Error: avoid_web_libraries_in_flutter

// ✅ Good: universal_htmlまたはプラットフォーム分岐
import 'package:universal_html/html.dart';
```

#### ✅ 安全なURL
```dart
// ✅ Good: HTTPS使用
const apiUrl = 'https://api.example.com';

// ❌ Bad: HTTPは警告（pubspec.yaml）
# pubspec.yaml
# repository: http://github.com/... # Warning!
```

## 🔧 IDE設定

### VSCode設定 (.vscode/settings.json)

```json
{
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true,
    "source.organizeImports": true
  },
  "dart.lineLength": 120,
  "dart.previewFlutterUiGuides": true,
  "dart.previewFlutterUiGuidesCustomTracking": true,
  "[dart]": {
    "editor.rulers": [80, 120],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off"
  }
}
```

### IntelliJ/Android Studio設定

1. **Preferences → Editor → Code Style → Dart**
   - Line length: 120
   - Use single quotes: ✓

2. **Preferences → Editor → Inspections → Dart**
   - Enable all Dart Analysis inspections

## 📊 CI/CD統合

### GitHub Actions例

```yaml
name: Code Quality

on: [push, pull_request]

jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.9.2'

      - name: Install dependencies
        run: flutter pub get

      - name: Run Flutter analyze
        run: flutter analyze

      - name: Run custom lint
        run: dart run custom_lint

      - name: Check formatting
        run: dart format --set-exit-if-changed .
```

## 🎯 チェックリスト（PR前）

開発完了時、以下を必ず実行：

- [ ] `flutter analyze` で0エラー
- [ ] `dart run custom_lint` で0エラー
- [ ] `dart format .` でコード整形
- [ ] 新規Widget/Classにドキュメントコメント追加
- [ ] 不要な`print`文を削除（logger使用）
- [ ] `TODO`コメントはissue化またはコメント削除

## 📚 参考リンク

- [Effective Dart](https://dart.dev/guides/language/effective-dart)
- [Flutter Style Guide](https://github.com/flutter/flutter/wiki/Style-guide-for-Flutter-repo)
- [Riverpod Best Practices](https://riverpod.dev/docs/essentials/faq)
- [Very Good Ventures Analysis](https://pub.dev/packages/very_good_analysis)

---

**最終更新**: 2025-10-05
**適用バージョン**: Flutter 3.9.2+, Dart 3.9.2+
