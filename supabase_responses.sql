-- ============================================================
-- バス混雑度 HITL データ収集  Supabase スキーマ (Phase A)
-- Supabase ダッシュボード > SQL Editor に貼り付けて実行してください。
-- PROJECT_SPEC.md §6 responses に対応。
-- ============================================================

-- 生の回答（不変）
create table if not exists public.responses (
  id               bigint generated always as identity primary key,
  created_at       timestamptz not null default now(),        -- サーバ受信時刻
  surveyor_id      uuid        not null default auth.uid(),    -- 認証ユーザー(GitHub)のUUID
  answered_at      timestamptz,                               -- 端末での回答時刻(TZ付き)
  congestion_class smallint    not null,                       -- 1〜6
  exact_count      integer,                                    -- 実測人数(任意, null可)
  trajectory       jsonb,                                      -- 回答中〜直後の短い軌跡 [{t,lat,lng,acc},...]
  lang             text,
  app_version      text,
  constraint congestion_class_range check (congestion_class between 1 and 6),
  constraint exact_count_nonneg     check (exact_count is null or exact_count >= 0)
);

create index if not exists responses_created_at_idx on public.responses (created_at desc);
create index if not exists responses_surveyor_idx   on public.responses (surveyor_id);

-- 行レベルセキュリティ
alter table public.responses enable row level security;

-- ログイン済みユーザーは「自分の回答のみ」INSERT可能
drop policy if exists "auth insert own" on public.responses;
create policy "auth insert own"
  on public.responses
  for insert
  to authenticated
  with check (surveyor_id = auth.uid());

-- 自分の回答は閲覧可（本人の記録数=インセンティブ集計や画面表示用）
drop policy if exists "auth select own" on public.responses;
create policy "auth select own"
  on public.responses
  for select
  to authenticated
  using (surveyor_id = auth.uid());

-- 集計・全件閲覧は SQL Editor / service_role キーで行う（匿名SELECTは不可）。

-- ============================================================
-- 動作確認（任意, SQL Editorはservice_role実行なのでRLSを通らない点に注意）:
--   select count(*) from public.responses;
-- ============================================================
