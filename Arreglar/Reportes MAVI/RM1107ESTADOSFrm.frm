
[Forma]
Clave=RM1107ESTADOSFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107ESTADOSFrm

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=428
PosicionInicialAncho=171
BarraHerramientas=S
ListaAcciones=Seleccion
AccionesTamanoBoton=15x5
AccionesDerecha=S
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=RM1107ESTADOSVis


ListaEnCaptura=Estado
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=(Lista)
[Lista.Columnas]
0=-2
1=-2

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar]
Nombre=Quitar
Boton=0
NombreDesplegar=Quitar selección
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S


[Acciones.Seleccion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Estado<T>)
[Acciones.Seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1107ESTADOS,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S

[Lista.Estado]
Carpeta=Lista
Clave=Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro










[Acciones.Seleccion.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)

[Acciones.Seleccionart]
Nombre=Seleccionart
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitart]
Nombre=Quitart
Boton=0
NombreDesplegar=&Quitar seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Lista.ListaAcciones]
(Inicio)=Seleccionart
Seleccionart=Quitart
Quitart=(Fin)
