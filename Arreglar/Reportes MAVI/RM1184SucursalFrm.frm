
[Forma]
Clave=RM1184SucursalFrm
Icono=700
Modulos=(Todos)
Nombre=Sucursales

ListaCarpetas=MuestraSucursal
CarpetaPrincipal=MuestraSucursal
PosicionInicialIzquierda=476
PosicionInicialArriba=285
PosicionInicialAlturaCliente=150
PosicionInicialAncho=430


BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[MuesttraAlmacen.Columnas]
0=-2
1=-2
2=-2


[MuestraAlmacen.Columnas]
0=-2
1=299

2=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

ListaAccionesMultiples=Asigna<BR>Registra<BR>Seleccion
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

Expresion=RegistrarSeleccion(<T>RM1184Sucursal<T>)
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S

ClaveAccion=Seleccionar/Resultado

Expresion=Asigna(Mavi.RM1184Sucursal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[MuestraSucursal]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Muestra Sucursales
Clave=MuestraSucursal
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1184SucursalVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=NombreAlm
CarpetaVisible=S


IconosSubTitulo=2
IconosNombre=RM1184SucursalVis:Sucursal
[MuestraSucursal.Columnas]
0=41
1=-2






[MuestraSucursal.NombreAlm]
Carpeta=MuestraSucursal
Clave=NombreAlm
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
