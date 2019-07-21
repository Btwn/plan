
[Forma]
Clave=RM1199FamArtVisFrm
Icono=0
Modulos=(Todos)
PosicionInicialAlturaCliente=468
PosicionInicialAncho=250
Nombre=Familia de Artículos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Seleccionar
ListaCarpetas=Vista
CarpetaPrincipal=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=558
PosicionInicialArriba=130
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
EnBarraHerramientas=S
Activo=S
Visible=S
NombreDesplegar=&seleccionar
Multiple=S
NombreEnBoton=S

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
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S



Expresion=Asigna(Mavi.RM1199FamArt,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Vista]
Estilo=Iconos
Clave=Vista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1199FamArtvis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Valor
CarpetaVisible=S

ListaAcciones=SelTodo<BR>QuitarSeleccion
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
BusquedaRespetarUsuario=S
BusquedaEnLinea=S
IconosSeleccionMultiple=S

[Acciones.SelTodo]
Nombre=SelTodo
Boton=0
UsaTeclaRapida=S
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S

[Vista.Columnas]
0=-2

[Vista.Valor]
Carpeta=Vista
Clave=Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

