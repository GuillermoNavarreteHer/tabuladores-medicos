# 3. Mapa de consultas

Todas las consultas de **Por cliente** van a `v_tabulador`, filtran por `id_region` y por rangos de `id_tabulador_cliente`, y leen en bloques de 1,000 filas.

Columnas que se muestran en cada grid:
- **Contacto**: CPT · Especialidad (`concepto`) · Costo
- **Hospitalario**: CPT · Concepto · Costo
- **CPT**: CPT · Especialidad · Concepto · Costo
- **CPT+Región**: CPT · Especialidad · Concepto · Costo · Región

## 3.1 Por cliente · INDEP (id_cliente 2, región 12)
| Pestaña | Grid | Filtro | Columnas | Registros |
|---|---|---|---|---|
| Consulta | Primer contacto | especialidad = CONSULTAS; id 1–4 **y** 9–12 | Contacto | 8 |
| Consulta | Segundo contacto | CONSULTAS; 13–47 | Contacto | 35 |
| Consulta | Tercer contacto | CONSULTAS; 48–53 | Contacto | 6 |
| Hospitalario | Hospitalario | especialidad = HOSPITALIZACION | Hospitalario | 5 |
| Quirúrgico | Quirúrgico | 330–2813 | CPT | 2,484 |
| Proc. en consultorio | Proc. en consultorio | 108–329 | CPT | 222 |
| Dental | Dental | 59–107 | CPT | 49 |

## 3.2 Por cliente · CNBV (id_cliente 4, región 14)
| Pestaña | Grid | Rango | Columnas | Registros |
|---|---|---|---|---|
| Honorarios médicos | Visita domiciliaria · Primer contacto | 2814–2833 | Contacto | 20 |
| Honorarios médicos | Primer contacto | 2834–2837 | Contacto | 4 |
| Honorarios médicos | Segundo contacto | 2838–2841 | Contacto | 4 |
| Honorarios médicos | Consulta de especialidad | 2842–2877 | Contacto | 36 |
| Procedimientos en consultorios | — | 2878–2879 | CPT | 2 |
| Quirúrgico | — | 2880–5063 | CPT | 2,184 |
| Rehabilitación | — | 5064–5077 | CPT | 14 |
| Odontología | — | 5078–5164 | CPT | 87 |

## 3.3 Por cliente · BANRURAL (id_cliente 1, 11 regiones)
| Pestaña | Grid | Rango | Región | Columnas | Registros |
|---|---|---|---|---|---|
| Consulta | Primer contacto | 5165–5171 | Siempre 19 | Contacto | 7 |
| Consulta | Segundo contacto | 5172–5208 | Siempre 19 | Contacto | 37 |
| Consulta | Tercer contacto | 5209–5214 | Siempre 19 | Contacto | 6 |
| Hospitalario | — | 5215–5219 | Siempre 19 | Hospitalario | 5 |
| Quirúrgico | — | 5220–32598 | La elegida | CPT+Región | 2,489 por región |
| Proc. en consultorio | — | 32599–35095 | La elegida | CPT+Región | 227 por región |
| Dental | — | 35096–35634 | La elegida | CPT | 49 por región |

**Reglas:**
- Consulta y Hospitalario tienen el mismo precio en todas las regiones, así que no muestran el desplegable de región.
- La región 19 no se ofrece en el desplegable.

## 3.4 Datos generales del cliente
| Dato | Consulta |
|---|---|
| Nombre | `clientes` → `descripcion` where `id_cliente = ?` |
| Regiones | `regiones_clientes` → `id_region, descripcion` where `id_cliente = ?` |

## 3.5 Por médico
| Parámetro | Campo | Operación |
|---|---|---|
| Médico | `nombre_medico` | `ilike` flexible: sin mayúsculas ni acentos, desde 2 letras |
| Especialidad (combo) | `especialidad` | `eq` (si el combo muestra el catálogo) o filtro en pantalla |
| Cliente (combo) | `cliente` | `eq` o filtro en pantalla |
| CPT | `cpt` | `ilike '%texto%'` |
| (siempre) | `cliente` | `neq 'JLFC'` |

Se consultan **dos vistas** con los mismos filtros y se unen en un solo grid:

| Vista | Origen mostrado |
|---|---|
| `v_med_tab_cliente` | Tabulador cliente |
| `v_med_tab_especial` | Tabulador especial (incluye autorizaciones) |

Columnas: Médico · CPT · Descripción · Tipo de servicio · Especialidad · Cédula · Cliente · Región · Costo · Origen.

Catálogos de los combos: especialidades distintas de `medicos` y clientes de `clientes` (sin JLFC).

## 3.6 Exportaciones a Excel
| Pantalla | Opción | Contenido | Nombre del archivo |
|---|---|---|---|
| Por cliente | Datos buscados | Pestaña actual con filtro; una hoja por tabla | `Tabulador_<CLIENTE>[_<REGIÓN>]_<PESTAÑA>[_<FILTRO>]_<fecha>.xlsx` |
| Por cliente | Concentrado | Todas las pestañas, sin filtros; hoja "Concentrado" + una por tabla | `Tabulador_<CLIENTE>[_<REGIÓN>]_CONCENTRADO_<fecha>.xlsx` |
| Por médico | Concentrado | Filas visibles | `Tabuladores_<BÚSQUEDA>_CONCENTRADO_<fecha>.xlsx` |
| Por médico | Por cliente | Un archivo por cliente | `Tabuladores_<BÚSQUEDA>_<CLIENTE>_<fecha>.xlsx` |
