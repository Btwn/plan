
[Forma]
Clave=RM1168ComprasArtLineaFrm
Icono=0
Modulos=(Todos)
Nombre=RM1168ComprasArtLineaFrm

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
BarraHerramientas=S
PosicionInicialIzquierda=405
PosicionInicialArriba=210
[Principal]
Estilo=Iconos
Clave=Principal
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1168ComprasArtLineaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
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


IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=0
IconosSeleccionMultiple=S
IconosNombre=RM1168ComprasArtLineaVis:Linea
BusquedaRespetarFiltros=S
BusquedaRespetarUsuario=S
FiltroIgnorarEmpresas=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S

EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Exp<BR>Final
[Principal.Columnas]
Linea=304

0=-2
1=-2

[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Art<T>)
[Acciones.Seleccionar.Final]
Nombre=Final
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Resultado


Expresion=Asigna(Mavi.RM1168Linea,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
