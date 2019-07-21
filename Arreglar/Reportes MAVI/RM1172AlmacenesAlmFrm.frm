
[Forma]
Clave=RM1172AlmacenesAlmFrm
Icono=0
Modulos=(Todos)
Nombre=RM1172A Almacen

ListaCarpetas=Almacen
CarpetaPrincipal=Almacen
PosicionInicialAlturaCliente=655
PosicionInicialAncho=319
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=480
PosicionInicialArriba=165
ListaAcciones=Aceptar<BR>SeleccionarTodo<BR>QuitarSeleccion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1172AlmacenesAlm,nulo)<BR>Asigna(Mavi.RM1172AlmacenesTipo,nulo)<BR>Asigna(Mavi.RM1172AlmacenesEstatus,nulo)
[Almacen]
Estilo=Iconos
Clave=Almacen
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM1172AlmacenesAlmVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


MostrarConteoRegistros=S


IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
ElementosPorPaginaEsp=200
IconosConRejilla=S
ListaEnCaptura=RM1172AlmacenesTbl.Almacen
IconosSeleccionMultiple=S
IconosConSenales=S
[Almacen.Columnas]
0=282




1=106
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1172Almacen,RegistrarSeleccion( <T>Almacen<T> ))


[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Otros
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Seleccionar
Activo=S
Visible=S

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=55
NombreEnBoton=S
NombreDesplegar=&Seleccionar todo
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=36
NombreEnBoton=S
NombreDesplegar=&Quitar selección
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar

[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion


Expresion=RegistrarSeleccion(<T>Almacen<T>)

[Acciones.Aceptar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado



Expresion=Asigna(Mavi.RM1172AlmacenesAlm,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Almacen.RM1172AlmacenesTbl.Almacen]
Carpeta=Almacen
Clave=RM1172AlmacenesTbl.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

