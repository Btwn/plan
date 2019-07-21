[Forma]
Clave=ArtAlmGruposAlmacenFrm
Nombre=<T>Grupos de Almacenes<T>
Icono=0
ListaCarpetas=ArtAlmGruposAlmacen
CarpetaPrincipal=ArtAlmGruposAlmacen
PosicionInicialIzquierda=632
PosicionInicialArriba=58
PosicionInicialAlturaCliente=422
PosicionInicialAncho=265
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
[ArtAlmGruposAlmacen]
Estilo=Iconos
Clave=ArtAlmGruposAlmacen
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=ArtAlmGruposAlmacenVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=SelT<BR>QuiT
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
BusquedaRespetarFiltros=S
BusquedaRespetarUsuario=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosSubTitulo=<T>Grupo<T>
IconosConRejilla=S
IconosNombre=ArtAlmGruposAlmacenVis:Grupo
[ArtAlmGruposAlmacen.Columnas]
0=242
1=-2
Grupo=304
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=controles Captura
Activo=S
Visible=S
ListaAccionesMultiples=Selec<BR>Regis<BR>Asig
GuardarAntes=S
[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Regis]
Nombre=Regis
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Asig]
Nombre=Asig
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.ArtAlmGruposAlmacen,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T> + EstacionTrabajo + <T>, 2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T> + EstacionTrabajo + <T>, 2<T>)
[Acciones.SelT]
Nombre=SelT
Boton=0
UsaTeclaRapida=S
TeclaRapida=F11
NombreDesplegar=&Seleccionar Todos
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=seleccionar Todo
Activo=S
Visible=S
[Acciones.QuiT]
Nombre=QuiT
Boton=0
UsaTeclaRapida=S
TeclaRapida=F12
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S


