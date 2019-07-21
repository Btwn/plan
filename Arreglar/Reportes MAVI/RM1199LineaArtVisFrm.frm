
[Forma]
Clave=RM1199LineaArtVisFrm
Icono=0
Modulos=(Todos)
Nombre=Líneas de Artículos

ListaCarpetas=Vista
CarpetaPrincipal=Vista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=336
PosicionInicialAncho=215
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=575
PosicionInicialArriba=196
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1199LineaArtvis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

BusquedaRapidaControles=S
MenuLocal=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
ListaEnCaptura=Nombre
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaEnLinea=S
ListaAcciones=SelTodo<BR>QuitarSeleccion
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSeleccionMultiple=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S

ListaAccionesMultiples=Asigna<BR>Regis<BR>Selec
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
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

[Acciones.Seleccionar.Selec]
Nombre=Selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1199LineaArt,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)


[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&Quitar Seleecion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S

[Vista.Columnas]
0=-2

[Vista.Nombre]
Carpeta=Vista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

