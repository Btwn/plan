
[Forma]
Clave=RM1124AnalisisAsociado
Icono=17
Modulos=(Todos)
MovModulo=(Todos)
Nombre=<T>RM1124 AnalisisAsociado<T>

ListaCarpetas=CamposFiltro
CarpetaPrincipal=CamposFiltro
PosicionInicialIzquierda=456
PosicionInicialArriba=327
PosicionInicialAlturaCliente=332
PosicionInicialAncho=367
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=(Lista)
AccionesTamanoBoton=25x5
VentanaConIcono=S
AccionesDerecha=S
BarraHerramientas=S
BarraAcciones=S
ExpresionesAlMostrar=Asigna(Info.FechaInicio,nulo)<BR>Asigna(Info.FechaCorte,nulo)
[CamposFiltro]
Estilo=Ficha
Pestana=S
Clave=CamposFiltro
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=(Lista)

CarpetaVisible=S
FichaEspacioEntreLineas=8
FichaEspacioNombres=14
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata

PermiteEditar=S
[CamposFiltro.Info.FechaA]
Carpeta=CamposFiltro
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

Pegado=N
[CamposFiltro.Info.FechaD]
Carpeta=CamposFiltro
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

Pegado=N
[Acciones.AcCerrar]
Nombre=AcCerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar 
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S










EnBarraHerramientas=S
[CamposFiltro.Info.FechaInicio]
Carpeta=CamposFiltro
Clave=Info.FechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[CamposFiltro.Info.FechaCorte]
Carpeta=CamposFiltro
Clave=Info.FechaCorte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

















Pegado=N






[RM0430GrupoCalificacionesVis.Grupo]
Carpeta=RM0430GrupoCalificacionesVis
Clave=Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro


[RM0430GrupoCalificacionesVis.Columnas]
Grupo=64



[CamposFiltro.Mavi.RM1124GrupoCalificacionVis]
Carpeta=CamposFiltro
Clave=Mavi.RM1124GrupoCalificacionVis
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro








[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Vista Preliminar
Activo=S
Visible=S























TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar




















EnBarraHerramientas=S
[RM1124AnalisisAsociado.Grupo]
Carpeta=RM1124AnalisisAsociado
Clave=Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro



[RM1124AnalisisAsociado.Columnas]
Grupo=64

[Forma.ListaCarpetas]
(Inicio)=CamposFiltro
CamposFiltro=RM1124AnalisisAsociado
RM1124AnalisisAsociado=(Fin)












[ListaGrupos.Columnas]
Grupo=179













[CamposFiltro.Mavi.RM1124AnalisisAsociadoEstatus]
Carpeta=CamposFiltro
Clave=Mavi.RM1124AnalisisAsociadoEstatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
















[CamposFiltro.ListaEnCaptura]
(Inicio)=Info.FechaD
Info.FechaD=Info.FechaA
Info.FechaA=Mavi.RM1124GrupoCalificacionVis
Mavi.RM1124GrupoCalificacionVis=Info.FechaInicio
Info.FechaInicio=Info.FechaCorte
Info.FechaCorte=Mavi.RM1124AnalisisAsociadoEstatus
Mavi.RM1124AnalisisAsociadoEstatus=(Fin)



















[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=AcCerrar
AcCerrar=(Fin)

