[Forma]
Clave=CxcEndosarEnLoteMAVI
Nombre=<T>Cxc - Endosar En Lote<T>
Icono=6
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=163
PosicionInicialArriba=151
PosicionInicialAltura=370
PosicionInicialAncho=954
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>Propiedades<BR>Campos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
Comentarios=Lista(Info.Cliente,Mayusculas(SQL(<T>SELECT Nombre FROM Cte WHERE Cliente=:tCte<T>, Info.Cliente)))
VentanaExclusiva=S
VentanaEscCerrar=S
PosicionInicialAlturaCliente=466
EsConsultaExclusiva=S
ExpresionesAlMostrar=Si(Forma(<T>EspecificarCliente<T>),Verdadero, AbortarOperacion)

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CxcPendiente
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CxcPendiente.Referencia<BR>CxcPendiente.Concepto<BR>CxcPendiente.FechaEmision<BR>CxcPendiente.Vencimiento<BR>CxcPendiente.ImporteTotal<BR>CxcPendiente.Saldo<BR>CxcPendiente.Moneda
CarpetaVisible=S
Filtros=S
OtroOrden=S
PestanaOtroNombre=S
FiltroPredefinido=S
FiltroTipo=General
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroNullNombre=(sin clasificar)
FiltroRespetar=S
FiltroAncho=30
PermiteLocalizar=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
ListaOrden=CxcPendiente.Vencimiento<TAB>(Acendente)
PestanaNombre=Movimientos
BusquedaRapidaControles=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasCampo=CxcPendiente.FechaEmision
FiltroFechasDefault=(Todo)
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
MenuLocal=S
ListaAcciones=LocalTodo<BR>LocalQuitar
IconosSeleccionMultiple=S
FiltroSucursales=S
IconosNombre=CxcPendiente:CxcPendiente.Mov+<T> <T>+CxcPendiente:CxcPendiente.MovID
FiltroGeneral=CxcPendiente.Mov NOT IN(<T>Contra Recibo Inst<T>,<T>Cta Incobrable F<T>,<T>Cta Incobrable NV<T>) AND<BR>CxcPendiente.Cliente=<T>{Info.Cliente}<T> AND<BR>CxcPendiente.Empresa=<T>{Empresa}<T>

[Lista.Columnas]
Mov=114
MovID=64
FechaEmision=83
Vencimiento=76
Saldo=93
Importe=82
0=173
1=174
2=144
3=97
4=86
5=94
6=91
Referencia=107
7=54


[Lista.CxcPendiente.Referencia]
Carpeta=Lista
Clave=CxcPendiente.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CxcPendiente.FechaEmision]
Carpeta=Lista
Clave=CxcPendiente.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CxcPendiente.Saldo]
Carpeta=Lista
Clave=CxcPendiente.Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1

[Lista.CxcPendiente.ImporteTotal]
Carpeta=Lista
Clave=CxcPendiente.ImporteTotal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Totalizador=1

[Lista.CxcPendiente.Vencimiento]
Carpeta=Lista
Clave=CxcPendiente.Vencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Propiedades]
Nombre=Propiedades
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
EjecucionCondicion=ConDatos(CxcPendiente:CxcPendiente.ID)
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.ID, CxcPendiente:CxcPendiente.ID)

[Lista.CxcPendiente.Moneda]
Carpeta=Lista
Clave=CxcPendiente.Moneda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

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

[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S

[Lista.CxcPendiente.Concepto]
Carpeta=Lista
Clave=CxcPendiente.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.LocalTodo]
Nombre=LocalTodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S

[Acciones.LocalQuitar]
Nombre=LocalQuitar
Boton=0
NombreDesplegar=&Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Generar]
Nombre=Generar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Endosos
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Antes=S
Visible=S
Expresion=EjecutarSQLAnimado(<T>spEndososEnLoteMAVI :tEmpresa, :nEstacion, :tCteEndosar, :tCte, :tUsuario<T>, Empresa, EstacionTrabajo, Info.ClienteA, Info.Cliente, Usuario)<BR>Forma(<T>ListaIDOk<T>)<BR>ActualizarForma
AntesExpresiones=RegistrarSeleccionID(<T>Lista<T>)<BR>Si((CuantosSeleccionID(<T>Lista<T>))>0,verdadero,Si(Informacion(<T>No se han seleccionado movimientos para endosar<T>)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Asigna(Info.ClienteA, nulo)<BR>Si(Forma(<T>EspecificarClienteA<T>),Verdadero,AbortarOperacion)<BR>Si(SQL(<T>SELECT Count(*) FROM Cte WHERE Cliente=:tCte<T>,Info.ClienteA)>0,verdadero,Si(Error(<T>Cliente Incorrecto<T>)=BotonAceptar,AbortarOperacion, AbortarOperacion))<BR>Si(Info.Cliente = Info.ClienteA, Si(Error(<T>Los endosos no se pueden hacer al mismo cliente<T>)=BotonAceptar, AbortarOperacion, AbortarOperacion))<BR>Asigna(Temp.Texto,<T>Los documentos seleccionados del cliente: <T>+SQL(<T>SELECT Nombre FROM Cte WHERE Cliente=:tCte<T>, Info.Cliente)+<T> (<T>+Info.Cliente+<T>)<T>+ Nue<CONTINUA>
AntesExpresiones002=<CONTINUA>vaLinea +<T>Se endosaran al cliente: <T>+SQL(<T>SELECT Nombre FROM Cte WHERE Cliente=:tCte<T>, Info.ClienteA)+<T> (<T>+Info.ClienteA+<T>)<T>+ NuevaLinea +<T>¿Es Correcto?<T>)<BR>Si(Informacion(Temp.Texto,BotonAceptar, BotonCancelar )=BotonAceptar, verdadero, AbortarOperacion)

