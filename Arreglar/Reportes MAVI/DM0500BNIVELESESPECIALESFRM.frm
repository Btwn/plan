[Forma]
Clave=DM0500BNIVELESESPECIALESFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=DM0500BNIVELESPECIALVIS
CarpetaPrincipal=DM0500BNIVELESPECIALVIS
PosicionInicialAlturaCliente=328
PosicionInicialAncho=244
PosicionInicialIzquierda=824
PosicionInicialArriba=108
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[DM0500BNIVELESPECIALVIS]
Estilo=Iconos
Clave=DM0500BNIVELESPECIALVIS
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0500BNIVELESPECIALVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S
BusquedaRapida=S
BusquedaEnLinea=S
BusquedaAutoAsterisco=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=nombre
[DM0500BNIVELESPECIALVIS.Columnas]
nombre=604
0=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=Seleccionar
EnMenu=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=registra<BR>Seleccionar<BR>Quitar Seleccion
[Acciones.Seleccionar.registra]
Nombre=registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>DM0500BNIVELESPECIALVIS<T>)
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[Acciones.Seleccionar.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
