
[Forma]
Clave=RM1107MOVIMIENTOSFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107MOVIMIENTSFrm

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=229
PosicionInicialAncho=199
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Acciones.Seleccionartodo]
Nombre=Seleccionartodo
Boton=0
NombreDesplegar=&Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitarseleccion]
Nombre=Quitarseleccion
Boton=0
NombreDesplegar=Quitar selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Lista]
Estilo=Iconos
Clave=Lista
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1107MOVIMIENTOSVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mov
ListaAcciones=(Lista)

CarpetaVisible=S

IconosSeleccionMultiple=S
[Lista.Mov]
Carpeta=Lista
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
0=-2
1=-2












[Acciones.Seleccion]
Nombre=Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
BtnResaltado=S
ListaAccionesMultiples=(Lista)
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
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S

[Acciones.Seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1107MOVIMIENTOS,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)



[Lista.ListaAcciones]
(Inicio)=Seleccionartodo
Seleccionartodo=Quitarseleccion
Quitarseleccion=(Fin)

[Acciones.Seleccion.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)
