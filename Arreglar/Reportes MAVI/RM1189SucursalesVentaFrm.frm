
[Forma]
Clave=RM1189SucursalesVentaFrm
Icono=14
Modulos=(Todos)
Nombre=Sucursales venta

ListaCarpetas=MuestraSucursales
CarpetaPrincipal=MuestraSucursales
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialIzquierda=550
PosicionInicialArriba=139
PosicionInicialAlturaCliente=451
PosicionInicialAncho=260
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
[MuestraSucursales]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Sucursales venta
Clave=MuestraSucursales
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1189SucursalesVentaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Sucursal
IconosConRejilla=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

ListaEnCaptura=NombreAlm
IconosSeleccionMultiple=S
IconosNombreNumerico=S
MenuLocal=S
IconosNombre=RM1189SucursalesVentaVis:Sucursal
ListaAcciones=seltodo<BR>Quitar
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Selecciona
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>RM1189SucursalesVenta<T>)
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S

ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1189SucursalVenta,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>)
[MuestraSucursales.NombreAlm]
Carpeta=MuestraSucursales
Clave=NombreAlm
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[MuestraSucursales.Columnas]
0=-2
1=-2

[Acciones.seltodo]
Nombre=seltodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

