[Forma]
Clave=ProcesarEmbarqueMAVI
Nombre=Embarque - Procesar en Lote
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=127
PosicionInicialArriba=42
PosicionInicialAltura=503
PosicionInicialAncho=1026
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Seleccionar Todo<BR>Mostrar Campos<BR>EmbEstatusS<BR>EmbEstatusP<BR>ActualizarDatos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionSeccion1=91
EsMovimiento=S
TituloAuto=S
MovModulo=EMB
MovEspecificos=Todos
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=682
VentanaEscCerrar=S
VentanaEstadoInicial=Normal

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=EmbarqueA
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
BusquedaRapidaControles=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroListaEstatus=SINAFECTAR<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=SINAFECTAR
FiltroUsuarioDefault=(Usuario)
FiltroFechasNormal=S
FiltroMonedasCampo=Venta.Moneda
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>QuitarSeleccion<BR>LocalCampos
IconosCampo=(por Omisión)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
BusquedaRespetarFiltros=S
BusquedaRespetarUsuario=S
FiltroFechasCampo=Embarque.FechaEmision
FiltroFechasDefault=(Todo)
FiltroFechas=S
FiltroModificarEstatus=S
FiltroMovDefault=(Todos)
FiltroSituacionTodo=S
IconosConSenales=S
FiltroEstatus=S
FiltroUsuarios=S
FiltroSucursales=S
Filtros=S
FiltroPredefinido=S
FiltroGrupo1=Embarque.Ruta
FiltroValida1=Embarque.Ruta
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroAutoCampo=(Validaciones Memoria)
FiltroAutoValidar=Alm
FiltroAutoOrden=Alm
FiltroTodo=S
FiltroAplicaEn=Embarque.Ruta
FiltroSituacion=S
ListaEnCaptura=Embarque.FechaEmision<BR>Embarque.Estatus<BR>Embarque.Concepto<BR>Embarque.Ruta<BR>Embarque.Agente<BR>Embarque.Importe<BR>ImporteTotal
IconosConRejilla=S
IconosNombre=EmbarqueA:Embarque.Mov + <T> <T>+ EmbarqueA:Embarque.MovID
IconosSeleccionMultiple=S
FiltroGeneral=Embarque.Mov =<T>Orden Cobro<T>

[Lista.Columnas]
0=135
1=123
2=77
3=129
4=93
5=109
6=91
7=92
8=87
9=92
10=59
11=76
12=64
13=83
14=71
15=56
16=97
17=92
18=24
19=51
20=56
21=56
22=56
23=56
24=72
25=81
26=81
27=81
28=81
29=64
30=73
31=73
32=73
33=73
34=47
35=41

[Acciones.Mostrar Campos]
Nombre=Mostrar Campos
Boton=45
NombreDesplegar=Personalizar &Vista
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
EspacioPrevio=S

[(Variables).Info.Mov]
Carpeta=(Variables)
Clave=Info.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20

[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=55
NombreEnBoton=S
NombreDesplegar=Seleccionar &Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.QuitarSeleccion]
Nombre=QuitarSeleccion
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S








[Acciones.LocalCampos]
Nombre=LocalCampos
Boton=0
NombreDesplegar=Personalizar &Vista
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S




















[Lista.Embarque.FechaEmision]
Carpeta=Lista
Clave=Embarque.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Embarque.Estatus]
Carpeta=Lista
Clave=Embarque.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Embarque.Concepto]
Carpeta=Lista
Clave=Embarque.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Embarque.Ruta]
Carpeta=Lista
Clave=Embarque.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Embarque.Agente]
Carpeta=Lista
Clave=Embarque.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Embarque.Importe]
Carpeta=Lista
Clave=Embarque.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.ImporteTotal]
Carpeta=Lista
Clave=ImporteTotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.EmbEstatus.Asignar1]
Nombre=Asignar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.EmbEstatus.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
[Acciones.EmbEstatusS]
Nombre=EmbEstatusS
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar Orden Cobro Sin Afectar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asignar1<BR>Expresion1<BR>Actualizar1
Activo=S
Visible=S
[Acciones.EmbEstatusP]
Nombre=EmbEstatusP
Boton=7
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Desembarcar Ordenes de Cobro
Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=Asignar2<BR>Expresion2<BR>Actualizar2
[Acciones.EmbEstatusS.Expresion1]
Nombre=Expresion1
Boton=0
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>    Confirmacion(<T>¿Desea pasar a estatus pendiente las ordenes de cobro seleccionadas?<T>,  BotonAceptar, BotonCancelar) = BotonAceptar<BR> Entonces<BR>   RegistrarSeleccionID( <T>Lista<T> )<BR>   EjecutarSQLAnimado(<T>spAfectarOrdenesCobroSinAfectarMAVI :nEstacionT, :tEmpresa, :tUsuario, :tAccion<T>,  EstacionTrabajo, Empresa, Usuario, <T>SINAFECTAR<T>)<BR>   Forma(<T>ListaIDOk<T>)<BR>   Si(SQL(<T>SELECT COUNT(0) FROM ListaIDOK l JOIN Embarque E ON E.ID = l.ID WHERE l.Empresa =:tEmp AND l.Estacion =:nEst AND l.Modulo =:tMod AND E.Estatus =:tEst<T>, Empresa, EstacionTrabajo, <T>EMB<T>, <T>SINAFECTAR<T>)>0,ReportePantalla(<T>EmbNoProcesadosMAVI<T>))<BR>Fin
EjecucionCondicion=CuantosSeleccionID( <T>Lista<T>)>0
EjecucionMensaje=<T>No se ha seleccionado ningun movimiento<T>
[Acciones.EmbEstatusS.Actualizar1]
Nombre=Actualizar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.EmbEstatusS.Asignar1]
Nombre=Asignar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.EmbEstatusP.Asignar2]
Nombre=Asignar2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.EmbEstatusP.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>   Confirmacion(<T>¿Desea desembarcar las ordenes de cobro seleccionadas?<T>,  BotonAceptar, BotonCancelar) = BotonAceptar<BR> Entonces<BR>   RegistrarSeleccionID( <T>Lista<T> )<BR>    EjecutarSQLAnimado(<T>spAfectarOrdenesCobroSinAfectarMAVI :nEstacionT, :tEmpresa, :tUsuario, :tAccion<T>,  EstacionTrabajo, Empresa, Usuario, <T>PENDIENTE<T>)<BR>    Forma(<T>ListaIDOk<T>)<BR>Fin
EjecucionCondicion=CuantosSeleccionID(<T>Lista<T>) > 0
EjecucionMensaje=<T>No se ha seleccionado ningun movimiento<T>
[Acciones.EmbEstatusP.Actualizar2]
Nombre=Actualizar2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ActualizarDatos]
Nombre=ActualizarDatos
Boton=82
NombreDesplegar=Actualizar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

