[Forma]
Clave=RM0071AMaviActivoFListaFrm
Nombre=Activos Fijos
Icono=6
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=295
PosicionInicialArriba=293
PosicionInicialAltura=459
PosicionInicialAncho=690
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Imprimir<BR>Preliminar<BR>Excel<BR>Personalizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
EsConsultaExclusiva=S
Comentarios=Info.Articulo
PosicionInicialAlturaCliente=401

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0071AMaviActivoFListaVis
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Art.Descripcion1<BR>ActivoF.Serie<BR>ActivoF.Almacen
CarpetaVisible=S
Filtros=S
OtroOrden=S
ListaOrden=ActivoF.Articulo<TAB>(Acendente)<BR>ActivoF.Serie<TAB>(Acendente)
FiltroPredefinido=S
FiltroGrupo1=ActivoF.Categoria
FiltroGrupo2=ActivoF.Almacen
FiltroAncho=20
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=Todos
FiltroTodoFinal=S
FiltroNullNombre=(sin clasificar)
FiltroNull=S
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Artículo<T>
ElementosPorPagina=200
PestanaOtroNombre=S
PestanaNombre=Activos Fijos
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroListaEstatus=(Todos)<BR>ACTIVO<BR>INACTIVO
FiltroEstatusDefault=ACTIVO
FiltroFechasNormal=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroEstatus=S
IconosNombre=RM0071AMaviActivoFListaVis:ActivoF.Articulo
FiltroIgnorarEmpresas=S

[Lista.Art.Descripcion1]
Carpeta=Lista
Clave=Art.Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Lista.ActivoF.Almacen]
Carpeta=Lista
Clave=ActivoF.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
Articulo=124
Descripcion1=244
SubCuenta=124
SerieLote=124
Almacen=64
0=118
1=158
2=100
3=66

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Info.SerieLote, RM0071AMaviActivoFListaVis:ActivoF.Serie)<BR>Asigna(Info.Copiar, Verdadero)

[Lista.ActivoF.Serie]
Carpeta=Lista
Clave=ActivoF.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=Imprimir
EnBarraHerramientas=S
EspacioPrevio=S
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

[Acciones.Personalizar]
Nombre=Personalizar
Boton=45
NombreDesplegar=&Personalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

