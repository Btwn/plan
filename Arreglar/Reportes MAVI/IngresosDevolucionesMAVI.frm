[Forma]
Clave=IngresosDevolucionesMAVI
Nombre=<T>Ingreso Generado<T>
Icono=98
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
PosicionInicialIzquierda=329
PosicionInicialArriba=188
PosicionInicialAlturaCliente=134
PosicionInicialAncho=367
VentanaConIcono=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Salir<BR>Propiedades
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=IngresosDevolucionesMAVI
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Movimiento
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Dinero.Importe<BR>Dinero.CtaDinero
CarpetaVisible=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=IngresosDevolucionesMAVI:Dinero.Mov+<T> <T>+IngresosDevolucionesMAVI:Dinero.MovID
FiltroGeneral=Venta.ID = {Info.IDMAVI}
[Lista.Dinero.Importe]
Carpeta=Lista
Clave=Dinero.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
0=136
1=97
2=119
[Lista.Dinero.CtaDinero]
Carpeta=Lista
Clave=Dinero.CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Propiedades]
Nombre=Propiedades
Boton=35
NombreDesplegar=Propiedades
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
Activo=S
Visible=S
EspacioPrevio=S
ConCondicion=S
EjecucionCondicion=ConDatos(IngresosDevolucionesMAVI:Dinero.ID)
Antes=S
AntesExpresiones=Asigna(Info.Modulo,<T>DIN<T>)<BR>Asigna(Info.ID, IngresosDevolucionesMAVI:Dinero.ID)
[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

