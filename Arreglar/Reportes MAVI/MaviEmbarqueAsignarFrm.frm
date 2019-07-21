[Forma]
Clave=MaviEmbarqueAsignarFrm
Nombre=Asignar Embarques
Icono=622
Modulos=(Todos)
ListaCarpetas=Pendientes<BR>Asignado<BR>RutaDescripcion
CarpetaPrincipal=Pendientes
PosicionInicialIzquierda=0
PosicionInicialArriba=26
PosicionInicialAltura=516
PosicionInicialAncho=1024
PosicionColumna1=61
PosicionSeccion1=57
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Asignar<BR>AsignarTodo
Comentarios=Lista(<T>Almacen: <T>+Info.CentroCostos,FechaEnTexto(Hoy,<T>dd/mmm/aaaa<T>))
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=688
PosicionSec1=41
PosicionSec2=377
PosicionCol1=473

[Pendientes]
Estilo=Iconos
Clave=Pendientes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MaviEmbarqueCasaEVis
Fuente={MS Sans Serif, 8, Negro, [Negritas]}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Pendientes
IconosSeleccionMultiple=S
MenuLocal=S
ListaAcciones=PendientesAsignar<BR>PendientesSeleccionarTodo<BR>PendientesQuitaSel
OtroOrden=S
ListaOrden=EmbarqueMov.ID<TAB>(Acendente)
PermiteLocalizar=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
ListaEnCaptura=Embarque.Mov<BR>Embarque.MovID<BR>Embarque.Estatus<BR>EmbarqueD.Estado<BR>Cte.Poblacion<BR>RutaNombre
FiltroGrupo1=Embarque.Ruta
FiltroValida1=Embarque.Ruta
FiltroTodo=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroTodoFinal=S
IconosNombre=MaviEmbarqueCasaEVis:EmbarqueMov.Mov+<T> <T>+MaviEmbarqueCasaEVis:EmbarqueMov.MovID
FiltroGeneral=EmbarqueMov.Mov Like <T>Factura%<T><BR>And Embarque.Mov = <T>Embarque Magisterio<T><BR>And Embarque.Estatus in (<T>PENDIENTE<T>,<T>CONCLUIDO<T>)<BR>And EmbarqueD.Estado in (<T>Entregado<T>,<T>Transito<T>)<BR>And EmbarqueMov.Modulo = <T>VTAS<T><BR><BR><BR>And EmbarqueMov.Mov +<T> <T>+EmbarqueMov.MovID Not in (Select ECD.Mov+<T> <T>+ECD.MovID As Movimiento<BR>                                                    From MaviEmbarqueCasaDTbl ECD<BR>                                                    INNER JOIN MaviEmbarqueCasaTbl EC on ECD.ID = EC.ID<BR>                                                    Where EC.Estatus in (<T>SINAFECTAR<T>,<T>PENDIENTE<T>,<T>CONCLUIDO<T>))






[Asignado]
Estilo=Iconos
Clave=Asignado
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Vista=MaviEmbarqueCasaAsigVis
Fuente={MS Sans Serif, 8, Negro, [Negritas]}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosSubTitulo=<T>Movimiento<T>
PestanaOtroNombre=S
PestanaNombre=Asignados
MenuLocal=S
ListaAcciones=AsignadoQuitar<BR>AsignadoSelecciona
OtroOrden=S
IconosCambiarOrden=S
ListaEnCaptura=MaviEmbarqueCasaDTbl.Orden<BR>MaviEmbarqueCasaDTbl.Codigo
ListaOrden=MaviEmbarqueCasaDTbl.ID<TAB>(Acendente)
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=MaviEmbarqueCasaAsigVis:MaviEmbarqueCasaDTbl.Mov+<T> <T>+MaviEmbarqueCasaAsigVis:MaviEmbarqueCasaDTbl.MovID
FiltroGeneral=ID = {Info.ID}

[Pendientes.Columnas]
0=158
1=115
2=72
3=75
4=111
5=105
6=214
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
Expresion=Si<BR>  CuantosSeleccionID(<T>Pendientes<T>)>0<BR>Entonces<BR>  RegistrarSeleccion(<T>Pendientes<T>)<BR>  EjecutarSQL(<T>SP_MaviEmbarqueCasaAsignar :nEstacion, :nID,1<T>, EstacionTrabajo, Info.ID)<BR>  ActualizarForma<BR>Fin

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
Expresion=RegistrarSeleccion(<T>Asignado<T>)<BR>EjecutarSQL(<T>SP_MaviEmbarqueCasaAsignar :nEstacion, :nID, 2<T>, EstacionTrabajo, Info.ID)

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
Expresion=Si CuantosSeleccionID(<T>Pendientes<T>)>0 Entonces<BR>   RegistrarSeleccion(<T>Pendientes<T>)<BR>   EjecutarSQL(<T>SP_MaviEmbarqueCasaAsignar :nEstacion, :nID,1<T>, EstacionTrabajo, Info.ID)<BR>Sino<BR>    Precaucion(<T>No se Seleccionó Ninguna Factura<T>)<BR>Fin

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
Expresion=Si<BR>  CuantosSeleccionID(<T>Asignado<T>)>0<BR>Entonces<BR>  RegistrarSeleccion(<T>Asignado<T>)<BR>  EjecutarSQL(<T>SP_MaviEmbarqueCasaAsignar :nEstacion, :nID, 1<T>, EstacionTrabajo, Info.ID)<BR>Fin

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




[Acciones.AsignarTodo]
Nombre=AsignarTodo
Boton=55
NombreEnBoton=S
NombreDesplegar=Asignar &Todo
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SeleccionarTodo(<T>Pendientes<T>)<BR>Si<BR>  CuantosSeleccionID(<T>Pendientes<T>)>0<BR>Entonces<BR>  RegistrarSeleccion(<T>Pendientes<T>)<BR>  EjecutarSQL(<T>SP_MaviEmbarqueCasaAsignar :nEstacion, :nID,1<T>, EstacionTrabajo, Info.ID)<BR>  ActualizarForma<BR>Fin
[Acciones.PendientesQuitaSel]
Nombre=PendientesQuitaSel
Boton=0
NombreDesplegar=&Quitar Seleción
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Asignado.MaviEmbarqueCasaDTbl.Codigo]
Carpeta=Asignado
Clave=MaviEmbarqueCasaDTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Embarque.Mov]
Carpeta=Pendientes
Clave=Embarque.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Embarque.MovID]
Carpeta=Pendientes
Clave=Embarque.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Asignado.MaviEmbarqueCasaDTbl.Orden]
Carpeta=Asignado
Clave=MaviEmbarqueCasaDTbl.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.RutaNombre]
Carpeta=Pendientes
Clave=RutaNombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Cte.Poblacion]
Carpeta=Pendientes
Clave=Cte.Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Pendientes.Embarque.Estatus]
Carpeta=Pendientes
Clave=Embarque.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[RutaDescripcion.Embarque.Ruta]
Carpeta=RutaDescripcion
Clave=Embarque.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=N
Tamano=15
ColorFondo=Plata
ColorFuente=Azul
Efectos=[Negritas + Subrayado]
Pegado=S
[RutaDescripcion.RutaNombre]
Carpeta=RutaDescripcion
Clave=RutaNombre
Editar=S
LineaNueva=N
ValidaNombre=N
3D=N
ColorFondo=Plata
ColorFuente=Azul
Tamano=50
Efectos=[Negritas + Subrayado]
Pegado=S
[RutaDescripcion]
Estilo=Ficha
Clave=RutaDescripcion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviEmbarqueCasaEVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Azul
CampoColorFondo=Plata
ListaEnCaptura=Embarque.Ruta<BR>RutaNombre
CarpetaVisible=S
[Pendientes.EmbarqueD.Estado]
Carpeta=Pendientes
Clave=EmbarqueD.Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

