[Forma]
Clave=MaviCxcBonificacionesD
Nombre=MaviCxcBonificacionesD
Icono=0
Modulos=(Todos)
ListaCarpetas=MaviCxcBonificacionesD
CarpetaPrincipal=MaviCxcBonificacionesD
PosicionInicialAlturaCliente=736
PosicionInicialAncho=539
PosicionInicialIzquierda=166
PosicionInicialArriba=6
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion<BR>Seleccionar Todo<BR>Quitar Seleccion<BR>Totalizar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEstadoInicial=Normal
PosicionSec1=336
PosicionSec2=336
[MaviCxcBonificacionesD]
Estilo=Iconos
Clave=MaviCxcBonificacionesD
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviCxcBonificacionesD
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Consecutivo<T>
ElementosPorPagina=200
IconosSeleccionPorLlave=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mov<BR>Importe<BR>Referencia<BR>Vencimiento
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
IconosNombre=MaviCxcBonificacionesD:MovID
FiltroGeneral=p.OrigenID = <T>{Info.MovID}<T> AND p.Origen = <T>{Info.Mov}<T><BR>AND c.Cliente = <T>{Info.Cliente}<T> AND c.Empresa = <T>{Empresa}<T><BR>AND c.ClienteEnviarA = {Info.EnviarA}
[MaviCxcBonificacionesD.Mov]
Carpeta=MaviCxcBonificacionesD
Clave=Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MaviCxcBonificacionesD.Importe]
Carpeta=MaviCxcBonificacionesD
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MaviCxcBonificacionesD.Referencia]
Carpeta=MaviCxcBonificacionesD
Clave=Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[MaviCxcBonificacionesD.Vencimiento]
Carpeta=MaviCxcBonificacionesD
Clave=Vencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[MaviCxcBonificacionesD.Columnas]
0=-2
1=101
2=101
3=151
4=103
5=-2
[Acciones.Seleccion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccionID ( Lista )<BR>EjecutarSQL(<T>spBonificacionesCalcula :tEmpresa,:nEstacion<T>, {Empresa},EstacionTrabajo)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Expresion
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=55
NombreDesplegar=Seleccionar &Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Quitar Seleccion]
Nombre=Quitar Seleccion
Boton=54
NombreDesplegar=&Quitar Seleccion
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Total
Totalizadores2=SqlEnLista(<T>SELECT SUM(c.Saldo) FROM CxcPendiente c JOIN ListaID l ON c.ID = l.ID AND l.Estacion = :nEstacion<T>, {EstacionTrabajo})
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
TotAlCambiar=S
ListaEnCaptura=Total
TotCarpetaRenglones=MaviCxcBonificacionesD
[(Carpeta Totalizadores).Total]
Carpeta=(Carpeta Totalizadores)
Clave=Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.Totalizar]
Nombre=Totalizar
Boton=64
NombreDesplegar=&Totalizar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=RegistrarSeleccionID ( Lista )<BR>Asigna(Info.Importe, SqlEnLista(<T>SELECT SUM(c.Saldo) FROM CxcPendiente c JOIN ListaID l ON c.ID = l.ID AND l.Estacion = :nEstacion<T>, {EstacionTrabajo}))<BR>Informacion(<T>$ <T> & Info.Importe, BotonAceptar)

