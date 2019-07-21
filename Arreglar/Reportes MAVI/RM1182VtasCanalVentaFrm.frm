
[Forma]
Clave=RM1182VtasCanalVentaFrm
Icono=0
Modulos=(Todos)
Nombre=Canal de Venta
PosicionInicialAlturaCliente=202
PosicionInicialAncho=206

ListaCarpetas=RM1182VtasCanalVentaPrin
CarpetaPrincipal=RM1182VtasCanalVentaPrin
PosicionInicialIzquierda=661
PosicionInicialArriba=451
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=SelecccionCanal
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[RM1182VtasCanalVentaPrin]
Estilo=Iconos
Clave=RM1182VtasCanalVentaPrin
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM1182VtasCanalVentaVis
Fuente={Tahoma, 8, Negro, []}
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S

BusquedaRapida=S
BusquedaAncho=20
BusquedaEnLinea=S
ListaAcciones=SectAll<BR>QuitarSle
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaRespetarUsuario=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=ID
FiltroIgnorarEmpresas=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSeleccionMultiple=S
[RM1182VtasCanalVentaPrin.ID]
Carpeta=RM1182VtasCanalVentaPrin
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Color=Negro
[RM1182VtasCanalVentaPrin.Columnas]
0=-2

ID=64
[Acciones.SelecccionCanal.Asinar]
Nombre=Asinar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.SelecccionCanal]
Nombre=SelecccionCanal
Boton=23
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
Activo=S
Visible=S

NombreEnBoton=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Multiple=S
ListaAccionesMultiples=asignar<BR>register<BR>selectCanal
[Acciones.SelecccionCanal.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S

[Acciones.SectAll]
Nombre=SectAll
Boton=0
UsaTeclaRapida=S
NombreDesplegar=Selecccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSle]
Nombre=QuitarSle
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.SelecccionCanal.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.SelecccionCanal.selectCanal]
Nombre=selectCanal
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1182CanalTelemarketing,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.SelecccionCanal.register]
Nombre=register
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>RM1182VtasCanalVentaPrin<T>)

