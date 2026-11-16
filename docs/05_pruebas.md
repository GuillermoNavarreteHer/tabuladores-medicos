# 5. Pruebas

Marca ✅ o ❌ en la columna **Obtenido** al probar cada versión.

## 5.1 Conteos de datos (contra Supabase)
Corre `sql/03_consultas_verificacion.sql` y compara con lo que muestra la app.

| ID | Cliente | Grid | Esperado | Obtenido |
|---|---|---|---|---|
| D-01 | INDEP | Primer / Segundo / Tercer contacto | 8 / 35 / 6 | |
| D-02 | INDEP | Hospitalario / Dental / Consultorio / Quirúrgico | 5 / 49 / 222 / 2,484 | |
| D-03 | CNBV | Visita dom. / 1er / 2º / Especialidad | 20 / 4 / 4 / 36 | |
| D-04 | CNBV | Proc. consultorios / Quirúrgico / Rehabilitación / Odontología | 2 / 2,184 / 14 / 87 | |
| D-05 | BANRURAL | Primer / Segundo / Tercer / Hospitalario | 7 / 37 / 6 / 5 | |
| D-06 | BANRURAL (cualquier región) | Quirúrgico / Consultorio / Dental | 2,489 / 227 / 49 | |

## 5.2 Funcionales
| ID | Caso | Pasos | Resultado esperado | Obtenido |
|---|---|---|---|---|
| F-01 | Login | Escribir cualquier usuario y dar Entrar | Abre el menú inicial | |
| F-02 | Navegación | Clic en la barra de ubicación | Regresa a esa pantalla | |
| F-03 | Modo oscuro | Clic en Modo oscuro y recargar | Se mantiene el modo elegido | |
| F-04 | Región oculta | Entrar a INDEP y CNBV | No aparece Región | |
| F-05 | Región BANRURAL | Pestaña Consulta | Sin desplegable; aviso "Mismos precios para todas las regiones." | |
| F-06 | Región BANRURAL | Pestaña Quirúrgico → elegir MÉRIDA | Carga sus datos con la columna Región = MÉRIDA | |
| F-07 | Región 19 oculta | Abrir el desplegable en BANRURAL | 11 regiones, sin "BANRURAL" | |
| F-08 | Filtro en vivo | Escribir un CPT en "CPT o descripción" | Filtra sin Enter | |
| F-09 | Paginado | Grid con más de 10 registros | Aparecen ‹ 1 2 … › | |
| F-10 | Ampliar | Clic en Ampliar y luego Esc | Abre a pantalla completa y cierra | |
| F-11 | Descargar buscados | Filtrar Quirúrgico → Descargar datos buscados | El Excel trae solo lo filtrado | |
| F-12 | Descargar concentrado | Descargar concentrado | Hoja "Concentrado" + una hoja por tabla | |
| F-13 | Médico en vivo | Escribir "fab" en Médico | Aparecen resultados sin Enter | |
| F-14 | Sin JLFC | Buscar un médico de INDEP/JLFC | Solo aparece INDEP | |
| F-15 | Combos del médico | Buscar un médico | Especialidad y Cliente muestran solo los suyos | |
| F-16 | Filtro por combo | Elegir un cliente en el combo | La tabla se filtra al momento | |
| F-17 | Vaciar | Borrar Médico y CPT | Los combos vuelven a la lista completa | |
| F-18 | Origen | Médico con precio especial | Columna Origen = "Tabulador especial" | |
| F-19 | Exportar por cliente | Exportar por cliente | Un archivo por cliente | |
| F-21 | Modo demo | Abrir `index.html?demo` y recorrer INDEP, CNBV, BANRURAL y Por médico | Etiqueta "MODO DEMO"; mismos conteos que en 5.1 | |
| F-20 | Búsqueda rápida | Escribir un CPT en el menú inicial | Abre Por médico con el CPT buscado | |

## 5.3 No funcionales
| ID | Caso | Esperado | Obtenido |
|---|---|---|---|
| N-01 | Consola del navegador (F12) | Sin errores en rojo | |
| N-02 | Celular / pantalla angosta | Menú con iconos y tablas con desplazamiento horizontal | |
| N-03 | Quirúrgico (2,000+ registros) | Carga completa, en bloques de 1,000 | |
| N-04 | Columnas fiscales (con script 04) | `medicos?select=rfc` sin sesión → error de permiso | |
