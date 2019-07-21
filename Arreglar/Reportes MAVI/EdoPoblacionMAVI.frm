[Forma]
Clave=EdoPoblacionMAVI
Nombre=<T>Estado y Población<T>
Icono=4
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=230
PosicionInicialArriba=78
PosicionInicialAltura=442
PosicionInicialAncho=820
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
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
Vista=EdoPoblacionMAVI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=<T>Estados y Poblaciones<T>
MenuLocal=S
PermiteLocalizar=S
ListaAcciones=LocalTodo<BR>LocalQuitar
OtroOrden=S
ListaOrden=CodigoPostal.Estado<TAB>(Acendente)
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
Filtros=S
FiltroPredefinido=S
FiltroGrupo1=CodigoPostal.Estado
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
IconosSeleccionPorLlave=S
IconosSubTitulo=<T>Delegacion<T>
FiltroTodoFinal=S
IconosNombre=EdoPoblacionMAVI:CodigoPostal.Delegacion




[Lista.Columnas]
Delegacion=122
Colonia=200
CodigoPostal=71
Zona=33
Ruta=80
Estado=132
LocalidadCNBV=79
0=190
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
AntesExpresiones=Asigna(Info.Estado, EdoPoblacionMAVI:CodigoPostal.Estado)<BR>RegistrarListaSt(<T>Lista<T>, <T>CodigoPostal.Delegacion<T>)<BR>EjecutarSQL(<T>spEdoPoblacionMAVI :nEstacion, :tCobertura, :tEstado<T>, EstacionTrabajo, Info.Concepto, Info.Estado)

