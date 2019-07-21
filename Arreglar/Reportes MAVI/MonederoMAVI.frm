[Forma]
Clave=MonederoMAVI
Icono=67
Nombre=Monedero Electrónico
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=Lista<BR>Detalle
CarpetaPrincipal=Lista
PosicionInicialIzquierda=359
PosicionInicialArriba=139
PosicionInicialAlturaCliente=451
PosicionInicialAncho=655
PosicionSec1=140
EsMovimiento=S
MovEspecificos=Todos
BarraAyuda=S
BarraAyudaBold=S
TituloAutoNombre=S
TituloAuto=S
Menus=S
ListaAcciones=Nuevo<BR>Abrir<BR>Localizar<BR>Guardar<BR>Propiedades<BR>Afectar<BR>Eliminar<BR>Cancelar<BR>Anterior<BR>Siguiente<BR>Tiempo<BR>MovPos<BR>Navegador<BR>Cerrar
AutoGuardarEncabezado=S
DialogoAbrir=S
CarpetasMultilinea=S
MenuPrincipal=&Archivo<BR>&Ver
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MonederoMAVI
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=7
FichaEspacioNombres=75
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MonederoMAVI.Mov<BR>MonederoMAVI.MovID<BR>MonederoMAVI.UEN<BR>MonederoMAVI.Sucursal<BR>MonederoMAVI.FechaEmision<BR>MonederoMAVI.CategoriaCV<BR>MonederoMAVI.TipoMonedero<BR>MonederoMAVI.Referencia<BR>MonederoMAVI.Observaciones
CarpetaVisible=S

GuardarAlSalir=S
[Lista.MonederoMAVI.Mov]
Carpeta=Lista
Clave=MonederoMAVI.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Lista.MonederoMAVI.MovID]
Carpeta=Lista
Clave=MonederoMAVI.MovID
Editar=N
ValidaNombre=N
3D=S
Tamano=10
ColorFondo=Plata

Pegado=S
ColorFuente=Negro
[Lista.MonederoMAVI.UEN]
Carpeta=Lista
Clave=MonederoMAVI.UEN
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=6
ColorFuente=Negro
[Lista.MonederoMAVI.FechaEmision]
Carpeta=Lista
Clave=MonederoMAVI.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
ColorFuente=Negro
[Lista.MonederoMAVI.Referencia]
Carpeta=Lista
Clave=MonederoMAVI.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
UEN=44
Nombre=269

0=91
Observacion=416
1=267
[Detalle]
Estilo=Hoja
Clave=Detalle
OtroOrden=S
Detalle=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MonederoMAVID
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=MonederoMAVI
LlaveLocal=MonederoMAVID.ID
LlaveMaestra=MonederoMAVI.ID
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MonederoMAVID.Serie<BR>MonederoMAVID.SerieDestino<BR>MonederoMAVID.Importe
ListaOrden=MonederoMAVID.ID<TAB>(Acendente)<BR>MonederoMAVID.Renglon<TAB>(Acendente)<BR>MonederoMAVID.RenglonSub<TAB>(Acendente)
CarpetaVisible=S
ControlRenglon=S
CampoRenglon=MonederoMAVID.Renglon

[Detalle.MonederoMAVID.Serie]
Carpeta=Detalle
Clave=MonederoMAVID.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.MonederoMAVID.SerieDestino]
Carpeta=Detalle
Clave=MonederoMAVID.SerieDestino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.MonederoMAVID.Importe]
Carpeta=Detalle
Clave=MonederoMAVID.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.Columnas]
Serie=146
SerieDestino=157
Importe=125

[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
OtroOrden=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=MonederoMAVIA
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Movimientos
ListaEnCaptura=MonederoMAVI.FechaEmision<BR>MonederoMAVI.UEN<BR>MonederoMAVI.Referencia
ListaOrden=MonederoMAVI.Mov<TAB>(Acendente)<BR>MonederoMAVI.MovID<TAB>(Acendente)<BR>MonederoMAVI.FechaEmision<TAB>(Acendente)
FiltroEstatus=S
FiltroUsuarios=S
FiltroFechas=S
FiltroMovs=S
FiltroMovsTodos=S
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>CANCELADO<BR>CONCLUIDO
FiltroEstatusDefault=SINAFECTAR
FiltroUsuarioDefault=(Usuario)
FiltroFechasCampo=MonederoMAVI.FechaEmision
FiltroFechasDefault=(Todo)
FiltroMovDefault=(Todos)
FiltroFechasCancelacion=MonederoMAVI.FechaCancelacion
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaEnLinea=S
FiltroSucursales=S
FiltroUENsCampo=MonederoMAVI.UEN
IconosNombre=MonederoMAVIA:MonederoMAVI.Mov + <T> <T> + MonederoMAVIA:MonederoMAVI.MovID
[(Carpeta Abrir).Columnas]
0=173

1=90
2=58
3=416
[(Carpeta Abrir).MonederoMAVI.FechaEmision]
Carpeta=(Carpeta Abrir)
Clave=MonederoMAVI.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[(Carpeta Abrir).MonederoMAVI.UEN]
Carpeta=(Carpeta Abrir)
Clave=MonederoMAVI.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[(Carpeta Abrir).MonederoMAVI.Referencia]
Carpeta=(Carpeta Abrir)
Clave=MonederoMAVI.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.MonederoMAVI.Observaciones]
Carpeta=Lista
Clave=MonederoMAVI.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=75
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S

[Acciones.Abrir]
Nombre=Abrir
Boton=2
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=&Abrir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S

Menu=&Archivo
[Acciones.Localizar]
Nombre=Localizar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Shift+F3
NombreDesplegar=L&ocalizar...
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Localizar
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Propiedades]
Nombre=Propiedades
Boton=0
Menu=&Archivo
NombreDesplegar=Propie&dades
EnMenu=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
ActivoCondicion=ConDatos(MonederoMAVI:MonederoMAVI.ID)
Antes=S
AntesExpresiones=Asigna(Info.Modulo, <T>MONEL<T>)<BR>Asigna(Info.ID, MonederoMAVI:MonederoMAVI.ID)
Visible=S

[Acciones.Afectar]
Nombre=Afectar
Boton=7
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=F12
NombreDesplegar=<T>A&fectar<T>
GuardarAntes=S
RefrescarDespues=S
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
ConCondicion=S
Visible=S

Multiple=S
ListaAccionesMultiples=Afectacion<BR>Actualizar Vista
ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, MonederoMAVI:MonederoMAVI.Usuario) y (MonederoMAVI:MonederoMAVI.Estatus en (EstatusSinAfectar))
EjecucionCondicion=ConDatos(MonederoMAVI:MonederoMAVI.Mov)
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
Menu=&Archivo
NombreDesplegar=E&liminar
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Eliminar
ActivoCondicion=Vacio(MonederoMAVI:MonederoMAVI.MovID) y (MonederoMAVI:MonederoMAVI.Estatus=EstatusSinAfectar) y PuedeAfectar(Verdadero, Usuario.ModificarOtrosMovs, MonederoMAVI:MonederoMAVI.Usuario)
ConCondicion=S
EjecucionCondicion=Vacio(SQL(<T>SELECT MovID FROM MonederoMAVI WHERE ID=:nID<T>, MonederoMAVI:MonederoMAVI.ID))
EjecucionMensaje=Forma.ActualizarForma<BR><T>El movimiento ya fue afectado por otro usuario<T>
EjecucionConError=S
Visible=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=33
Menu=&Archivo
NombreDesplegar=<T>Cancela&r<T>
GuardarAntes=S
RefrescarDespues=S
EnBarraHerramientas=S
EnMenu=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cancelacion<BR>Actualizar Cancelar
ConfirmarAntes=S
DialogoMensaje=EstaSeguroPrecaucion
ActivoCondicion=PuedeAfectar(Usuario.Cancelar, Usuario.CancelarOtrosMovs, MonederoMAVI:MonederoMAVI.Usuario) y ConDatos(MonederoMAVI:MonederoMAVI.ID) y ConDatos(MonederoMAVI:MonederoMAVI.MovID) y<BR>(MonederoMAVI:MonederoMAVI.Estatus en (EstatusSinAfectar, EstatusConcluido))
[Acciones.Anterior]
Nombre=Anterior
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+,
NombreDesplegar=Anterior
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Anterior
Activo=S
Visible=S

[Acciones.Siguiente]
Nombre=Siguiente
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+.
NombreDesplegar=Siguiente
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Siguiente
Activo=S
Visible=S

[Acciones.Tiempo]
Nombre=Tiempo
Boton=0
Menu=&Ver
NombreDesplegar=&Tiempos
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=VerMovTiempo
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(MonederoMAVI:MonederoMAVI.ID)
Antes=S
AntesExpresiones=Asigna(Info.Modulo, <T>MONEL<T>)<BR>Asigna(Info.ID, MonederoMAVI:MonederoMAVI.ID)<BR>Asigna(Info.Mov, MonederoMAVI:MonederoMAVI.Mov)<BR>Asigna(Info.MovID,MonederoMAVI:MonederoMAVI.MovID)
Visible=S

[Acciones.MovPos]
Nombre=MovPos
Boton=0
Menu=&Ver
NombreDesplegar=&Posición del Movimiento
EnMenu=S
TipoAccion=Formas
ClaveAccion=MovPos
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(MonederoMAVI:MonederoMAVI.MovID)
Antes=S
AntesExpresiones=Asigna(Info.Modulo, <T>MONEL<T>)<BR>Asigna(Info.ID, MonederoMAVI:MonederoMAVI.ID)<BR>Asigna(Info.Mov, MonederoMAVI:MonederoMAVI.Mov)<BR>Asigna(Info.MovID,MonederoMAVI:MonederoMAVI.MovID)
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+F4
NombreDesplegar=Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador (Documentos)
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Afectar.Afectacion]
Nombre=Afectacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ProcesarSQL(<T>EXEC spAfectarMonederoMAVI :tEmp, :nSuc, :tAcc, :nID, :tUsu, :tMod, :tMov, :tEst, :tTipo, :tCat<T>, Empresa, MonederoMAVI:MonederoMAVI.Sucursal, <T>AFECTAR<T>, MonederoMAVI:MonederoMAVI.ID, Usuario, <T>MONEL<T>, MonederoMAVI:MonederoMAVI.Mov, MonederoMAVI:MonederoMAVI.Estatus,MonederoMAVI:MonederoMAVI.TipoMonedero, MonederoMAVI:MonederoMAVI.CategoriaCV )

[Acciones.Afectar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Cancelar.Cancelacion]
Nombre=Cancelacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ProcesarSQL(<T>EXEC spAfectarMonederoMAVI :tEmp, :nSuc, :tAcc, :nID, :tUsu, :tMod, :tMov, :tEst, :tTipo, :tCat<T>, Empresa, Sucursal, <T>CANCELAR<T>, MonederoMAVI:MonederoMAVI.ID, Usuario, <T>MONEL<T>, MonederoMAVI:MonederoMAVI.Mov, MonederoMAVI:MonederoMAVI.Estatus,MonederoMAVI:MonederoMAVI.TipoMonedero, MonederoMAVI:MonederoMAVI.CategoriaCV )

[Acciones.Cancelar.Actualizar Cancelar]
Nombre=Actualizar Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[SucursalV.Sucursal.Sucursal]
Carpeta=SucursalV
Clave=Sucursal.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SucursalV.Columnas]
Sucursal=64
[(Variables).Info.Sucursal]
Carpeta=(Variables)
Clave=Info.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.MonederoMAVI.Sucursal]
Carpeta=Lista
Clave=MonederoMAVI.Sucursal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.MonederoMAVI.TipoMonedero]
Carpeta=Lista
Clave=MonederoMAVI.TipoMonedero
Editar=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Lista.MonederoMAVI.CategoriaCV]
Carpeta=Lista
Clave=MonederoMAVI.CategoriaCV
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N

[Referencias.Columnas]
Valor=304

