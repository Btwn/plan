[Forma]
Clave=DM0174EmbAsignarPisoFrm
Nombre=Asignar Embarques Piso
Icono=622
Modulos=(Todos)
ListaCarpetas=Variablesititia<BR>Pendientes<BR>Asignar
CarpetaPrincipal=Pendientes
PosicionInicialIzquierda=0
PosicionInicialArriba=4
PosicionInicialAltura=516
PosicionInicialAncho=1368
PosicionColumna1=61
PosicionSeccion1=57
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Asignar<BR>asigna
Comentarios=Lista(<T>Almacen: <T>+Info.CentroCostos,FechaEnTexto(Hoy,<T>dd/mmm/aaaa<T>))
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
PosicionInicialAlturaCliente=721
PosicionSec1=54
PosicionSec2=293
PosicionCol1=473
EsConsultaExclusiva=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0174MovId,nulo)

[Pendientes]
Estilo=Iconos
Clave=Pendientes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0174EmbPisoEVis
Fuente={MS Sans Serif, 8, Negro, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Pendientes
MenuLocal=S
ListaAcciones=PendientesAsignar<BR>PendientesSeleccionarTodo<BR>PendientesQuitaSel<BR>ClienteR
PermiteLocalizar=S
ListaEnCaptura=Estatus<BR>FechaEmision<BR>Mes<BR>Anual<BR>Sucursal
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosSubTitulo=<T>Movimiento<T>
IconosNombre=DM0174EmbPisoEVis:Mov+<T> <T>+DM0174EmbPisoEVis:MovID







[Pendientes.Columnas]
0=158
1=115
2=108
3=75
4=111
5=105
6=84
7=56
8=58
9=103
10=77

[Asignado.Columnas]
0=137
1=83
2=135
3=80
4=123
5=61
6=61
7=96
8=97
9=56
10=57
11=84
12=77



[Acciones.Asignar]
Nombre=Asignar
Boton=54
NombreEnBoton=S
NombreDesplegar=Asignar &Selección
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=CuantosSeleccionID(<T>Pendientes<T>)>0<BR>Entonces<BR>  RegistrarSeleccion(<T>Pendientes<T>)<BR>  EjecutarSQL(<T>SP_DM0174MaviEmbarquePisoAsignar :nEstacion, :nID,:numero,:nSucursal, :tfactura<T>, EstacionTrabajo, Info.ID,1,Sucursal,mavi.dm0174movid) <BR>  ActualizarForma<BR>Fin

[Acciones.PendientesSeleccionarTodo]
Nombre=PendientesSeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S



[Acciones.AsignadoQuitar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Asignado<T>)<BR>EjecutarSQL(<T>SP_MaviDM0174EmbarquePisoAsignar :nEstacion, :nID, 2<T>, EstacionTrabajo, Info.ID)

[Acciones.AsignadoQuitar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.PendientesAsignar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si CuantosSeleccionID(<T>Pendientes<T>)>0 Entonces<BR>   RegistrarSeleccion(<T>Pendientes<T>)<BR>   EjecutarSQL(<T>SP_MaviDM0174EmbarquePisoAsignar :nEstacion, :nID,1<T>, EstacionTrabajo, Info.ID)<BR>Sino<BR>    Precaucion(<T>No se Seleccionó Ninguna Factura<T>)<BR>Fin

[Acciones.PendientesAsignar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.PendientesAsignar]
Nombre=PendientesAsignar
Boton=0
NombreDesplegar=A&signar selección
Multiple=S
EnMenu=S
ListaAccionesMultiples=Expresion<BR>Actualizar Forma
Activo=S
Visible=S

[Acciones.AsignadoQuitar]
Nombre=AsignadoQuitar
Boton=0
NombreDesplegar=&Quitar
Multiple=S
EnMenu=S
ListaAccionesMultiples=Expresion<BR>Actualizar Forma
Activo=S
Visible=S

[Acciones.AsignadoSelecciona]
Nombre=AsignadoSelecciona
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S


[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Ordenar<BR>Aceptar













[Acciones.Aceptar.Ordenar]
Nombre=Ordenar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  CuantosSeleccionID(<T>Asignado<T>)>0<BR>Entonces<BR>  RegistrarSeleccion(<T>Asignado<T>)<BR>  EjecutarSQL(<T>SP_MaviDM0174EmbarquePisoAsignar :nEstacion, :nID, 1, :Nsuc<T>, EstacionTrabajo, Info.ID,Sucursal)<BR>Fin

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S




[Acciones.CancelarLocal.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S




[Acciones.PendientesQuitaSel]
Nombre=PendientesQuitaSel
Boton=0
NombreDesplegar=&Quitar Seleción
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Pendientes.Estatus]
Carpeta=Pendientes
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.FechaEmision]
Carpeta=Pendientes
Clave=FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Mes]
Carpeta=Pendientes
Clave=Mes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=74
[Pendientes.Anual]
Carpeta=Pendientes
Clave=Anual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Sucursal]
Carpeta=Pendientes
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.ID]
Carpeta=RutaDescripcion
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Mov]
Carpeta=RutaDescripcion
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.MovID]
Carpeta=RutaDescripcion
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Estatus]
Carpeta=RutaDescripcion
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.FechaEmision]
Carpeta=RutaDescripcion
Clave=FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Mes]
Carpeta=RutaDescripcion
Clave=Mes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=74
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Anual]
Carpeta=RutaDescripcion
Clave=Anual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Sucursal]
Carpeta=RutaDescripcion
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.ID]
Carpeta=Asignado
Clave=ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.Renglon]
Carpeta=Asignado
Clave=Renglon
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.RenglonID]
Carpeta=Asignado
Clave=RenglonID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.Orden]
Carpeta=Asignado
Clave=Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.Mov]
Carpeta=Asignado
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.MovID]
Carpeta=Asignado
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.Codigo]
Carpeta=Asignado
Clave=Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.ObservacionInicial]
Carpeta=Asignado
Clave=ObservacionInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.ObservacionFinal]
Carpeta=Asignado
Clave=ObservacionFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.ObservacionFinalProrroga]
Carpeta=Asignado
Clave=ObservacionFinalProrroga
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.FechaEntrega]
Carpeta=Asignado
Clave=FechaEntrega
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.EstadoArticulo]
Carpeta=Asignado
Clave=EstadoArticulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.FechaEntregaProrroga]
Carpeta=Asignado
Clave=FechaEntregaProrroga
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.EstadoArticuloProrroga]
Carpeta=Asignado
Clave=EstadoArticuloProrroga
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Asignar]
Estilo=Hoja
Clave=Asignar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Asignados
MenuLocal=S
Vista=DM0174EmbPisoAsigVis
ListaEnCaptura=DM0174EmbPisoDTbl.Orden<BR>DM0174EmbPisoDTbl.Mov<BR>DM0174EmbPisoDTbl.MovID<BR>DM0174EmbPisoDTbl.Codigo
ListaAcciones=QuitarF
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=ID = {Info.Id}
[Asignar.Columnas]
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=-2
12=-2
13=-2
14=-2
Renglon=64
ID=64
RenglonID=64
Orden=52
Mov=80
MovID=64
Codigo=64
ObservacionInicial=604
ObservacionFinal=604
ObservacionFinalProrroga=604
FechaEntrega=94
EstadoArticulo=124
FechaEntregaProrroga=113
EstadoArticuloProrroga=124
[Acciones.AsignadosQuitar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Asignado<T>)<BR>EjecutarSQL(<T>SP_MaviDM0174EmbarquePisoAsignar :nEstacion, :nID, 2<T>, EstacionTrabajo, Info.ID)
[Asignar.DM0174EmbPisoDTbl.Orden]
Carpeta=Asignar
Clave=DM0174EmbPisoDTbl.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Asignar.DM0174EmbPisoDTbl.Mov]
Carpeta=Asignar
Clave=DM0174EmbPisoDTbl.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Asignar.DM0174EmbPisoDTbl.MovID]
Carpeta=Asignar
Clave=DM0174EmbPisoDTbl.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Asignar.DM0174EmbPisoDTbl.Codigo]
Carpeta=Asignar
Clave=DM0174EmbPisoDTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ClienteR]
Nombre=ClienteR
Boton=0
NombreDesplegar=Cliente &Recoje
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MaviDM0174EmbarquePisoClienteRecoje :NSucursal, :TFactura, :TAgente, :TVehiculo, :TEstado, :TMunicipio, :TUsuario, :TAlmacen, :NUEN<T>,{Sucursal}, <T>Factura <T>+{DM0174EmbPisoEVis:MovID}, <T>ClIENTE<T>,<T>CLIENTE<T>,{Sucursal.Estado}, {Sucursal.Delegacion},{Usuario},DM0174EmbPisoEVis:Almacen,DM0174EmbPisoEVis:Uen)<BR>ActualizarVista<BR>Forma.ActualizarForma
[Acciones.QuitarF]
Nombre=QuitarF
Boton=0
NombreDesplegar=Quitar Factura
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSql(<T>Exec SP_MaviDM0174EmbarquePisoEliminaFactura :Tfactura <T>, DM0174EmbPisoAsigVis:DM0174EmbPisoDTbl.Mov+<T> <T>+DM0174EmbPisoAsigVis:DM0174EmbPisoDTbl.MovID)<BR><BR>Actualizarforma
[Variablesititia]
Estilo=Ficha
Clave=Variablesititia
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0174MOVID
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Variablesititia.Mavi.DM0174MOVID]
Carpeta=Variablesititia
Clave=Mavi.DM0174MOVID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.asigna]
Nombre=asigna
Boton=82
NombreDesplegar=Asignar Variables
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=aSIGNAR<BR>actualizar Titulos<BR>BUSCARfAC
RefrescarDespues=S
[Acciones.asigna.aSIGNAR]
Nombre=aSIGNAR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.asigna.actualizar Titulos]
Nombre=actualizar Titulos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.asigna.BUSCARfAC]
Nombre=BUSCARfAC
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=si Sql(<T>Select Count(*) from DM0174EmbEmbarquePisoDTbl where Movid=:tmovid and EstadoArticulo = :Testado<T>, Mavi.DM0174MovId,<T>Pendiente<T>) > 0 entonces<BR>     informacion(<T>La factura se encuentra en movimiento<T>)<BR>     fin<BR>  si Sql(<T>Select Count(*) from DM0174EmbEmbarquePisoDTbl where Movid=:tmovid and EstadoArticulo = :Testado<T>, Mavi.DM0174MovId,<T>Entregado<T>) > 0 entonces<BR>     informacion(<T>La factura ya fue entregada<T>)<BR>     fin


