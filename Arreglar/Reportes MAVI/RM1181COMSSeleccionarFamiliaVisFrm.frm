
[Forma]
Clave=RM1181COMSSeleccionarFamiliaVisFrm
Icono=570
Modulos=(Todos)
Nombre=<T>Seleccionar Familia(s)<T>

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=400
PosicionInicialAncho=375
PosicionInicialIzquierda=185
PosicionInicialArriba=221
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1181COMSSeleccionarFamiliaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=0
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

IconosSeleccionMultiple=S

BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaRespetarControlesNum=S
MenuLocal=S
IconosNombre=RM1181COMSSeleccionarFamiliaVis:Familia
ListaAcciones=SeleccionarTodo<BR>QuitarSeleccion
[Vista.Columnas]
0=-2
1=-2


[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.RegistrarSeleccion]
Nombre=RegistrarSeleccion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Art<T>)
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>RegistrarSeleccion<BR>Validar
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Seleccionar.Validar]
Nombre=Validar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1181Familia,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
Activo=S
Visible=S

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

