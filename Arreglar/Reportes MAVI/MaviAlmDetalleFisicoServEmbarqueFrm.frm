[Forma]
Clave=MaviAlmDetalleFisicoServEmbarqueFrm
Nombre=<T>Servicio a <T>+Info.MovFactura+<T> <T>+Mavi.Factura
Icono=631
Modulos=(Todos)
ListaCarpetas=Facturas<BR>Artics
CarpetaPrincipal=Facturas
PosicionInicialAlturaCliente=241
PosicionInicialAncho=240
PosicionInicialIzquierda=0
PosicionInicialArriba=1
Menus=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=82
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Comentarios=<T>Servicio<T>
ListaAcciones=Aceptar<BR>CapturaDatos<BR>Eliminacion<BR>Cambios<BR>Actualizar
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.ID,nulo)<BR>Asigna(Filtro.actividad,3)
ExpresionesAlCerrar=Asigna(Mavi.AlmacenIdEmbarque,nulo)
[Facturas]
Estilo=Iconos
Clave=Facturas
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=MaviAlmDetalleFisicoServicioVis
Fuente={Tahoma, 7, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=CapturaServicios
ConFuenteEspecial=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Orden Servicio<T>
ElementosPorPagina=200
IconosNombre=MaviAlmDetalleFisicoServicioVis:OrdenServicio
[Facturas.Columnas]
Factura=47
0=218
1=-2
OrdenServicio=209
[Articulos.Columnas]
Factura=47
Articulo=71
Serie=145
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
[Acciones.Captura Fisica.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=MaviAlmDevEmbarqueFisicoFrm
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=condatos(Mavi.AlmacenIdEmbarque)<BR>Condatos(Mavi.AlmacenIdFactura)
[Acciones.Captura Fisica.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque)<BR>Asigna(Mavi.AlmacenIdFactura,MaviAlmDetalleFisicoEmbarqueVis:IDFactuta)<BR>Asigna(Mavi.Factura,MaviAlmDetalleFisicoEmbarqueVis:Mov)
[Acciones.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
NombreDesplegar=<T>Actualizar<T>
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
TeclaFuncion=F5
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreDesplegar=<T>Actualizar<T>
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5
ConAutoEjecutar=S
TeclaFuncion=F5
EnBarraHerramientas=S
ConCondicion=S
ActivoCondicion=SQL(<T>Select Count(IdEmbarque) from MaviServiciosEmbarqueFisicoalmacen Where IdEmbarque=:nval1<T>,Mavi.AlmIdServiciosAlmacen)> 0
EjecucionCondicion=True<BR>//Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>//Condatos(Info.Id)
AutoEjecutarExpresion=5
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Procesar.Proceso]
Nombre=Proceso
Boton=0
TipoAccion=Expresion
Expresion=Asigna()
Activo=S
Visible=S
[Acciones.Procesar.Afectarr]
Nombre=Afectarr
Boton=0
Activo=S
Visible=S
[Articulos.MaviAlmDevEmbarqueFisicoTbl.Articulo]
Carpeta=Articulos
Clave=MaviAlmDevEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Articulos.MaviAlmDevEmbarqueFisicoTbl.Serie]
Carpeta=Articulos
Clave=MaviAlmDevEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Articulos.MaviAlmDevEmbarqueFisicoTbl.FechaRegistro]
Carpeta=Articulos
Clave=MaviAlmDevEmbarqueFisicoTbl.FechaRegistro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Arts.MaviAlmDevEmbarqueFisicoTbl.Serie]
Carpeta=Arts
Clave=MaviAlmDevEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Arts.Columnas]
0=-2
1=-2
[Artics]
Estilo=Iconos
Clave=Artics
AlineacionAutomatica=S
AcomodarTexto=S
Zona=B1
Vista=MaviAlmDetalleCaptServVis
Fuente={Arial, 7, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Articulo<T>
ElementosPorPagina=200
ConFuenteEspecial=S
ListaEnCaptura=Articulo<BR>Serie
IconosNombre=MaviAlmDetalleCaptServVis:Cuenta
[Artics.Columnas]
0=64
1=68
2=84
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
[Acciones.CapturaServicios]
Nombre=CapturaServicios
Boton=0
NombreDesplegar=Captura de Articulos
Multiple=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=MaviAlmCapturaEmbarqueFisicoFrm
Activo=S
Visible=S
ListaAccionesMultiples=FormaServicio
[Acciones.CapturaServicios.FormaServicio]
Nombre=FormaServicio
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MaviAlmCapturaServicioFrm
[Acciones.CapturaDatos]
Nombre=CapturaDatos
Boton=39
NombreDesplegar=Capturar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=AsignaDatosServicios<BR>FormaCaptura<BR>ActualizaDCaptServ
[Acciones.CapturaDatos.AsignaDatosServicios]
Nombre=AsignaDatosServicios
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,Mavi.AlmIdServiciosAlmacen)<BR>Asigna(Mavi.AlmacenIdFactura,MaviAlmDetalleCaptServVis:IdFactura)<BR>Asigna(Mavi.Factura,MaviAlmDetalleFisicoServicioVis:movid)
[Acciones.CapturaDatos.FormaCaptura]
Nombre=FormaCaptura
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmCapturaServicioFrm<T>)
[Artics.Serie]
Carpeta=Artics
Clave=Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cambios]
Nombre=Cambios
Boton=59
NombreDesplegar=<T>Modifica Captura<T>
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
Multiple=S
ListaAccionesMultiples=FormaCambServ<BR>ActualizaCambServ
ActivoCondicion=Asigna(Info.Id,SQL(<T>Select IdEmbarque from MAVIServiciosEmbarqueFisicoAlmacen where idembarque=:nval1<T>,Mavi.AlmIdServiciosAlmacen))<BR>Condatos(Info.Id)
[Acciones.Eliminacion]
Nombre=Eliminacion
Boton=32
NombreDesplegar=<T>Modifica Captura<T>
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviAlmPassModificacionesFrm
Visible=S
Multiple=S
ListaAccionesMultiples=FormaPassElimSer<BR>ActualizaElimServ
ActivoCondicion=Asigna(Info.Id,SQL(<T>Select IdEmbarque from MAVIServiciosEmbarqueFisicoAlmacen where idembarque=:nval1<T>,Mavi.AlmIdServiciosAlmacen))<BR>Condatos(Info.Id)
[Artics.Articulo]
Carpeta=Artics
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CapturaDatos.ActualizaDCaptServ]
Nombre=ActualizaDCaptServ
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminacion.FormaPassElimSer]
Nombre=FormaPassElimSer
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmPassModificacionesFrm<T>)
Activo=S
Visible=S
[Acciones.Eliminacion.ActualizaElimServ]
Nombre=ActualizaElimServ
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Cambios.FormaCambServ]
Nombre=FormaCambServ
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmCambiaCapturaServiciosEmbarqueFrm<T>)
Activo=S
Visible=S
[Acciones.Cambios.ActualizaCambServ]
Nombre=ActualizaCambServ
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

