[Forma]
Clave=EdoPoblacionColoniaMAVI
Nombre=<T>Poblaciónes y Colonias del Estado: <T> & {Info.Estado}
Icono=4
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=260
PosicionInicialArriba=51
PosicionInicialAltura=442
PosicionInicialAncho=928
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=609
EsConsultaExclusiva=S
VentanaEstadoInicial=Normal
VentanaExclusiva=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Info.Numero, 1)

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=EdoPoblacionColoniaMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Colonias
MenuLocal=S
PermiteLocalizar=S
ListaAcciones=LocalTodo<BR>LocalQuitar
OtroOrden=S
ListaOrden=CodigoPostal.Colonia<TAB>(Acendente)<BR>CodigoPostal.Estado<TAB>(Acendente)
Filtros=S
FiltroPredefinido=S
FiltroGrupo1=CodigoPostal.Delegacion
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroArbolClave=CodigoPostal.Delegacion
FiltroArbolRama=CodigoPostal.Delegacion
FiltroAutoCampo=CodigoPostal.Estado
FiltroAutoValidar=CodigoPostal.Estado
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Colonia
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=EdoPoblacionColoniaMAVI:CodigoPostal.Colonia
FiltroGeneral=CodigoPostal.Estado = <T>{Info.Estado}<T>




[Lista.Columnas]
Delegacion=122
Colonia=601
CodigoPostal=71
Zona=33
Ruta=80
Estado=132
LocalidadCNBV=79
0=661
1=248
Nombre=604
2=-2




[Acciones.LocalTodo]
Nombre=LocalTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.LocalQuitar]
Nombre=LocalQuitar
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Info.Delegacion, EdoPoblacionColoniaMAVI:CodigoPostal.Delegacion)<BR>RegistrarListaSt(<T>Lista<T>, <T>CodigoPostal.Colonia<T>)<BR>EjecutarSQL(<T>spColoniasEliminarMAVI :nIDCampana, :nEstacion, :tEstado, :tPoblacion<T>, Info.ID, EstacionTrabajo, Info.Estado, Info.Delegacion)

