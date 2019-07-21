[Forma]
Clave=SegmentosMAVIInfoT
Nombre=Segmentos MAVI
Icono=0
Modulos=(Todos)
ListaCarpetas=SegmentosMAVIInfoT
CarpetaPrincipal=SegmentosMAVIInfoT
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
ClaveAccion=CampanaTelefonicaAux
Activo=S
Visible=S
[SegmentosMAVIInfoT]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Información
Clave=SegmentosMAVIInfoT
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=SegmentosMAVI
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=SegmentosMAVI:SegmentosMAVI.Segmento
IconosSubTitulo=<T>Segmento<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=SegmentosMAVI.Numero
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroGeneral=SegmentosMAVI.Estacion = {EstacionTrabajo} AND SegmentosMAVI.MovID = <T>{Info.CampanaMovID}<T>
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
[SegmentosMAVIInfoT.SegmentosMAVI.Numero]
Carpeta=SegmentosMAVIInfoT
Clave=SegmentosMAVI.Numero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

