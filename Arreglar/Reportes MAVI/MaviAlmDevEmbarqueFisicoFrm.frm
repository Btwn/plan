[Forma]
Clave=MaviAlmDevEmbarqueFisicoFrm
Nombre=Si(Mavi.Factura<><T>Orden Traspaso<T>,Mavi.Factura+<T> <T>+SQL(<T>Select MovID from venta where ID=:nval1<T>,Mavi.AlmacenIdFactura),Mavi.Factura+<T> <T>+SQL(<T>Select MovID from Inv where ID=:nval1<T>,Mavi.AlmacenIdFactura))
Icono=602
Modulos=(Todos)
ListaCarpetas=Devolucion
CarpetaPrincipal=Devolucion
PosicionInicialAlturaCliente=239
PosicionInicialAncho=241
PosicionInicialIzquierda=-1
PosicionInicialArriba=4
AccionesTamanoBoton=3x3
AccionesDerecha=S
BarraHerramientas=S
AccionesDivision=S
ListaAcciones=Guardar<BR>Eliminar Registro<BR>Agregar Registro<BR>Cancelar Registro
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=53
AutoGuardar=S
IniciarAgregando=S
Nombre002=<CONTINUA>,Mavi.AlmacenIdFactura),)
Comentarios=si((Posicion(<T>Factura Mayoreo<T>,Mavi.Factura)) >0,<T>Parcial/Completo<T>,si((Posicion(<T>Traspaso<T>,Mavi.Factura)) >0 , <T>Parcial/Completo<T>,<T>Completo<T>))<BR>//si((Posicion(<T>Traspaso<T>,Mavi.Factura)) >0 , <T>Parcial/Completo<T>,<T>Completo<T>)<BR>//Informacion(Posicion(<T>Factura Mayoreo<T>,Mavi.Factura))<BR>//Informacion(Posicion(<T>Traspaso<T>,Mavi.Factura))<BR>//Informacion(Mavi.Factura)<BR>//Si(Mavi.Factura=<T>Factura Mayoreo<T>,<T>Parcial/Completo<T>,<T><T>)<BR>//Si(Mavi.Factura=<T>Traspaso<T>,<T>Parcial/Completo<T>,<T><T>)<BR>//Si(((Mavi.Factura <> <T>Traspaso<T>) y (Mavi.Factura <> <T>Factura Mayoreo<T>)) ,<T>Completo<T>,<T><T>)<BR>//Informacion( Posicion(<T>Factura Mayoreo<T>,Mavi.Factura))
ExpresionesAlMostrar=//Aqui insertamos los valores por default a la tabla<BR>Asigna(Mavi.AlmRealizoCapturaFisica,0)
ExpresionesAlCerrar=//Asigna(Mavi.Factura,nulo)
[Detalle.Columnas]
ID=64
IDEmbarque=64
IDFactura=64
Articulo=45
Serie=94
Validado=64
FechaRegistro=94
Usuario=304
[Captura.Columnas]
Articulo=62
Serie=134
ID=44
IDEmbarque=74
IDFactura=60
Validado=52
FechaRegistro=85
Usuario=204
[(Variable).Mavi.AlmacenIdEmbarque]
Carpeta=(Variable)
Clave=Mavi.AlmacenIdEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=<T>&Guardar y Cerrar <T>
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
ListaAccionesMultiples=Guardar<BR>Cerrar
Activo=S
Visible=S
[Acciones.Eliminar Registro]
Nombre=Eliminar Registro
Boton=63
NombreDesplegar=<T>Eliminar Registro<T>
EnBarraHerramientas=S
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
ConfirmarAntes=S
DialogoMensaje=EstaSeguroEliminar
Multiple=S
ListaAccionesMultiples=Valida<BR>Elimina<BR>CambiaValor
VisibleCondicion=1=2<BR>//ESTE BOTON SE PASO A LA FORMA DE MODIFICACIONES DE LA CAPTURA
[Acciones.Agregar Registro]
Nombre=Agregar Registro
Boton=62
NombreDesplegar=<T>Agregar un Registro<T>
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Insertar
Activo=S
Visible=S
[Acciones.Cancelar Registro]
Nombre=Cancelar Registro
Boton=21
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
Activo=S
Visible=S
NombreDesplegar=<T>Cancelar Registro<T>
[Devolucion]
Estilo=Hoja
Clave=Devolucion
PermiteEditar=S
GuardarAlSalir=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviAlmCapturaDevEmbarqueFisicoVis
ConFuenteEspecial=S
Fuente={Tahoma, 6, Negro, []}
HojaTitulos=S
HojaIndicador=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaTitulosEnBold=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=MaviAlmDevEmbarqueFisicoTbl.Articulo<BR>MaviAlmDevEmbarqueFisicoTbl.Serie
[Acciones.Eliminar Registro.Valida]
Nombre=Valida
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
Activo=S
Visible=S
[Acciones.Eliminar Registro.Elimina]
Nombre=Elimina
Boton=0
Carpeta=Devolucion
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.Eliminar Registro.CambiaValor]
Nombre=CambiaValor
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
Activo=S
Visible=S
[Devolucion.Columnas]
Articulo=84
Serie=84
Codigo=84
Empacada=62
Motivo=204
Unidad=44
[Devolucion.MaviAlmDevEmbarqueFisicoTbl.Serie]
Carpeta=Devolucion
Clave=MaviAlmDevEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Devolucion.MaviAlmDevEmbarqueFisicoTbl.Articulo]
Carpeta=Devolucion
Clave=MaviAlmDevEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

