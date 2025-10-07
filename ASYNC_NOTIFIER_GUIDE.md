# AsyncNotifier 実装ガイド（React Query 風 API 状態管理）

## 概要

このプロジェクトでは **dio_smart_retry** を導入し、React Query 相当の API 状態管理を **手動 AsyncNotifier** で実装します。

**インストール済み:**
- ✅ `dio_smart_retry ^6.0.0` - リトライ・指数バックオフ
- ✅ `hooks_riverpod ^2.5.1` - 状態管理

**見送り:**
- ❌ `riverpod_annotation` - analyzer_plugin 互換性問題のため削除

---

## 実装パターン

### 1. 基本的な AsyncNotifier（Query）

```dart
// lib/src/features/dashboard/data/dashboard_providers_v2.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_repository.dart';
import 'models/dashboard_models.dart';

// Provider定義
final revenueTrendProvider =
    AsyncNotifierProvider<RevenueTrendNotifier, List<RevenuePoint>>(() {
  return RevenueTrendNotifier();
});

// AsyncNotifier実装
class RevenueTrendNotifier extends AsyncNotifier<List<RevenuePoint>> {
  @override
  Future<List<RevenuePoint>> build() async {
    final repository = ref.watch(dashboardRepositoryProvider);
    return repository.fetchRevenueTrend();
  }

  /// refetch() - React Query の refetch 相当
  Future<void> refresh({
    void Function(List<RevenuePoint>)? onSuccess,
    void Function(Object, StackTrace)? onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(dashboardRepositoryProvider);
      return repository.fetchRevenueTrend();
    });

    // onSuccess/onError コールバック
    state.when(
      data: (data) => onSuccess?.call(data),
      error: (error, stack) => onError?.call(error, stack),
      loading: () {},
    );
  }

  /// パラメータ付きフェッチ
  Future<void> loadFrom(
    DateTime from, {
    void Function(List<RevenuePoint>)? onSuccess,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(dashboardRepositoryProvider);
      return repository.fetchRevenueTrend(from: from);
    });

    state.whenData((data) => onSuccess?.call(data));
  }
}
```

### 2. Mutation パターン（POST/PUT/DELETE）

```dart
// Provider定義
final customerMutationProvider =
    AsyncNotifierProvider<CustomerMutationNotifier, Customer?>(() {
  return CustomerMutationNotifier();
});

class CustomerMutationNotifier extends AsyncNotifier<Customer?> {
  @override
  Future<Customer?> build() async {
    return null; // mutation は初期状態 null
  }

  /// Create customer - React Query の useMutation 相当
  Future<void> createCustomer(
    Customer customer, {
    void Function(Customer)? onSuccess,
    void Function(Object)? onError,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(customerRepositoryProvider);
      final created = await repository.createCustomer(customer);

      // キャッシュ無効化（invalidateQueries 相当）
      ref.invalidate(customerListProvider);

      return created;
    });

    state.when(
      data: (data) {
        if (data != null) onSuccess?.call(data);
      },
      error: (error, stack) => onError?.call(error),
      loading: () {},
    );
  }

  /// Update customer
  Future<void> updateCustomer(
    String id,
    Customer customer, {
    void Function(Customer)? onSuccess,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final repository = ref.read(customerRepositoryProvider);
      final updated = await repository.updateCustomer(id, customer);

      // 関連キャッシュ無効化
      ref.invalidate(customerListProvider);
      ref.invalidate(customerDetailProvider(id));

      return updated;
    });

    state.whenData((data) {
      if (data != null) onSuccess?.call(data);
    });
  }
}
```

### 3. Optimistic Update パターン

```dart
final todoListProvider =
    AsyncNotifierProvider<TodoListNotifier, List<Todo>>(() {
  return TodoListNotifier();
});

class TodoListNotifier extends AsyncNotifier<List<Todo>> {
  @override
  Future<List<Todo>> build() async {
    final repository = ref.watch(todoRepositoryProvider);
    return repository.fetchTodos();
  }

  /// Optimistic update with rollback
  Future<void> toggleTodo(
    String id,
    bool completed, {
    void Function()? onSuccess,
    void Function()? onError,
  }) async {
    // 現在の状態を保存（ロールバック用）
    final previousState = state;

    // Optimistic update（楽観的更新）
    state = state.whenData((todos) {
      return todos.map((todo) {
        if (todo.id == id) {
          return todo.copyWith(completed: completed);
        }
        return todo;
      }).toList();
    });

    // サーバー同期
    final result = await AsyncValue.guard(() async {
      final repository = ref.read(todoRepositoryProvider);
      return repository.toggleTodo(id, completed);
    });

    // エラー時はロールバック
    result.when(
      data: (_) => onSuccess?.call(),
      error: (error, stack) {
        state = previousState;  // ロールバック
        onError?.call();
      },
      loading: () {},
    );
  }
}
```

---

## UI での利用例

### 基本的な表示

```dart
class DashboardScreen extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revenueTrendAsync = ref.watch(revenueTrendProvider);

    return Scaffold(
      body: revenueTrendAsync.when(
        data: (data) => RevenueChart(data: data),
        loading: () => CircularProgressIndicator(),
        error: (error, stack) => ErrorWidget(error),
      ),
    );
  }
}
```

### refetch with callbacks

```dart
FloatingActionButton(
  onPressed: () {
    ref.read(revenueTrendProvider.notifier).refresh(
      onSuccess: (data) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Refreshed: ${data.length} points')),
        );
      },
      onError: (error, stack) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      },
    );
  },
  child: Icon(Icons.refresh),
)
```

### Mutation の実行

```dart
ElevatedButton(
  onPressed: () {
    final customer = Customer(
      id: uuid.v4(),
      companyName: 'New Company',
      contactName: 'John Doe',
      email: 'john@example.com',
    );

    ref.read(customerMutationProvider.notifier).createCustomer(
      customer,
      onSuccess: (created) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Created: ${created.companyName}')),
        );
      },
      onError: (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $error')),
        );
      },
    );
  },
  child: Text('Create'),
)
```

---

## dio_smart_retry 設定

[dio_client.dart:22-33](lib/src/core/networking/dio_client.dart) に設定済み:

```dart
dio.interceptors.add(
  RetryInterceptor(
    dio: dio,
    logPrint: (msg) => logger.d('Retry: $msg'),
    retries: 3,
    retryDelays: const [
      Duration(milliseconds: 500),  // 1回目: 500ms
      Duration(milliseconds: 1000), // 2回目: 1000ms
      Duration(milliseconds: 2000), // 3回目: 2000ms
    ],
  ),
);
```

---

## React Query との機能比較

| React Query                  | 手動 AsyncNotifier                  | 実装状況 |
|------------------------------|-------------------------------------|---------|
| `useQuery()`                 | `AsyncNotifierProvider`             | ✅       |
| `data`, `isLoading`, `error` | `AsyncValue.when()`                 | ✅       |
| `refetch()`                  | `.notifier.refresh()`               | ✅       |
| `onSuccess`, `onError`       | コールバック引数で実装                  | ✅       |
| `invalidateQueries()`        | `ref.invalidate()`                  | ✅       |
| Optimistic Update            | state 保存 + ロールバック               | ✅       |
| `retry`                      | dio_smart_retry で実装                | ✅       |
| `staleTime`, `cacheTime`     | Riverpod の autoDispose で制御        | ⚠️ 手動  |

---

## まとめ

- **dio_smart_retry**: ✅ インストール・設定完了
- **AsyncNotifier**: 手動実装で React Query 並みの API 状態管理を実現
- **riverpod_annotation**: 見送り（互換性問題）

この実装パターンで、2025年の B2B プロジェクトに必要な API 状態管理は十分カバーできます。
