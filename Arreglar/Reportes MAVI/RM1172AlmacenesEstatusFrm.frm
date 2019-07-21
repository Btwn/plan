
[Forma]
Clave=RM1172AlmacenesEstatusFrm
Icono=0
Modulos=(Todos)
Nombre=RM1172A Estatus

ListaCarpetas=Estatus
CarpetaPrincipal=Estatus
PosicionInicialAlturaCliente=187
PosicionInicialAncho=306
PosicionInicialIzquierda=487
PosicionInicialArriba=399
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=Aceptar<BR>SleccionarTodo<BR>QuitarSeleccion
[Estatus]
Estilo=Iconos
Clave=Estatus
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1172AlmacenesEstatusVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200


ListaEnCaptura=RM1172AlmacenesTbl.Estatus
[Estatus.Columnas]
0=286


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
Expresion=Asigna(Mavi.RM1172Estatus,RegistrarSeleccion( <T>Estatus<T> ))

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
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Seleccionar
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


Expresion=RegistrarSeleccion( <T>Estatus<T> )
[Estatus.RM1172AlmacenesTbl.Estatus]
Carpeta=Estatus
Clave=RM1172AlmacenesTbl.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Acciones.Aceptar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado

Expresion=Asigna(Mavi.RM1172AlmacenesEstatus,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.SleccionarTodo]
Nombre=SleccionarTodo
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

