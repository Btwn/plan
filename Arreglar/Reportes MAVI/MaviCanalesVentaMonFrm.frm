[Forma]
Clave=MaviCanalesVentaMonFrm
Nombre=Canales de Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=Canales
CarpetaPrincipal=Canales
PosicionInicialAlturaCliente=216
PosicionInicialAncho=274
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=543
PosicionInicialArriba=256
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ExpresionesAlMostrar=//si vacio(Mavi.CategoCanalesVenta)<BR>//entonces<BR>//sI(precaucion(<T>Debe seleccionar una Categoría<T>, BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion)<BR>//Fin
ListaAcciones=SELECCION

[(Vista).Columnas]
Canal=64
Clave=64
Cadena=304



[(Lista).Columnas]
Cadena=175
Canal=35
Clave=72
nombre=604



[Canales]
Estilo=Hoja
Clave=Canales
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCanalesVentaMonVis
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
ListaEnCaptura=Canal<BR>Cadena
CarpetaVisible=S
[Canales.Canal]
Carpeta=Canales
Clave=Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Canales.Cadena]
Carpeta=Canales
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Canales.Columnas]
Canal=42
Cadena=304
[Acciones.SELECCION]
Nombre=SELECCION
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

