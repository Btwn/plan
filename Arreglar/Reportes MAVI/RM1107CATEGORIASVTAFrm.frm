
[Forma]
Clave=RM1107CATEGORIASVTAFrm
Icono=0
Modulos=(Todos)
Nombre=RM1107CATEGORIASVTAFrm

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=164
PosicionInicialAncho=220
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1107CATEGORIASVTAVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Categoria

MenuLocal=S
ListaAcciones=(Lista)
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
[Lista.Categoria]
Carpeta=Lista
Clave=Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
0=-2


[Forma.ListaCarpetas]
(Inicio)=Lista
Lista=Cat. de Canal de Venta
Cat. de Canal de Venta=(Fin)

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
NombreDesplegar=Quitar seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S




[Acciones.Seleccion]
Nombre=Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
Activo=S
Visible=S

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
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Lista<T>)

[Acciones.Seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1107CATEGORIASVTA,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S


[Lista.ListaAcciones]
(Inicio)=Seleccionar
Seleccionar=Quitar
Quitar=(Fin)

[Acciones.Seleccion.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)
