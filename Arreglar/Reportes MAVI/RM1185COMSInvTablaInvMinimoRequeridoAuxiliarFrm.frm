
[Forma]
Clave=RM1185COMSInvTablaInvMinimoRequeridoAuxiliarFrm
Icono=132
Modulos=(Todos)

CarpetaPrincipal=Temporal
PosicionInicialAlturaCliente=479
PosicionInicialAncho=852
PosicionInicialIzquierda=214
PosicionInicialArriba=253
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar<BR>Eliminar<BR>Cerrar<BR>AlmacenaEnTabla
Nombre=<T>Tabla De Inventario Minimo Requerido<T>
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal

PosicionSec1=132
VentanaBloquearAjuste=S
ListaCarpetas=Temporal
VentanaSinIconosMarco=S
ExpresionesAlMostrar=EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nSpid<T>,1,usuario,SQL(<T>SELECT @@SPID<T>))<BR>ActualizarForma
ExpresionesAlCerrar=EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nSpid<T>,5,usuario,SQL(<T>SELECT @@SPID<T>))
ExpresionesAlActivar=//Forma.Accion(<T>Importar<T>)
[RM1185COMSTablaInvMinimoRequeridoPorLineaVis.Columnas]
Articulo=124
Descripcion=604
MinimoExhibicion=83

[Acciones.Importar]
Nombre=Importar
Boton=115
NombreEnBoton=S
NombreDesplegar=Importar Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Enviar/Recibir Excel
[Acciones.Guardar]
Nombre=Guardar
Boton=23
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S



Multiple=S
ListaAccionesMultiples=Registro Siguiente<BR>Guardar Cambios<BR>expresion

[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Temporal.RM1185COMSTablaInvMinimoRequeridoTempTbl.Articulo]
Carpeta=Temporal
Clave=RM1185COMSTablaInvMinimoRequeridoTempTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Temporal.RM1185COMSTablaInvMinimoRequeridoTempTbl.Descripcion]
Carpeta=Temporal
Clave=RM1185COMSTablaInvMinimoRequeridoTempTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Temporal.RM1185COMSTablaInvMinimoRequeridoTempTbl.MinimoExhibicion]
Carpeta=Temporal
Clave=RM1185COMSTablaInvMinimoRequeridoTempTbl.MinimoExhibicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Original.RM1185COMSTablaInvMinimoRequeridoTbl.Articulo]
Carpeta=Original
Clave=RM1185COMSTablaInvMinimoRequeridoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Original.RM1185COMSTablaInvMinimoRequeridoTbl.Descripcion]
Carpeta=Original
Clave=RM1185COMSTablaInvMinimoRequeridoTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Original.RM1185COMSTablaInvMinimoRequeridoTbl.MinimoExhibicion]
Carpeta=Original
Clave=RM1185COMSTablaInvMinimoRequeridoTbl.MinimoExhibicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Temporal.Columnas]
Articulo=124
Descripcion=604
MinimoExhibicion=83

[Original.Columnas]
Articulo=124
Descripcion=604
MinimoExhibicion=83


[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S





[Acciones.AlmacenaEnTabla]
Nombre=AlmacenaEnTabla
Boton=0
Activo=S
ConCondicion=S
Visible=S



TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Expresion<BR>Actualiza
EjecucionCondicion=//Verificar si existen articulos duplicados en el archivo<BR>Si<BR>SQL(<T>SELECT COUNT(*)<BR>     FROM(<BR>          SELECT ROW_NUMBER() OVER (PARTITION BY Articulo ORDER BY Articulo) AS NumeroRenglon<BR>          FROM COMSDRM1185InvMinimoRequeridoTemp WITH(NOLOCK)<BR>          WHERE Usuario=:tUsuario<BR>          AND Spid = :nSpid<BR>         )EncuentraDuplicados<BR>     WHERE NumeroRenglon >1<T>,usuario,SQL(<T>SELECT @@SPID<T>)) > 0<BR>Entonces<BR>  Informacion(<T>El archivo Excel o los datos que trata de ingresar contiene articulos duplicados<T><BR>               +NuevaLinea+<BR>               <T>Por favor corrija el archivo Excel o los datos que intenta ingresar<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR>                                                                <BR>//Verificar si hay valores nulos en las columnas correspondientes a Articulo        <BR>Si<BR>SQL(<T>SELECT COUNT(t.Articulo)<BR>     FROM (SELECT Usuario, Spid,<BR>     ISNULL(Articulo, <T>+ Comillas(<T>Nulo<T>)+<T>) Articulo<BR>     FROM COMSDRM1185InvMinimoRequeridoTemp WITH(NOLOCK)<BR>     WHERE Articulo IS NULL<BR>     AND Spid = :nSpid) t<T>,SQL(<T>SELECT @@SPID<T>)) > 0<BR>Entonces<BR>  Informacion(<T>El archivo Excel o los datos que trata de ingresar<T><BR>               +NuevaLinea+<BR>               <T>contiene valores vacios en la columna correspondiente a <Articulo><T><BR>               +NuevaLinea+<BR>               <T>Por favor corrija el archivo Excel o los datos que intenta ingresar<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>//Verificar si hay valores nulos en las columnas correspondientes a Minimo Exhibicion<BR>Si<BR>SQL(<T>SELECT COUNT(t.MinimoExhibicion)<BR>     FROM (SELECT Usuario, Spid,     <BR>     ISNULL(MinimoExhibicion, -1) MinimoExhibicion  <BR>     FROM COMSDRM1185InvMinimoRequeridoTemp WITH(NOLOCK)<BR>     WHERE MinimoExhibicion IS NULL<BR>     AND Spid = :nSpid) t<T>,SQL(<T>SELECT @@SPID<T>)) > 0<BR>Entonces<BR>  Informacion(<T>El archivo Excel o los datos que trata de ingresar<T>+<BR>               NuevaLinea+<BR>               <T>contiene valores vacios en la columna correspondiente a <MinimoExhibicion><T><BR>               +NuevaLinea+<BR>               <T>Por favor corrija el archivo Excel o los datos que intenta ingresar<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>//Verificar que los articulos a capturar sean validos<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM(<BR>            SELECT T.Articulo<BR>            FROM COMSDRM1185InvMinimoRequeridoTemp T WITH(NOLOCK)<BR>            LEFT JOIN Art A WITH(NOLOCK)<BR>            ON A.Articulo=T.Articulo<BR>            WHERE A.Articulo IS NULL<BR>            AND Spid = :nSpid)NoValidos<T>,SQL(<T>SELECT @@SPID<T>))>0<BR>Entonces<BR>  Informacion(<T>El archivo Excel o los datos que trata de ingresar contiene articulos no validos:<T><BR>  +NuevaLinea+NuevaLinea+<BR>  SQLEnLista(<T>SELECT T.Articulo<BR>       FROM COMSDRM1185InvMinimoRequeridoTemp T WITH(NOLOCK)<BR>       LEFT JOIN Art A WITH(NOLOCK)<BR>       ON A.Articulo=T.Articulo<BR>       WHERE A.Articulo IS NULL<BR>       AND Spid = :nSpid<T>,SQL(<T>SELECT @@SPID<T>)   <BR>      )<BR>  +NuevaLinea+NuevaLinea+  <BR>  <T>Por favor corrija el archivo Excel o los datos que intenta ingresar<T>)<BR>  //EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nEstacionDeTrabajo<T>,1,usuario,estaciontrabajo)<BR>  //ActualizarForma<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Guardar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nEstacionDeTrabajo<T>,3,usuario,estaciontrabajo)<BR>ActualizarForma<BR><BR>Forma.Accion(<T>AlmacenaEnTabla<T>)
[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=105
NombreEnBoton=S
NombreDesplegar=Cerrar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

[Temporal]
Estilo=Hoja
Clave=Temporal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1185COMSTablaInvMinimoRequeridoTempVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1185COMSTablaInvMinimoRequeridoTempTbl.Articulo<BR>RM1185COMSTablaInvMinimoRequeridoTempTbl.Descripcion<BR>RM1185COMSTablaInvMinimoRequeridoTempTbl.MinimoExhibicion
CarpetaVisible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Valida<BR>Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Forma
[Acciones.DescartarCambios.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.DescartarCambios.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Eliminar.Valida]
Nombre=Valida
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  (RM1185COMSTablaInvMinimoRequeridoTempVis:RM1185COMSTablaInvMinimoRequeridoTempTbl.Usuario = <T>RESPA_ORIG<T>)<BR>  y<BR>  (RM1185COMSTablaInvMinimoRequeridoTempVis:RM1185COMSTablaInvMinimoRequeridoTempTbl.Spid = SQL(<T>SELECT @@SPID<T>))<BR>Entonces<BR>  EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tArticulo, :nEstacionDeTrabajo<T>,<BR>               4,<BR>               RM1185COMSTablaInvMinimoRequeridoTempVis:RM1185COMSTablaInvMinimoRequeridoTempTbl.Articulo,<BR>               estaciontrabajo)<BR>  ActualizarForma<BR><BR>Fin
[Acciones.AlmacenaEnTabla.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nEstacionDeTrabajo<T>,<BR>             2,<BR>             usuario,<BR>             SQL(<T>SELECT @@SPID<T>))<BR><BR>Informacion(<T>Se almacenó con exito los cambios<T>)



[Acciones.AlmacenaEnTabla.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Expresion
Expresion=EJECUTARSQL(<T>EXEC dbo.SpCOMSRM1185AnalisisDeInventario :nOpcion, :tUsuario, :nSpid<T>,1,usuario,SQL(<T>SELECT @@SPID<T>))<BR>ActualizarForma
Activo=S
Visible=S

