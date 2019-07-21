[Forma]
Clave=ProcesarVentaMAVI
Nombre=Ventas - Costeo Flete
Icono=0
Modulos=(Todos)
PosicionInicialIzquierda=204
PosicionInicialArriba=75
PosicionInicialAltura=503
PosicionInicialAncho=1032
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Seleccionar Todo<BR>MovPropiedades<BR>Mostrar Campos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionSeccion1=91
EsMovimiento=S
TituloAuto=S
MovModulo=VTAS
MovEspecificos=Todos
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=712
ListaCarpetas=Lista
CarpetaPrincipal=Lista


[Lista.Columnas]
0=127
1=76
2=81
3=81
4=117
5=64
6=64
7=60
8=87
9=170
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

[Acciones.MovPropiedades]
Nombre=MovPropiedades
Boton=35
NombreDesplegar=Propiedades
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
Activo=S
Antes=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(VentaPMAVI:ID)
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, VentaPMAVI:ID)

[Acciones.LocalPropiedades]
Nombre=LocalPropiedades
Boton=0
NombreDesplegar=&Propiedades
EnMenu=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
Antes=S
Visible=S
ActivoCondicion=ConDatos(VentaP:ID)
AntesExpresiones=Asigna(Info.Modulo, <T>VTAS<T>)<BR>Asigna(Info.ID, VentaP:ID)

[Acciones.Localizar]
Nombre=Localizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=Alt+F3
NombreDesplegar=&Localizar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S

[Acciones.LocalizarSiguiente]
Nombre=LocalizarSiguiente
Boton=0
UsaTeclaRapida=S
TeclaRapida=F3
NombreDesplegar=Localizar &Siguiente
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar Siguiente
Activo=S
Visible=S

[Acciones.Imprimir]
Nombre=Imprimir
Boton=0
NombreDesplegar=Imprimir
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=0
NombreDesplegar=Presentación preliminar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S

[Acciones.Enviar a Excel]
Nombre=Enviar a Excel
Boton=0
NombreDesplegar=Enviar a Excel
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
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


;[Acciones.Reservar]
;Nombre=Reservar
;Boton=0
;NombreDesplegar=&Reservar Lote
;RefrescarIconos=S
;EnLote=S
;EnMenu=S
;TipoAccion=Expresion
;Expresion=Reservar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>PENDIENTE<T>, <T><T>, <T>ProcesarVenta<T>)
;ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
;VisibleCondicion=Usuario.AfectarLote

[Acciones.Desreservar]
Nombre=Desreservar
Boton=0
NombreDesplegar=&Des-Reservar Lote
RefrescarIconos=S
EnLote=S
EnMenu=S
TipoAccion=Expresion
Expresion=DesReservar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>RESERVADO<T>, <T><T>, <T>ProcesarVenta<T>)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote








[Acciones.ImprimirSeleccion]
Nombre=ImprimirSeleccion
Boton=0
NombreDesplegar=&Imprimir Lote
EnMenu=S
TipoAccion=Expresion
Visible=S
EnLote=S
RefrescarIconos=S
ConCondicion=S
Expresion=ReporteImpresora(ReporteMovImpresora(<T>VTAS<T>, VentaP:Mov, VentaP:e.Estatus), VentaP:ID)
ActivoCondicion=Usuario.ImprimirMovs
EjecucionCondicion=ConDatos(VentaP:ID)

[Acciones.CancelarPendiente]
Nombre=CancelarPendiente
Boton=0
NombreDesplegar=Cancelar Lote (Cantidad Pendiente)
RefrescarIconos=S
EnLote=S
EnMenu=S
TipoAccion=Expresion
Expresion=Cancelar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>PENDIENTE<T>, <T><T>, <T>ProcesarVenta<T>)
ActivoCondicion=PuedeAfectar(Usuario.Cancelar, Usuario.CancelarOtrosMovs, VentaP:e.Usuario) y ConDatos(VentaP:ID) y ConDatos(VentaP:MovID)
VisibleCondicion=Usuario.CancelarLote

[Acciones.VentaPerdida]
Nombre=VentaPerdida
Boton=0
NombreDesplegar=Venta Perdida Lote
RefrescarIconos=S
EnMenu=S
TipoAccion=Expresion
Expresion=RegistrarSeleccionID<BR>ProcesarSQL(<T>spAfectarLoteLista :nEstacion, :tEmpresa, :tModulo, :tAccion, :tBase, :tGenerarMov, :tUsuario, :tFactLote<T>, EstacionTrabajo, Empresa, <T>VTAS<T>, <T>GENERAR<T>, <T>PENDIENTE<T>, ConfigMov.VentaPerdida, Usuario, <T>Cliente<T>)<BR>Forma(<T>ListaIDOk<T>)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote

[Acciones.CancelarMov]
Nombre=CancelarMov
Boton=0
NombreDesplegar=Cancelar Lote (Movimiento Completo)
RefrescarIconos=S
EnLote=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Expresion
Expresion=Cancelar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>TODO<T>, <T><T>, <T>ProcesarVenta<T>)
ActivoCondicion=PuedeAfectar(Usuario.Cancelar, Usuario.CancelarOtrosMovs, VentaP:e.Usuario) y ConDatos(VentaP:ID) y ConDatos(VentaP:MovID)
VisibleCondicion=Usuario.CancelarLote

[Acciones.Concluir]
Nombre=Concluir
Boton=0
NombreDesplegar=Concluir &Facturas Lote
EnMenu=S
TipoAccion=Expresion
RefrescarIconos=S
EnLote=S
Expresion=Afectar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>Todo<T>, <T><T>, <T>ProcesarVenta<T>)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote y Config.FacturasPendientesSerieLote

[Acciones.Afectar]
Nombre=Afectar
Boton=0
NombreDesplegar=&Afectar Lote
EnMenu=S
TipoAccion=Expresion
EspacioPrevio=S
ConCondicion=S
RefrescarIconos=S
EnLote=S
Expresion=Afectar(<T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, <T>Todo<T>, <T><T>, <T>ProcesarVenta<T>)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
EjecucionCondicion=VentaP:e.Estatus=EstatusSinAfectar
VisibleCondicion=Usuario.AfectarLote

[Acciones.Facturar]
Nombre=Facturar
Boton=0
NombreDesplegar=&Facturar Lote...
EnMenu=S
TipoAccion=Expresion
RefrescarIconos=S
EspacioPrevio=S
Expresion=Si<BR>  Forma(<T>EspecificarMovFactura<T>) y (MovTipo(<T>VTAS<T>, Info.MovFactura) = VTAS.F)<BR>Entonces<BR>  RegistrarSeleccionID<BR>  Si(SQL(<T>spValidarUEN_MAVI :nEstacion, :tMov<T>, EstacionTrabajo, Info.MovFactura) = 0,Si(Precaucion(<T>Hay UENs Incompatibles<T>, BotonCancelar)=BotonCancelar, AbortarOperacion))<BR>  ProcesarSQL(<T>spAfectarLoteLista :nEstacion, :tEmpresa, :tModulo, :tAccion, :tBase, :tGenerarMov, :tUsuario, :tFactLote<T>, EstacionTrabajo, Empresa, <T>VTAS<T>, <T>GENERAR<T>, <T>TODO<T>, Info.MovFactura, Usuario, Info.FacturarLote)<BR>  Forma(<T>ListaIDOk<T>)<BR>  Informacion(SQL(<T>spMAVIMsjProceso :nEstacion<T>, EstacionTrabajo ))<BR>Fin
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote

[Acciones.DesEmbarcar]
Nombre=DesEmbarcar
Boton=0
NombreDesplegar=Desembarcar Lote
EnMenu=S
TipoAccion=Expresion
Activo=S
EnLote=S
RefrescarIconos=S
Expresion=EjecutarSQL(<T>spEmbarqueManual :tEmpresa, :tModulo, :nID, :tMov, :tMovID, :tEstatus, 1, 1<T>, VentaP:Empresa, <T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, VentaP:e.Estatus)
VisibleCondicion=Usuario.AfectarLote

[Acciones.Embarcar]
Nombre=Embarcar
Boton=0
NombreDesplegar=Embarcar Lote
EnMenu=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
EnLote=S
RefrescarIconos=S
Expresion=EjecutarSQL(<T>spEmbarqueManual :tEmpresa, :tModulo, :nID, :tMov, :tMovID, :tEstatus, 0, 1<T>, VentaP:Empresa, <T>VTAS<T>, VentaP:ID, VentaP:Mov, VentaP:MovID, VentaP:e.Estatus)
VisibleCondicion=Usuario.AfectarLote


[Acciones.FacturacionRapida]
Nombre=FacturacionRapida
Boton=0
NombreDesplegar=Fac&turación Rápida Lote
EnMenu=S
TipoAccion=Expresion
RefrescarIconos=S
EnLote=S
Expresion=EjecutarSQL(<T>spFacturacionRapida :nID, :tUsuario, :tEmpresa<T>, VentaP:ID, Usuario, Empresa)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote y (Config.VentaLimiteRenFacturas>0)

[Acciones.FacturacionRapidaAgrupada]
Nombre=FacturacionRapidaAgrupada
Boton=0
NombreDesplegar=Fac&turación Rápida Agrupada Lote 
EnMenu=S
TipoAccion=Expresion
RefrescarIconos=S
EnLote=S
Expresion=EjecutarSQL(<T>spFacturacionRapida :nID, :tUsuario, :tEmpresa, 1<T>, VentaP:ID, Usuario, Empresa)
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, VentaP:e.Usuario)
VisibleCondicion=Usuario.AfectarLote y (Config.VentaLimiteRenFacturas>0)
[Lista.Situacion]
Carpeta=Lista
Clave=Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.SituacionFecha]
Carpeta=Lista
Clave=SituacionFecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cliente]
Carpeta=Lista
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista]
Estilo=Iconos
Pestana=S
PestanaOtroNombre=S
Clave=Lista
Filtros=S
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=VentaPMAVI
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroGrupo1=(Validaciones Memoria)
FiltroValida1=Alm
FiltroAplicaEn1=e.Almacen
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaRespetarUsuario=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
FiltroMovsTodos=S
FiltroUENsCampo=e.UEN
FiltroListaEstatus=SINAFECTAR<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=PENDIENTE
FiltroFechasCampo=FechaEmision
FiltroFechasDefault=(Todo)
FiltroMovDefault=(Todos)
FiltroFechas=S
FiltroUENs=S
ListaEnCaptura=e.Situacion<BR>e.SituacionFecha<BR>e.Cliente<BR>Metros<BR>PesoCalculado<BR>e.UEN<BR>Nombre<BR>Direccion<BR>DireccionNumero<BR>DireccionNumeroInt<BR>Poblacion<BR>Delegacion<BR>Colonia<BR>CodigoPostal<BR>Estado
FiltroSituacion=S
FiltroSucursales=S
IconosSeleccionMultiple=S
ListaAcciones=Costear
FiltroEstatus=S
FiltroMovs=S
FiltroSituacionTodo=S
IconosNombre=VentaPMAVI:Mov+<T> <T>+VentaPMAVI:MovID
[Lista.e.UEN]
Carpeta=Lista
Clave=e.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.e.Situacion]
Carpeta=Lista
Clave=e.Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.e.SituacionFecha]
Carpeta=Lista
Clave=e.SituacionFecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.e.Cliente]
Carpeta=Lista
Clave=e.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Nombre]
Carpeta=Lista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Direccion]
Carpeta=Lista
Clave=Direccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DireccionNumero]
Carpeta=Lista
Clave=DireccionNumero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DireccionNumeroInt]
Carpeta=Lista
Clave=DireccionNumeroInt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Poblacion]
Carpeta=Lista
Clave=Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Delegacion]
Carpeta=Lista
Clave=Delegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Colonia]
Carpeta=Lista
Clave=Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CodigoPostal]
Carpeta=Lista
Clave=CodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Estado]
Carpeta=Lista
Clave=Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Costear]
Nombre=Costear
Boton=0
NombreDesplegar=&Costear...
EnMenu=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
RefrescarIconos=S
Multiple=S
ListaAccionesMultiples=Costear<BR>Refrescar
[Acciones.Costear.Costear]
Nombre=Costear
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccionID<BR>SI(SQL(<T>Select count(*) from ListaID where Estacion = :nEstacion<T>,EstacionTrabajo)>0,Forma(<T>CosteoFleteMAVI<T>),Si(Precaucion(<T>No ha seleccionado ningun Pedido Mayoreo<T>,BotonAceptar)=BotonAceptar,AbortarOperacion,AbortarOperacion))
Activo=S
Visible=S
[Acciones.Costear.Refrescar]
Nombre=Refrescar
Boton=0
TipoAccion=Expresion
Expresion=ActualizarVista
Activo=S
Visible=S
[Lista.Metros]
Carpeta=Lista
Clave=Metros
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PesoCalculado]
Carpeta=Lista
Clave=PesoCalculado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

