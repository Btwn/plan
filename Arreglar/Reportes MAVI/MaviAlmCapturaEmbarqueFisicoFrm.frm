[Forma]
Clave=MaviAlmCapturaEmbarqueFisicoFrm
Nombre=Captura Fisica
Icono=122
Modulos=(Todos)
ListaCarpetas=Capturas
CarpetaPrincipal=Capturas
AutoGuardar=S
IniciarAgregando=S
PosicionInicialAlturaCliente=240
PosicionInicialAncho=239
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Guardar<BR>Eliminar Registro<BR>Agregar Registro<BR>Cancelar Registro
Comentarios=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaSiempreAlFrente=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=//Aqui insertamos los valores por default a la tabla<BR>Asigna(Mavi.AlmRealizoCapturaFisica,0)
[Capturas]
Estilo=Hoja
Clave=Capturas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviAlmCapturaEmbarqueFisicoVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
PermiteEditar=S
GuardarPorRegistro=S
ListaEnCaptura=MaviAlmCapturaEmbarqueFisicoTbl.Articulo<BR>MaviAlmCapturaEmbarqueFisicoTbl.Serie
CarpetaVisible=S
[Capturas.MaviAlmCapturaEmbarqueFisicoTbl.Articulo]
Carpeta=Capturas
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Capturas.MaviAlmCapturaEmbarqueFisicoTbl.Serie]
Carpeta=Capturas
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Capturas.Columnas]
Articulo=86
Serie=124
id=5

; MODIFICACION VICTOR DE LOS SANTOS 05/05/2011 SE COMVIRTIO EN ACCION MULTIPLE
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Cerrar<BR>Elim<BR>Guard


; MODIFICACION VICTOR DE LOS SANTOS 05/05/2011 SE AGREGO ACCION ELIMINAR
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guarda<BR>Elimina<BR>Cierra

;NUEVA MODIFICACION VICTOR DE LOS SANTOS 05/05/2011
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

;NUEVA MODIFICACION VICTOR DE LOS SANTOS 05/05/2011
[Acciones.Aceptar.Elim]
Nombre=Elim
Boton=0
TipoAccion=expresion
Expresion=ejecutarsql(<T>SP_MaviEliminaEmbarqueFisico<T>)
Activo=S
Visible=S

;NUEVA MODIFICACION VICTOR DE LOS SANTOS 05/05/2011
[Acciones.Aceptar.Guard]
Nombre=Guard
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

;NUEVA MODIFICACION VICTOR DE LOS SANTOS 05/05/2011
[Acciones.Guardar.Elimina]
Nombre=Elimina
Boton=0
TipoAccion=Expresion
Expresion=ejecutarsql(<T>SP_MaviEliminaEmbarqueFisico<T>)
Activo=S
Visible=S

[Acciones.Eliminar Registro]
Nombre=Eliminar Registro
Boton=63
NombreDesplegar=<T>Eliminar Registro<T>
EnBarraHerramientas=S
Activo=S
ConfirmarAntes=S
DialogoMensaje=EstaSeguroEliminar
Carpeta=Capturas
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Multiple=S
ListaAccionesMultiples=Eliminalo<BR>GuardarCambios
Antes=S
AntesExpresiones=informacion(MaviAlmCapturaEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.id)<BR>informacion(MaviAlmCapturaEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.Articulo)<BR>informacion(MaviAlmCapturaEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.Serie)
VisibleCondicion=1=2<BR>//ESTE BOTON SE PASO A LA FORMA DE MODIFICACIONES DE CAPTURA
[Acciones.Agregar Registro]
Nombre=Agregar Registro
Boton=62
NombreDesplegar=AgregarRegistro
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=Capturas
TipoAccion=Controles Captura
ClaveAccion=Registro Insertar
[Acciones.Cancelar Registro]
Nombre=Cancelar Registro
Boton=21
NombreDesplegar=CancelarRegistro
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=Capturas
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Cierra]
Nombre=Cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar Registro.Eliminalo]
Nombre=Eliminalo
Boton=0
Carpeta=Capturas
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar Registro.GuardarCambios]
Nombre=GuardarCambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

