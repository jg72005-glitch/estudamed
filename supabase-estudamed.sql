-- EstudaMed + Supabase
-- Rode este arquivo no Supabase SQL Editor.
-- Depois, adicione os e-mails permitidos no bloco final.

create extension if not exists pgcrypto;

create table if not exists public.estudamed_allowed_emails (
  email text primary key,
  name text,
  role text not null default 'student',
  active boolean not null default true,
  created_at timestamptz not null default now()
);

create table if not exists public.estudamed_user_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  email text not null,
  app_state jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.estudamed_allowed_emails enable row level security;
alter table public.estudamed_user_state enable row level security;

drop policy if exists "Allowed users can read own permission" on public.estudamed_allowed_emails;
create policy "Allowed users can read own permission"
on public.estudamed_allowed_emails
for select
to authenticated
using (
  active = true
  and lower(email) = lower((select auth.jwt() ->> 'email'))
);

drop policy if exists "Users can read own EstudaMed state" on public.estudamed_user_state;
create policy "Users can read own EstudaMed state"
on public.estudamed_user_state
for select
to authenticated
using (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from public.estudamed_allowed_emails allowed
    where allowed.active = true
      and lower(allowed.email) = lower((select auth.jwt() ->> 'email'))
  )
);

drop policy if exists "Users can insert own EstudaMed state" on public.estudamed_user_state;
create policy "Users can insert own EstudaMed state"
on public.estudamed_user_state
for insert
to authenticated
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from public.estudamed_allowed_emails allowed
    where allowed.active = true
      and lower(allowed.email) = lower((select auth.jwt() ->> 'email'))
  )
);

drop policy if exists "Users can update own EstudaMed state" on public.estudamed_user_state;
create policy "Users can update own EstudaMed state"
on public.estudamed_user_state
for update
to authenticated
using ((select auth.uid()) = user_id)
with check (
  (select auth.uid()) = user_id
  and exists (
    select 1
    from public.estudamed_allowed_emails allowed
    where allowed.active = true
      and lower(allowed.email) = lower((select auth.jwt() ->> 'email'))
  )
);

create or replace function public.estudamed_require_allowed_email()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
begin
  if not exists (
    select 1
    from public.estudamed_allowed_emails allowed
    where allowed.active = true
      and lower(allowed.email) = lower(new.email)
  ) then
    raise exception 'E-mail nao autorizado para acessar a EstudaMed';
  end if;

  return new;
end;
$$;
drop trigger if exists estudamed_check_allowed_email on auth.users;
create trigger estudamed_check_allowed_email
before insert on auth.users
for each row execute function public.estudamed_require_allowed_email();

-- Edite esta lista com os e-mails permitidos.
-- Troque os exemplos pelos e-mails reais antes de criar os acessos.
insert into public.estudamed_allowed_emails (email, name, role, active)
values
  ('joao.jacinto@ufnt.edu.br', 'Joao Jacinto', 'student', true),
  ('raphael.calzada@ufnt.edu.br', 'Raphael Calzada', 'student', true),
  ('annacarollinnagm@gmail.com', 'Anna Carolinna', 'student', true),
   ('jg72005@gmail.com', 'Joao Jacinto', 'student', true)
on conflict (email) do update set
  name = excluded.name,
  role = excluded.role,
  active = excluded.active;
