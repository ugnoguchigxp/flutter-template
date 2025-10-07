# CLAUDE.md - AI向けコーディング規約

AI（Claude）がコード生成・修正時に従う最小限のルール。

## 🎯 基本原則

**DRY (Don't Repeat Yourself)**: 同じコードを2回書かない。3回出現したら即リファクタリング。共通処理は関数・クラス・Providerに抽出。

**KISS (Keep It Simple, Stupid)**: シンプルな解決策を優先。過度な抽象化禁止。読みやすさ > 賢さ。

**YAGNI (You Aren't Gonna Need It)**: 将来必要"かもしれない"機能は実装しない。現在の要件のみ実装。

**Single Responsibility**: 1クラス = 1責務、1関数 = 1目的。600行超過ファイルは分割。

## 📦 Flutter/Dart

**型安全性**: dynamic禁止。型を明示、unknownまたは適切な型使用。

**Null Safety**: !!（forceUnwrap）禁止。?? 演算子活用。

**Immutability**: final/const優先。状態は必要最小限。

**Async/Await**: 未awaitのFuture禁止。unawaited()で明示的にマーク。

**Widget Key**: すべてのStatelessWidget/StatefulWidgetに{super.key}追加。

## 🏗️ アーキテクチャ（Riverpod）

**Provider設計**: 単一責任。1Provider = 1データソース/ビジネスロジック。

**依存関係**: ref.watchで明示。循環依存禁止。

**AsyncNotifier**: onSuccess/onErrorコールバック、キャッシュ無効化が必要な場合はAsyncNotifierProvider使用（FutureProviderより高機能）。

**Mutation後の処理**: POST/PUT/DELETE後は必ずref.invalidate()でキャッシュ無効化。

**Widget分割**: 200行超過Widget禁止。責務ごとに分割。

**Widget選択**: Container過剰使用禁止。ColoredBox/SizedBox/Padding使い分け。

## ♿ アクセシビリティ（必須）

**IconButton**: すべてtooltip必須。

**Image**: 意味のある画像はSemantics.label必須。装飾画像はexcludeSemantics: true。

**タッチサイズ**: 最小48x48dp確保。IconButtonのpadding調整。

**エラー通知**: Semantics(liveRegion: true)で即座に読み上げ。

**フォーム**: TextFieldのlabelText必須。

## 🔒 セキュリティ

**機密情報**: ハードコード禁止。String.fromEnvironment使用。

**ログ**: トークン・パスワードをログ出力禁止。マスク必須。

**認証**: 認証バイパス実装絶対禁止（isDev && return trueなど）。

## 📝 スタイル

**クォート**: シングルクォート必須。

**トレーリングカンマ**: 複数行の最後の引数に必須。

**インポート順序**: dart → package → relative。

**フォーマット**: flutter format . 実行必須。

## ❌ 絶対禁止

- dynamic乱用
- ignore_for_file使用
- print()使用（logger使用）
- 認証バイパス
- 機密情報ハードコード
- 3階層以上のif/forネスト
- 600行超過ファイル
- useRef/useEffectの無限ループ

## 🧪 テスト

**優先順位**: 1. Unit（必須） 2. Widget（推奨） 3. Integration（主要機能のみ）

**モック**: mocktail推奨（コード生成不要）

**カバレッジ**: ビジネスロジック100%目標

## 🔄 エラーハンドリング

**AsyncValue**: Riverpod非同期処理で使用。when()で全状態処理（data/loading/error）

**try-catch**: 具体的な例外型でキャッチ（DioException等）

**ユーザー向けメッセージ**: i18n対応必須

## 📊 パフォーマンス

**const**: 可能な限り使用（Text/SizedBox/Icon等）

**ListView**: 大量データはListView.builder必須。Column + map禁止。

**Provider select**: 部分watch時はselect使用。

**再ビルド**: 不要なsetState/ref.watch回避。

## 🚀 PR前チェック

1. flutter format .
2. flutter analyze（0エラー）
3. dart run custom_lint（0エラー）
4. dart run build_runner build --delete-conflicting-outputs（Freezed使用時）
5. flutter test（全パス）

## 📚 コメントルール

**Why優先**: なぜこの実装か（What/Howは不要）

**TODO**: 具体的に記述。TODO(name): 説明

**複雑ロジック**: ビジネスルールは必ずドキュメント化

## ✅ AI生成時チェックリスト

- DRY: 重複なし
- KISS: シンプル
- 型安全: dynamic未使用
- Null Safety: !!未使用
- アクセシビリティ: tooltip/Semantics
- エラーハンドリング: try-catch or AsyncValue
- テスタビリティ: Provider依存注入可
- セキュリティ: 機密情報ハードコードなし
- スタイル: trailing comma, single quote
- Mutation: POST/PUT/DELETE後にref.invalidate()実装

**重要**: このルールに従わないコードは生成禁止。不明点はユーザー確認。

## 📦 インストール済みパッケージ

- dio_smart_retry ^6.0.0（リトライ設定済み: lib/src/core/networking/dio_client.dart）
- hooks_riverpod ^2.5.1
- freezed ^2.5.2
- go_router ^14.2.1
- logger ^2.4.0

**詳細**: [CODE_GUIDELINES.md](CODE_GUIDELINES.md), [ASYNC_NOTIFIER_GUIDE.md](ASYNC_NOTIFIER_GUIDE.md) 参照
