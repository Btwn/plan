[Forma]
Clave=ContabilidadElectronica
Nombre=Contabilidad Electr�nica
Icono=4
CarpetaPrincipal=Lista
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista<BR>Detalle<BR>Empresas
PosicionInicialIzquierda=219
PosicionInicialArriba=86
PosicionInicialAlturaCliente=558
PosicionInicialAncho=927
Menus=S
BarraHerramientas=S
CarpetasMultilinea=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
ListaAcciones=Guardar<BR>Navegador<BR>Actualizar<BR>Cerrar<BR>Anexos<BR>CodigoAgrupador<BR>MetodoPago<BR>General<BR>GenCatalogo<BR>Definicion<BR>Balanza<BR>MovTipo<BR>InstitucionFin<BR>FormaPago<BR>Edici�nXSD<BR>ConSatTrabajo<BR>PrevioPolizas<BR>Comprobantes<BR>TipoSolicitud<BR>ActualizarComprobantes<BR>MapMoneda
PosicionSeccion1=54
PosicionColumna2=93
VentanaAjustarZonas=S
PosicionSec1=266
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=SQL( <T>EXEC spCuentasSATEmpresa<T> )
MenuPrincipal=&Archivo<BR>&Edici�n<BR>&Ver<BR>&Maestros<BR>&Configuraci�n<BR>&Herramientas
[Lista]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Cuentas SAT
Clave=Lista
Filtros=S
OtroOrden=S
BusquedaRapidaControles=S
MenuLocal=S
PermiteLocalizar=S
RefrescarAlEntrar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CtaSAT
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CtaSAT.Cuenta<BR>CtaSAT.Descripcion
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Arbol
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S
FiltroArbolClave=CtaSAT.Cuenta
FiltroArbolValidar=CtaSAT.Descripcion
FiltroArbolRama=CtaSAT.Rama
FiltroArbolAcumulativas=CtaSAT.EsAcumulativa
FiltroListas=S
FiltroListasRama=CONT
BusquedaRapida=S
BusquedaAncho=40
BusquedaEnLinea=S
ListaAcciones=AsignaCodigo
HojaAjustarColumnas=S
BusquedaInicializar=S
FiltroTodo=S
[Lista.CtaSAT.Cuenta]
Carpeta=Lista
Clave=CtaSAT.Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CtaSAT.Descripcion]
Carpeta=Lista
Clave=CtaSAT.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.AsignaCodigo]
Nombre=AsignaCodigo
Boton=0
NombreDesplegar=Asignar C�digo Agrupador
EnMenu=S
TipoAccion=Expresion
Expresion=FormaModal(<T>AsignaCodigoAgrupador<T>)<BR>ActualizarVista<BR>ActualizarForma
Activo=S
Antes=S
AntesExpresiones=Asigna(Info.Valor,CtaSAT:CtaSAT.ClaveSAT)<BR>Asigna(Info.CuentaD,CtaSAT:CtaSAT.Cuenta)<BR>Asigna(Info.Rama,CtaSAT:CtaSAT.Rama)
Visible=S
[Lista.Columnas]
Cuenta=151
Descripcion=521
[Acciones.Guardar]
Nombre=Guardar
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar Cambios
RefrescarDespues=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador 2 (Registros)
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=&Actualizar
EnMenu=S
Carpeta=Lista
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=&Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Anexos]
Nombre=Anexos
Boton=77
NombreEnBoton=S
Menu=&Edici�n
UsaTeclaRapida=S
TeclaRapida=F4
NombreDesplegar=Ane&xos
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=AnexoContaSAT
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(CtaSAT:CtaSAT.Cuenta)
Antes=S
AntesExpresiones=Asigna(Info.Rama, <T>CONT<T>)<BR>Asigna(Info.AnexoCfg, Verdadero)<BR>Asigna(Info.Cuenta, CtaSAT:CtaSAT.Cuenta)<BR>Asigna(Info.Descripcion, CtaSAT:CtaSAT.Descripcion)<BR>Asigna(Info.Tipo, <T>CatalogoCtas<T>)
Visible=S
[Acciones.CodigoAgrupador]
Nombre=CodigoAgrupador
Boton=0
Menu=&Maestros
NombreDesplegar=&C�digo Agrupador
EnMenu=S
TipoAccion=Formas
ClaveAccion=CodigoAgrupador
Activo=S
Visible=S
[Acciones.General.EmpresaCfg]
Nombre=EmpresaCfg
Boton=0
TipoAccion=Formas
ClaveAccion=EmpresaCfgContaSAT
Activo=S
Visible=S
[Acciones.General.AsignaVariable]
Nombre=AsignaVariable
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Info.AnexoCfg, SQL(<T>SELECT CfgMultiempresa FROM EmpresaCfgContaSAT<T>))
[Acciones.General.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.General.Maximizar]
Nombre=Maximizar
Boton=0
TipoAccion=Ventana
ClaveAccion=Maximizar
Activo=S
ConCondicion=S
EjecucionCondicion=Info.AnexoCfg = Verdadero
Visible=S
[Acciones.General.Restaurar]
Nombre=Restaurar
Boton=0
TipoAccion=Ventana
ClaveAccion=Normal
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Info.AnexoCfg <> Verdadero
[Acciones.General]
Nombre=General
Boton=0
Menu=&Configuraci�n
NombreDesplegar=&General
GuardarAntes=S
Multiple=S
EnMenu=S
ListaAccionesMultiples=EmpresaCfg<BR>AsignaVariable<BR>Actualiza<BR>Maximizar<BR>Restaurar
Activo=S
Visible=S
[Acciones.GenCatalogo]
Nombre=GenCatalogo
Boton=0
Menu=&Herramientas
NombreDesplegar=&Previo Cat�logo de Cuentas
GuardarAntes=S
Multiple=S
EnMenu=S
ListaAccionesMultiples=AsignaNivel
Activo=S
Visible=S
[Acciones.Definicion]
Nombre=Definicion
Boton=17
NombreEnBoton=S
NombreDesplegar=&Definici�n
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
Expresion=VerComentario( <T>Definici�n - <T>+CtaSAT:CodigoAgrupador.Descripcion, CtaSAT:CodigoAgrupador.Definicion )
ActivoCondicion=ConDatos(CtaSAT:CodigoAgrupador.Definicion)
[Detalle]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Detalles
Clave=Detalle
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=CtaSAT
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
ListaEnCaptura=CtaSAT.Cuenta<BR>CtaSAT.Descripcion<BR>CtaSAT.Tipo<BR>CtaSAT.Rama<BR>CtaSAT.Grupo<BR>CtaSAT.EsAcumulativa<BR>CtaSAT.EsAcreedora<BR>CtaSAT.ContSATCFD<BR>CtaSAT.ContSATDin<BR>CtaSAT.ClaveSAT<BR>CodigoAgrupador.Descripcion<BR>CodigoAgrupador.ClaveSup<BR>CodigoAgrupador.Nivel
CarpetaVisible=S
CondicionEdicion=CtaSAT:CtaSAT.Tipo<><T>Estructura<T>
GuardarPorRegistro=S
[Detalle.CtaSAT.Cuenta]
Carpeta=Detalle
Clave=CtaSAT.Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.Descripcion]
Carpeta=Detalle
Clave=CtaSAT.Descripcion
ValidaNombre=S
3D=S
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.Tipo]
Carpeta=Detalle
Clave=CtaSAT.Tipo
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.Rama]
Carpeta=Detalle
Clave=CtaSAT.Rama
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.Grupo]
Carpeta=Detalle
Clave=CtaSAT.Grupo
ValidaNombre=S
3D=S
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.EsAcumulativa]
Carpeta=Detalle
Clave=CtaSAT.EsAcumulativa
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=35
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.EsAcreedora]
Carpeta=Detalle
Clave=CtaSAT.EsAcreedora
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.ClaveSAT]
Carpeta=Detalle
Clave=CtaSAT.ClaveSAT
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Empresas]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Empresas
Clave=Empresas
Detalle=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=CtaEmpresa
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=CtaSAT
LlaveLocal=CtaEmpresa.Cuenta
LlaveMaestra=CtaSAT.Cuenta
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Autom�tica
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CtaEmpresa.Pertenece<BR>CtaEmpresa.Empresa<BR>Empresa.Nombre
CondicionEdicion=EsNumerico( CtaSAT:CodigoAgrupador.ClaveSAT)
CondicionAutoBloqueo=EsNumerico( CtaSAT:CodigoAgrupador.ClaveSAT )
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=CtaEmpresa.Empresa  = <T>{Empresa}<T>
CondicionVisible=SQL(<T>SELECT CfgMultiempresa FROM EmpresaCfgContaSAT<T>) = Verdadero
[Empresas.CtaEmpresa.Pertenece]
Carpeta=Empresas
Clave=CtaEmpresa.Pertenece
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=5
[Empresas.CtaEmpresa.Empresa]
Carpeta=Empresas
Clave=CtaEmpresa.Empresa
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
[Empresas.Empresa.Nombre]
Carpeta=Empresas
Clave=Empresa.Nombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[Empresas.Columnas]
Pertenece=70
Empresa=70
Nombre=226
[Detalle.CodigoAgrupador.Descripcion]
Carpeta=Detalle
Clave=CodigoAgrupador.Descripcion
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CodigoAgrupador.ClaveSup]
Carpeta=Detalle
Clave=CodigoAgrupador.ClaveSup
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CodigoAgrupador.Nivel]
Carpeta=Detalle
Clave=CodigoAgrupador.Nivel
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.GenCatalogo.AsignaNivel]
Nombre=AsignaNivel
Boton=0
TipoAccion=Formas
ClaveAccion=AsignaNivel
Activo=S
Visible=S
[Acciones.Balanza]
Nombre=Balanza
Boton=92
NombreEnBoton=S
Menu=&Herramientas
NombreDesplegar=Previo Balanza de Comprobaci�n
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=VarBalanzaSAT
Activo=S
Visible=S
[Acciones.InstitucionFin]
Nombre=InstitucionFin
Boton=0
Menu=&Configuraci�n
NombreDesplegar=&Instituciones Financieras
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContInstitucionFin
Activo=S
Visible=S
[Acciones.Edici�nXSD]
Nombre=Edici�nXSD
Boton=0
Menu=&Configuraci�n
NombreDesplegar=Configuraci�n XML
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATPlantilla
Activo=S
Visible=S
[Acciones.ConSatTrabajo]
Nombre=ConSatTrabajo
Boton=0
Menu=&Configuraci�n
NombreDesplegar=Trabajo Monitor
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATTrabajo
Activo=S
Visible=S
[Acciones.PrevioPolizas]
Nombre=PrevioPolizas
Boton=0
Menu=&Herramientas
NombreDesplegar=&Previo P�lizas
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ContSATComprobanteLista
Activo=S
Visible=S
[Acciones.Comprobantes]
Nombre=Comprobantes
Boton=0
Menu=&Herramientas
NombreDesplegar=Monitor de P�lizas
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATComprobanteFaltante
Activo=S
Visible=S
EspacioPrevio=S
GuardarAntes=S
[Acciones.MovTipo]
Nombre=MovTipo
Boton=0
Menu=&Configuraci�n
NombreDesplegar=Movimientos
GuardarAntes=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATMovTipo
Activo=S
Visible=S
[Detalle.CtaSAT.ContSATCFD]
Carpeta=Detalle
Clave=CtaSAT.ContSATCFD
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CtaSAT.ContSATDin]
Carpeta=Detalle
Clave=CtaSAT.ContSATDin
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.MetodoPago]
Nombre=MetodoPago
Boton=0
Menu=&Maestros
NombreDesplegar=&M�todos de Pago
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATMetodoPago
Activo=S
Visible=S

[Acciones.FormaPago]
Nombre=FormaPago
Boton=0
Menu=&Configuraci�n
NombreDesplegar=&M�todo de Pago SAT
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATFormaPago
Activo=S
Visible=S
[Acciones.TipoSolicitud]
Nombre=TipoSolicitud
Boton=0
Menu=&Maestros
NombreDesplegar=Tipo de Solicitud
EnMenu=S
TipoAccion=Formas
ClaveAccion=ContSATTipoSolicitud
Activo=S
Visible=S

[Acciones.ActualizarComprobantes]
Nombre=ActualizarComprobantes
Boton=0
Menu=&Herramientas
NombreDesplegar=Actualizar Comprobantes
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ParActualizaComprobante
Activo=S
Visible=S

[Acciones.MapMoneda]
Nombre=MapMoneda
Boton=0
Menu=&Configuraci�n
NombreDesplegar=Mapear Moneda
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=MonMapeoCFD
Activo=S
Visible=S

