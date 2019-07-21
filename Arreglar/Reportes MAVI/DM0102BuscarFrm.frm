
[Forma]
Clave=DM0102BuscarFrm
Icono=44
Modulos=(Todos)

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=469
PosicionInicialArriba=94
Nombre=Buscador
ExpresionesAlMostrar=Asigna( Mavi.DM0102Buscador,nulo  )
[Vista]
Estilo=Hoja
Clave=Vista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0102Buscador
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
ListaEnCaptura=AD.Articulo


HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática

[Vista.Columnas]
Articulo=124




[Acciones.Seleccionar.Selecccion]
Nombre=Selecccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Asigna( Mavi.DM0102Buscador,DM0102Buscador:AD.Articulo )<BR>informacion(Mavi.DM0102Buscador)<BR>OtraForma(<T>DM0102AsignacionPreciosEspFrm<T>, Forma.Accion(<T>Buscar<T>))
[Vista.AD.Articulo]
Carpeta=Vista
Clave=AD.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



