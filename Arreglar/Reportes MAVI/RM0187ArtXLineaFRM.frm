[Forma]
Clave=RM0187ArtXLineaFRM
Nombre=Articulos por Linea
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0187ArtXLineaVIS
CarpetaPrincipal=RM0187ArtXLineaVIS
PosicionInicialIzquierda=375
PosicionInicialArriba=169
PosicionInicialAlturaCliente=365
PosicionInicialAncho=227
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[RM0187ArtXLineaVIS]
Estilo=Iconos
Clave=RM0187ArtXLineaVIS
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0187ArtXLineaVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Linea
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
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
BusquedaRespetarFiltros=S
[RM0187ArtXLineaVIS.Linea]
Carpeta=RM0187ArtXLineaVIS
Clave=Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[RM0187ArtXLineaVIS.Columnas]
Linea=152
0=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>expresion<BR>Seleccionar/Resultado
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM0187ArtXLinea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

