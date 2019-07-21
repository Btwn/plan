[Forma]
Clave=MaviInvEtiqActivoFAsignarFrm
Nombre=Asignar Activos Fijos de la Empresa
Icono=6
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=0
PosicionInicialArriba=0
PosicionInicialAltura=459
PosicionInicialAncho=1288
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Agregar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
PosicionInicialAlturaCliente=1002
Comentarios=Lista(Info.Personal, Info.Espacio, Info.Nombre)
EsConsultaExclusiva=S

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviInvEtiqActivoFAsignarVis
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
OtroOrden=S
ListaOrden=ActivoF.Articulo<TAB>(Acendente)<BR>ActivoF.Serie<TAB>(Acendente)
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
MenuLocal=S
ListaAcciones=Seleccionar Todo<BR>Quitar Seleccion
Pestana=S
FiltroIgnorarEmpresas=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
Filtros=S
IconosSubTitulo=<T>Serie<T>
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=22
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
IconosSeleccionMultiple=S
FiltroTodo=S
FiltroTodoFinal=S
ListaEnCaptura=ActivoF.Articulo<BR>Art.Descripcion1<BR>ActivoF.Almacen
FiltroGrupo1=ActivoF.Categoria
PermiteLocalizar=S
FiltroGrupo2=ActivoF.Almacen
FiltroListas=S
FiltroListasRama=INV
FiltroListasAplicaEn=ActivoF.Articulo
FiltroArbol=Articulos
FiltroArbolAplica=ActivoF.Articulo
IconosNombre=MaviInvEtiqActivoFAsignarVis:ActivoF.Serie



[Lista.Columnas]
Articulo=124
Descripcion1=244
SubCuenta=124
SerieLote=124
Almacen=64
0=118
1=158
2=119
3=66


[Acciones.Agregar]
Nombre=Agregar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Agregar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Antes=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asig<BR>Registrar<BR>Resul
AntesExpresiones=RegistrarSeleccionID(<T>Ficha<T>)<BR>EjecutarSQL(<T>spActivoFijoAsignar :nEstacion, :nID<T>, EstacionTrabajo, Info.ID)

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>&Cancelar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
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
[Acciones.Agregar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Agregar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Lista<T>)  <BR>//Asigna(Mavi.Factura,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo))<BR>//Asigna(Mavi.SucuAdeC, nulo)
[Acciones.Agregar.Resul]
Nombre=Resul
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Lista.ActivoF.Articulo]
Carpeta=Lista
Clave=ActivoF.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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

