-- =====================================================================
-- Tabuladores Médicos · Políticas de lectura TEMPORALES (rol anon)
-- Permiten leer sin iniciar sesión mientras se define el login.
-- ⚠ Cualquiera con la URL y la clave publishable puede LEER estas tablas.
-- Cuando exista login, borrarlas y usar el bloque «Producción» de abajo.
-- =====================================================================

drop policy if exists "Prueba temporal lectura clientes"       on clientes;
drop policy if exists "Prueba temporal lectura regiones"       on regiones_clientes;
drop policy if exists "Prueba temporal lectura tabulador"      on tabulador_cliente;
drop policy if exists "Prueba temporal lectura procedimientos" on cat_procedimientos;
drop policy if exists "Prueba temporal lectura medicos"        on medicos;
drop policy if exists "Prueba temporal lectura tab especial"   on tabulador_especial;

create policy "Prueba temporal lectura clientes"       on clientes           for select to anon using (true);
create policy "Prueba temporal lectura regiones"       on regiones_clientes  for select to anon using (true);
create policy "Prueba temporal lectura tabulador"      on tabulador_cliente  for select to anon using (true);
create policy "Prueba temporal lectura procedimientos" on cat_procedimientos for select to anon using (true);
create policy "Prueba temporal lectura medicos"        on medicos            for select to anon using (true);
create policy "Prueba temporal lectura tab especial"   on tabulador_especial for select to anon using (true);

-- =====================================================================
-- Producción (cuando exista login con Supabase Auth): descomentar y correr
-- =====================================================================
-- drop policy if exists "Prueba temporal lectura clientes"       on clientes;
-- drop policy if exists "Prueba temporal lectura regiones"       on regiones_clientes;
-- drop policy if exists "Prueba temporal lectura tabulador"      on tabulador_cliente;
-- drop policy if exists "Prueba temporal lectura procedimientos" on cat_procedimientos;
-- drop policy if exists "Prueba temporal lectura medicos"        on medicos;
-- drop policy if exists "Prueba temporal lectura tab especial"   on tabulador_especial;
-- create policy "Lectura con sesion" on clientes           for select to authenticated using (true);
-- create policy "Lectura con sesion" on regiones_clientes  for select to authenticated using (true);
-- create policy "Lectura con sesion" on tabulador_cliente  for select to authenticated using (true);
-- create policy "Lectura con sesion" on cat_procedimientos for select to authenticated using (true);
-- create policy "Lectura con sesion" on medicos            for select to authenticated using (true);
-- create policy "Lectura con sesion" on tabulador_especial for select to authenticated using (true);
