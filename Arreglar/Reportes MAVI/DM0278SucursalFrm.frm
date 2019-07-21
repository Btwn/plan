
[Forma]
Clave=DM0278SucursalFrm
Icono=747
Modulos=(Todos)
Nombre=DM0278SucursalFrm

ListaCarpetas=Sucursal
CarpetaPrincipal=Sucursal
PosicionInicialAlturaCliente=464
PosicionInicialAncho=281

BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=SELECCIONAR
PosicionInicialIzquierda=538
PosicionInicialArriba=279
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Sucursal]
Estilo=Iconos
Clave=Sucursal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0278SucursalVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSubTitulo=<T>Sucursal<T>
IconosSeleccionMultiple=S
ListaEnCaptura=Nombre

MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>quitarSeleccion
BusquedaRapidaControles=S
IconosNombre=DM0278SucursalVis:Sucursal
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
[Sucursal.Nombre]
Carpeta=Sucursal
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Sucursal.Columnas]
0=-2
1=-2

[Acciones.SELECCIONAR]
Nombre=SELECCIONAR
Boton=23
NombreEnBoton=S
NombreDesplegar=SELECCIONAR
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Registrar<BR>seleccionar Todo
[Acciones.SELECCIONAR.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.SELECCIONAR.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Sucursal<T>)
Activo=S
Visible=S

[Acciones.SELECCIONAR.seleccionar Todo]
Nombre=seleccionar Todo
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
Activo=S
Visible=S

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.quitarSeleccion]
Nombre=quitarSeleccion
Boton=0
NombreDesplegar=quitar Seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S



