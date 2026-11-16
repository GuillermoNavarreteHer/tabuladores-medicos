# 2. Base de datos

Supabase (PostgreSQL), esquema `public`. **RLS activado en todas las tablas.**

## 2.1 Diagrama entidad-relación

```mermaid
erDiagram
  clientes ||--o{ regiones_clientes : "tiene"
  regiones_clientes ||--o{ tabulador_cliente : "precios por región"
  cat_procedimientos ||--o{ tabulador_cliente : "procedimiento"
  tabulador_cliente ||--o{ medicos : "id_tabulador_cliente"
  medicos ||--o{ tabulador_especial : "precios especiales"
  cat_procedimientos ||--o{ tabulador_especial : "procedimiento"
  regiones_clientes ||--o{ tabulador_especial : "región"

  clientes {
    numeric id_cliente PK
    varchar descripcion
    varchar estatus
  }
  regiones_clientes {
    numeric id_region PK
    varchar descripcion
    varchar estatus
    numeric id_cliente FK
  }
  cat_procedimientos {
    numeric id_procedimiento PK
    varchar cpt
    varchar descripcion
    varchar tipo_servicio
    varchar estatus
  }
  tabulador_cliente {
    numeric id_tabulador_cliente PK
    numeric id_procedimiento FK
    numeric id_region FK
    varchar descripcion_cliente
    float costo
    varchar especialidad
    varchar estatus
  }
  medicos {
    numeric id_medico PK
    numeric id_tabulador_cliente FK
    varchar nombre_medico
    varchar especialidad
    varchar cedula
    varchar regimen_fiscal
    varchar razon_social
    varchar tipo_proveedor
    varchar rfc
    varchar estatus
  }
  tabulador_especial {
    numeric id_tabulador_especial PK
    numeric id_medico FK
    numeric id_procedimiento FK
    numeric id_region FK
    float costo
    varchar origen
    varchar especialidad
    varchar fecha_inicial
    varchar fecha_final
    varchar motivo
    varchar estatus
  }
```

> Las relaciones se dedujeron de las consultas del proyecto. Para confirmar qué llaves foráneas existen realmente en Supabase, consulta `information_schema.table_constraints`.

## 2.2 Diccionario de datos

### clientes
| Columna | Tipo | Descripción |
|---|---|---|
| id_cliente | numeric | Identificador. 1 = BANRURAL, 2 = INDEP, 4 = CNBV |
| descripcion | varchar | Nombre del cliente (en MAYÚSCULAS) |
| estatus | varchar | Estado del registro |

### regiones_clientes
| Columna | Tipo | Descripción |
|---|---|---|
| id_region | numeric | Identificador de región |
| descripcion | varchar | Nombre (p. ej. MÉRIDA) |
| estatus | varchar | Estado |
| id_cliente | numeric | Cliente al que pertenece |

### cat_procedimientos
| Columna | Tipo | Descripción |
|---|---|---|
| id_procedimiento | numeric | Identificador |
| cpt | varchar | Código CPT (p. ej. 99203, D7110) |
| descripcion | varchar | Descripción del procedimiento |
| tipo_servicio | varchar | Tipo de servicio |
| estatus | varchar | Estado |

### tabulador_cliente
| Columna | Tipo | Descripción |
|---|---|---|
| id_tabulador_cliente | numeric | Identificador. **Sus rangos definen cada grid** (ver [Mapa de consultas](03_mapa_de_consultas.md)) |
| id_procedimiento | numeric | Procedimiento (CPT) |
| id_region | numeric | Región del cliente |
| descripcion_cliente | varchar | Concepto tal como lo nombra el cliente |
| costo | double | Precio |
| especialidad | varchar | Especialidad (p. ej. CONSULTAS, HOSPITALIZACION) |
| estatus | varchar | Estado |

### medicos
| Columna | Tipo | Descripción |
|---|---|---|
| id_medico | numeric | Identificador |
| id_tabulador_cliente | numeric | Registro del tabulador del cliente que le aplica |
| nombre_medico | varchar | Nombre completo |
| especialidad | varchar | Especialidad |
| cedula | varchar | Cédula profesional |
| regimen_fiscal, razon_social, tipo_proveedor, rfc | varchar | **Datos fiscales (sensibles)**. La app no los usa |
| estatus | varchar | Estado |

### tabulador_especial
| Columna | Tipo | Descripción |
|---|---|---|
| id_tabulador_especial | numeric | Identificador |
| id_medico | numeric | Médico |
| id_procedimiento | numeric | Procedimiento |
| id_region | numeric | Región |
| costo | double | Precio especial |
| origen | varchar | Origen del precio |
| especialidad | varchar | Especialidad |
| fecha_inicial, fecha_final | varchar | Vigencia (guardadas como texto) |
| motivo | varchar | Motivo (p. ej. autorización) |
| estatus | varchar | Estado |

## 2.3 Vistas (`sql/01_vistas.sql`)
Todas se crean `with (security_invoker = true)`, así respetan el RLS de las tablas.

| Vista | Une | Columnas | La usa |
|---|---|---|---|
| `v_tabulador` | tabulador_cliente + cat_procedimientos | id_tabulador_cliente, id_region, cpt, especialidad, concepto, costo | Por cliente |
| `v_med_tab_cliente` | medicos + tabulador_cliente + cat_procedimientos + regiones_clientes + clientes | id_medico, nombre_medico, cpt, descripcion, tipo_servicio, especialidad, cedula, costo, cliente, region | Por médico (origen: Tabulador cliente) |
| `v_med_tab_especial` | medicos + tabulador_especial + cat_procedimientos + regiones_clientes + clientes | las mismas + motivo | Por médico (origen: Tabulador especial) |

## 2.4 Datos de referencia
| Cliente | id_cliente | Regiones |
|---|---|---|
| BANRURAL | 1 | 1–11 (MAZATLÁN … PUEBLA) + 19 "BANRURAL", que guarda Consulta y Hospitalario y está oculta en la app |
| INDEP | 2 | 12 |
| CNBV | 4 | 14 |
| JLFC | — | Misma unidad que INDEP; se excluye en Por médico |

## 2.5 Seguridad (RLS)
| Política | Rol | Estado |
|---|---|---|
| "Prueba temporal lectura …" (6 tablas) | `anon` | **Activa (temporal)**: cualquiera con la URL y la clave puede leer |
| "Lectura con sesion" (6 tablas) | `authenticated` | Preparada en `sql/02_…`, se activará con el login |
| Columnas fiscales de `medicos` | `anon` | Bloqueadas con `sql/04_ocultar_datos_sensibles.sql` (recomendado) |

> La clave **publishable** es pública por diseño. La seguridad depende de RLS. La clave `service_role` nunca debe ir en el front ni en el repositorio.
