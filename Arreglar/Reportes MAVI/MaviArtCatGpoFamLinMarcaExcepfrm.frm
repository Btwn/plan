[Forma]
Clave=MaviArtCatGpoFamLinMarcaExcepfrm
Nombre=Articulos
Icono=0
Modulos=INV
AccionesTamanoBoton=14x5
AccionesDerecha=S
ListaCarpetas=Lista
CarpetaPrincipal=Lista
ListaAcciones=Seleccionar
PosicionInicialIzquierda=328
PosicionInicialArriba=97
PosicionInicialAltura=309
PosicionInicialAncho=703
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
PosicionSeccion1=43
PosicionColumna1=46
PosicionInicialAlturaCliente=534
VentanaEstadoInicial=Normal

[Lista]
Estilo=Iconos
PestanaNombre=Lista
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviArtCatGpoFamLinMarcaVis
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
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
ListaEnCaptura=Descripcion1
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Articulo<T>
IconosConPaginas=S
ElementosPorPagina=200
MenuLocal=S
IconosSeleccionPorLlave=S
ListaAcciones=seltodo<BR>quitartodo
IconosNombre=MaviArtCatGpoFamLinMarcaVis:Articulo


[Detalle.ArtFam.Familia]
Carpeta=Detalle
Clave=ArtFam.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
Efectos=[Negritas]

[Detalle.ArtFam.Icono]
Carpeta=Detalle
Clave=ArtFam.Icono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10

[Lista.Columnas]
Familia=263
Descripcion=310
Linea=304
Articulo=124
Descripcion1=604
0=-2
1=484

[Detalle.Columnas]
Familia=64
Descripcion=304
Icono=64

[Detalle.ArtFam.FamiliaMaestra]
Carpeta=Detalle
Clave=ArtFam.FamiliaMaestra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[ArtFamD.ArtFamD.TipoPropiedad]
Carpeta=ArtFamD
Clave=ArtFamD.TipoPropiedad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[ArtFamD.Columnas]
TipoPropiedad=194

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
[Lista.Descripcion1]
Carpeta=Lista
Clave=Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.regist]
Nombre=regist
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Lista<T>)
[Acciones.Seleccionar.selecciona]
Nombre=selecciona
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar.asignar]
Nombre=asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.seltodo]
Nombre=seltodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitartodo]
Nombre=quitartodo
Boton=0
NombreDesplegar=&Quitar Todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

