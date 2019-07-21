[Forma]
Clave=MaviAlmCapturaServicioFrm
Nombre=Articulos para Servicio
Icono=631
Modulos=(Todos)
ListaCarpetas=CapturaServicio
CarpetaPrincipal=CapturaServicio
PosicionInicialAlturaCliente=273
PosicionInicialAncho=540
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Guardar<BR>AgregarRegServ<BR>EliminarRegServ<BR>CancelaRegServ
AutoGuardar=S
IniciarAgregando=S
PosicionInicialIzquierda=13
PosicionInicialArriba=170
[CapturaServicio]
Estilo=Hoja
Clave=CapturaServicio
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviAlmCapturaServiciosVis
Fuente={Tahoma, 7, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Articulo<BR>MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Serie<BR>MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Empacada<BR>MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Motivo
CarpetaVisible=S
PermiteEditar=S
GuardarAlSalir=S
ConFuenteEspecial=S
[CapturaServicio.Columnas]
Articulo=84
Serie=81
Empacada=54
Motivo=304
Validado=64
Codigo=124
Usuario=64
Transportista=68
FechaRegistro=94
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.AgregarRegServ]
Nombre=AgregarRegServ
Boton=62
NombreDesplegar=Agregar Registro
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
[Acciones.EliminarRegServ]
Nombre=EliminarRegServ
Boton=63
NombreDesplegar=Eliminar Registro
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
VisibleCondicion=1=2<BR>//ESTE BOTON SE PASO A LA FORMA DE MOFICACION DE LA CAPTURA
[Acciones.CancelaRegServ]
Nombre=CancelaRegServ
Boton=21
NombreDesplegar=Cancelar Registro
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[CapturaServicio.MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Articulo]
Carpeta=CapturaServicio
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CapturaServicio.MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Serie]
Carpeta=CapturaServicio
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CapturaServicio.MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Empacada]
Carpeta=CapturaServicio
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Empacada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[CapturaServicio.MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Motivo]
Carpeta=CapturaServicio
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacenTbl.Motivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
