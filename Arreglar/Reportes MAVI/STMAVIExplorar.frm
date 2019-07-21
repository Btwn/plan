[Forma]
Clave=STMAVIExplorar
Nombre=Atencion a Clientes
Icono=47
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=178
PosicionInicialArriba=146
PosicionInicialAlturaCliente=473
PosicionInicialAncho=924
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cerrar<BR>Seleccionar<BR>Personalizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
EsMovimiento=S
MovModulo=ST
TituloAuto=S
MovEspecificos=Especificos
MovimientosValidos=Queja Servicio<BR>Reporte Servicio
VentanaExclusiva=S

[Lista]
Estilo=Iconos
Clave=Lista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=SoporteA
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Soporte.FechaEmision<BR>Soporte.Concepto<BR>Soporte.Proyecto<BR>Soporte.Referencia<BR>Soporte.Observaciones<BR>Atraso
FiltroEstatus=S
FiltroUsuarios=S
FiltroFechas=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroSituacion=S
FiltroProyectos=S
FiltroUsuarioDefault=(Usuario)
FiltroFechasCampo=Soporte.FechaEmision
FiltroFechasDefault=(Todo)
FiltroFechasNormal=S
FiltroFechasCancelacion=Soporte.FechaCancelacion
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=movimientos
FiltroListaEstatus=PENDIENTE<BR>CONCLUIDO
FiltroEstatusDefault=PENDIENTE
FiltroMovs=S
FiltroMovDefault=(Todos)
FiltroSituacionTodo=S
FiltroMovsTodos=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
IconosNombre=SoporteA:Soporte.Mov+<T> <T>+SoporteA:Soporte.MovID
FiltroAplicaEn=Soporte.Cliente
FiltroGrupo1=Soporte.Cliente
FiltroValida1=Soporte.Cliente
FiltroTodo=S
FiltroTodoFinal=S
FiltroGeneral=Soporte.SubModulo=<T>ST<T>

[Lista.Soporte.FechaEmision]
Carpeta=Lista
Clave=Soporte.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Soporte.Concepto]
Carpeta=Lista
Clave=Soporte.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Soporte.Proyecto]
Carpeta=Lista
Clave=Soporte.Proyecto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Soporte.Referencia]
Carpeta=Lista
Clave=Soporte.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Soporte.Observaciones]
Carpeta=Lista
Clave=Soporte.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Atraso]
Carpeta=Lista
Clave=Atraso
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
0=132
1=84
2=117
3=112
4=140
5=127
6=52
FechaEmision=94
Concepto=304
Proyecto=304
Referencia=304
Observaciones=604
Atraso=64

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[Acciones.Personalizar]
Nombre=Personalizar
Boton=45
NombreDesplegar=Personalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

