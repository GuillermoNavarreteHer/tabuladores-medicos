# Changelog — Tabuladores Médicos

Formato basado en [Keep a Changelog](https://keepachangelog.com/es-ES/1.1.0/) y versionado [SemVer](https://semver.org/lang/es/).

## [1.1.0] — 2026-11-16

### Agregado
- **Modo demo** (`index.html?demo`): genera datos ficticios con la misma estructura, rangos y conteos de la configuración real, y responde con la misma API que `supabase-js`. No se conecta a Supabase. Muestra la etiqueta "MODO DEMO · datos ficticios" y llena el login.
- **README de portafolio**: descripción del problema y la solución, funciones, capturas, arquitectura, decisiones técnicas y enlace a la demo en vivo.
- **Capturas** en `docs/img/`: login, menú, clientes, INDEP, CNBV, BANRURAL, descarga, grid ampliado, por médico, modo oscuro y móvil.

### Cambiado
- `spec()` y `conRegion()` exponen `meta` (rangos y especialidad) para que el modo demo genere datos coherentes.

## [1.0.0] — 2026-11-13

Primera versión oficial. Incluye todo lo de 0.2.0-beta más los cambios de abajo.

### Cambiado
- El archivo principal ahora se llama `index.html`. Se agregaron README, scripts SQL en `sql/`, documentación en `docs/` y `.gitignore`.
- **BANRURAL**: en Consulta y Hospitalario se oculta el desplegable de Región, como en INDEP, y el aviso dice "Mismos precios para todas las regiones." En Quirúrgico, Proc. en consultorio y Dental el desplegable reaparece con la región que ya estaba elegida.

## [0.2.0-beta] — 2026-11-12

### Corregido
- **DataCloneError** ("Headers object could not be cloned") al abrir la página en visores que redirigen las peticiones por `postMessage`. El cliente de Supabase usa ahora un `fetch` que manda encabezados y URL como datos simples.

### Agregado
- **BANRURAL conectado a Supabase** (id_cliente 1, 11 regiones):
  - Consulta (Primer contacto 5165–5171, Segundo 5172–5208, Tercer 5209–5214) y Hospitalario (5215–5219): mismo precio para todas las regiones. Se leen siempre de la región 19 y cargan sin elegir región.
  - Quirúrgico (5220–32598), Proc. en consultorio (32599–35095) y Dental (35096–35634) usan la región elegida. Quirúrgico y Proc. en consultorio muestran la columna Región.
  - Al cambiar de región solo se recargan las tablas que dependen de ella.
  - Aviso por pestaña en clientes con varias regiones:
    - Consulta y Hospitalario: "mismo precio para todas las regiones, no cambia al elegir región".
    - Quirúrgico, Proc. en consultorio y Dental: "Mostrando la región X" o "Elige una región".
  - La región 19 (BANRURAL) no aparece en el desplegable (`ocultarRegiones`): solo guarda Consulta y Hospitalario. Verificado con datos reales: 55 registros en la 19; 2,489 / 227 / 49 en cada una de las 11 regiones.
  - Descargar Excel incluye la región en el nombre del archivo y pide elegir región antes del concentrado.
- **Por cliente · Descargar Excel**, en INDEP y CNBV (los clientes con datos), con dos opciones:
  - Descargar datos buscados: la pestaña actual con el filtro "CPT o descripción" aplicado. Lleva una hoja por tabla de la pestaña. Archivo `Tabulador_<CLIENTE>_<PESTAÑA>[_<FILTRO>]_<fecha>.xlsx`.
  - Descargar concentrado: todo el tabulador del cliente sin filtros. Lleva la hoja "Concentrado" (con columnas Pestaña y Tabla) más una hoja por tabla. Archivo `Tabulador_<CLIENTE>_CONCENTRADO_<fecha>.xlsx`.
  - El menú muestra cuántos registros se descargarán. El concentrado se habilita cuando terminan de cargar todas las tablas.
- **Por médico · Combos Especialidad y Cliente** en la fila de búsqueda:
  - Antes de buscar, o al vaciar médico y CPT, muestran el catálogo completo (especialidades de `medicos` y clientes sin JLFC) y sirven como parámetros de búsqueda.
  - Al buscar un médico se llenan con sus especialidades y los clientes que maneja (p. ej. solo INDEP, o BANRURAL e INDEP), igual que en la versión con radios. Si solo tiene un valor, aparece seleccionado.
  - Elegir un valor filtra la tabla al instante y se sincroniza con "Filtrar por".
- **Por médico · Exportar a Excel** (SheetJS 0.18.5), con dos opciones:
  - Exportar concentrado: un archivo con todos los registros visibles.
  - Exportar por cliente: un archivo por cliente.
  - Se exporta lo que muestra la tabla con los filtros aplicados, con encabezados, autofiltro, anchos de columna y costo en formato moneda.
  - Nombre del archivo: `Tabuladores_<BÚSQUEDA>_<CLIENTE|CONCENTRADO>_<AAAA-MM-DD>.xlsx`.
- **CNBV conectado a Supabase** (id_cliente 4, región 14, vista `v_tabulador`):
  - Honorarios médicos, con 4 grids en cuadrícula de 2×2: Visita domiciliaria · Primer contacto (2814–2833), Primer contacto (2834–2837), Segundo contacto (2838–2841) y Consulta de especialidad (2842–2877).
  - Procedimientos en consultorios (2878–2879), Quirúrgico (2880–5063), Rehabilitación (5064–5077) y Odontología (5078–5164).
- **Configuración por cliente** (`CLIENT_CFG`): cada cliente define sus pestañas, cuántos grids lleva cada una y la consulta de cada grid. Agregar un cliente nuevo ya no requiere tocar el resto del código.

### Cambiado
- **Por cliente**: "Seleccionar cliente" (antes "Cambiar cliente") va primero y después Región, en todos los clientes.
- **Por cliente**: se oculta el filtro de Región en INDEP, CNBV y JLFC (región única). BANRURAL y los demás lo conservan.
- **Búsqueda en vivo en todo el programa**: los resultados aparecen mientras se escribe, sin presionar Enter. Enter y los botones Buscar siguen funcionando.
  - Por médico: busca 0.4 s después de dejar de escribir (médico desde 2 letras). Los combos buscan al instante y se conservan entre búsquedas si el valor sigue existiendo. Solo se muestra la respuesta más reciente.
  - Búsqueda rápida de CPT del menú inicial: al dejar de escribir abre Por médico con el CPT y deja el cursor ahí.
  - Filtro "CPT o descripción" de las pestañas de cada cliente (ya era en vivo).
- **Por médico**: se quitaron los filtros tipo Excel. Cliente y Especialidad se filtran solo con los combos. La barra conserva "Exportar a Excel".
- **Consulta por médico** rediseñada:
  - Se quitaron los botones de radio y los dos grids. Ahora hay **un solo grid** que une el tabulador del cliente y el tabulador especial (este incluye los de autorización).
  - Columnas: Médico, CPT, Descripción, Tipo de servicio, Especialidad, Cédula, Cliente, Región, Costo y **Origen** ("Tabulador cliente" o "Tabulador especial").
  - Se busca por **médico, especialidad y/o CPT**, combinables. Médico no distingue mayúsculas ni acentos.
  - **JLFC e INDEP son la misma unidad**: los registros de JLFC se excluyen y solo se muestran los de INDEP (`EXCLUIR_CLIENTES`).
  - Textos de ayuda (placeholders) con ejemplos en los tres campos.
- INDEP se migró a `CLIENT_CFG`, sin cambios en sus consultas ni en lo que muestra.
- **CNBV**: pestañas renombradas a Honorarios médicos, Procedimientos en consultorios, Quirúrgico, Rehabilitación y Odontología. El resto de los clientes conserva los nombres por defecto. Se configura en `TAB_LABELS`.

### Pendiente / conocido
- **Login**: se definirá junto con los otros proyectos. Al hacerlo, cambiar las políticas `to anon` por `to authenticated`.
- **Permisos temporales activos**: cualquiera con el archivo puede leer las 6 tablas.
- **Sin consultas todavía**: BANCOMEXT, BANBIEN, NAFIN y JLFC (este último sin tarjeta).
- **Rangos de `id_tabulador_cliente`**: si cambian los datos, hay que actualizarlos en `CLIENT_CFG`.
- Abrir la página directamente en Chrome o Edge. Algunos visores, como la vista previa de VS Code, pueden bloquear o alterar las conexiones.

## [0.1.0-beta] — 2026-11-10

Primera versión beta.

### Agregado
- **Login** de maqueta (Usuario / Contraseña). Todavía no valida usuarios.
- **Menú superior** con Inicio, Por cliente, Por médico y Catálogos (próxima etapa).
- **Barra de ubicación** tipo explorador (Menú inicial › Selecciona cliente › Cliente) con botón de regreso.
- **Modo claro / oscuro** que recuerda la preferencia de cada usuario.
- **Estilo** con degradados y paneles translúcidos usando la paleta: blanco, pino, teal, aqua, petróleo y bosque.
- **Menú inicial** con accesos a Consulta por cliente y Consulta por médico, búsqueda rápida de CPT y accesos directos a clientes.
- **Selección de cliente** con logotipos: INDEP, BANRURAL, CNBV, BANCOMEXT, BANBIEN y NAFIN.
- **Desplegable de región**:
  - BANRURAL: 11 regiones leídas de `regiones_clientes`.
  - INDEP, JLFC y CNBV: bloqueado (región única, con candado).
- **INDEP conectado a Supabase** (vista `v_tabulador`, región 12):
  - Consulta: Primer contacto (ids 1–4 y 9–12), Segundo contacto (13–47), Tercer contacto (48–53).
  - Hospitalario (especialidad HOSPITALIZACION), Dental (59–107), Proc. en consultorio (108–329) y Quirúrgico (330–2813).
- **Consulta por médico conectada a Supabase**:
  - Búsqueda por **Médico** (nombre, elección entre varios resultados) o por **CPT**.
  - Arriba, tabulador del cliente (`v_med_tab_cliente`). Abajo, tabulador especial (`v_med_tab_especial`), con motivo.
  - Filtro por especialidad en la búsqueda por CPT.
- **Grids**:
  - 10 registros por página con paginado (‹ 1 2 3 … ›).
  - Botón Ampliar a pantalla completa (Esc o clic fuera para cerrar).
  - Costos en formato moneda (MXN).
  - Filtro "CPT o descripción" mientras se escribe.
  - Esqueleto de carga mientras llegan los datos.
- Lectura de tablas grandes en bloques de 1,000 registros (límite de Supabase).

### Eliminado
- Botón temporal "Probar conexión BD" (la conexión a Supabase se conserva).

### Pendiente / conocido
- **Login**: se definirá junto con los otros proyectos. Al hacerlo, cambiar los permisos temporales (`to anon`) por permisos con sesión (`to authenticated`).
- **Permisos temporales activos**: cualquiera con el archivo puede leer `clientes`, `regiones_clientes`, `tabulador_cliente`, `cat_procedimientos`, `medicos` y `tabulador_especial`.
- **Grids de BANRURAL, CNBV, BANCOMEXT, BANBIEN y NAFIN**: sin consultas todavía.
- **Rangos de `id_tabulador_cliente` de INDEP**: válidos solo para una región. Si INDEP agrega regiones, se necesita una columna de clasificación.
- **JLFC**: sin tarjeta en la pantalla de clientes.
- **Botones Médico / CPT**: interpretación inicial, pendiente de confirmar.

### Requisitos en Supabase
- Vistas: `v_tabulador`, `v_med_tab_cliente` y `v_med_tab_especial`.
- Políticas temporales de lectura `to anon` en las 6 tablas.
