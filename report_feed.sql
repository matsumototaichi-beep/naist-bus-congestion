-- ============================================================
-- データ一覧（公開用）ビュー
-- responses から「安全な列だけ」を全員に見せる。
-- 軌跡(trajectory)・surveyor_id・メール等の個人情報は含めない。
-- Supabase SQL Editor に貼って実行してください。
-- ============================================================

create or replace view public.report_feed as
  select
    id,
    created_at,
    answered_at,
    congestion_class,
    exact_count,
    app_version
  from public.responses;

-- 匿名(未ログイン)・ログイン済みの双方から閲覧可に
-- （ビューは所有者権限で実行されるため、responses のRLSは通さずに
--   ここで許可した安全な列だけが読める。生データ本体は本人のみのまま）
grant select on public.report_feed to anon, authenticated;

-- 反映されない場合は PostgREST にスキーマ再読込を通知
notify pgrst, 'reload schema';
