-- =====================================================================
-- Tabuladores Médicos · Vistas de Supabase
-- Correr en: Supabase → SQL Editor. Se puede volver a correr sin problema.
-- security_invoker = true → las vistas respetan las políticas RLS de las tablas.
-- =====================================================================

-- Tabulador por cliente con su CPT (pestañas de «Por cliente»)
create or replace view v_tabulador
with (security_invoker = true) as
select tc.id_tabulador_cliente,
       tc.id_region,
       cp.cpt,
       tc.especialidad,
       tc.descripcion_cliente as concepto,
       tc.costo
from tabulador_cliente tc
left join cat_procedimientos cp on cp.id_procedimiento = tc.id_procedimiento;

-- «Por médico» · origen: Tabulador cliente
create or replace view v_med_tab_cliente
with (security_invoker = true) as
select m.id_medico, m.nombre_medico, cp.cpt, cp.descripcion, cp.tipo_servicio,
       m.especialidad, m.cedula, tc.costo,
       c.descripcion as cliente, rc.descripcion as region
from medicos m
join tabulador_cliente tc  on m.id_tabulador_cliente = tc.id_tabulador_cliente
join cat_procedimientos cp on tc.id_procedimiento = cp.id_procedimiento
join regiones_clientes rc  on tc.id_region = rc.id_region
join clientes c            on c.id_cliente = rc.id_cliente;

-- «Por médico» · origen: Tabulador especial (incluye autorizaciones)
create or replace view v_med_tab_especial
with (security_invoker = true) as
select m.id_medico, m.nombre_medico, cp.cpt, cp.descripcion, cp.tipo_servicio,
       m.especialidad, m.cedula, te.costo,
       c.descripcion as cliente, rc.descripcion as region, te.motivo
from medicos m
join tabulador_especial te on m.id_medico = te.id_medico
join cat_procedimientos cp on te.id_procedimiento = cp.id_procedimiento
join regiones_clientes rc  on te.id_region = rc.id_region
join clientes c            on c.id_cliente = rc.id_cliente;
