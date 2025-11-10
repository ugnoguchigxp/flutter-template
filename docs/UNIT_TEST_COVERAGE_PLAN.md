# Unitテストカバレッジ向上計画

## 📊 現状分析

### カバレッジサマリー（2025-11-09時点）

**全体カバレッジ: 77.5%** (330/426 lines)

- テスト済みファイル数: 16
- 全ソースファイル数: 86
- **未テストファイル数: 70**

### 既存テスト状況

#### ✅ 高カバレッジファイル (80%以上)

| カバレッジ | ファイル名 | 行数 | 状態 |
|-----------|-----------|------|------|
| 100.0% | app_config.dart | 4/4 | ✅ 完璧 |
| 100.0% | app_logger.dart | 3/3 | ✅ 完璧 |
| 100.0% | app_theme.dart | 32/32 | ✅ 完璧 |
| 100.0% | locale_provider.dart | 7/7 | ✅ 完璧 |
| 100.0% | customer_model.dart | 2/2 | ✅ 完璧 |
| 100.0% | customer_repository.dart | 16/16 | ✅ 完璧 |
| 100.0% | dashboard_models.dart | 6/6 | ✅ 完璧 |
| 100.0% | dashboard_providers.dart | 9/9 | ✅ 完璧 |
| 97.0% | logger_extensions.dart | 32/33 | ✅ 良好 |
| 83.3% | app_localizations.dart | 20/24 | ✅ 良好 |

#### ⚠️ 低カバレッジファイル (80%未満)

| カバレッジ | ファイル名 | 行数 | 改善余地 | 優先度 |
|-----------|-----------|------|---------|--------|
| 45.5% | dio_client.dart | 10/22 | 12行 | 🔴 高 |
| 52.5% | dashboard_repository.dart | 31/59 | 28行 | 🔴 高 |
| 58.9% | api_wrapper.dart | 53/90 | 37行 | 🔴 高 |
| 79.7% | api_error.dart | 55/69 | 14行 | 🟡 中 |

#### ❌ 未テストファイル（重要度別）

##### 🔴 優先度：高（ビジネスロジック・コアライブラリ）

**Domain層 - ゲーム機能:**
- `lib/src/features/game/domain/services/target_generator.dart` ✅ **テスト済み**
- `lib/src/features/game/utils/geometry_utils.dart` ❌ **未テスト**
- `lib/src/features/game/utils/constants.dart` ❌ **未テスト**

**Domain層 - オセロ機能:**
- `lib/src/features/othello/domain/models/board.dart` ❌ **未テスト**
- `lib/src/features/othello/domain/models/othello_game_state.dart` ❌ **未テスト**
- `lib/src/features/othello/domain/models/position.dart` ❌ **未テスト**
- `lib/src/features/othello/domain/services/othello_ai.dart` ❌ **未テスト**

**Domain層 - 反射神経テスト:**
- `lib/src/features/reflex_test/domain/models/falling_bar.dart` ❌ **未テスト**
- `lib/src/features/reflex_test/domain/models/game_result.dart` ❌ **未テスト**
- `lib/src/features/reflex_test/domain/models/reflex_game_state.dart` ❌ **未テスト**

**Domain層 - テトリス:**
- `lib/src/features/tetris/domain/models/tetris_game_state.dart` ❌ **未テスト**
- `lib/src/features/tetris/domain/models/tetromino.dart` ❌ **未テスト**

##### 🟡 優先度：中（プロバイダー・状態管理）

**プロバイダー層:**
- `lib/src/features/game/presentation/providers/game_provider.dart` ❌ **未テスト**
- `lib/src/features/othello/presentation/providers/othello_game_provider.dart` ❌ **未テスト**
- `lib/src/features/reflex_test/presentation/providers/reflex_game_provider.dart` ❌ **未テスト**
- `lib/src/features/tetris/presentation/providers/tetris_game_provider.dart` ❌ **未テスト**

##### 🟢 優先度：低（UI・ウィジェット）

**Presentation層（Widgetテストが適切）:**
- 各種Screen・Widget (現時点でUnitテスト不要)

---

## 🎯 テスト戦略

### 戦略的アプローチ

#### 1. **80/20の法則を適用**
- 20%の努力で80%の効果を得る
- ビジネスロジック・ドメイン層を最優先
- UIコンポーネントは最後

#### 2. **テストピラミッド**
```
        /\
       /UI\       ← 少数（Widget/Integration）
      /────\
     /Unit \     ← 多数（Unitテスト）
    /────────\
   /Foundation\  ← 最重要（ビジネスロジック）
```

#### 3. **段階的実施**

**Phase 1: 既存カバレッジの改善** (目標: 85%)
- 低カバレッジファイルの改善
- 最小工数で最大効果

**Phase 2: ドメイン層の完全カバレッジ** (目標: 90%)
- ゲームロジックのテスト
- AIアルゴリズムのテスト

**Phase 3: プロバイダー層のテスト** (目標: 95%)
- 状態管理のテスト
- Riverpod Providerのテスト

---

## 🛠️ 効率的なテスト手法

### 1. **Freezedモデルのテスト**

**手法**: copyWith・equalityテストのみ（コード生成なので軽量）

```dart
test('GameState copyWith updates fields', () {
  final initial = GameState.initial();
  final updated = initial.copyWith(score: 100);
  expect(updated.score, 100);
  expect(updated.player, initial.player); // 他フィールド維持確認
});

test('GameState equality works', () {
  final state1 = GameState.initial();
  final state2 = GameState.initial();
  expect(state1, equals(state2));
});
```

**所要時間**: 1ファイル5分

---

### 2. **ビジネスロジックのテスト（最重要）**

**手法**: 入力→出力の境界値テスト

```dart
// オセロAIの例
group('OthelloAI', () {
  test('空のボードでは中央4マスを選択', () {
    final board = Board.empty();
    final move = OthelloAI.getBestMove(board, Player.black);
    expect(move, isIn([Position(3,3), Position(3,4), Position(4,3), Position(4,4)]));
  });

  test('確実に勝てる手を選択', () {
    final board = Board.fromString('''
      WWWWWWWW
      WWWWWWWW
      WWWWWWWW
      WWWWBW_W
      ...
    ''');
    final move = OthelloAI.getBestMove(board, Player.black);
    expect(move, Position(3, 6)); // 確実勝利の手
  });
});
```

**所要時間**: 1ファイル30-60分

---

### 3. **リポジトリのテスト**

**手法**: モック不要、実際のDioインスタンス使用

```dart
test('fetchData returns stubbed data in dev mode', () async {
  final container = ProviderContainer(
    overrides: [
      appConfigProvider.overrideWithValue(AppConfig(apiMode: ApiMode.dev)),
    ],
  );

  final repository = container.read(myRepositoryProvider);
  final result = await repository.fetchData();

  expect(result, isNotEmpty);
  expect(result.first.id, isNotNull);
});
```

**所要時間**: 1ファイル20-40分

---

### 4. **プロバイダーのテスト**

**手法**: ProviderContainerでシンプルテスト

```dart
test('gameProvider initial state is correct', () {
  final container = ProviderContainer();
  final state = container.read(gameProvider);

  expect(state.score, 0);
  expect(state.isGameOver, false);
});

test('incrementScore updates state', () {
  final container = ProviderContainer();
  container.read(gameProvider.notifier).incrementScore(10);

  final state = container.read(gameProvider);
  expect(state.score, 10);
});
```

**所要時間**: 1ファイル15-30分

---

### 5. **ユーティリティ関数のテスト**

**手法**: 純粋関数なので最も簡単

```dart
group('GeometryUtils', () {
  test('distance calculates correctly', () {
    final p1 = Offset(0, 0);
    final p2 = Offset(3, 4);
    expect(GeometryUtils.distance(p1, p2), 5.0);
  });

  test('isPointInCircle works', () {
    final center = Offset(0, 0);
    final point = Offset(3, 4);
    expect(GeometryUtils.isPointInCircle(point, center, 10), true);
    expect(GeometryUtils.isPointInCircle(point, center, 3), false);
  });
});
```

**所要時間**: 1ファイル10-20分

---

## 📋 実施計画 Todo

### Phase 1: 既存カバレッジ改善（目標85%）

#### 🔴 優先度：最高

- [ ] **dio_client.dart** カバレッジ改善 (45.5% → 85%)
  - リトライロジックのテスト
  - エラーハンドリングのテスト
  - 所要時間: 40分

- [ ] **api_wrapper.dart** カバレッジ改善 (58.9% → 85%)
  - 各HTTPメソッドのエラーケース
  - Response/Request変換のテスト
  - 所要時間: 60分

- [ ] **dashboard_repository.dart** カバレッジ改善 (52.5% → 85%)
  - 全エンドポイントのテスト
  - データ変換ロジックのテスト
  - 所要時間: 50分

- [ ] **api_error.dart** カバレッジ改善 (79.7% → 90%)
  - 各種エラータイプのテスト
  - 所要時間: 20分

**Phase 1 合計所要時間: 約2.5時間**

---

### Phase 2: ドメイン層完全カバレッジ（目標90%）

#### 🎮 ゲーム機能

- [ ] **geometry_utils.dart** テスト作成
  - 幾何計算関数のテスト
  - 所要時間: 15分

- [ ] **constants.dart** テスト作成（必要に応じて）
  - 定数値の妥当性確認
  - 所要時間: 5分

#### 🔘 オセロ機能

- [ ] **board.dart** テスト作成
  - ボード初期化・操作のテスト
  - 所要時間: 40分

- [ ] **othello_game_state.dart** テスト作成
  - 状態遷移のテスト
  - 所要時間: 30分

- [ ] **position.dart** テスト作成
  - 座標計算のテスト
  - 所要時間: 15分

- [ ] **othello_ai.dart** テスト作成（最重要）
  - AI思考ロジックのテスト
  - 各種盤面パターンのテスト
  - 所要時間: 90分

#### ⚡ 反射神経テスト機能

- [ ] **falling_bar.dart** テスト作成
  - バー挙動のテスト
  - 所要時間: 20分

- [ ] **game_result.dart** テスト作成
  - スコア計算のテスト
  - 所要時間: 15分

- [ ] **reflex_game_state.dart** テスト作成
  - 状態管理のテスト
  - 所要時間: 25分

#### 🧱 テトリス機能

- [ ] **tetris_game_state.dart** テスト作成
  - ゲーム状態管理のテスト
  - 所要時間: 30分

- [ ] **tetromino.dart** テスト作成
  - テトリミノ回転・移動のテスト
  - 所要時間: 40分

**Phase 2 合計所要時間: 約5時間**

---

### Phase 3: プロバイダー層テスト（目標95%）

- [ ] **game_provider.dart** テスト作成
  - 所要時間: 30分

- [ ] **othello_game_provider.dart** テスト作成
  - 所要時間: 30分

- [ ] **reflex_game_provider.dart** テスト作成
  - 所要時間: 30分

- [ ] **tetris_game_provider.dart** テスト作成
  - 所要時間: 30分

**Phase 3 合計所要時間: 約2時間**

---

## 📈 目標カバレッジ推移

| フェーズ | 目標カバレッジ | 追加工数 | 累積工数 |
|---------|--------------|---------|---------|
| 現状 | 77.5% | - | - |
| Phase 1 | 85% | 2.5時間 | 2.5時間 |
| Phase 2 | 90% | 5時間 | 7.5時間 |
| Phase 3 | 95% | 2時間 | 9.5時間 |

**総計: 約10時間でカバレッジ77.5% → 95%達成**

---

## 🎯 効率化のポイント

### 1. **テストを書かないもの**
- ✅ Freezed生成コード (.freezed.dart, .g.dart)
- ✅ 単純なUIウィジェット（Widget testで代替）
- ✅ Routing設定（Integration testで代替）

### 2. **最小限のテストで済ませるもの**
- Freezedモデル: copyWith/equalityのみ
- 定数ファイル: スキップ可

### 3. **重点的にテストするもの**
- ビジネスロジック（AIアルゴリズム、ゲームルール）
- データ変換・計算ロジック
- エラーハンドリング

### 4. **テスト作成の工夫**
- テストテンプレート活用
- Given-When-Thenパターン統一
- マッチャーの積極活用 (isA, isIn, etc.)

---

## ✅ 成功基準

### 定量的基準
- [ ] 全体カバレッジ 95%以上
- [ ] ドメイン層カバレッジ 100%
- [ ] コア機能カバレッジ 95%以上
- [ ] 失敗テスト 0件

### 定性的基準
- [ ] 全テストが5秒以内に完了
- [ ] CIで自動実行可能
- [ ] テストコードが読みやすい
- [ ] リファクタリングが容易

---

## 🚀 開始方法

```bash
# 1. カバレッジ測定
flutter test --coverage

# 2. Phase 1から順次実装
# 例: dio_client.dartのテスト改善
code test/core/dio_client_test.dart

# 3. 定期的にカバレッジ確認
flutter test --coverage
python3 scripts/coverage_report.py  # 詳細レポート生成
```

---

## 📚 参考資料

- [Flutter Testing Documentation](https://docs.flutter.dev/testing)
- [Riverpod Testing Guide](https://riverpod.dev/docs/essentials/testing)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- プロジェクト内: `CLAUDE.md` - テストルール

---

**作成日**: 2025-11-09
**最終更新**: 2025-11-09
**対象プロジェクト**: flutter_template
