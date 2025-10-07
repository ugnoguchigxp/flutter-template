## テスト方針と運用ガイド（test-operation）

このドキュメントはこのテンプレートプロジェクト向けに、Unit / Widget / Integration テストの違い、mockito と mocktail の比較、推奨パッケージ、導入手順、実行例をまとめたものです。

対象読者: 開発者（新規参画者）、CI 設定担当者

---

## 1. テストの種類と目的

- Unit Test（ユニットテスト）
  - 目的: 個々の関数やクラスのロジックを検証する。外部依存（ネットワーク・DB・Time 等）はモックする。
  - 実行速度: 速い。CI の基本ゲートに含める。

- Widget Test（ウィジェットテスト）
  - 目的: 単一ウィジェットや小さなウィジェットツリーの表示・イベント処理を検証する。レンダリングや State の変化をテスト。
  - 実行速度: Unit より遅いが速い。UI ロジックの回帰検知に有用。

- Integration / End-to-End テスト
  - 目的: 実際のデバイスまたはエミュレータ上でアプリ全体のフローを検証する（ログイン → 操作 → API 結果など）。
  - 実行速度: 遅い（エミュレータ起動を伴う）。CI では専用ジョブで実行するのが一般的。

---

## 2. パッケージの比較と推奨

このテンプレート（Flutter 3.x / Dart 3.x・hooks_riverpod を使用）にふさわしい選択肢を整理します。

- テストランタイム（必須）
  - `flutter_test`（SDK に同梱）: Unit / Widget の基盤。既に `pubspec.yaml` にあります。

- Integration テスト
  - `integration_test`（公式パッケージ）: 推奨。エミュレータ/実機で E2E を実行するための公式フレームワーク。

- モッキングライブラリ（比較）
  - mockito
    - 長所: 歴史があり機能豊富。@GenerateMocks を使った静的な Mock クラス生成。
    - 短所: コード生成（build_runner）を必要とする。Dart null-safety 型周りで boilerplate が増えることがある。
  - mocktail
    - 長所: コード生成不要。null-safety に親和性が高く、書きやすい。テストコードがシンプルになる。
    - 短所: 一部高度なモック機能で mockito に劣るケースがあるが、一般的な利用では十分。

推奨: テンプレート用途では「mocktail」を推奨します。理由はセットアップが簡単で build_runner を増やさないこと、CI 環境で余計な生成ステップが減ることです。

- 追加で便利なパッケージ
  - `golden_toolkit`：Golden（スナップショット）テストの支援。
  - `flutter_driver` は非推奨（integration_test を使う）。

---

## 3. pubspec への追加（推奨 dev_dependencies）

テンプレートに追記する最小の dev_dependencies（バージョンはプロジェクトポリシーで固定してください）:

```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test: # E2E 用
  mocktail: # モッキング
  # golden_toolkit: # Golden テストを使う場合
```

注: 上記はバージョン指定を省略しています。CI で安定するバージョンに固定することを推奨します。

---

## 4. テストの書き方（最小サンプル）

以下はこのテンプレ構成（hooks_riverpod 等を使った UI）での代表的な例です。

### 4.1 Unit テスト（`test/`）

例: `test/utils/formatter_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/src/core/utils/formatter.dart';

void main() {
  test('formatDate returns yyyy-MM-dd', () {
    final result = formatDate(DateTime(2024, 1, 2));
    expect(result, '2024-01-02');
  });
}
```

ポイント: 外部依存（HTTP など）はモックして isolate されたテストを書く。

### 4.2 Widget テスト（`test/widget_test.dart`）

例: `test/widgets/counter_widget_test.dart`

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:my_app/src/features/counter/counter_widget.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(home: CounterWidget()),
      ),
    );

    expect(find.text('0'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('1'), findsOneWidget);
  });
}
```

ポイント: Provider を使うウィジェットは `ProviderScope` または `ProviderContainer` を用いて依存（mock provider の override など）を注入する。

### 4.3 Mocktail を使ったモック例（Unit / Widget 共通）

例: リポジトリをモックする

```dart
import 'package:mocktail/mocktail.dart';

class MockCustomerRepository extends Mock implements CustomerRepository {}

void main() {
  final mockRepo = MockCustomerRepository();
  when(() => mockRepo.fetchCustomers()).thenAnswer((_) async => [Customer(id: '1')]);
}
```

注意点: null-safety のため `when` の引数はクロージャで渡す。`registerFallbackValue` の利用が必要なケースもある。

### 4.4 Integration テスト（`integration_test/`）

例: `integration_test/app_test.dart`

```dart
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('full app smoke test', (WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();

    // 例: ログイン画面->ダッシュボード遷移の簡易フロー
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('dashboard')), findsOneWidget);
  });
}
```

実行手順（ローカル）:

1. Android emulator / iOS simulator / 実機 を起動
2. 実行:

```bash
# 端末・エミュレータが起動した状態で
flutter test integration_test
```

環境依存の設定（API モックやフラグの切替）は `--dart-define` や `Provider` の override を使って行ってください。

---

## 5. カバレッジ測定

基本コマンド:

```bash
flutter test --coverage
# 出力は coverage/lcov.info
# lcov を HTML に変換する場合（lcov, genhtml が必要）
genhtml coverage/lcov.info -o coverage/html
```

CI では HTML 生成の代わりに lcov ファイルをアーティファクトとして保存し、カバレッジサービス（Codecov / Coveralls 等）に送るのが一般的です。

---

## 6. CI での実行方針（概念例）

- Unit/Widget: `flutter test` を PR の必須ジョブにする（比較的高速）。
- analyze: `flutter analyze` を必須に。
- codegen: `flutter pub run build_runner build --delete-conflicting-outputs` を分離ジョブで実行（freezed 等を使用する場合）。
- Integration: 別ジョブでエミュレータを起動して `flutter test integration_test` を実行。

簡単な GitHub Actions のジョブ例（概念）:

```yaml
name: CI
on: [push, pull_request]
jobs:
  analyze:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with: {flutter-version: 'stable'}
      - run: flutter pub get
      - run: flutter analyze

  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test --coverage
```

Integration ジョブはエミュレータ起動（`setup-android` 等のアクション）やデバイス接続が必要になるため別途設定します。

---

## 7. ベストプラクティスまとめ（このテンプレ向け）

1. `flutter_test` と `integration_test` を使い分ける。
2. モックは `mocktail` を推奨（コード生成を減らすため）。
3. Provider（Riverpod） 依存の注入はテスト内で `ProviderScope` / `ProviderContainer` を使って override する。
4. CI に `analyze` と `flutter test` を必須ジョブとして追加する。
5. Integration テストは実機/エミュレータ上で実行し、PR の毎回実行は負荷が高いためリリース前や nightly ジョブで実行することを検討する。

---

必要であれば、このドキュメントに合わせて `pubspec.yaml` の dev_dependencies を編集する patch や、簡易 GitHub Actions ワークフローのテンプレートを作成します。どれを先に自動追加しますか？
