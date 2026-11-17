# 6. Despliegue y mantenimiento

## 6.1 Instalación de la base de datos
En Supabase → **SQL Editor**, corre en orden:
1. `sql/01_vistas.sql`
2. `sql/02_politicas_lectura_temporal.sql`
3. `sql/04_ocultar_datos_sensibles.sql` (recomendado)

## 6.2 Configuración
En `index.html` (al final):

| Constante | Valor |
|---|---|
| `SUPABASE_URL` | `https://<proyecto>.supabase.co` (sin `/rest/v1/`) |
| `SUPABASE_KEY` | Clave **publishable** (`sb_publishable_…`), en Project Settings → API |

## 6.3 Publicación
| Opción | Cómo |
|---|---|
| Local | Doble clic en `index.html` (Chrome o Edge) |
| GitHub Pages | Repositorio → Settings → Pages → Branch `main` / root → https://erosamhi2026.github.io/tabuladores-medicos/ |
| Demo pública | Agregar `?demo` a la dirección: https://erosamhi2026.github.io/tabuladores-medicos/?demo (datos ficticios, sin Supabase) |

**Actualizar en GitHub (sin comandos):**
1. En el repositorio, entra al archivo que cambió, da clic en el lápiz ✏️, pega el contenido nuevo y da **Commit changes**.
2. O usa **Add file → Upload files** y arrastra los archivos nuevos: GitHub los reemplaza.

## 6.4 Versiones
| Cambio | Nueva versión |
|---|---|
| Corrección | 1.0.**1** |
| Función nueva (p. ej. conectar NAFIN, login) | 1.**1**.0 |
| Cambio incompatible | **2**.0.0 |

Al sacar una versión:
1. En `index.html` actualiza `APP_VERSION`, la insignia `v1.x`, `<title>`, `<meta name="version">` y el encabezado.
2. En `CHANGELOG.md` agrega la sección `## [x.y.z] — fecha`.
3. En GitHub ve a **Releases → Create a new release** y crea la etiqueta `vx.y.z`.

## 6.5 Solución de problemas
| Síntoma | Causa probable | Solución |
|---|---|---|
| Grid con "Error: Failed to fetch" | Sin internet, Supabase caído o visor que bloquea | Revisar https://status.supabase.com; abrir en Chrome |
| `DataCloneError … Headers` | Visor que reenvía peticiones (p. ej. vista previa de VS Code) | Ya corregido en v1.0 (`fetchCompatible`); abrir en Chrome |
| Grids vacíos o "0 filas" | RLS sin política de lectura | Correr `sql/02_…` |
| "relation v_tabulador does not exist" | Faltan las vistas | Correr `sql/01_vistas.sql` |
| Región sin datos en Consulta (BANRURAL) | Comportamiento esperado: precio único | Ver Quirúrgico, Consultorio o Dental |
| Excel no descarga | No cargó SheetJS (sin internet) o el navegador bloquea varias descargas | Revisar conexión; permitir descargas múltiples |
| Proyecto pausado | Plan gratuito de Supabase sin uso | Reactivar en el panel de Supabase |

## 6.6 Pendientes del proyecto
- Login real (Supabase Auth, compartido con otros proyectos). Después, cambiar a políticas `authenticated`.
- Consultas de BANCOMEXT, BANBIEN, NAFIN y JLFC.
- Limpieza de código sin uso (ver [Manual técnico](01_manual_tecnico.md#18-deuda-técnica-conocida)).
- Columna de clasificación en `tabulador_cliente` para no depender de rangos de ids.
