-- =====================================================================
-- Tabuladores Médicos · Consultas de verificación (solo lectura)
-- =====================================================================

-- 1) Registros por grid de INDEP (región 12). Esperado: 8, 35, 6, 5, 49, 222, 2484
select
  count(*) filter (where especialidad = 'CONSULTAS' and (id_tabulador_cliente between 1 and 4 or id_tabulador_cliente between 9 and 12)) as primer_contacto,
  count(*) filter (where especialidad = 'CONSULTAS' and id_tabulador_cliente between 13 and 47) as segundo_contacto,
  count(*) filter (where especialidad = 'CONSULTAS' and id_tabulador_cliente between 48 and 53) as tercer_contacto,
  count(*) filter (where especialidad = 'HOSPITALIZACION') as hospitalario,
  count(*) filter (where id_tabulador_cliente between 59 and 107)   as dental,
  count(*) filter (where id_tabulador_cliente between 108 and 329)  as consultorio,
  count(*) filter (where id_tabulador_cliente between 330 and 2813) as quirurgico
from tabulador_cliente where id_region = 12;

-- 2) Registros por grid de CNBV (región 14). Esperado: 20, 4, 4, 36, 2, 2184, 14, 87
select
  count(*) filter (where id_tabulador_cliente between 2814 and 2833) as visita_domiciliaria,
  count(*) filter (where id_tabulador_cliente between 2834 and 2837) as primer_contacto,
  count(*) filter (where id_tabulador_cliente between 2838 and 2841) as segundo_contacto,
  count(*) filter (where id_tabulador_cliente between 2842 and 2877) as consulta_especialidad,
  count(*) filter (where id_tabulador_cliente between 2878 and 2879) as proc_consultorios,
  count(*) filter (where id_tabulador_cliente between 2880 and 5063) as quirurgico,
  count(*) filter (where id_tabulador_cliente between 5064 and 5077) as rehabilitacion,
  count(*) filter (where id_tabulador_cliente between 5078 and 5164) as odontologia
from tabulador_cliente where id_region = 14;

-- 3) BANRURAL por región. Esperado: región 19 → 55 en consulta_hosp; regiones 1–11 → 2489 / 227 / 49
select rc.id_region, rc.descripcion,
  count(*) filter (where tc.id_tabulador_cliente between 5165 and 5219)   as consulta_hosp,
  count(*) filter (where tc.id_tabulador_cliente between 5220 and 32598)  as quirurgico,
  count(*) filter (where tc.id_tabulador_cliente between 32599 and 35095) as consultorio,
  count(*) filter (where tc.id_tabulador_cliente between 35096 and 35634) as dental
from tabulador_cliente tc
join regiones_clientes rc on rc.id_region = tc.id_region
where rc.id_cliente = 1
group by rc.id_region, rc.descripcion
order by rc.id_region;

-- 4) Médicos con más especialidades y clientes (JLFC cuenta como INDEP)
with datos as (
  select nombre_medico, cedula, especialidad, cliente from v_med_tab_cliente
  union all
  select nombre_medico, cedula, especialidad, cliente from v_med_tab_especial
)
select nombre_medico, cedula,
       count(distinct especialidad) as num_especialidades,
       count(distinct cliente)      as num_clientes,
       string_agg(distinct especialidad, ', ' order by especialidad) as especialidades,
       string_agg(distinct cliente, ', ' order by cliente)           as clientes
from datos
where cliente <> 'JLFC'
group by nombre_medico, cedula
order by num_especialidades desc, num_clientes desc, nombre_medico
limit 20;

-- 5) Estado de RLS por tabla
select relname as tabla, relrowsecurity as rls_activo
from pg_class
where relnamespace = 'public'::regnamespace and relkind = 'r'
order by relname;
