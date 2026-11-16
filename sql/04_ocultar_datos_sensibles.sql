-- =====================================================================
-- Tabuladores Médicos · Ocultar datos fiscales de los médicos al rol anon
-- Recomendado si el repositorio o la página son públicos.
-- La aplicación solo usa estas columnas de `medicos`; RFC, razón social,
-- régimen fiscal y tipo de proveedor dejan de ser legibles sin sesión.
-- =====================================================================

revoke select on medicos from anon;
grant select (id_medico, id_tabulador_cliente, nombre_medico, especialidad, cedula, estatus)
  on medicos to anon;

-- Para revertir:
-- grant select on medicos to anon;
