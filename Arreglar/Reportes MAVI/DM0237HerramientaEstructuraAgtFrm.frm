
[Forma]
Clave=DM0237HerramientaEstructuraAgtFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=(Lista)
CarpetaPrincipal=filtros
PosicionInicialIzquierda=266
PosicionInicialArriba=216
PosicionInicialAlturaCliente=378
PosicionInicialAncho=605
PosicionSec1=92
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec2=300
ExpresionesAlMostrar=Asigna( Info.Ejercicio,  Año( Hoy )  )<BR>Asigna( Mavi.Quincena,   Mes(Hoy)  )<BR>Asigna(Mavi.RM1037PersonalEmp,  nulo  )<BR>Asigna(Mavi.DM0237Equipo,<T><T>)
Nombre=DM0237 Herramienta Estructura Agente
[filtros]
Estilo=Ficha
Clave=filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=(Lista)

PermiteEditar=S

[filtros.Mavi.RM1037PersonalEmp]
Carpeta=filtros
Clave=Mavi.RM1037PersonalEmp
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[filtros.Mavi.Quincena]
Carpeta=filtros
Clave=Mavi.Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro

[filtros.Info.Ejercicio]
Carpeta=filtros
Clave=Info.Ejercicio
Editar=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro


[lista]
Estilo=Hoja
Clave=lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0237HerramientaEstructuraAgtVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco

CarpetaVisible=S





HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
ListaEnCaptura=(Lista)
[ArtPersonal.Columnas]
PERSONAL=64
Estatus=94
NOMBRE=303
PUESTO=53
DEPARTAMENTO=91
FECHAALTA=70

[lista.Columnas]
Equipo=155
Agente=96
Valor=49
Fecha=155






UsrMod=94
[Acciones.buscar]
Nombre=buscar
Boton=6
NombreEnBoton=S
NombreDesplegar=Buscar
EnBarraHerramientas=S
Activo=S
Visible=S



Multiple=S
ListaAccionesMultiples=(Lista)

BtnResaltado=S
[Acciones.buscar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.buscar.refrescar]
Nombre=refrescar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S





[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

ListaEnCaptura=Mavi.DM0237Equipo

[(Variables).Mavi.DM0237Equipo]
Carpeta=(Variables)
Clave=Mavi.DM0237Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[lista_equipos.Columnas]
agente=64











[Acciones.modificar]
Nombre=modificar
Boton=-1
NombreEnBoton=S
NombreDesplegar=Modificar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S



BtnResaltado=S






ListaAccionesMultiples=(Lista)


EspacioPrevio=S
[Acciones.modificar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.modificar.refrescar]
Nombre=refrescar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.modificar.modificar]
Nombre=modificar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S













ConCondicion=S
EjecucionConError=S


Expresion=Si<BR> ( SQL( <T>EXEC Sp_DM0237HERRAMIENTAESTRUCTURAAGENTE2 :nqui,:nejr,:tper,:teq,:nopc,:tusr,:tcob<T>,Mavi.Quincena,Info.Ejercicio,Mavi.RM1037PersonalEmp,Mavi.DM0237Equipo,2,Usuario,Mavi.DM0237Cobranza ) = 1)<BR>Entonces<BR>  Informacion( <T>Se insertarón los registros satisfactoriamente<T> )<BR>Sino<BR>   Informacion( <T>Hubo un error y no se insertarón los registros<T> )<BR>Fin
EjecucionCondicion=ConDatos( Mavi.Quincena) y ConDatos(Info.Ejercicio) y ConDatos(Mavi.RM1037PersonalEmp) y ConDatos(Mavi.DM0237Equipo)
EjecucionMensaje=<T>Completa los campos<T>
[lista.ListaEnCaptura]
(Inicio)=Equipo
Equipo=Agente
Agente=Valor
Valor=Fecha
Fecha=UsrMod
UsrMod=(Fin)

[lista.Equipo]
Carpeta=lista
Clave=Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[lista.Agente]
Carpeta=lista
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[lista.Valor]
Carpeta=lista
Clave=Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[lista.Fecha]
Carpeta=lista
Clave=Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[lista.UsrMod]
Carpeta=lista
Clave=UsrMod
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro




























































[filtros.Mavi.DM0237Cobranza]
Carpeta=filtros
Clave=Mavi.DM0237Cobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro



[filtros.ListaEnCaptura]
(Inicio)=Mavi.RM1037PersonalEmp
Mavi.RM1037PersonalEmp=Mavi.Quincena
Mavi.Quincena=Info.Ejercicio
Info.Ejercicio=Mavi.DM0237Cobranza
Mavi.DM0237Cobranza=(Fin)




















[Acciones.modificar.ListaAccionesMultiples]
(Inicio)=asignar
asignar=modificar
modificar=refrescar
refrescar=(Fin)















[Acciones.buscar.ListaAccionesMultiples]
(Inicio)=asignar
asignar=refrescar
refrescar=(Fin)



[Forma.ListaCarpetas]
(Inicio)=filtros
filtros=lista
lista=(Variables)
(Variables)=(Fin)

[Forma.ListaAcciones]
(Inicio)=buscar
buscar=modificar
modificar=(Fin)

