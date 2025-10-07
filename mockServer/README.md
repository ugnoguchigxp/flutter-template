# モックサーバー

Flutter テンプレートの API デモ画面から呼び出すための FastAPI 製モックサーバーです。最小限の依存関係で `/posts` リソースを提供し、GET/POST/PUT/DELETE を試せるようにしています。

## セットアップ
1. プロジェクトルートで一度だけ依存関係をインストールします。
   ```bash
   cd mockServer
   make install
   ```
   `make install` は `.venv/` を作成し、`fastapi` と `uvicorn[standard]` をインストールします。

## 起動方法
- リロード付きで 8081 番ポートに起動します。
  ```bash
  make run
  ```
  （内部では `./.venv/bin/uvicorn app.main:app --reload --host 0.0.0.0 --port 8081` を呼び出すため、毎回仮想環境を `source` する必要はありません。）
- サーバーを止めるときは `Ctrl+C` を押してください。

## 提供エンドポイント
| メソッド | パス             | 説明                               |
|----------|------------------|------------------------------------|
| GET      | `/health`        | ヘルスチェック。`{"status": "ok"}` を返します |
| GET      | `/posts`         | 全投稿の一覧を返します                     |
| GET      | `/posts/{id}`    | 指定 ID の投稿を返します                   |
| POST     | `/posts`         | `title/body/author` を受け取り新規作成      |
| PUT      | `/posts/{id}`    | 任意フィールドを更新します                  |
| DELETE   | `/posts/{id}`    | 投稿を削除します（204 No Content）        |
| POST     | `/echo`          | 送信した JSON をそのまま返します             |

レスポンスはすべて JSON で返却され、Flutter 側の `ApiDemoScreen` で整形表示できます。

## Flutter からの利用
1. サーバーを `make run` で起動したままにする（デフォルト: `http://127.0.0.1:8081`）。
2. Flutter アプリを起動するときに、モックサーバーの URL を `--dart-define` で渡します。
   ```bash
   flutter run --dart-define=API_BASE_URL=http://127.0.0.1:8081
   ```
   - Android エミュレーターの場合は `http://10.0.2.2:8081` を指定してください。
   - iOS Simulator では `http://127.0.0.1:8081` のままで問題ありません。
3. アプリ内の「API Demo」画面で、初期値 `/posts/1` のままリクエストを送ればモックレスポンスが表示されます。

## 補足
- 依存関係の更新が必要になった場合は `requirements.txt` を変更し、再度 `make install` を実行してください。
- 追加のエンドポイントを増やす際は `app/main.py` にルーターを追記し、必要ならフィクスチャ用ディレクトリを整備してください。
