
[Forma]
Clave=RM1186FamiliaFrm
Icono=0
Modulos=(Todos)
Nombre=Familias



ListaCarpetas=RM1186FamiliaVis
CarpetaPrincipal=RM1186FamiliaVis
PosicionInicialAlturaCliente=412
PosicionInicialAncho=312
PosicionInicialIzquierda=527
PosicionInicialArriba=159
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[RM1186FamiliaVis]
Estilo=Iconos
Clave=RM1186FamiliaVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1186FamiliaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Familia
CarpetaVisible=S

PestanaOtroNombre=S

BusquedaRapidaControles=S
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
IconosConRejilla=S
IconosSeleccionMultiple=S
[RM1186FamiliaVis.Columnas]
Familia=304

0=-2
[RM1186FamiliaVis.Familia]
Carpeta=RM1186FamiliaVis
Clave=Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Preliminar
NombreEnBoton=S
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>RM1186FamiliaVis<T>)
[Acciones.Seleccionar.Preliminar]
Nombre=Preliminar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.RM1186Familia,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

