-- ============================================================
--  כוכבות החשבון — סכמת Supabase
--  הריצו את כל הקובץ פעם אחת ב-Supabase → SQL Editor → New query
-- ============================================================

-- שורה אחת לכל חשבון משפחה. כל הפרופילים, ההישגים והקניות
-- יושבים בתוך העמודה data כ-JSON.
create table if not exists public.saves (
  user_id    uuid primary key references auth.users on delete cascade,
  data       jsonb       not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.saves enable row level security;

-- כל משתמש רואה ומעדכן אך ורק את השורה שלו.
drop policy if exists "saves_select_own" on public.saves;
create policy "saves_select_own" on public.saves
  for select using (auth.uid() = user_id);

drop policy if exists "saves_insert_own" on public.saves;
create policy "saves_insert_own" on public.saves
  for insert with check (auth.uid() = user_id);

drop policy if exists "saves_update_own" on public.saves;
create policy "saves_update_own" on public.saves
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "saves_delete_own" on public.saves;
create policy "saves_delete_own" on public.saves
  for delete using (auth.uid() = user_id);
