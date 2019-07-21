
[Forma]
Clave=ContSATMetodoPago
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=Métodos de Pago SAT

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=495
PosicionInicialArriba=159
PosicionInicialAlturaCliente=412
PosicionInicialAncho=375
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
[Lista]
Estilo=Hoja
Clave=Lista
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATMetodoPagoLista
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
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
ListaEnCaptura=ContSATMetodoPago.Clave<BR>ContSATMetodoPago.Descripcion

FiltroGeneral={<T>ContSATMetodoPago.Estatus = 1<T>}
[Lista.ContSATMetodoPago.Clave]
Carpeta=Lista
Clave=ContSATMetodoPago.Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.ContSATMetodoPago.Descripcion]
Carpeta=Lista
Clave=ContSATMetodoPago.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[Lista.Columnas]
Clave=64
Descripcion=252

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

