-- ===== 0001_init.sql (исправленная версия) =====
create extension if not exists pgcrypto;

-- 1. Таблицы
create table if not exists public.users (
  id uuid primary key references auth.users (id) on delete cascade,
  display_name text not null default '',
  display_name_dative text,
  avatar_url text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  sync_status text not null default 'synced'
);

create table if not exists public.spaces (
  id uuid primary key default gen_random_uuid(),
  name text not null default '',
  encryption_salt text not null,
  status text not null default 'active',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  sync_status text not null default 'synced'
);

create table if not exists public.memberships (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references public.users (id) on delete cascade,
  space_id uuid not null references public.spaces (id) on delete cascade,
  role text not null default 'member',
  status text not null default 'active',
  last_active_at timestamptz,
  joined_at timestamptz not null default now(),
  left_at timestamptz,
  unique (user_id, space_id)
);

create table if not exists public.app_settings (
  user_id uuid primary key references public.users (id) on delete cascade,
  base_currency text not null default 'RUB',
  use_historical_exchange_rate boolean not null default true,
  inherit_limit_from_previous_month boolean not null default false,
  carry_over_unused_limit boolean not null default false,
  limit_alert_mode text not null default 'global_percent',
  global_alert_percent integer not null default 80,
  global_alert_amount bigint not null default 0,
  enable_secrecy_mode boolean not null default true,
  secrecy_days_before integer not null default 14,
  secrecy_timeout_seconds integer not null default 120,
  large_transaction_threshold bigint not null default 10000000,
  auto_hide_gifts_on_import boolean not null default true,
  updated_at timestamptz not null default now()
);

-- 2. НОВАЯ функция триггера (соль через gen_random_uuid() — без зависимостей)
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
declare
  v_space_id uuid;
begin
  insert into public.users (id) values (new.id)
    on conflict (id) do nothing;

  insert into public.spaces (name, encryption_salt)
    values ('Personal', gen_random_uuid()::text)
    returning id into v_space_id;

  insert into public.memberships (user_id, space_id, role, status, last_active_at)
    values (new.id, v_space_id, 'admin', 'active', now())
    on conflict (user_id, space_id) do nothing;

  insert into public.app_settings (user_id) values (new.id)
    on conflict (user_id) do nothing;

  return new;
end;
$$;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute function public.handle_new_user();

-- 3. RLS + политики
alter table public.users enable row level security;
alter table public.spaces enable row level security;
alter table public.memberships enable row level security;
alter table public.app_settings enable row level security;

drop policy if exists "users_own" on public.users;
create policy "users_own" on public.users
  for all using (auth.uid() = id) with check (auth.uid() = id);

drop policy if exists "spaces_member" on public.spaces;
create policy "spaces_member" on public.spaces
  for all using (exists (
    select 1 from public.memberships m
    where m.space_id = spaces.id and m.user_id = auth.uid()
  ));

drop policy if exists "memberships_own_or_same_space" on public.memberships;
create policy "memberships_own_or_same_space" on public.memberships
  for all using (
    user_id = auth.uid()
    or exists (
      select 1 from public.memberships m
      where m.space_id = memberships.space_id and m.user_id = auth.uid()
    )
  );

drop policy if exists "settings_own" on public.app_settings;
create policy "settings_own" on public.app_settings
  for all using (auth.uid() = user_id) with check (auth.uid() = user_id);