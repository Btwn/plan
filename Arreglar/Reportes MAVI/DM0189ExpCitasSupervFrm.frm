[Forma]
Clave=DM0189ExpCitasSupervFrm
Nombre=DM0189 Explorador de Citas de Supervisión
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>sql
CarpetaPrincipal=sql
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Excel<BR>Filtrar<BR>inf
PosicionInicialAlturaCliente=608
PosicionInicialAncho=1214
PosicionInicialIzquierda=99
PosicionInicialArriba=34
PosicionSec1=43
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaAjustarZonas=S
VentanaEstadoInicial=Normal
Menus=S
ExpresionesAlMostrar=Asigna(Info.FechaD,Hoy)<BR>Asigna(Info.FechaA,Hoy)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Filtrar.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Filtrar.actu]
Nombre=actu
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Filtrar]
Nombre=Filtrar
Boton=107
NombreDesplegar=&Filtrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asi<BR>exp<BR>actu
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5
TeclaFuncion=F5
EnMenu=S
NombreEnBoton=S
[sql]
Estilo=Hoja
Clave=sql
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0189ExpCitasSupervVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaActualizacionManual=S
ListaEnCaptura=FechaEvento<BR>SucOrig<BR>FechaEmision<BR>SolicitudCred<BR>AnalisisCred<BR>Tipo<BR>FechadeCita<BR>HorariodeCita<BR>ComentarioEvent<BR>Canal<BR>TipoVenta<BR>TipoCredito<BR>Importe<BR>Cliente<BR>Nombre<BR>CodigoPostal<BR>Colonia<BR>Municipio<BR>Estado<BR>Situacion<BR>GrpCalif<BR>FUM<BR>Usuario
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[sql.Columnas]
0=-2
1=133
2=80
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=86
12=50
13=126
ComentarioEvent=375
SucOrig=45
FechaEmision=75
SolicitudCred=69
AnalisisCred=65
Canal=37
TipoVenta=56
Importe=71
Cliente=68
Nombre=223
Situacion=177
GrpCalif=50
FUM=120
Tipo=51
TipoCredito=85
FechadeCita=87
HorariodeCita=91
CodigoPostal=66
Colonia=147
Municipio=145
Estado=98
Usuario=84
FechaEvento=119
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=Excel
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=forma.enviarexcel(<T>SQL<T>)

[sql.SucOrig]
Carpeta=sql
Clave=SucOrig
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[sql.FechaEmision]
Carpeta=sql
Clave=FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco








[Acciones.inf]
Nombre=inf
Boton=0
NombreDesplegar=INFO
EnBarraHerramientas=S
TipoAccion=expresion
Activo=S
Visible=S
Expresion=informacion(Info.Fechad)<BR>informacion(Info.Fechaa)
[Acciones.Filtrar.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si(Vacio(Info.FechaD),Asigna(Info.FechaD,Hoy),Info.FechaD)<BR>Si(Vacio(Info.FechaA),Asigna(Info.FechaA,Hoy),Info.FechaA)
[sql.SolicitudCred]
Carpeta=sql
Clave=SolicitudCred
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[sql.AnalisisCred]
Carpeta=sql
Clave=AnalisisCred
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



[sql.Tipo]
Carpeta=sql
Clave=Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco







[sql.FechaEvento]
Carpeta=sql
Clave=FechaEvento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[sql.FechadeCita]
Carpeta=sql
Clave=FechadeCita
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[sql.HorariodeCita]
Carpeta=sql
Clave=HorariodeCita
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=13
ColorFondo=Blanco

[sql.ComentarioEvent]
Carpeta=sql
Clave=ComentarioEvent
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[sql.Canal]
Carpeta=sql
Clave=Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[sql.TipoVenta]
Carpeta=sql
Clave=TipoVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[sql.TipoCredito]
Carpeta=sql
Clave=TipoCredito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[sql.Importe]
Carpeta=sql
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[sql.Cliente]
Carpeta=sql
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[sql.Nombre]
Carpeta=sql
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco









[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0189ExpCitasSupervVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S

[sql.CodigoPostal]
Carpeta=sql
Clave=CodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[sql.Colonia]
Carpeta=sql
Clave=Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[sql.Municipio]
Carpeta=sql
Clave=Municipio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[sql.Estado]
Carpeta=sql
Clave=Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[sql.Situacion]
Carpeta=sql
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[sql.GrpCalif]
Carpeta=sql
Clave=GrpCalif
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[sql.FUM]
Carpeta=sql
Clave=FUM
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[sql.Usuario]
Carpeta=sql
Clave=Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

