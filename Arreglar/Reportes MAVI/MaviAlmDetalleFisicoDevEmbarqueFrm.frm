[Forma]
Clave=MaviAlmDetalleFisicoDevEmbarqueFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=602
Modulos=(Todos)
ListaCarpetas=Facturas
CarpetaPrincipal=Facturas
PosicionInicialAlturaCliente=241
PosicionInicialAncho=240
PosicionInicialIzquierda=0
PosicionInicialArriba=1
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=82
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Comentarios=<T>Retorno<T>
ListaAcciones=Aceptar<BR>CapturaDatos<BR>Eliminacion<BR>Cambios<BR>EmbarqueCompleto<BR>Actualizar
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Info.ID,nulo)<BR>Asigna(Filtro.actividad,2)
ExpresionesAlCerrar=Asigna(Mavi.AlmacenIdEmbarque,nulo)
[Facturas]
Estilo=Iconos
Clave=Facturas
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=MaviAlmDetalleFisicoEmbarqueVis
Fuente={Tahoma, 7, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Captura Fisica
ConFuenteEspecial=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Factura(s)<T>
ElementosPorPagina=200
IconosNombre=MaviAlmDetalleFisicoEmbarqueVis:Factura
[Facturas.Columnas]
Factura=47
0=-2
1=-2
[Acciones.Captura Fisica]
Nombre=Captura Fisica
Boton=0
NombreDesplegar=Captura de Articulos
EnMenu=S
TipoAccion=Formas
ClaveAccion=MaviAlmCapturaEmbarqueFisicoFrm
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Forma
Activo=S
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
TeclaFuncion=F5
EnBarraHerramientas=S
ConCondicion=S
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIDevEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque) en (<T>Recibe Retorno<T>,<T>Revisar por Caja<T>)))
EjecucionCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIDevEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque) en (<T>Recibe Retorno<T>,<T>Revisar por Caja<T>)))
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
[Artics.Columnas]
0=61
1=72
2=-2
[Acciones.CapturaDatos]
Nombre=CapturaDatos
Boton=39
NombreDesplegar=Capturar Datos
Multiple=S
EnBarraHerramientas=S
Visible=S
ListaAccionesMultiples=AsignaDCaptura<BR>FormaCDatos<BR>ActualizaForma
ActivoCondicion=(SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque) en (<T>Recibe Retorno<T>,<T>Revisar por Caja<T>))
[Acciones.CapturaDatos.AsignaDCaptura]
Nombre=AsignaDCaptura
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque)<BR>Asigna(Mavi.AlmacenIdFactura,MaviAlmDetalleFisicoEmbarqueVis:IDFactuta)<BR>Asigna(Mavi.Factura,MaviAlmDetalleFisicoEmbarqueVis:Mov)
[Acciones.CapturaDatos.FormaCDatos]
Nombre=FormaCDatos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=FormaModal(<T>MaviAlmDevEmbarqueFisicoFrm<T>)
EjecucionCondicion=Condatos(Mavi.AlmacenIdFactura)
EjecucionMensaje=<T>No seleccionó una factura para captura de articulos<T>
[Acciones.Cambios]
Nombre=Cambios
Boton=59
NombreDesplegar=<T>Modifica Captura<T>
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
Multiple=S
ListaAccionesMultiples=FormaCD<BR>ActualizaDC
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIDevEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque) en (<T>Recibe Retorno<T>,<T>Revisar por Caja<T>)))
[Acciones.Eliminacion]
Nombre=Eliminacion
Boton=32
NombreDesplegar=<T>Elimina Capturas<T>
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MaviAlmPassModificacionesFrm
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaDatosElimina<BR>FormaElimina<BR>ActualizaDElimin
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIDevEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque) en (<T>Recibe Retorno<T>,<T>Revisar por Caja<T>)))
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
[Acciones.EmbarqueCompleto]
Nombre=EmbarqueCompleto
Boton=41
NombreDesplegar=<T>Registrar Retorno Completo<T>
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MaviPocketRegistraEmbarqueCompleto :nval1,:tval2<T>,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque,Usuario)<BR>ActualizarForma
ActivoCondicion=(vacio(SQL(<T>Select top 1 (Articulo) from MAVIDevEmbarqueFisicoAlmacen Where idEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))
[Acciones.Eliminacion.AsignaDatosElimina]
Nombre=AsignaDatosElimina
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.AlmacenIdEmbarque,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque)<BR>Asigna(Mavi.AlmacenIdFactura,MaviAlmDetalleFisicoEmbarqueVis:IDFactuta)<BR>Asigna(Mavi.Factura,MaviAlmDetalleFisicoEmbarqueVis:Mov)
Activo=S
Visible=S
[Acciones.Eliminacion.FormaElimina]
Nombre=FormaElimina
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
Expresion=FormaModal(<T>MaviAlmPassModificacionesFrm<T>)
EjecucionCondicion=Condatos(Mavi.AlmacenIdFactura)
EjecucionMensaje=<T>No seleccionó una factura para eliminacion de articulos<T>
[Acciones.CapturaDatos.ActualizaForma]
Nombre=ActualizaForma
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Actualizar Vista
[Acciones.Eliminacion.ActualizaDElimin]
Nombre=ActualizaDElimin
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Cambios.FormaCD]
Nombre=FormaCD
Boton=0
TipoAccion=Expresion
Expresion=Formamodal(<T>MaviAlmCambiaCapturaDevEmbarqueFisicoFrm<T>)
Activo=S
Visible=S
[Acciones.Cambios.ActualizaDC]
Nombre=ActualizaDC
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

