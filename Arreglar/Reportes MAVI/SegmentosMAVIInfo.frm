[Forma]
Clave=SegmentosMAVIInfo
Nombre=Segmentos MAVI
Icono=0
Modulos=(Todos)
ListaCarpetas=SegmentosMAVIInfo
CarpetaPrincipal=SegmentosMAVIInfo
PosicionInicialAlturaCliente=333
PosicionInicialAncho=258
PosicionInicialIzquierda=511
PosicionInicialArriba=216
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Imprimir<BR>Cancelar
VentanaExclusiva=S
[SegmentosMAVIInfo]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Información
Clave=SegmentosMAVIInfo
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=SegmentosMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Segmento<T>
ElementosPorPagina=200
ListaEnCaptura=SegmentosMAVI.Numero
PermiteEditar=S
IconosSeleccionMultiple=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=SegmentosMAVI:SegmentosMAVI.Segmento
FiltroGeneral=SegmentosMAVI.Estacion = {EstacionTrabajo} AND SegmentosMAVI.MovID = <T>{Info.CampanaMovID}<T>
[SegmentosMAVIInfo.SegmentosMAVI.Numero]
Carpeta=SegmentosMAVIInfo
Clave=SegmentosMAVI.Numero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SegmentosMAVIInfo.Columnas]
0=-2
1=185
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=&Imprimir Selección
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
Antes=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Expresion<BR>Reporte
AntesExpresiones=RegistrarSeleccion(<T>Lista<T>)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Imprimir.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>spRepCampanaDMAVI :tMovID, :nEstacion<T>, {Info.CampanaMovID}, EstacionTrabajo)
[Acciones.Imprimir.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=CampanaCorreoAux
Activo=S
Visible=S

