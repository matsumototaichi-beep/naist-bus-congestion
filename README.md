# NAIST バス混雑度 計測アプリ

NAIST（奈良先端科学技術大学院大学）のバス混雑度をスマホから記録するための、
**会員登録なし・完全ローカル保存**の軽量 Web アプリです。

## 特徴

- **会員登録・ログイン不要**。データベースや外部サーバーへの送信は一切なし。
- 記録は端末内（`localStorage`）にのみ保存され、**CSV でいつでも書き出し**できます。
- 6 段階の混雑度をワンタップで記録。任意で正確な人数と GPS 位置も付与。
- 日本語 / English 切り替え対応。
- 単一の `index.html` のみ。外部 CDN 依存なしの完全静的ファイル。

## 公開URL（GitHub Pages）

```
https://<あなたのGitHubユーザー名>.github.io/naist-bus-congestion/
```

※ GPS（位置情報）はHTTPS環境でのみ動作します。GitHub Pages はHTTPSなので利用可能です。

## 使い方

1. 上記URLをスマホで開く。
2. 右上の ⚙ から路線・区間・車両番号・回答者区分を設定。
3. 乗車中に混雑度カード（1〜6）をタップ。必要なら人数も入力。
4. 記録一覧の **⬇ CSV** ボタンでいつでもCSV書き出し。

## 記録されるCSV項目

`answered_at, respondent_type, respondent_id, congestion_class, exact_count,
lat, lng, gps_accuracy, route_id, busstop_id, vehicle_id, lang, app_version`

## データの扱い

- すべて利用者の端末内に保存されます。開発者・第三者がデータを収集することはありません。
- 端末のブラウザデータを消去すると記録も消えます。**こまめにCSVを書き出してください。**
