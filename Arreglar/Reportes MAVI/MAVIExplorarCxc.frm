[Forma]
Clave=MAVIExplorarCxc
Nombre=<T>Explorando - Cuentas por Cobrar (Movimientos)<T>
Icono=47
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=87
PosicionInicialArriba=116
PosicionInicialAltura=508
PosicionInicialAncho=1105
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Propiedades<BR>Imprimir<BR>Preliminar<BR>Excel<BR>Campos<BR>FiltroMov<BR>ActualizarSituacion<BR>Cancelar<BR>CancelaCobroInst<BR>Actualizar
EsMovimiento=S
TituloAuto=S
MovModulo=CXC
MovEspecificos=Todos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
EsConsultaExclusiva=S
PosicionInicialAlturaCliente=529
VentanaEstadoInicial=Normal
Comentarios=<T>Canal de Venta: <T> + Info.CanalVentaMAVI  + <T>   Periodo: <T> + Info.Periodo + <T>   Ejercicio: <T> + Info.Ejercicio
Totalizadores=S
PosicionSec1=470
PosicionSec2=208
ExpresionesAlMostrar=Asigna(Info.Ejercicio,0)<BR>Asigna(Info.Periodo,0)<BR>Asigna(Info.CanalVentaMAVI ,0 )

[Lista]
Estilo=Iconos
Clave=Lista
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCxc2
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroAutoCampo=(Validaciones Memoria)
FiltroAutoValidar=Mon
FiltroNullNombre=(sin clasificar)
FiltroTodoNombre=Todo
FiltroAncho=20
FiltroAplicaEn=Cxc.Moneda
FiltroRespetar=S
FiltroTipo=General
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroListaEstatus=(Todos)<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO<BR>SINAFECTAR
FiltroEstatusDefault=PENDIENTE
FiltroFechasCampo=Cxc.FechaEmision
FiltroFechasDefault=Este Mes
FiltroFechasNormal=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Movimientos
FiltroMovDefault=(Todos)
FiltroMonedasCampo=Cxc.Moneda
FiltroUENsCampo=Cxc.UEN
IconosSeleccionMultiple=S
ListaEnCaptura=Cxc.Cliente<BR>Cte.Nombre<BR>Cxc.FechaEmision<BR>Cxc.Vencimiento<BR>Cxc.Importe<BR>Cxc.Impuestos<BR>ImporteTotal<BR>SaldoF<BR>Cxc.Referencia<BR>Coincidencia<BR>UsuarioCancela
MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>QuitarSelecciona
FiltroEditarFueraPeriodo=S
FiltroEstatus=S
IconosSubTitulo=<T>Movimiento<T>
BusquedaRespetarFiltros=S
FiltroMovs=S
FiltroMovsTodos=S
IconosNombre=MaviCxc2:Movimiento
FiltroGeneral=CteEnviarA.id in (select id from VentasCanalMavi where categoria = <T>INSTITUCIONES<T>) AND<BR>Cte.Estatus = <T>ALTA<T> AND  isnull(Cte.Situacion,<T><T>) <> (<T>Cliente Fallecido<T>) AND<BR>CteEnviarA.SeccionCobranzaMAVI=<T>Instituciones<T> AND Cxc.ClienteEnviarA= {Comillas(Info.CanalVentaMAVI)}<BR><BR>/*{<BR>Si<BR>  ConDatos(Rep.MovEspecifico)<BR>Entonces<BR>  Si<BR>    (Rep.MovEspecifico = <T>Todos<T>) o (Rep.MovEspecifico = <T>Todo<T>) o (Rep.MovEspecifico = <T>TODOS<T>) o (Rep.MovEspecifico = <T>TODO<T>)<BR>  Entonces<BR>    <T>Cxc.Empresa=<T>+Comillas(Empresa)<BR>  SiNo<BR>    Si<BR>      Rep.MovEspecifico = <T>Contra Recibo Inst<T><BR>    Entonces                                                                                   <BR>      <T>Cxc.Mov=<T>+Comillas(Rep.MovEspecifico)+<T><CONTINUA>
FiltroGeneral002=<CONTINUA> AND Cxc.Empresa=<T>+Comillas(Empresa)+<T> AND CteEnviarA.SeccionCobranzaMAVI=<T>+Comillas(<T>Instituciones<T>)<BR>    SiNo<BR>      <T>Cxc.Mov=<T>+Comillas(Rep.MovEspecifico)+<T> AND Cxc.Empresa=<T>+Comillas(Empresa)<BR>    Fin<BR>  Fin<BR>Sino<BR>  <T> <T><BR>Fin<BR>}  */<BR><BR> /*<BR>{<BR>Si<BR>  ConDatos(Info.CanalVentaMAVI)<BR>Entonces<BR>  <T> AND Cxc.ClienteEnviarA=<T>+Comillas(Info.CanalVentaMAVI)<BR>Sino<BR>  <T> <T><BR>Fin<BR>} */<BR><BR>{<BR>Si<BR>  Info.Periodo <> 0<BR>Entonces<BR>  <T> AND DatePart(month,Cxc.Vencimiento)=<T>+Comillas(Info.Periodo)<BR>Sino<BR>  <T> <T><BR>Fin<BR>}<BR><BR>{<BR>Si<BR>  Info.Ejercicio <> 0<BR>Entonces<BR>  <T> AND DatePart(year,Cxc.Vencimiento)=<T>+Comillas(Info.Ejercicio)<BR>Sino<BR>  <T> <T><BR>Fin                                            <BR<CONTINUA>
FiltroGeneral003=<CONTINUA>>}






[Lista.Columnas]
0=170
1=140
2=84
3=167
4=91
5=83
6=85
7=87
8=90
9=86
10=67
11=-2
12=-2
13=-2
14=-2

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


[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=Imprimir
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Presentación preliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=67
NombreDesplegar=Enviar a Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S

[Acciones.Campos]
Nombre=Campos
Boton=45
NombreDesplegar=Personalizar &Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S






[Lista.Cxc.Cliente]
Carpeta=Lista
Clave=Cxc.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.FechaEmision]
Carpeta=Lista
Clave=Cxc.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Vencimiento]
Carpeta=Lista
Clave=Cxc.Vencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Referencia]
Carpeta=Lista
Clave=Cxc.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Importe]
Carpeta=Lista
Clave=Cxc.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Impuestos]
Carpeta=Lista
Clave=Cxc.Impuestos
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
[Lista.SaldoF]
Carpeta=Lista
Clave=SaldoF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=&Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarSelecciona]
Nombre=QuitarSelecciona
Boton=0
NombreDesplegar=&Quitar Selecciona
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
;Se comento para el refinanciamiento se dejen de generar contrarecibos BVF 04032011
;[Acciones.EnvioCobro]
;Nombre=EnvioCobro
;Boton=64
;NombreDesplegar=Envio a Cobro
;Multiple=S
;EnBarraHerramientas=S
;Activo=S
;Visible=S
;ListaAccionesMultiples=Expresion<BR>Actualizar
;NombreEnBoton=S
;EspacioPrevio=S
;Antes=S
;AntesExpresiones=Si((CuantosSeleccionID(<T>Lista<T>))>0,verdadero,Si(Informacion(<T>No se ha seleccionado ningun movimiento<T>)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Si(Precaucion(<T>¿Esta seguro de generar la cobranza de los movimientos seleccionados?<T>, BotonAceptar, BotonCancelar)=BotonAceptar, Verdadero, AbortarOperacion)
;[Acciones.EnvioCobro.Expresion]
;Nombre=Expresion
;Boton=0
;TipoAccion=Expresion
;Activo=S
;Visible=S
;Expresion=RegistrarListaSt(<T>Lista<T>,<T>Cxc.ID<T> )<BR>EjecutarSQLAnimado(<T>spMAVIEnvioCobro :tEmpresa, :nEstacionT, :tUsuario<T>,  Empresa, EstacionTrabajo, Usuario)<BR>Forma(<T>ListaIDOk<T>)
;[Acciones.EnvioCobro.Actualizar]
;Nombre=Actualizar
;Boton=0
;TipoAccion=Controles Captura
;ClaveAccion=Actualizar Vista
;Activo=S
;Visible=S
[Acciones.ActualizarSituacion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarListaSt(<T>Lista<T>,<T>Cxc.ID<T> )<BR>EjecutarSQLAnimado( <T>spMAVICobroDiferidoUpd :nEstacionT, :tUsuario<T>, EstacionTrabajo, Usuario))<BR>ActualizarVista
[Acciones.ActualizarSituacion]
Nombre=ActualizarSituacion
Boton=89
NombreDesplegar=&Actualizar Situación a Cobro Diferido
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
AntesExpresiones=Si((CuantosSeleccionID(<T>Lista<T>))>0,verdadero,Si(Informacion(<T>No se ha seleccionado ningun movimiento<T>)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Si(Precaucion(<T>¿Esta seguro de cambiar la situacion de los movimientos seleccionados?<T>, BotonAceptar, BotonCancelar)=BotonAceptar, Verdadero, AbortarOperacion)
[Acciones.FiltroMov]
Nombre=FiltroMov
Boton=107
NombreDesplegar=Filtro 
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Antes=S
Visible=S
EspacioPrevio=S
NombreEnBoton=S
AntesExpresiones=Forma(<T>MaviEspecificarMov<T>)
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Lista<T>)<BR>EjecutarSQL( <T>spMAVICobroInstitucionesDelete :nEstacionT<T>, EstacionTrabajo))
[Acciones.Eliminar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar.Eliminar]
Nombre=Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar.EliminarC]
Nombre=EliminarC
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar.ActualizarV]
Nombre=ActualizarV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Expresion.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Lista<T>)<BR>informacion(estacionTrabajo)<BR>informacion(SQL(<T>select @@spid<T>))
[Acciones.Expresion.actualizar Titulos]
Nombre=actualizar Titulos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Propiedades]
Nombre=Propiedades
Boton=35
NombreDesplegar=Propiedades del Movimiento
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
Activo=S
ConCondicion=S
Antes=S
Visible=S
EspacioPrevio=S
EjecucionConError=S
EjecucionCondicion=ConDatos(MaviCxc2:Cxc.ID)
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.ID, MaviCxc2:Cxc.ID)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=21
NombreEnBoton=S
NombreDesplegar=Cancelar Contra Recibos Inst.
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Antes=S
Expresion=RegistrarListaSt(<T>Lista<T>,<T>Cxc.ID<T> )<BR>EjecutarSQLAnimado( <T>spCancelarReciboMAVI :nEstacionT, :tUsuario, :tEmpresa<T>,  EstacionTrabajo, Usuario, Empresa ))<BR>Forma(<T>ListaIDOk<T>)<BR>ActualizarVista
AntesExpresiones=Si((CuantosSeleccionID(<T>Lista<T>))>0,verdadero,Si(Informacion(<T>No se ha seleccionado ningun movimiento<T>)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Si(Precaucion(<T>¿Esta seguro de cancelar los movimientos seleccionados?<T>, BotonAceptar, BotonCancelar)=BotonAceptar, Verdadero, AbortarOperacion)
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Monto
Totalizadores=S
TotCarpetaRenglones=Lista
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores2=Suma(MaviCxc2:SaldoF)
Totalizadores3=(Monetario)
ListaEnCaptura=Monto
[(Carpeta Totalizadores).Monto]
Carpeta=(Carpeta Totalizadores)
Clave=Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
[Lista.Coincidencia]
Carpeta=Lista
Clave=Coincidencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreDesplegar=Actualizar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


; ***** nuevo campo calculado para mostrar el usuario que cancelo el mov cobro. JR *****
[Lista.UsuarioCancela]
Carpeta=Lista
Clave=UsuarioCancela
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


; ***** Nueva accion para cancelar cobros al dia. JR *****
[Acciones.CancelaCobroInst]
Nombre=CancelaCobroInst
Boton=21
NombreEnBoton=S
NombreDesplegar=Cancelar Cobro Inst.
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=EspecificaCancelaCobroIns
Activo=S
Visible=S


