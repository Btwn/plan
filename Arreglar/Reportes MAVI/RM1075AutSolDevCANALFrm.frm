[Forma]
Clave=RM1075AutSolDevCANALFrm
Nombre=RM1075 Categoria Canal
Icono=23
Modulos=(Todos)
ListaCarpetas=RM1075AutSolDevCANALVis
CarpetaPrincipal=RM1075AutSolDevCANALVis
PosicionInicialAlturaCliente=273
PosicionInicialAncho=280
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=500
PosicionInicialArriba=356
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[RM1075AutSolDevCANALVis]
Estilo=Iconos
Clave=RM1075AutSolDevCANALVis
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1075AutSolDevCANALVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Negro
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
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM1075AutSolDevCANALVis:Categoria
IconosSubTitulo=<T>Categoria<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
IconosCambiarOrden=S
[RM1075AutSolDevCANALVis.Columnas]
0=256
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
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Seleccionar/Resultado
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1075CategoriaCanal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
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

