
[Forma]
Clave=RM1172AlmacenesTipoFrm
Icono=0
Modulos=(Todos)
Nombre=RM1172A Tipo

ListaCarpetas=Tipo
CarpetaPrincipal=Tipo
PosicionInicialAlturaCliente=273
PosicionInicialAncho=308
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=486
PosicionInicialArriba=356
ListaAcciones=Aceptar<BR>SeleccionarTodo<BR>QuitarSeleccion
[Tipo]
Estilo=Iconos
Clave=Tipo
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1172AlmacenesTipoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S


ListaEnCaptura=RM1172AlmacenesTbl.Tipo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosConRejilla=S
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
[Tipo.Columnas]
0=288


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
Expresion=Asigna(Mavi.RM1172Tipo,RegistrarSeleccion( <T>Tipo<T> ))

[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
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


Expresion=RegistrarSeleccion( <T>Tipo<T> )
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

[Tipo.RM1172AlmacenesTbl.Tipo]
Carpeta=Tipo
Clave=RM1172AlmacenesTbl.Tipo
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

Expresion=Asigna(Mavi.RM1172AlmacenesTipo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
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

