[Forma]
Clave=DM0213FILTROServicioRefaccionFrm
Nombre=DM0213 Servicio Refaccion  
Icono=533
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=493
PosicionInicialAncho=424
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=428
PosicionInicialArriba=246
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0213FILTROServicioRefaccionVis
Fuente={Tahoma, 8, Negro, []}
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
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaRespetarUsuario=S
BusquedaAncho=20
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=SelTodo<BR>QuitarSeleccion
IconosSubTitulo=<T>Servicio / Refaccion<T>
ListaEnCaptura=Descripcion
IconosNombre=DM0213FILTROServicioRefaccionVis:ServicioRefaccion
BusquedaEnLinea=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Regis<BR>Selec
[Vista.Columnas]
Familia=304
0=227
1=568
2=-2
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
Expresion=Asigna(Mavi.DM0213MenuRefaccionesServicios,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Vista.Descripcion]
Carpeta=Vista
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro

