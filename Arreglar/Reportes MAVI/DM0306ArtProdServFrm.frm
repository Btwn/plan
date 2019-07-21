[Forma]
Clave=DM0306ArtProdServFrm
Nombre=Relación de excepciones por Articulo
Icono=0
Modulos=(Todos)
ListaCarpetas=(vista)
CarpetaPrincipal=(vista)
PosicionInicialIzquierda=9
PosicionInicialArriba=31
PosicionInicialAlturaCliente=916
PosicionInicialAncho=1262
PosicionSec1=68
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=guardar<BR>eliminar<BR>Excel<BR>cerrar<BR>cancel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec2=184

VentanaSinIconosMarco=S
ExpresionesAlMostrar=/*EjecutarSQL(<T>EXEC SP_DM0306CFDI :nNUM <T>, 1)*/
[articulo.DM0306AuxiliarTbl.Articulo]
Carpeta=articulo
Clave=DM0306AuxiliarTbl.Articulo
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Editar=S
[articulo.DM0306AuxiliarTbl.Descripcion1]
Carpeta=articulo
Clave=DM0306AuxiliarTbl.Descripcion1
Editar=N
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[clave.DM0306AuxiliarTbl.CveProdServ]
Carpeta=clave
Clave=DM0306AuxiliarTbl.CveProdServ
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[clave.DM0306AuxiliarTbl.Descripcion]
Carpeta=clave
Clave=DM0306AuxiliarTbl.Descripcion
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.guardar]
Nombre=guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=guardar<BR>ActualizaVista

Antes=S
AntesExpresiones=Si<BR>   Vacio(DM0306ArticulosProdServVist:DM0306AuxTbl.CveProdServ)<BR>Entonces<BR>  informacion(<T>El campo Clave SAT debe tener un valor<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.eliminar]
Nombre=eliminar
Boton=32
NombreEnBoton=S
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
ConfirmarAntes=S
Multiple=S
ListaAccionesMultiples=Elim<BR>guardar Cambios
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=C&errar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=cancelar<BR>cerrar
[Acciones.cerrar.cancelar]
Nombre=cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.cerrar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.modificar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.modificar.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.eliminar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.eliminar.actualizaVis]
Nombre=actualizaVis
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.guardar.guardar]
Nombre=guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>   Vacio(DM0306ArticulosProdServVist:DM0306AuxTbl.CveProdServ)<BR>Entonces<BR>  informacion(<T>El campo Clave SAT debe tener un valor<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.guardar.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.cancel]
Nombre=cancel
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[DM0306ClaveSatVist.Columnas]
CveProdServ=77
Descripcion=704

[DM0306Articulo.Columnas]
Articulo=144
Descripcion1=704

[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=DM0306ReporteRepXls
Activo=S
Visible=S

[(vista)]
Estilo=Hoja
Clave=(vista)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0306ArticulosProdServVist
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S





ListaEnCaptura=DM0306AuxTbl.Articulo<BR>Descripcion1<BR>DM0306AuxTbl.CveProdServ<BR>Descrip
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaEnLinea=S
PermiteEditar=S
GuardarPorRegistro=S
[(vista).Columnas]
Articulo=144
Descripcion1=349
CveProdServ=77
Descripcion=704

Descrip=371
[(vista).DM0306AuxTbl.Articulo]
Carpeta=(vista)
Clave=DM0306AuxTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(vista).DM0306AuxTbl.CveProdServ]
Carpeta=(vista)
Clave=DM0306AuxTbl.CveProdServ
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[(vista).Descripcion1]
Carpeta=(vista)
Clave=Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco

[(vista).Descrip]
Carpeta=(vista)
Clave=Descrip
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Acciones.g2.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.g2.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.eliminar.Elim]
Nombre=Elim
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.eliminar.guardar Cambios]
Nombre=guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

