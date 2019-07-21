
[Forma]
Clave=RM1107CANALDEVENTAfrm
Icono=0
Modulos=(Todos)
Nombre=RM1107CANALDEVENTAfrm

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=711
PosicionInicialAncho=409
PosicionSec1=49
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
Vista=RM1107CANALDEVENTAVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cadena

CarpetaVisible=S


MenuLocal=S
ListaAcciones=(Lista)
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=RM1107CANALDEVENTAVis:id
[Lista.Columnas]
id=64
Clave=64
Cadena=304





0=64
1=221
2=-2









3=-2

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
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

Expresion=Asigna(Mavi.RM1107CANALDEVENTA,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=35
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S



BtnResaltado=S
[Acciones.Seltodo]
Nombre=Seltodo
Boton=0
NombreDesplegar=Seleccionar &todo
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitodo]
Nombre=Quitodo
Boton=0
NombreDesplegar=&Quitar seleccion
EnMenu=S
TipoAccion=controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S










[Filtrar por Categorias.Mavi.RM1107CATEGORIASVTA]
Carpeta=Filtrar por Categorias
Clave=Mavi.RM1107CATEGORIASVTA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro










Pegado=N

[Filtrar por Categorias.ListaEnCaptura]
(Inicio)=Mavi.RM1107CATEGORIASVTA
Mavi.RM1107CATEGORIASVTA=Mavi.RM1107UEN
Mavi.RM1107UEN=(Fin)



















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
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Filtrar por Categorias.ListaAcciones]
(Inicio)=Seleccionar
Seleccionar=Quitar
Quitar=(Fin)

















































[Acciones.Buscar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Buscar.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S



[Acciones.Buscar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Refrescar
Refrescar=(Fin)

[Forma.ListaCarpetas]
(Inicio)=Filtrar por Categorias
Filtrar por Categorias=Lista
Lista=(Fin)



[Forma.ListaAcciones]
(Inicio)=Buscar
Buscar=Seleccion
Seleccion=(Fin)

[Acciones.Seleccion.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Expresion
Expresion=Seleccionar
Seleccionar=(Fin)














[Lista.Cadena]
Carpeta=Lista
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro







[Lista.ListaEnCaptura]
(Inicio)=id
id=Cadena
Cadena=(Fin)















[Lista.ListaAcciones]
(Inicio)=Seltodo
Seltodo=Quitodo
Quitodo=(Fin)
