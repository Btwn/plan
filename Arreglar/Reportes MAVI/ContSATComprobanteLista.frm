
[Forma]
Clave=ContSATComprobanteLista
Icono=0
CarpetaPrincipal=ContSATComprobanteListas
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

PosicionInicialIzquierda=182
PosicionInicialArriba=111
PosicionInicialAlturaCliente=506
PosicionInicialAncho=1001
PosicionSec1=328
Nombre=Información Polizas
ListaCarpetas=ContSATComprobanteListas<BR>Detalles
ListaAcciones=Aceptare<BR>EnviarExcel<BR>Comprobante<BR>CFDCBB<BR>Extranjero<BR>Cheque<BR>Transferencia<BR>OtrosMetodos<BR>Validare<BR>MovPosicion<BR>ExploradorPolizas
PosicionSeccion1=50
Menus=S
MenuPrincipal=&Archivo<BR>&Transacción
[ContSATComprobanteLista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Polizas
Clave=ContSATComprobanteLista
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATComprobanteLista
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
;ListaEnCaptura=(Lista)
ListaEnCaptura=ContSATComprobanteLista.TipoPoliza<BR>ContSATComprobanteLista.Referencia<BR>ContSATComprobanteLista.Concepto<BR>ContSATComprobanteLista.Proyecto

FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroPeriodos=S
FiltroEjercicios=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroMonedas=S
FiltroFechasCampo=ContSATComprobanteLista.FechaEmision
FiltroFechasNormal=S
FiltroMonedasCampo=ContSATComprobanteLista.Moneda
FiltroFechasNombre=&Fecha
CarpetaVisible=S

IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSubTitulo=<T>Consecutivo<T>
FiltroTodo=S
FiltroGrupo1=ContSATComprobanteLista.TipoPoliza
FiltroValida1=ContSATComprobanteLista.TipoPoliza
BusquedaRapida=S
BusquedaEnLinea=S
IconosNombre=ContSATComprobanteLista:ContSATComprobanteLista.Mov+<T> <T>+ContSATComprobanteLista:ContSATComprobanteLista.MovID
[ContSATComprobanteLista.ContSATComprobanteLista.Referencia]
Carpeta=ContSATComprobanteLista
Clave=ContSATComprobanteLista.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATComprobanteLista.ContSATComprobanteLista.Concepto]
Carpeta=ContSATComprobanteLista
Clave=ContSATComprobanteLista.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[ContSATComprobanteLista.ContSATComprobanteLista.Proyecto]
Carpeta=ContSATComprobanteLista
Clave=ContSATComprobanteLista.Proyecto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Calendario.ListaEnCaptura]
(Inicio)=ContD.Cuenta
ContD.Cuenta=ContD.Debe
ContD.Debe=ContD.Haber
ContD.Haber=ContD.Concepto
ContD.Concepto=(Fin)





[ContSATComprobanteLista.Columnas]
0=163
1=196
2=278
3=198

Referencia=304
Concepto=304
Proyecto=304
4=93
5=-2
6=-2
[Calendario.Columnas]
Cuenta=124
Debe=64
Haber=64
Concepto=304






[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S




[ContSATComprobante.Columnas]
Modulo=64
ModuloID=64
ContID=64
ModuloRenglon=77
UUID=304
Monto=64
RFC=304

EsCheque=64
EsTransferencia=81
[Acciones.Comprobantes]
Nombre=Comprobantes
Boton=0
NombreEnBoton=S
NombreDesplegar=Comprobantes
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S





EspacioPrevio=S


GuardarAntes=S
Antes=S
DespuesGuardar=S

Expresion=FormaModal(<T>ContSATLista<T>)
AntesExpresiones=Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov+<T> <T>+ContSATComprobanteLista:ContSATComprobanteLista.MovID)<BR>Asigna(Info.Modulo,ContSATComprobanteLista:ContSATComprobanteLista.OrigenTipo)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio)<BR>Asigna(Info.Periodo,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)<BR>Asigna(Info.Tipo,ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza)
[Cont.ListaEnCaptura]
(Inicio)=ContD.Cuenta
ContD.Cuenta=ContD.Debe
ContD.Debe=ContD.Haber
ContD.Haber=ContD.Concepto
ContD.Concepto=(Fin)






[Cont.Columnas]
Cuenta=124
Debe=64
Haber=64
Concepto=304















[Detalle]
Estilo=Hoja
Clave=Detalle
Detalle=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=ContD
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=ContSATComprobanteLista
LlaveLocal=ContD.ID
LlaveMaestra=ContSATComprobanteLista.ID
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
;ListaEnCaptura=(Lista)
ListaEnCaptura=ContD.Cuenta<BR>ContD.Debe<BR>ContD.Haber<BR>ContD.Concepto

CarpetaVisible=S

[Detalle.ContD.Cuenta]
Carpeta=Detalle
Clave=ContD.Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.ContD.Debe]
Carpeta=Detalle
Clave=ContD.Debe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.ContD.Haber]
Carpeta=Detalle
Clave=ContD.Haber
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.ContD.Concepto]
Carpeta=Detalle
Clave=ContD.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco



[Detalle.Columnas]
Cuenta=124
Debe=64
Haber=64
Concepto=304

;[Detalle.ListaEnCaptura]
(Inicio)=ContD.Cuenta
ContD.Cuenta=ContD.Debe
ContD.Debe=ContD.Haber
ContD.Haber=ContD.Concepto
ContD.Concepto=(Fin)













[ContSATComprobanteLista.ContSATComprobanteLista.TipoPoliza]
Carpeta=ContSATComprobanteLista
Clave=ContSATComprobanteLista.TipoPoliza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco













[Acciones.Expresion]
Nombre=Expresion
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Archivo SAT
GuardarAntes=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S












Expresion=ProcesarSQL(<T>spContSATGenerarXml :tEmpresa, :nEjercicio, :nPeriodo<T>,Empresa,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)
[ContSATCheque.Columnas]
CtaOrigen=94
BancoOrigen=145
Monto=64
Fecha=94
Beneficiario=228
NumeroCheque=110
RFC=138

[ContSATTranferencia.Columnas]
CtaOrigen=112
BancoOrigen=140
CtaDestino=184
BancoDestino=136
Monto=64
Fecha=94
Beneficiario=136
RFC=137











[Acciones.Excel]
Nombre=Excel
Boton=67
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S








[Acciones.MovPos]
Nombre=MovPos
Boton=34
NombreEnBoton=S
NombreDesplegar=&Posición del Movimiento
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Antes=S
Visible=S





Expresion= Forma(<T>MovPos<T>)
AntesExpresiones=Asigna(Info.Modulo, <T>CONT<T>)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov)
[Acciones.Validar]
Nombre=Validar
Boton=71
NombreEnBoton=S
NombreDesplegar=&Validar Información
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S



EspacioPrevio=S
Expresion=ProcesarSQL(<T>spValidarContSatComprobante :tEmpresa, :nEjercicio, :nPeriodo<T>,Empresa,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)


;[ContSATComprobanteLista.ListaEnCaptura]
(Inicio)=ContSATComprobanteLista.TipoPoliza
ContSATComprobanteLista.TipoPoliza=ContSATComprobanteLista.Referencia
ContSATComprobanteLista.Referencia=ContSATComprobanteLista.Concepto
ContSATComprobanteLista.Concepto=ContSATComprobanteLista.Proyecto
ContSATComprobanteLista.Proyecto=(Fin)























[ContSATComprobanteListas]
Estilo=Hoja
PestanaOtroNombre=S
PestanaNombre=Polizas
Clave=ContSATComprobanteListas
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ContSATComprobanteLista
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Consecutivo<BR>ContSATComprobanteLista.TipoPoliza<BR>ContSATComprobanteLista.Referencia<BR>ContSATComprobanteLista.Concepto<BR>ContSATComprobanteLista.Proyecto
FiltroPredefinido=S
FiltroGrupo1=ContSATComprobanteLista.TipoPoliza
FiltroValida1=ContSATComprobanteLista.TipoPoliza
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroPeriodos=S
FiltroEjercicios=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroMonedas=S
FiltroFechasNormal=S
FiltroMonedasCampo=ContSATComprobanteLista.Moneda
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
BusquedaRespetarControles=S
FiltroGeneral=ContSATComprobanteLista.Empresa = Empresa
[ContSATComprobanteListas.ContSATComprobanteLista.TipoPoliza]
Carpeta=ContSATComprobanteListas
Clave=ContSATComprobanteLista.TipoPoliza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ContSATComprobanteListas.ContSATComprobanteLista.Referencia]
Carpeta=ContSATComprobanteListas
Clave=ContSATComprobanteLista.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ContSATComprobanteListas.ContSATComprobanteLista.Concepto]
Carpeta=ContSATComprobanteListas
Clave=ContSATComprobanteLista.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ContSATComprobanteListas.ContSATComprobanteLista.Proyecto]
Carpeta=ContSATComprobanteListas
Clave=ContSATComprobanteLista.Proyecto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Detalles]
Estilo=Hoja
Clave=Detalles
Detalle=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=ContD
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
VistaMaestra=ContSATComprobanteLista
LlaveLocal=ContD.ID
LlaveMaestra=ContSATComprobanteLista.ID
;ListaEnCaptura=(Lista)
ListaEnCaptura=ContD.Cuenta<BR>ContD.Debe<BR>ContD.Haber<BR>ContD.Concepto

[Detalles.ContD.Cuenta]
Carpeta=Detalles
Clave=ContD.Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Detalles.ContD.Debe]
Carpeta=Detalles
Clave=ContD.Debe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Detalles.ContD.Haber]
Carpeta=Detalles
Clave=ContD.Haber
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Detalles.ContD.Concepto]
Carpeta=Detalles
Clave=ContD.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[ContSATComprobanteListas.Columnas]
0=100
1=100
2=100
3=100
4=100
TipoPoliza=170
Referencia=189
Concepto=188
Proyecto=231
Consecutivo=154
[Detalles.Columnas]
Cuenta=124
Debe=64
Haber=64
Concepto=304
[Acciones.Aceptare]
Nombre=Aceptare
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
Menu=&Archivo
EnMenu=S
[Acciones.EnviarExcel]
Nombre=EnviarExcel
Boton=67
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
[Acciones.Comprobante]
Nombre=Comprobante
Boton=0
NombreEnBoton=S
NombreDesplegar=Comp. Nacional
GuardarAntes=S
TipoAccion=Expresion
Visible=S
Antes=S
Menu=&Transacción
EnMenu=S
Expresion=FormaModal(<T>ContSATLista<T>)
ActivoCondicion=ConDatos(ContSATComprobanteLista:ContSATComprobanteLista.ID)
AntesExpresiones=Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov+<T> <T>+ContSATComprobanteLista:ContSATComprobanteLista.MovID)<BR>Asigna(Info.Modulo,ContSATComprobanteLista:ContSATComprobanteLista.OrigenTipo)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio)<BR>Asigna(Info.Periodo,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)<BR>Asigna(Info.Tipo,ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza)
[Acciones.Validare]
Nombre=Validare
Boton=71
NombreEnBoton=S
NombreDesplegar=&Validar Información
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Expresion=ProcesarSQL(<T>spValidarContSatComprobante :tEmpresa, :nEjercicio, :nPeriodo<T>,Empresa,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)
Activo=S
Visible=S
[Acciones.MovPosicion]
Nombre=MovPosicion
Boton=34
NombreEnBoton=S
NombreDesplegar=&Posición del Movimiento
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Antes=S
Visible=S
Expresion=Forma(<T>MovPos<T>)
AntesExpresiones=Asigna(Info.Modulo, <T>CONT<T>)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov)
[Acciones.Cheque]
Nombre=Cheque
Boton=0
NombreEnBoton=S
NombreDesplegar=Ch&eque
GuardarAntes=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
Antes=S
DespuesGuardar=S
Menu=&Transacción
EnMenu=S
Expresion=Asigna( Info.ID, ContSATComprobanteLista:ContSATComprobanteLista.ID ) <BR> FormaModal( <T>ContSATChequeLista<T> )
ActivoCondicion=( ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Egresos<T>) <BR>y<BR>((SQL( <T>SELECT dbo.fnBuscaMetodoPago(:tId,:tEmpresa,:nQMetodo)<T>,ContSATComprobanteLista:ContSATComprobanteLista.ID, Empresa, 2)) = 1)
AntesExpresiones=Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov+<T> <T>+ContSATComprobanteLista:ContSATComprobanteLista.MovID)<BR>Asigna(Info.Modulo,ContSATComprobanteLista:ContSATComprobanteLista.OrigenTipo)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio)<BR>Asigna(Info.Periodo,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)<BR>Asigna(Info.Tipo,ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza)
[Acciones.Transferencia]
Nombre=Transferencia
Boton=0
NombreEnBoton=S
NombreDesplegar=&Transferencia
GuardarAntes=S
TipoAccion=Expresion
Antes=S
DespuesGuardar=S
Visible=S

Menu=&Transacción
EnMenu=S
Expresion=Asigna( Info.ID, ContSATComprobanteLista:ContSATComprobanteLista.ID )<BR> FormaModal( <T>ContSATTranferenciaLista<T> )
ActivoCondicion=(ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Egresos<T>)<BR> y<BR>((SQL( <T>SELECT dbo.fnBuscaMetodoPago(:tId,:tEmpresa,:nQMetodo)<T>,ContSATComprobanteLista:ContSATComprobanteLista.ID, Empresa, 3)) = 1)
AntesExpresiones=Asigna(Info.Mov,ContSATComprobanteLista:ContSATComprobanteLista.Mov+<T> <T>+ContSATComprobanteLista:ContSATComprobanteLista.MovID)<BR>Asigna(Info.Modulo,ContSATComprobanteLista:ContSATComprobanteLista.OrigenTipo)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>Asigna(Info.Ejercicio,ContSATComprobanteLista:ContSATComprobanteLista.Ejercicio)<BR>Asigna(Info.Periodo,ContSATComprobanteLista:ContSATComprobanteLista.Periodo)<BR>Asigna(Info.Tipo,ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza)
[ContSATTranferenciaLista.Columnas]
CtaOrigen=122
BancoOrigen=114
CtaDestino=160
BancoDestino=124
Monto=64
Fecha=94
Beneficiario=136
RFC=133
[ContSATComprobanteListas.Consecutivo]
Carpeta=ContSATComprobanteListas
Clave=Consecutivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
[Acciones.CFDCBB]
Nombre=CFDCBB
Boton=0
Menu=&Transacción
NombreDesplegar=Comp. Nacional Otros
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna(Info.Valor,<T>0<T>)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>FormaModal(<T>ContSATCFDCBB<T>)
ActivoCondicion=(<BR>(ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Egresos<T>)<BR>o<BR>(ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Diario<T>)<BR>)
[Acciones.Extranjero]
Nombre=Extranjero
Boton=0
NombreDesplegar=Comp. Extranjero
EnMenu=S
TipoAccion=Expresion
Visible=S
Menu=&Transacción
GuardarAntes=S
Expresion=Asigna(Info.Valor,<T>0<T>)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>FormaModal(<T>ContSATExtranjero<T>)
ActivoCondicion=(<BR>(ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Egresos<T>)<BR>o<BR>(ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Diario<T>)<BR>)
[Acciones.OtrosMetodos]
Nombre=OtrosMetodos
Boton=0
NombreDesplegar=&Otro Método Pago
EnMenu=S
TipoAccion=Expresion
Visible=S
Menu=&Transacción
GuardarAntes=S
Expresion=Asigna(Info.Valor,<T>0<T>)<BR>Asigna(Info.ID,ContSATComprobanteLista:ContSATComprobanteLista.ID)<BR>FormaModal(<T>ContSATOtroMetodoPago<T>)
ActivoCondicion=ContSATComprobanteLista:ContSATComprobanteLista.OrigenTipo = <T>DIN<T><BR>Y<BR>(<BR>    ContSATComprobanteLista:ContSATComprobanteLista.TipoPoliza = <T>Egresos<T><BR>)<BR>Y<BR>((SQL( <T>SELECT dbo.fnBuscaMetodoPago(:tId,:tEmpresa,:nQMetodo)<T>,ContSATComprobanteLista:ContSATComprobanteLista.ID, Empresa, 0)) = 1)

[Acciones.ExploradorPolizas]
Nombre=ExploradorPolizas
Boton=6
NombreEnBoton=S
NombreDesplegar=&Explorador de Pólizas
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ContSATMonitorPolizas
Activo=S
Visible=S







;[Detalles.ListaEnCaptura]
(Inicio)=ContD.Cuenta
ContD.Cuenta=ContD.Debe
ContD.Debe=ContD.Haber
ContD.Haber=ContD.Concepto
ContD.Concepto=(Fin)




;[Forma.ListaCarpetas]
(Inicio)=ContSATComprobanteListas
ContSATComprobanteListas=Detalles
Detalles=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptare
Aceptare=EnviarExcel
EnviarExcel=Comprobante
Comprobante=CFDCBB
CFDCBB=Extranjero
Extranjero=Cheque
Cheque=Transferencia
Transferencia=OtrosMetodos
OtrosMetodos=Validare
Validare=MovPosicion
MovPosicion=ExploradorPolizas
ExploradorPolizas=(Fin)

[Forma.MenuPrincipal]
(Inicio)=&Archivo
&Archivo=&Transacción
&Transacción=(Fin)

