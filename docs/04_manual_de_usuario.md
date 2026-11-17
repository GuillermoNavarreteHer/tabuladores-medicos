# 4. Manual de usuario

## 4.1 Entrar
1. Abre la aplicación en Chrome o Edge (doble clic en `index.html`) o en su dirección web.
2. Escribe tu **Usuario** y **Contraseña** y presiona **Entrar**.
   > En esta versión el acceso es de prueba y no valida usuarios.

> **Demo:** agrega `?demo` al final de la dirección para probar el sistema con datos ficticios.

## 4.2 Moverse por el sistema
- **Menú superior**: Inicio, Por cliente, Por médico. Catálogos estará disponible después.
- **Barra de ubicación** (debajo del menú): muestra dónde estás, p. ej. *Menú inicial › Selecciona cliente › BANRURAL*. Da clic en cualquier parte para regresar; la flecha ‹ sube un nivel.
- **Modo claro / oscuro**: botón con luna o sol, arriba a la derecha.
- **Salir**: cierra la sesión.

## 4.3 Consultar por cliente
1. Ve a **Por cliente** y da clic en el logotipo del cliente.
2. Usa **Seleccionar cliente** para cambiar de cliente sin regresar.
3. **Región** aparece solo cuando hace falta:
   - INDEP y CNBV trabajan con una sola región, así que no la piden.
   - En BANRURAL, Consulta y Hospitalario tienen **los mismos precios en todas las regiones**. Quirúrgico, Proc. en consultorio y Dental piden elegir región.
4. Elige una **pestaña**: Consulta, Hospitalario, Quirúrgico, etc. CNBV tiene sus propias pestañas: Honorarios médicos, Rehabilitación, Odontología…
5. Escribe en **CPT o descripción** para filtrar. La tabla se actualiza mientras escribes.

### Descargar a Excel
Botón **Descargar Excel**:
- **Descargar datos buscados**: lo que ves en la pestaña actual, con tu filtro.
- **Descargar concentrado**: todo el tabulador del cliente, de todas las pestañas.

## 4.4 Consultar por médico
1. Ve a **Por médico**.
2. Llena uno o varios campos. Los resultados aparecen solos, sin Enter:
   - **Médico**: parte del nombre, sin importar acentos ni mayúsculas (p. ej. "fabia").
   - **Especialidad**: elige de la lista.
   - **Cliente**: elige de la lista.
   - **CPT**: el código (p. ej. D7110).
3. Al encontrar un médico, las listas **Especialidad** y **Cliente** muestran solo las suyas (p. ej. *BANRURAL e INDEP*). Elegir una filtra la tabla al momento.
4. La columna **Origen** indica si el precio viene del **Tabulador cliente** o del **Tabulador especial**.
5. Para empezar de nuevo, borra el médico y el CPT.

> JLFC e INDEP son la misma unidad: solo se muestran los registros de INDEP.

### Exportar a Excel
Botón **Exportar a Excel**:
- **Exportar concentrado**: un archivo con lo que muestra la tabla.
- **Exportar por cliente**: un archivo por cada cliente. Si el navegador lo pregunta, permite **descargar varios archivos**.

## 4.5 Uso de las tablas
- **10 registros por página**. Usa los números de abajo (‹ 1 2 3 ›) para avanzar.
- **Ampliar**: abre la tabla en pantalla completa. Se cierra con **Cerrar**, la tecla **Esc** o un clic afuera.
- Mientras carga se ven **barras grises animadas**: espera un momento.

## 4.6 Mensajes comunes
| Mensaje | Qué hacer |
|---|---|
| "Selecciona una región" | Elige una región arriba |
| "Escribe al menos 2 letras del nombre del médico…" | Sigue escribiendo |
| "Sin resultados para …" | Revisa lo que escribiste o prueba con menos letras |
| "Error: …" | Revisa tu internet. Si sigue, avisa a sistemas con el mensaje completo |
