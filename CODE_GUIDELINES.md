# コーディング規約 / セキュリティ & 運用ガイド

このドキュメントは Flutter B2B テンプレートプロジェクト向けのコーディング規約と運用ベストプラクティスの要約です。

**前提**: Dart 3.x / Flutter 3.x、hooks_riverpod、dio、freezed、json_serializable、go_router、flutter_lints 使用。

## 目次

1. [目的と範囲](#1-目的と範囲)
2. [コードスタイルと静的解析](#2-コードスタイルと静的解析)
3. [アーキテクチャと状態管理](#3-アーキテクチャと状態管理riverpod)
4. [ネットワーク / API](#4-ネットワーク--apidio)
5. [認証・トークン管理](#5-認証トークン管理)
6. [センシティブデータ](#6-センシティブデータの扱い)
7. [ロギング](#7-ロギングと可観測性)
8. [アクセシビリティ](#8-アクセシビリティb2b必須)
9. [テスト戦略](#9-テスト戦略)
10. [依存関係とコード生成](#10-依存関係とコード生成)
11. [CI / パイプライン](#11-ci--パイプライン)
12. [開発ワークフロー](#12-開発ワークフロー)
13. [推奨パッケージ](#13-推奨パッケージ)

---

## 1. 目的と範囲

B2B アプリケーションで必要とされる **セキュリティ、可観測性、保守性** を満たすための実践的ガイドラインです。

## 2. コードスタイルと静的解析

### PR前の必須チェック

```bash
flutter format .
flutter pub get
flutter analyze
dart run custom_lint
```

### 命名規則

- **クラス名**: UpperCamelCase
- **変数/関数**: lowerCamelCase
- **非公開**: 先頭に `_`

### 禁止事項

- `dynamic` の乱用（型を明示）
- `ignore_for_file` の常用（生成コードやレビュー合意済みの最小限の例外のみ可）
- `print()` の使用（logger 使用）

## 3. アーキテクチャと状態管理（Riverpod）

### 基本原則

- **UI 層**: `HookConsumerWidget` を使用
- **ビジネスロジック**: Provider 層に分離
- **1 Provider = 1 責務**
- **非同期**: `AsyncValue` / `AsyncNotifier` 使用

### 実装例

#### 基本的な FutureProvider

```dart
final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => HttpCustomerRepository(ref.read),
);

final customersProvider = FutureProvider.autoDispose<List<Customer>>((ref) async {
  final repo = ref.read(customerRepositoryProvider);
  return repo.fetchCustomers();
});
```

#### React Query 風の AsyncNotifier（推奨）

**onSuccess/onError コールバック、キャッシュ無効化、Optimistic Update** などが必要な場合は AsyncNotifier を使用:

```dart
final revenueTrendProvider =
    AsyncNotifierProvider<RevenueTrendNotifier, List<RevenuePoint>>(() {
  return RevenueTrendNotifier();
});

class RevenueTrendNotifier extends AsyncNotifier<List<RevenuePoint>> {
  @override
  Future<List<RevenuePoint>> build() async {
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.fetchRevenueTrend();
  }

  Future<void> refresh({
    void Function(List<RevenuePoint>)? onSuccess,
    void Function(Object, StackTrace)? onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(dashboardRepositoryProvider);
      return repository.fetchRevenueTrend();
    });

    state.when(
      data: (data) => onSuccess?.call(data),
      error: (error, stack) => onError?.call(error, stack),
      loading: () {},
    );
  }
}
```

**詳細**: [ASYNC_NOTIFIER_GUIDE.md](ASYNC_NOTIFIER_GUIDE.md) 参照

### 注意点

- Provider の破棄順序に注意
- `autoDispose` の過度な使用を避ける
- 重要なキャッシュは明示的に管理
- Mutation（POST/PUT/DELETE）後は `ref.invalidate()` でキャッシュ無効化

## 4. ネットワーク / API（Dio）

### 必須インターセプタ

1. **AuthInterceptor**: Authorization ヘッダ付与、401時の自動リフレッシュ
2. **RetryInterceptor**: 指数バックオフでリトライ（dio_smart_retry 使用）
3. **ErrorMappingInterceptor**: HTTPエラーを共通Error型に変換
4. **ConditionalLogInterceptor**: 環境別ログ出力

### タイムアウト設定

- **接続タイムアウト**: 10秒
- **受信タイムアウト**: 10秒
- 設定ファイルから変更可能にする（ハードコード禁止）

### リトライ設定（dio_smart_retry）

**インストール済み**: `dio_smart_retry ^6.0.0`

**設定例** ([dio_client.dart](lib/src/core/networking/dio_client.dart) 参照):
```dart
dio.interceptors.add(
  RetryInterceptor(
    dio: dio,
    logPrint: (msg) => logger.d('Retry: $msg'),
    retries: 3,
    retryDelays: const [
      Duration(milliseconds: 500),  // 1回目
      Duration(milliseconds: 1000), // 2回目
      Duration(milliseconds: 2000), // 3回目
    ],
  ),
);
```

**推奨値**:
- retries: 3
- retryDelays: 500ms → 1000ms → 2000ms（指数バックオフ）

## 5. 認証・トークン管理

### 必須ルール

- トークンは `flutter_secure_storage` に保存
- `AuthRepository` で一元管理
- ソース管理に認証情報をコミット禁止
- 認証バイパス実装絶対禁止

### AuthRepository インタフェース

```dart
abstract class AuthRepository {
  Future<String?> getAccessToken();
  Future<String?> getRefreshToken();
  Future<void> persistTokens({
    required String accessToken,
    required String refreshToken,
  });
  Future<bool> refreshToken(); // true: 成功
  Future<void> clearTokens();
}
```

### AuthInterceptor 実装要点

- **排他制御**: refresh 処理をミューテックスで保護
- **待機キュー**: 更新中のリクエストをキューで管理
- **再送処理**: refresh 成功後に元のリクエストを再送
- **タイムアウト**: 最大待機時間を設定

## 6. センシティブデータの扱い

### 定義

PII（個人識別情報）、クレジットカード情報、認証情報、医療情報など。

### 保管方針

- **暗号化ストレージ**: `flutter_secure_storage` 使用
- **最小保存**: サーバー側保存を優先
- **明確な定義**: チームで合意してドキュメント化

### 通信

- **HTTPS/TLS 必須**
- 証明書ピンニング検討（高セキュリティ要件時）
- 送信前に不要フィールド削除

### ログ

- センシティブフィールドはマスク（例: `e***@d***`）
- ログ出力前に必ずマスク処理

## 7. ロギングと可観測性

### 推奨方針

- **構造化ログ**: JSON形式
- **環境別**: dev（詳細）、prod（WARN/ERROR のみ）
- **外部SDK**: Sentry / Datadog 等と連携

### AppLogger 実装例

```dart
class AppLogger {
  final Set<String> _sensitiveKeys = {
    'password',
    'token',
    'accessToken',
    'refreshToken',
  };

  String _mask(Map<String, Object?> data) {
    final copy = Map.of(data);
    for (final k in _sensitiveKeys) {
      if (copy.containsKey(k)) copy[k] = '******';
    }
    return jsonEncode(copy);
  }

  void info(String message, [Map<String, Object?>? data]) {
    final output = data == null ? message : '$message | ${_mask(data)}';
    // debugPrint または外部SDK
  }
}
```

## 8. アクセシビリティ（B2B必須）

### 基本要件（WCAG 2.1 AA準拠）

- **IconButton**: すべて `tooltip` 必須
- **Image**: `Semantics.label` 必須（装飾画像は `excludeSemantics: true`）
- **タッチサイズ**: 最小 48x48dp
- **色コントラスト**: 4.5:1 以上
- **フォーム**: `TextField` の `labelText` 必須
- **エラー通知**: `Semantics(liveRegion: true)` で即座に読み上げ

### 実装例

```dart
// ボタン
IconButton(
  icon: Icon(Icons.delete),
  tooltip: '削除',  // 必須
  onPressed: () {},
)

// 画像
Semantics(
  label: 'ABC株式会社のロゴ',
  child: Image.asset('logo.png'),
)

// エラー
Semantics(
  liveRegion: true,
  child: Text('エラー: 保存に失敗しました'),
)
```

### 検証方法

**実機テスト必須**:
- iOS: VoiceOver ON
- Android: TalkBack ON

## 9. テスト戦略

### 優先順位

1. **Unit Test**: ビジネスロジック（必須、カバレッジ目標 100%）
2. **Widget Test**: UI 状態・イベント（推奨）
3. **Integration Test**: 主要フロー（Nightly で実行）

### モック

- **mocktail** 推奨（コード生成不要）

### Provider テスト

```dart
// Provider override
await tester.pumpWidget(
  ProviderScope(
    overrides: [
      customerRepositoryProvider.overrideWithValue(MockRepository()),
    ],
    child: const MyApp(),
  ),
);
```

### CI 要件

- `flutter test --coverage` 必須
- カバレッジ最低ライン設定（例: 60%）

## 10. 依存関係とコード生成

### build_runner

- **CI で生成** または **生成物コミット** をチームでルール化
- B2B 運用では CI 生成推奨

### 定期更新

```bash
flutter pub outdated
flutter pub upgrade --major-versions
```

互換性テスト実施後にアップデート。

## 11. CI / パイプライン

### PR 必須チェック

1. `flutter analyze`（0エラー）
2. `flutter test --coverage`（全パス）
3. `dart run custom_lint`（0エラー）
4. `build_runner`（必要時）

### Integration Test

Nightly / Release ブランチで実行（負荷が高いため）

## 12. 開発ワークフロー

### Commit メッセージ

**Conventional Commits** 推奨:
```
feat: add user profile screen
fix: resolve null pointer in login
refactor: extract auth logic to repository
test: add unit tests for user service
```

### PR ポリシー

- **最低 1 レビュワー** 必須
- **CI 成功** 必須
- **main ブランチ**: 常にデプロイ可能に保つ
- **ブランチ**: `feature/*`, `fix/*` を使用

### PR マージ前チェックリスト

- [ ] `flutter format .` 実行済み
- [ ] `flutter analyze` 0エラー
- [ ] Unit/Widget tests 全パス
- [ ] `build_runner` 実行済み（必要時）
- [ ] 認証情報ハードコードなし
- [ ] ログに PII 出力なし

## 13. 推奨パッケージ

### インストール済み

- ✅ **dio_smart_retry ^6.0.0**: HTTP リトライ・指数バックオフ（[設定済み](lib/src/core/networking/dio_client.dart)）
- ✅ **hooks_riverpod ^2.5.1**: 状態管理
- ✅ **dio ^5.6.0**: HTTP クライアント
- ✅ **freezed ^2.5.2**: イミュータブルモデル
- ✅ **go_router ^14.2.1**: ルーティング
- ✅ **logger ^2.4.0**: ロギング

### 必要に応じて追加

- **flutter_secure_storage**: 機密情報の安全な保存（認証実装時）
- **sentry_flutter**: エラー収集・レポート（PII マスク必須）

---

## 付録: サンプル実装

### AuthInterceptor 擬似コード

```dart
class PendingRequest {
  PendingRequest(this.options, this.handler);
  final RequestOptions options;
  final ErrorInterceptorHandler handler;
}

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.authRepo, required this.dio});

  final AuthRepository authRepo;
  final Dio dio;
  bool _isRefreshing = false;
  final _queue = <PendingRequest>[];

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await authRepo.getAccessToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      handler.next(err);
      return;
    }

    _queue.add(PendingRequest(err.requestOptions, handler));
    if (_isRefreshing) return;

    _isRefreshing = true;
    try {
      final refreshed = await authRepo
          .refreshToken()
          .timeout(const Duration(seconds: 10));

      for (final pending in _queue) {
        if (refreshed) {
          final token = await authRepo.getAccessToken();
          if (token != null) {
            pending.options.headers['Authorization'] = 'Bearer $token';
          }
          pending.handler.resolve(await dio.fetch(pending.options));
        } else {
          pending.handler.reject(err);
        }
      }
    } finally {
      _queue.clear();
      _isRefreshing = false;
    }
  }
}
```

**注意**: 実装では mutex/semaphore、タイムアウト、最大待機時間設定を追加すること。

---

このドキュメントはプロジェクトの実情に合わせて随時更新してください。
