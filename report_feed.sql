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

-- ログイン済みユーザーのみ閲覧可（未ログインの匿名からは読めない）
-- （ビューは所有者権限で実行されるため responses のRLSは通さず、
--   ここで許可した安全な列だけが読める。生データ本体は本人のみのまま）
revoke select on public.report_feed from anon;      -- 匿名は不可
grant  select on public.report_feed to authenticated;

-- 反映されない場合は PostgREST にスキーマ再読込を通知
notify pgrst, 'reload schema';
