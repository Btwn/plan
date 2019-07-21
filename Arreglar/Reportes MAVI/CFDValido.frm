[Forma]
Clave=CFDValido
Nombre=Administrador de Documentos
Icono=0
Menus=S
BarraHerramientas=S
Modulos=(Todos)
MovModulo=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Lista<BR>Detalle
CarpetaPrincipal=Lista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=193
PosicionInicialArriba=106
PosicionInicialAlturaCliente=517
PosicionInicialAncho=979
PosicionColumna1=80
ListaAcciones=Aceptar<BR>FiltroMonto<BR>Actualizar<BR>FiltroIngresos<BR>FiltroEgresos<BR>FiltroTodos<BR>FiltroAsociados<BR>FiltroNoAsociados<BR>FiltroTodosAsociacion<BR>Invalidos<BR>Excel<BR>ConfigurarColumnas
VentanaExclusiva=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.Cantidad, 0 )<BR>Asigna( Info.Valor, 0 )<BR>Asigna( Info.Filtro, <T> <T> )<BR>Asigna( Info.Accion, <T>Todos<T> )<BR>Asigna( Info.Nombre, <T>Todos<T> )<BR>EjecutarSQL(<T>spActualizaCFDValidoMov :tEmpresa<T>, Empresa)
PosicionCol1=780
MenuPrincipal=&Archivo<BR>&Edición<BR>&Ver
[Acciones.VerDocumento]
Nombre=VerDocumento
Boton=0
NombreDesplegar=Ver Documento
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=VerComentario(CFDValido:CFDValido.Ruta,CFDValido:CFDValido.Documento)
ActivoCondicion=ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
[Acciones.VerReporte]
Nombre=VerReporte
Boton=0
NombreDesplegar=Ver en PDF
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna(Info.ID,CFDValido:CFDValido.ID)<BR>Asigna(Info.Empresa,CFDValido:CFDValido.Empresa)<BR>ReportePantalla( <T>CFDValidoPDFS<T> )
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
[Acciones.VerTrazabilidad]
Nombre=VerTrazabilidad
Boton=0
NombreDesplegar=Ver Trazabilidad
EnMenu=S
TipoAccion=Formas
ClaveAccion=ACInversionAutoInfo
Antes=S
Visible=S
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
AntesExpresiones=Asigna( Info.Lista, CFDValido:CFDValido.ID )
[Acciones.AsociarMov.RegistrarLista]
Nombre=RegistrarLista
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Lista<T>)
Activo=S
Visible=S
[Acciones.AsociarMov.AsignaModulo]
Nombre=AsignaModulo
Boton=0
TipoAccion=Expresion
Expresion=Asigna( Info.Modulo, SQL(<T>Select Distinct Modulo From CfdValido A, ListaST B Where A.ID = B.Clave AND B.ESTACION = :nEstacion<T>, EstacionTrabajo))<BR>EjecutarSQL(<T>spVerMovtos :tEmpresa, :tModulo, :tMov, :tMovID, :nBandera<T>, {Empresa}, {Info.Modulo}, {Nulo}, {Nulo}, 1 )
Activo=S
ConCondicion=S
EjecucionCondicion=SQL(<T>Select Count(Distinct Modulo) From CfdValido A, ListaST B Where A.ID = B.Clave AND B.Estacion = :nEstacion<T>, EstacionTrabajo ) <= 1
EjecucionMensaje=Debe seleccionar documentos solo de un módulo.
EjecucionConError=S
Visible=S
[Lista]
Estilo=Iconos
Clave=Lista
Filtros=S
OtroOrden=S
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDValido
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Seleccionar<T>
IconosNombreNumerico=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CFDValido.Modulo<BR>CFDValido.RFCEmisor<BR>CFDValido.RFCReceptor<BR>CFDValido.FechaTimbrado<BR>CFDValido.Monto<BR>CFDValido.Moneda
ListaOrden=CFDValido.ID<TAB>(Acendente)<BR>CFDValido.Fecha<TAB>(Decendente)
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S
FiltroGrupo1=CFDValido.Tipo
FiltroValida1=CFDValido.Tipo
FiltroGrupo2=Modulo.Nombre
FiltroValida2=Modulo.Nombre
FiltroGrupo3=CFDValido.RFCEmisor
FiltroValida3=CFDValido.RFCEmisor
FiltroTodo=S
FiltroFechas=S
FiltroMonedas=S
FiltroFechasCampo=CFDValido.FechaTimbrado
FiltroFechasDefault=Este Mes
FiltroMonedasCampo=CFDValido.Moneda
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaEnLinea=S
ListaAcciones=VerDocumentos<BR>VerReportes<BR>Ver Trazabilidad<BR>AsociarMov<BR>EliminarDocto<BR>SeleccionarTodo<BR>QuitarTodo<BR>Personalizar
IconosNombre=CFDValido:CFDValido.ID
FiltroGeneral={<T>CFDValido.Empresa<T>} = {Comillas(Empresa)}<BR>{Info.Filtro}<BR>{Si Info.Accion = <T>Ingresos<T> Entonces <T> AND CFDValido.Tipo = <T>& Comillas(<T>Ingresos<T>) Sino <T> <T> Fin}<BR>{Si Info.Accion = <T>Egresos<T> Entonces <T> AND CFDValido.Tipo = <T>& Comillas(<T>Egresos<T>) Sino <T> <T> Fin}<BR>{Si Info.Nombre = <T>Asociados<T> Entonces <T> AND EXISTS (<T>&<T>SELECT ID FROM CFDValidoMov A WHERE A.ID = CFDValido.ID AND A.Empresa = <T>&Comillas(Empresa)&<T>)<T> Sino <T> <T> Fin}<BR>{Si Info.Nombre = <T>NoAsociados<T> Entonces <T> AND NOT EXISTS (<T>&<T>SELECT ID FROM CFDValidoMov A WHERE A.ID =  CFDValido.ID AND A.Empresa = <T>&Comillas(Empresa)&<T>)<T> Sino <T> <T> Fin}
[Lista.CFDValido.Modulo]
Carpeta=Lista
Clave=CFDValido.Modulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
[Lista.CFDValido.RFCEmisor]
Carpeta=Lista
Clave=CFDValido.RFCEmisor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Lista.CFDValido.RFCReceptor]
Carpeta=Lista
Clave=CFDValido.RFCReceptor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
[Lista.CFDValido.FechaTimbrado]
Carpeta=Lista
Clave=CFDValido.FechaTimbrado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Lista.CFDValido.Monto]
Carpeta=Lista
Clave=CFDValido.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Lista.CFDValido.Moneda]
Carpeta=Lista
Clave=CFDValido.Moneda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Acciones.VerDocumentos]
Nombre=VerDocumentos
Boton=0
NombreDesplegar=Ver XML
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=VerComentario(CFDValido:CFDValido.Ruta,CFDValido:CFDValido.Documento)
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
[Acciones.VerReportes]
Nombre=VerReportes
Boton=0
NombreDesplegar=Ver en PDF
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna(Info.ID, CFDValido:CFDValido.ID)<BR>Asigna(Info.Empresa, CFDValido:CFDValido.Empresa)<BR>ReportePantalla( <T>CFDValidoPDFS<T> )
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
[Acciones.Ver Trazabilidad]
Nombre=Ver Trazabilidad
Boton=0
NombreDesplegar=Ver Trazabilidad
EnMenu=S
TipoAccion=Formas
ClaveAccion=CFDTrazabilidad
Visible=S
Antes=S
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
AntesExpresiones=Asigna( Info.Folio, CFDValido:CFDValido.ID)
[Acciones.AsociarMov.RegistraLista]
Nombre=RegistraLista
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccionID(<T>Lista<T>)<BR>RegistrarSeleccion(<T>Lista<T>)
[Acciones.AsociarMov.AsignarModulo]
Nombre=AsignarModulo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna( Info.Modulo, SQL(<T>Select Distinct Modulo From CfdValido A, ListaID B Where A.ID = B.ID AND B.Estacion = :nEstacion AND A.Empresa = :tEmpresa<T>, EstacionTrabajo, Empresa))<BR>EjecutarSQL(<T>spVerMovtos :tEmpresa, :tModulo, :tMov, :tMovID, :nBandera<T>, {Empresa}, {Info.Modulo}, {Nulo}, {Nulo}, 1 )
EjecucionCondicion=SQL(<T>Select Count(Distinct Modulo) From CfdValido A, ListaID B Where A.ID = B.ID AND B.Estacion = :nEstacion AND A.Empresa = :tEmpresa<T>, EstacionTrabajo, Empresa ) <= 1
EjecucionMensaje=Debe seleccionar documentos solo de un módulo.
[Acciones.AsociarMov.Vermovimiento]
Nombre=Vermovimiento
Boton=0
TipoAccion=Formas
ClaveAccion=CFDMovimientos
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SQL(<T>Select Count(Distinct Modulo) From CfdValido A, ListaID B Where A.ID = B.ID AND B.Estacion = :nEstacion AND A.Empresa = :tEmpresa<T>, EstacionTrabajo, Empresa ) <= 1
[Acciones.AsociarMov]
Nombre=AsociarMov
Boton=0
NombreDesplegar=Asociar a Movimiento
Multiple=S
EnMenu=S
EspacioPrevio=S
ListaAccionesMultiples=RegistraLista<BR>AsignarModulo<BR>Vermovimiento<BR>Actualizar
Visible=S
Antes=S
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ListaSeleccion( <T>Lista<T> ) <> <T><T>)
AntesExpresiones=Asigna(Info.ID, CFDValido:CFDValido.ID )                     <BR>Asigna(Info.Opcion, CFDValido:CFDValido.RFCEmisor )
[Acciones.AsociarMov.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista(<T>Detalle<T>)
[Acciones.EliminarDocto]
Nombre=EliminarDocto
Boton=0
NombreDesplegar=Eliminar Comprobante
EnMenu=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
Expresion=Si<BR>  Precaucion(<T>El documento seleccionado también se eliminará del equipo. ¿Desea continuar?<T>,BotonSi, BotonNo ) = BotonSi<BR>Entonces<BR>  Informacion(SQL(<T>spBorraInvalidos :nID, 1<T>, CFDValido:CFDValido.ID))<BR>Fin<BR>ActualizarVista
ActivoCondicion=(ConDatos( CFDValido:CFDValido.ID)) y (ConDatos(CFDValidoMov:CFDValidoMov.ID) = Falso)
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.QuitarTodo]
Nombre=QuitarTodo
Boton=0
NombreDesplegar=Quitar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
ActivoCondicion=ListaSeleccion(<T>Lista<T>)<><T><T>
Visible=S
[Acciones.Personalizar]
Nombre=Personalizar
Boton=0
NombreDesplegar=Personalizar Vista
EnMenu=S
EspacioPrevio=S
Carpeta=Lista
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
[Lista.Columnas]
0=69
1=87
2=100
3=100
4=100
5=68
6=79
[Detalle]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Detalle
Clave=Detalle
OtroOrden=S
Detalle=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=CFDValidoMov
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=CFDValido
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Movimiento
ElementosPorPagina=200
IconosConRejilla=S
ListaEnCaptura=CFDValidoMov.MovID
ListaOrden=CFDValidoMov.Movimiento<TAB>(Acendente)<BR>CFDValidoMov.ID<TAB>(Acendente)
LlaveLocal=CFDValidoMov.ID<BR>CFDValidoMov.Empresa
LlaveMaestra=CFDValido.ID<BR>CFDValido.Empresa
Filtros=S
BusquedaRapidaControles=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
MenuLocal=S
ListaAcciones=Desasociar
IconosNombre=CFDValidoMov:CFDValidoMov.Movimiento
[Detalle.CFDValidoMov.MovID]
Carpeta=Detalle
Clave=CFDValidoMov.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Detalle.Columnas]
0=99
1=78
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
Menu=&Archivo
NombreDesplegar=Cerr&ar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.FiltroMonto.Filtro]
Nombre=Filtro
Boton=0
TipoAccion=Formas
ClaveAccion=FiltroMonto
Activo=S
Visible=S
[Acciones.FiltroMonto.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.FiltroMonto]
Nombre=FiltroMonto
Boton=107
NombreEnBoton=S
Menu=&Edición
NombreDesplegar=&Filtro Monto
Multiple=S
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
ListaAccionesMultiples=Filtro<BR>Actualiza
Activo=S
Visible=S
[Acciones.FiltroIngresos]
Nombre=FiltroIngresos
Boton=71
NombreDesplegar=&Ingresos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
NombreEnBoton=S
EspacioPrevio=S
Antes=S
ActivoCondicion=Info.Accion <> <T>Ingresos<T>
AntesExpresiones=Asigna(Info.Accion, <T>Ingresos<T>)
[Acciones.FiltroEgresos]
Nombre=FiltroEgresos
Boton=71
NombreDesplegar=E&gresos
EnBarraHerramientas=S
Visible=S
NombreEnBoton=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Antes=S
ActivoCondicion=Info.Accion <> <T>Egresos<T>
AntesExpresiones=Asigna(Info.Accion, <T>Egresos<T>)
[Acciones.FiltroTodos]
Nombre=FiltroTodos
Boton=71
NombreEnBoton=S
NombreDesplegar=&Todos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Antes=S
Visible=S
ActivoCondicion=Info.Accion <> <T>Todos<T>
AntesExpresiones=Asigna(Info.Accion, <T>Todos<T>)
[Acciones.FiltroAsociados]
Nombre=FiltroAsociados
Boton=71
NombreEnBoton=S
NombreDesplegar=A&sociados
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
Antes=S
ActivoCondicion=Info.Nombre<><T>Asociados<T>
AntesExpresiones=Asigna( Info.Nombre,<T>Asociados<T>)
[Acciones.FiltroNoAsociados]
Nombre=FiltroNoAsociados
Boton=71
NombreEnBoton=S
NombreDesplegar=&No Asociados
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
ActivoCondicion=Info.Nombre<><T>NoAsociados<T>
Antes=S
AntesExpresiones=Asigna( Info.Nombre,<T>NoAsociados<T>)
[Acciones.FiltroTodosAsociacion]
Nombre=FiltroTodosAsociacion
Boton=71
NombreEnBoton=S
NombreDesplegar=Todos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
ActivoCondicion=Info.Nombre<><T>Todos<T>
Antes=S
AntesExpresiones=Asigna( Info.Nombre,<T>Todos<T>)
[Acciones.Invalidos]
Nombre=Invalidos
Boton=65
NombreEnBoton=S
Menu=&Ver
NombreDesplegar=Invá&lidos
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CFDInvalido
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.ConfigurarColumnas]
Nombre=ConfigurarColumnas
Boton=45
NombreDesplegar=&Pesonalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=Lista
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=A&ctualizar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ActualizaArbol<BR>Actualizaforma
[Acciones.Desasociar]
Nombre=Desasociar
Boton=0
NombreDesplegar=Desasociar Documento
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna( Info.ID, CFDValido:CFDValido.ID )<BR>Si<BR>   Precaucion(<T>El movimiento se desasociará del documento. ¿Desea Continuar?<T>, BotonNo, BotonSi ) = BotonSi<BR>Entonces<BR>   EjecutarSQL(<T>spDesasociarDocumento :tEmpresa, :tModulo, :nModuloID, :nID <T>, Empresa, CFDValidoMov:CFDValidoMov.Modulo, CFDValidoMov:CFDValidoMov.ModuloID, CFDValidoMov:CFDValidoMov.ID )<BR>   Forma.ActualizarVista( <T>Detalle<T> )<BR>Fin
ActivoCondicion=ConDatos(CFDValido:CFDValido.ID)

[Acciones.Actualizar.ActualizaArbol]
Nombre=ActualizaArbol
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S

[Acciones.Actualizar.Actualizaforma]
Nombre=Actualizaforma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=67
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S

