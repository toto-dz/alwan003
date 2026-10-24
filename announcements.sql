-- Supabase schema for the Alwan announcements editor.
-- The editor is intentionally public/no-login, so anonymous visitors can also
-- manage rows. Enable this only if that public behavior is intended.

create table if not exists public.announcements (
  id text primary key default gen_random_uuid()::text,
  title text not null check (char_length(title) between 1 and 140),
  date date not null default current_date,
  category text not null check (category in ('shop','registration','documents','offers','services','alerts')),
  summary text not null check (char_length(summary) between 1 and 360),
  content text not null check (char_length(content) between 1 and 12000),
  image text not null default '',
  badge text,
  badge_type text check (badge_type is null or badge_type in ('new','important')),
  published boolean not null default false,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table public.announcements
  add column if not exists image text not null default '';

alter table public.announcements enable row level security;
grant select, insert, update, delete on public.announcements to anon, authenticated;

drop policy if exists "public manages announcements" on public.announcements;
create policy "public manages announcements" on public.announcements
  for all to anon, authenticated
  using (true)
  with check (true);

create index if not exists announcements_published_date_idx
  on public.announcements (published, date desc, created_at desc);
