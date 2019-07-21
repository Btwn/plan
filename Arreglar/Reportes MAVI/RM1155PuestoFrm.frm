
[Forma]
Clave=RM1155PuestoFrm
Icono=105
Nombre=Puesto

ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=447
PosicionInicialArriba=376
PosicionInicialAlturaCliente=350
PosicionInicialAncho=402
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
[Vista]
Estilo=Iconos
Pestana=S
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1155PuestoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Descripcion

IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
BusquedaRapidaControles=S
MenuLocal=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
ListaAcciones=(Lista)
BusquedaRapida=S
BusquedaInicializar=S
BusquedaEnLinea=S
BusquedaAncho=20
BusquedaRespetarControles=S
PestanaOtroNombre=S
PestanaNombre=Puesto
[Vista.Descripcion]
Carpeta=Vista
Clave=Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Vista.Columnas]
Descripcion=604

0=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=Seleccionar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Vista]
Nombre=Vista
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S

[Acciones.Seleccionar.ListaAccionesMultiples]
(Inicio)=Asignar
Asignar=Vista
Vista=Seleccionar
Seleccionar=(Fin)












[Acciones.select]
Nombre=select
Boton=23
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=(Lista)
NombreEnBoton=S
[Acciones.close]
Nombre=close
Boton=36
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


NombreEnBoton=S
EspacioPrevio=S
[Acciones.select.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.select.vis]
Nombre=vis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.select.Select]
Nombre=Select
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S





Expresion=Asigna(Mavi.RM1155Puesto,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[Acciones.seleccionarTodo]
Nombre=seleccionarTodo
Boton=0
NombreDesplegar=Seleccionar todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.quitarSeleccion]
Nombre=quitarSeleccion
Boton=0
NombreDesplegar=Quitar selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S














[Acciones.select.ListaAccionesMultiples]
(Inicio)=asig
asig=vis
vis=Select
Select=(Fin)










[Vista.ListaAcciones]
(Inicio)=seleccionarTodo
seleccionarTodo=quitarSeleccion
quitarSeleccion=(Fin)







[Forma.ListaAcciones]
(Inicio)=select
select=close
close=(Fin)
