
[Forma]
Clave=RM1166SucursalFRM
Icono=0
Modulos=(Todos)
Nombre=RM1166SucursalFRM

ListaCarpetas=Sucursalvista
CarpetaPrincipal=Sucursalvista
PosicionInicialAlturaCliente=389
PosicionInicialAncho=228
PosicionInicialIzquierda=486
PosicionInicialArriba=433
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=seleccionar
[Sucursalvista]
Estilo=Iconos
Clave=Sucursalvista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1166SucursalVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=Nombre
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
MenuLocal=S
ListaAcciones=seleccionarTodo<BR>quitarseleccion
IconosSubTitulo=<T>Sucursal<T>
IconosNombre=RM1166SucursalVis:Sucursal
[Sucursalvista.Columnas]
sucursal=64

Sucursal=64
0=96
1=93
2=-2

[Acciones.seleccionar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.seleccionar]
Nombre=seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Ventana
ClaveAccion=Seleccionar
Multiple=S
ListaAccionesMultiples=asig<BR>regi<BR>select
[Acciones.seleccionar.registrar]
Nombre=registrar
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>sucursalvista<T>)

[Acciones.seleccionar.capturarSel]
Nombre=capturarSel
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Seleccionar/Aceptar

[Acciones.seleccionar.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.seleccionar.regi]
Nombre=regi
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Sucursalvista<T>)
Activo=S
Visible=S

[Acciones.seleccionar.select]
Nombre=select
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(MAVI.RM1166Sucursal,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.seleccionarTodo]
Nombre=seleccionarTodo
Boton=0
NombreDesplegar=Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.quitarseleccion]
Nombre=quitarseleccion
Boton=0
NombreDesplegar=Quitar seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=quitar Seleccion
Activo=S
Visible=S







[Sucursalvista.Nombre]
Carpeta=Sucursalvista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
