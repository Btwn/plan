[Forma]
Clave=CxcRefSaldoMavi
Nombre=CxcRefSaldoMavi
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=405
PosicionInicialArriba=229
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CxcRefSaldoMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Anticipo Saldo Pendiente
Filtros=S
OtroOrden=S
BusquedaRapidaControles=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
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
IconosSubTitulo=<T>Movimientos<T>
ListaEnCaptura=MovID<BR>Abono<BR>FechaRegistro<BR>Moneda
ListaOrden=ModuloID<TAB>(Acendente)
FiltroFechas=S
IconosNombre=CxcRefSaldoMAVI:Mov
FiltroFechasCampo=FechaRegistro
[Lista.MovID]
Carpeta=Lista
Clave=MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Abono]
Carpeta=Lista
Clave=Abono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Moneda]
Carpeta=Lista
Clave=Moneda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
0=-2
1=-2
2=-2
3=-2
4=-2
[Lista.FechaRegistro]
Carpeta=Lista
Clave=FechaRegistro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
NombreEnBoton=S
ClaveAccion=Seleccionar
Antes=S
Expresion=Asigna(Info.MovAsigna, CxcRefSaldoMAVI:Mov)<BR>ASigna(Info.MovIDAsigna, CxcRefSaldoMAVI:MovID)<BR>Asigna(Info.AbonoAsigna, CxcRefSaldoMAVI:Abono)
