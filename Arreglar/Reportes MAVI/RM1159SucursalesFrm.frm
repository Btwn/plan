[Forma]
Clave=RM1159SucursalesFrm
Nombre=Sucursales
Icono=0
Modulos=(Todos)
ListaCarpetas=sucursales
CarpetaPrincipal=sucursales
PosicionInicialAlturaCliente=268
PosicionInicialAncho=281
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialIzquierda=499
PosicionInicialArriba=355
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[sucursales]
Estilo=Iconos
Clave=sucursales
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1159SucursalesVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaEnCaptura=Nombre
MenuLocal=S
ListaAcciones=Select<BR>Quitar Seleccion
IconosSubTitulo=<T>Sucursal<T>
IconosNombre=RM1159SucursalesVis:Sucursal
[Acciones.Seleccionar.Varia]
Nombre=Varia
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.asig]
Nombre=asig
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>sucursales<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
ListaAccionesMultiples=Varia<BR>asig<BR>Seleccion
Activo=S
Visible=S
[sucursales.Columnas]
0=94
1=-2
2=-2
[Acciones.Select]
Nombre=Select
Boton=0
NombreDesplegar=&Seleccionar Todo
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
[sucursales.Nombre]
Carpeta=sucursales
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1159Sucursales,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR>Reemplaza( Comillas(<T>,<T>),<T>,<T>, Mavi.RM1159Sucursales)

