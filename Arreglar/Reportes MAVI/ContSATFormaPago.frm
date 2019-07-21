
[Forma]
Clave=ContSATFormaPago
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Forma de Pago SAT

ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=410
PosicionInicialArriba=202
PosicionInicialAlturaCliente=324
PosicionInicialAncho=546
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=Guardar<BR>Cancelar
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATFormaPago
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
ListaEnCaptura=ContSATFormaPago.FormaPago<BR>ContSATFormaPago.MetodoPagoSAT<BR>ContSATMetodoPago.Descripcion
CarpetaVisible=S

PermiteEditar=S
[Lista.ContSATFormaPago.FormaPago]
Carpeta=Lista
Clave=ContSATFormaPago.FormaPago
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.ContSATFormaPago.MetodoPagoSAT]
Carpeta=Lista
Clave=ContSATFormaPago.MetodoPagoSAT
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.ContSATMetodoPago.Descripcion]
Carpeta=Lista
Clave=ContSATMetodoPago.Descripcion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[Lista.Columnas]
FormaPago=219
MetodoPagoSAT=64
Descripcion=201

Clave=64
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
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=23
NombreDesplegar=&Guardar y Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar<BR>Cerrar
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar/Cancelar Cambios
Activo=S
Visible=S

