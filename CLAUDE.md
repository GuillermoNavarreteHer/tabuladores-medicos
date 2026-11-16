# Tabuladores Médicos — contexto del proyecto

Sistema para consultar tabuladores de costos médicos por cliente, región, médico y CPT.
Versión actual: **1.1.0** (ver `CHANGELOG.md`). Idioma de la interfaz y del código comentado: **español**.

## Archivos
- `index.html`: aplicación completa en un solo HTML (CSS y JS incluidos, logotipos incrustados en base64).
- `sql/`: scripts de Supabase (vistas, políticas, consultas de verificación).
- `README.md`: guía de instalación y uso.
- `CHANGELOG.md`: historial de versiones (Keep a Changelog + SemVer).

## Stack
- Front: HTML + CSS + JavaScript sin frameworks. Navegación por hash (`#login`, `#menu`, `#clientes`, `#medico`, `#indep`, `#banrural`, etc.).
- Back: **Supabase** (Postgres + PostgREST) con `@supabase/supabase-js@2.45.4` (UMD desde jsDelivr).
- Conexión al final del HTML: `SUPABASE_URL = https://cwmvknmohhemxcfwstxz.supabase.co` y clave **publishable** (`sb_publishable_…`). Nunca usar la `service_role` en el front.

## Modo demo
- `index.html?demo` → `crearClienteDemo()` imita `supabase-js` (`from/select/eq/neq/gte/lte/ilike/order/range/limit/maybeSingle`) con datos ficticios generados desde `CLIENT_CFG` (usa `load.meta`).
- Conteos idénticos a los reales. Sirve para la demo pública en GitHub Pages y para las capturas de `docs/img/`.

## Pantallas
1. **Login**: maqueta, no valida usuarios. Se definirá después junto con otros proyectos (posiblemente Supabase Auth compartido).
2. **Menú superior**: Inicio, Por cliente, Por médico, Catálogos (deshabilitado, "Pronto"). Barra de ubicación tipo explorador con botón de regreso. Modo claro/oscuro guardado en localStorage.
3. **Menú inicial**: bloques a Consulta por cliente/médico, búsqueda rápida de CPT, accesos a clientes.
4. **Selecciona cliente**: INDEP, BANRURAL, CNBV, BANCOMEXT, BANBIEN, NAFIN (nombres en MAYÚSCULAS, con logotipo). JLFC existe en la BD pero aún no tiene tarjeta.
5. **Apartado del cliente**: logotipo, Seleccionar cliente, Región (solo clientes con varias regiones), Descargar Excel, pestañas Consulta / Hospitalario / Quirúrgico / Proc. en consultorio / Dental, filtro "CPT o descripción" por pestaña.
6. **Consulta por médico**: Médico / Especialidad (combo) / Cliente (combo) / CPT, un solo grid con columna Origen, filtros tipo Excel y exportación.

## Componente de grid (`createGrid`)
- 10 registros por página; paginado ‹ 1 2 … › visible si hay más de 10.
- Botón Ampliar (pantalla completa; Esc o clic fuera cierra).
- Estados: `loading` (esqueleto de carga), `ready`, `error`, `info`, `noregion`, `pending`.
- `setRows`, `setFilter` (texto en columnas no monetarias), `setPredicate` (filtro por función), `setState`.
- Columnas `{ key, label, type: 'money' }`; moneda en MXN (`Intl.NumberFormat('es-MX')`).
- Lectura en bloques de 1,000 filas con `.range()` (límite de Supabase).

## Base de datos (schema `public`, RLS activado en todas)
- `clientes(id_cliente, descripcion, estatus)` — INDEP = **2**. Hay 8 clientes.
- `regiones_clientes(id_region, descripcion, estatus, id_cliente)`
- `cat_procedimientos(id_procedimiento, cpt, descripcion, tipo_servicio, estatus)`
- `tabulador_cliente(id_tabulador_cliente, id_procedimiento, id_region, descripcion_cliente, costo, especialidad, estatus)`
- `medicos(id_medico, id_tabulador_cliente, nombre_medico, especialidad, cedula, regimen_fiscal, razon_social, tipo_proveedor, rfc, estatus)`
- `tabulador_especial(id_tabulador_especial, id_medico, id_procedimiento, id_region, costo, origen, especialidad, fecha_inicial, fecha_final, motivo, estatus)`

### Vistas (todas `with (security_invoker = true)`)
- `v_tabulador`: tabulador_cliente + cpt → `id_tabulador_cliente, id_region, cpt, especialidad, concepto (= descripcion_cliente), costo`.
- `v_med_tab_cliente`: medicos ⇢ tabulador_cliente (por `medicos.id_tabulador_cliente`) ⇢ cat_procedimientos ⇢ regiones_clientes ⇢ clientes.
- `v_med_tab_especial`: medicos ⇢ tabulador_especial (por `id_medico`) ⇢ cat_procedimientos ⇢ regiones_clientes ⇢ clientes, incluye `motivo`.
- Columnas de las vistas de médico: `id_medico, nombre_medico, cpt, descripcion, tipo_servicio, especialidad, cedula, costo, cliente, region` (+ `motivo`).

### Permisos
- Políticas **temporales** `for select to anon using (true)` en las 6 tablas (nombres "Prueba temporal lectura …").
- Al definir el login: borrarlas y crear `to authenticated`.

## Reglas de negocio
### INDEP (id_cliente 2, una sola región: 12)
| Grid | Filtro en `v_tabulador` |
|---|---|
| Primer contacto | especialidad = 'CONSULTAS' y id 1–4 **+** 9–12 (segundo nivel va dentro de primer contacto) |
| Segundo contacto | 'CONSULTAS' y id 13–47 |
| Tercer contacto | 'CONSULTAS' y id 48–53 |
| Hospitalario | especialidad = 'HOSPITALIZACION' |
| Dental | id 59–107 |
| Proc. en consultorio | id 108–329 |
| Quirúrgico | id 330–2813 (2,484 registros) |

- Conteos esperados: 8, 35, 6, 5, 49, 222, 2,484.
- Los rangos de `id_tabulador_cliente` **solo valen para una región**. Si INDEP agrega regiones, crear una columna de clasificación (p. ej. `grupo`).
- Ids 5–8 no se muestran (pendiente de confirmar).

### CNBV (id_cliente 4, una sola región: 14) — pestañas: Honorarios médicos | Procedimientos en consultorios | Quirúrgico | Rehabilitación | Odontología
| Grid | Rango `id_tabulador_cliente` |
|---|---|
| Honorarios · Visita domiciliaria · Primer contacto | 2814–2833 |
| Honorarios · Primer contacto | 2834–2837 |
| Honorarios · Segundo contacto | 2838–2841 |
| Honorarios · Consulta de especialidad | 2842–2877 |
| Procedimientos en consultorios | 2878–2879 |
| Quirúrgico | 2880–5063 |
| Rehabilitación | 5064–5077 |
| Odontología | 5078–5164 |

- Conteos esperados: 20, 4, 4, 36, 2, 2,184, 14, 87.
- Configuración de grids por cliente en `CLIENT_CFG` (claves internas de pestaña: consulta, hospitalario, quirurgico, consultorio, dental); nombres visibles en `TAB_LABELS`.

### BANRURAL (id_cliente 1, 11 regiones)
| Grid | Rango `id_tabulador_cliente` | Región |
|---|---|---|
| Primer contacto | 5165–5171 | fija 19 (`regionFija`) |
| Segundo contacto | 5172–5208 | fija 19 |
| Tercer contacto | 5209–5214 | fija 19 |
| Hospitalario | 5215–5219 | fija 19 |
| Quirúrgico (+ col. Región) | 5220–32598 | la elegida |
| Proc. en consultorio (+ col. Región) | 32599–35095 | la elegida |
| Dental | 35096–35634 | la elegida |

- Confirmado con datos reales: la región 19 (BANRURAL) tiene 55 registros (Consulta + Hospitalario). Cada una de las 11 regiones (ids 1–11) tiene 2,489 Quirúrgico, 227 Consultorio y 49 Dental.
- La región 19 se oculta del desplegable (`ocultarRegiones: [19]`).

### Desplegable de Región
- BANRURAL: 11 regiones desde `regiones_clientes` (las carga `initLive`). Elegir región carga Quirúrgico, Proc. en consultorio y Dental.
- INDEP, JLFC, CNBV (`REGION_BLOQUEADA`): el campo Región se **oculta**. El select sigue guardando internamente el `id_region` para las consultas.

### Descarga en Por cliente
- Botón "Descargar Excel" (`cxWrap`), visible solo en clientes de `CLIENT_CFG`:
  - Datos buscados: pestaña activa con filtro aplicado (`getRows`).
  - Concentrado: todas las pestañas sin filtros (`getAllRows`), con hoja "Concentrado" más una hoja por tabla.
- Hojas generadas con `hojaCols(columnas, filas)` (SheetJS).

### Consulta por médico
- Un solo grid (`MED`): une `v_med_tab_cliente` (origen "Tabulador cliente") y `v_med_tab_especial` (origen "Tabulador especial", incluye autorizaciones). Sin radios.
- Columnas: Médico, CPT, Descripción, Tipo de servicio, Especialidad, Cédula, Cliente, Región, Costo, Origen.
- Fila de búsqueda: Médico (texto, `ilike` insensible a acentos) · Especialidad (combo) · Cliente (combo) · CPT (texto, `ilike`).
- Combos (`comboModo`):
  - `catalogo`: lista completa; cuentan como parámetros (`eq`).
  - `resultado`: valores del médico encontrado; filtran la tabla vía `MS` y se sincronizan con "Filtrar por".
  - Al vaciar médico y CPT se vuelve a `catalogo`.
- Barra `medTools` (visible solo con resultados): solo "Exportar a Excel" con SheetJS, concentrado (1 archivo) o por cliente (1 por cliente). Exporta las filas visibles (`MED.getRows()`).
- `MS.cliente` / `MS.especialidad` siguen existiendo como estado interno de los combos (no se muestran).
- Búsqueda en vivo (sin Enter): médico desde 2 letras y CPT con espera de 0.4 s; `medReq` descarta respuestas viejas.
- JLFC e INDEP son la misma unidad: se excluye `cliente = 'JLFC'` (`EXCLUIR_CLIENTES`). Solo aplica a Consulta por médico.

## Diseño
Paleta (usar siempre variables CSS, sin HEX sueltos):
`--blanco #ffffff`, `--pino #2e3e3c`, `--teal #008890`, `--aqua #97d5d7`, `--petroleo #48868e`, `--bosque #334035`, y `--teal-oscuro #007a82` (solo fondo de botones pequeños con texto blanco).
- Estilo Metro: fondo con degradados radiales, paneles translúcidos `rgba(46,62,60,α)` + `backdrop-filter: blur(12px)`, esquinas rectas, títulos en letra ligera.
- Texto blanco; secundario `rgba(255,255,255,.80)`; divisores `rgba(151,213,215,.35)`.
- Sobre `--aqua` el texto va en `--pino`. Texto < 18px sobre teal/petróleo en `font-weight: 600`.
- Tipografía: "Segoe UI", "Open Sans", Arial.

## Pendientes
- Definir login (compartido con otros proyectos) y cambiar permisos a `authenticated`.
- Consultas para BANCOMEXT, BANBIEN, NAFIN y JLFC (INDEP, CNBV y BANRURAL ya conectados).
- Documentación: README, diccionario de datos, diagrama ER, mapa de consultas, manual de usuario.

## Convenciones de trabajo
- En todo el programa las búsquedas son en vivo (sin Enter); mantener ese comportamiento en pantallas nuevas.
- Cambios solo en lo que se pide; no alterar estructura ni textos no relacionados.
- Cada entrega nueva: subir versión SemVer (correcciones → 1.0.x; funciones nuevas → 1.x.0; cambios incompatibles → 2.0.0), actualizar `APP_VERSION`, la insignia, el encabezado del HTML y `CHANGELOG.md`, y crear la etiqueta de Git `vX.Y.Z`.
