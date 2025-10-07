# Authorization.md - 認証・認可設計書

## 📋 概要

本ドキュメントは、Flutter B2Bアプリケーションにおける認証・認可の実装ガイドラインを定義します。

## 🎯 要件定義

### ビジネス要件
- **B2B向けエンタープライズ認証**: 企業ユーザーの安全なアクセス制御
- **マルチテナント対応**: 組織ごとの権限分離
- **シングルサインオン (SSO)**: 既存の企業IDプロバイダーとの連携
- **ロールベースアクセス制御 (RBAC)**: きめ細かい権限管理

### 技術要件
- OAuth 2.0 / OpenID Connect準拠
- トークンベース認証 (JWT)
- リフレッシュトークンによる自動再認証
- セキュアなトークン保存 (暗号化)
- オフライン時の認証状態維持

## 🏗️ アーキテクチャ設計

### 認証フロー

```
┌─────────────┐      ┌──────────────┐      ┌─────────────┐
│   Flutter   │─────▶│ Auth Provider│─────▶│  Backend    │
│     App     │◀─────│ (Azure AD/   │◀─────│     API     │
└─────────────┘      │  Auth0, etc) │      └─────────────┘
                     └──────────────┘
```

### 推奨認証プロバイダー

#### 1. **Azure AD B2C** (Microsoft企業向け)
- **パッケージ**: `msal_flutter` or `aad_oauth`
- **利点**: Office 365統合、エンタープライズ実績
- **用途**: Microsoft環境の企業向け

#### 2. **Auth0** (マルチクラウド)
- **パッケージ**: `auth0_flutter`
- **利点**: 柔軟な統合、豊富なIDプロバイダー対応
- **用途**: 複数IDプロバイダー統合が必要な場合

#### 3. **Firebase Authentication** (Google)
- **パッケージ**: `firebase_auth`
- **利点**: 簡易実装、Firebaseエコシステム連携
- **用途**: スタートアップ、Firebaseバックエンド利用時

## 📦 必須パッケージ

```yaml
dependencies:
  # 認証プロバイダー (いずれか選択)
  msal_flutter: ^3.0.0              # Azure AD B2C
  # auth0_flutter: ^1.5.0           # Auth0
  # firebase_auth: ^4.15.0          # Firebase

  # セキュアストレージ
  flutter_secure_storage: ^9.0.0    # トークン暗号化保存

  # JWT解析
  dart_jsonwebtoken: ^2.12.0        # トークン検証

  # 状態管理 (既存)
  hooks_riverpod: ^2.5.1
```

## 🔐 実装設計

### 1. ディレクトリ構造

```
lib/src/features/auth/
├── data/
│   ├── auth_repository.dart          # 認証ロジック
│   ├── token_storage.dart            # トークン保存
│   └── models/
│       ├── auth_user.dart            # ユーザーモデル
│       └── auth_token.dart           # トークンモデル
├── domain/
│   └── auth_service.dart             # ビジネスロジック
└── presentation/
    ├── providers/
    │   └── auth_providers.dart       # Riverpod Providers
    ├── login_screen.dart             # ログイン画面
    └── splash_screen.dart            # 初期認証確認
```

### 2. 認証状態管理 (Riverpod)

```dart
// auth_providers.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// セキュアストレージProvider
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );
});

// 認証リポジトリProvider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final storage = ref.watch(secureStorageProvider);
  // 選択したプロバイダーに応じて実装
  return AuthRepository(storage: storage);
});

// 認証状態Provider (Stream)
final authStateProvider = StreamProvider<AuthUser?>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.authStateChanges();
});

// 現在のユーザーProvider
final currentUserProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    data: (user) => user,
    orElse: () => null,
  );
});
```

### 3. 認証リポジトリ実装例 (Azure AD)

```dart
// auth_repository.dart
import 'package:msal_flutter/msal_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  AuthRepository({required this.storage});

  final FlutterSecureStorage storage;
  late final PublicClientApplication _pca;

  static const String _clientId = 'YOUR_AZURE_CLIENT_ID';
  static const String _authority =
      'https://login.microsoftonline.com/YOUR_TENANT_ID';
  static const List<String> _scopes = ['User.Read', 'openid', 'profile'];

  Future<void> initialize() async {
    _pca = await PublicClientApplication.createPublicClientApplication(
      _clientId,
      authority: _authority,
    );
  }

  // ログイン
  Future<AuthUser> signIn() async {
    try {
      final result = await _pca.acquireToken(_scopes);
      final accessToken = result?.accessToken;
      final idToken = result?.idToken;

      if (accessToken == null || idToken == null) {
        throw AuthException('Failed to acquire tokens');
      }

      // トークンをセキュアに保存
      await storage.write(key: 'access_token', value: accessToken);
      await storage.write(key: 'id_token', value: idToken);

      // ユーザー情報を解析
      final user = _parseUserFromToken(idToken);
      return user;
    } catch (e) {
      throw AuthException('Sign in failed: $e');
    }
  }

  // サイレント認証 (リフレッシュ)
  Future<String?> getAccessToken() async {
    try {
      // キャッシュからトークン取得を試行
      final result = await _pca.acquireTokenSilent(_scopes);
      final token = result?.accessToken;

      if (token != null) {
        await storage.write(key: 'access_token', value: token);
      }
      return token;
    } catch (e) {
      // サイレント取得失敗時は再ログイン必要
      return null;
    }
  }

  // ログアウト
  Future<void> signOut() async {
    await _pca.signOut();
    await storage.deleteAll();
  }

  // 認証状態Stream
  Stream<AuthUser?> authStateChanges() async* {
    // 初回: ストレージからトークン確認
    final idToken = await storage.read(key: 'id_token');
    if (idToken != null) {
      yield _parseUserFromToken(idToken);
    } else {
      yield null;
    }

    // 以降: 定期的にトークン更新チェック
    await for (final _ in Stream.periodic(const Duration(minutes: 5))) {
      final token = await getAccessToken();
      if (token != null) {
        final newIdToken = await storage.read(key: 'id_token');
        yield newIdToken != null ? _parseUserFromToken(newIdToken) : null;
      } else {
        yield null;
      }
    }
  }

  AuthUser _parseUserFromToken(String idToken) {
    // JWT解析してユーザー情報抽出
    // dart_jsonwebtoken使用
    return AuthUser(/* ... */);
  }
}

class AuthException implements Exception {
  AuthException(this.message);
  final String message;
}
```

### 4. ルーター統合 (go_router)

```dart
// app_router.dart
final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: DashboardRoute.path,
    redirect: (context, state) {
      final isLoggedIn = authState.maybeWhen(
        data: (user) => user != null,
        orElse: () => false,
      );

      final isLoggingIn = state.matchedLocation == LoginRoute.path;

      // 未認証時はログイン画面へ
      if (!isLoggedIn && !isLoggingIn) {
        return LoginRoute.path;
      }

      // 認証済みでログイン画面にいる場合はダッシュボードへ
      if (isLoggedIn && isLoggingIn) {
        return DashboardRoute.path;
      }

      return null; // リダイレクト不要
    },
    routes: [
      GoRoute(
        path: LoginRoute.path,
        name: LoginRoute.name,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          // 認証済みルート
          GoRoute(
            path: DashboardRoute.path,
            name: DashboardRoute.name,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: DashboardScreen(),
            ),
          ),
          // ...他のルート
        ],
      ),
    ],
  );
});

class LoginRoute {
  static const name = 'login';
  static const path = '/login';
}
```

### 5. API通信の認証ヘッダー追加

```dart
// dio_client.dart
final dioProvider = Provider<Dio>((ref) {
  final config = ref.watch(appConfigProvider);
  final authRepository = ref.watch(authRepositoryProvider);

  final dio = Dio(BaseOptions(
    baseUrl: config.apiBaseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // 認証Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // アクセストークン取得
        final token = await authRepository.getAccessToken();

        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }

        handler.next(options);
      },
      onError: (error, handler) async {
        // 401エラー時の再認証
        if (error.response?.statusCode == 401) {
          final newToken = await authRepository.getAccessToken();

          if (newToken != null) {
            // リトライ
            final options = error.requestOptions;
            options.headers['Authorization'] = 'Bearer $newToken';

            final response = await dio.fetch(options);
            handler.resolve(response);
            return;
          }
        }

        handler.next(error);
      },
    ),
  );

  return dio;
});
```

## 🔒 セキュリティベストプラクティス

### 1. トークン保存
- ✅ `flutter_secure_storage`で暗号化保存
- ❌ `shared_preferences`は使用禁止 (平文保存)
- ✅ iOS: Keychain、Android: EncryptedSharedPreferences

### 2. トークン管理
- ✅ アクセストークン有効期限: 1時間以内
- ✅ リフレッシュトークン: 自動更新実装
- ✅ トークン失効時の再ログイン

### 3. 通信セキュリティ
- ✅ HTTPS強制 (証明書ピニング推奨)
- ✅ PKCE (Proof Key for Code Exchange) 有効化
- ✅ State parameter でCSRF対策

### 4. ログアウト
- ✅ ローカルトークン削除
- ✅ サーバー側セッション無効化
- ✅ セキュアストレージ完全クリア

## 🧪 テスト戦略

### Unit Tests
```dart
// auth_repository_test.dart
void main() {
  late AuthRepository repository;
  late MockSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockSecureStorage();
    repository = AuthRepository(storage: mockStorage);
  });

  group('AuthRepository', () {
    test('signIn stores tokens securely', () async {
      // テスト実装
    });

    test('getAccessToken refreshes expired tokens', () async {
      // テスト実装
    });

    test('signOut clears all stored data', () async {
      // テスト実装
    });
  });
}
```

### Integration Tests
- ログインフロー完全テスト
- トークン更新フローテスト
- エラーハンドリングテスト

## 📊 ロールベースアクセス制御 (RBAC)

### 権限モデル

```dart
enum UserRole {
  admin,       // 全権限
  manager,     // 部門管理権限
  user,        // 基本権限
  viewer,      // 閲覧のみ
}

class AuthUser {
  const AuthUser({
    required this.id,
    required this.email,
    required this.displayName,
    required this.roles,
    this.tenantId,
  });

  final String id;
  final String email;
  final String displayName;
  final List<UserRole> roles;
  final String? tenantId;

  bool hasRole(UserRole role) => roles.contains(role);
  bool hasAnyRole(List<UserRole> roles) =>
      roles.any((role) => this.roles.contains(role));
}
```

### 権限チェックWidget

```dart
class RoleGuard extends ConsumerWidget {
  const RoleGuard({
    required this.requiredRoles,
    required this.child,
    this.fallback,
    super.key,
  });

  final List<UserRole> requiredRoles;
  final Widget child;
  final Widget? fallback;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    if (user == null || !user.hasAnyRole(requiredRoles)) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}

// 使用例
RoleGuard(
  requiredRoles: [UserRole.admin, UserRole.manager],
  child: ElevatedButton(
    onPressed: () => context.go(AdminRoute.path),
    child: const Text('管理画面'),
  ),
  fallback: const Text('権限がありません'),
)
```

## 🚀 実装ロードマップ

### Phase 1: 基本認証 (必須)
1. ✅ 認証プロバイダー選定
2. ✅ パッケージ導入
3. ✅ AuthRepository実装
4. ✅ Riverpod状態管理統合
5. ✅ ログイン/ログアウト画面

### Phase 2: セキュリティ強化
1. ✅ トークン暗号化保存
2. ✅ 自動リフレッシュ実装
3. ✅ エラーハンドリング
4. ✅ 証明書ピニング

### Phase 3: 高度な機能
1. ✅ RBAC実装
2. ✅ マルチテナント対応
3. ✅ 生体認証 (指紋/Face ID)
4. ✅ 監査ログ

## 📚 参考リソース

### 公式ドキュメント
- [Azure AD B2C Flutter](https://learn.microsoft.com/azure/active-directory-b2c/)
- [Auth0 Flutter SDK](https://auth0.com/docs/quickstart/native/flutter)
- [Firebase Auth Flutter](https://firebase.google.com/docs/auth/flutter/start)

### ベストプラクティス
- [OAuth 2.0 for Mobile Apps (RFC 8252)](https://datatracker.ietf.org/doc/html/rfc8252)
- [OWASP Mobile Security](https://owasp.org/www-project-mobile-security/)

---

**最終更新**: 2025-10-05
**レビュー者**: AI Assistant
**承認**: 未承認 (実装前ドキュメント)
