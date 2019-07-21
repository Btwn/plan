[Forma]
Clave=RM0938ProvListaFrm
Nombre=Proveedores
Icono=44
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=390
PosicionInicialArriba=225
PosicionInicialAltura=425
PosicionInicialAncho=500
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Informacion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
VentanaExclusiva=S
VentanaEscCerrar=S
EsConsultaExclusiva=S
MovModulo=CXP
PosicionInicialAlturaCliente=539
ExpresionesAlMostrar=Asigna(Ver.Todo, Falso)

[Lista]
Estilo=Iconos
Clave=Lista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0938ProvFletesVis
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=25
BusquedaEnLinea=S
CarpetaVisible=S
FiltroClase=S
FiltroClaseTodo=S
FiltroFechasNormal=S
MenuLocal=S
ListaAcciones=Actualizar<BR>Personalizar
PermiteLocalizar=S
FiltroListaEstatus=(Todos)<BR>ALTA<BR>APROBAR<BR>BLOQUEADO<BR>BAJA
FiltroEstatusDefault=ALTA
FiltroSituacionTodo=S
PestanaOtroNombre=S
PestanaNombre=Proveedores
ListaEnCaptura=Prov.Nombre
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosNombre=RM0938ProvFletesVis:Prov.Proveedor
IconosSubTitulo=<T>Proveedor<T>
ElementosPorPagina=200


[Lista.Columnas]
Proveedor=118
Nombre=299
0=130
1=333

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Visible=S
Activo=S
NombreEnBoton=S
EnBarraHerramientas=S

[Acciones.Informacion]
Nombre=Informacion
Boton=34
NombreDesplegar=&Información
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=ProvInfo
Activo=S
Antes=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ConCondicion=S
EjecucionCondicion=(rm0938ProvFletesVis:Prov.Tipo<><T>Acreedor<T>) o Usuario.VerInfoAcreedores
AntesExpresiones=Asigna(Info.Proveedor, rm0938ProvFletesVis:Prov.Proveedor)

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=Actualizar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Todo.Actualizar Titulos]
Nombre=Actualizar Titulos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Titulos
Activo=S
Visible=S

[Acciones.Todo.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Personalizar]
Nombre=Personalizar
Boton=0
NombreDesplegar=Personalizar Vista
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
[Lista.Prov.Nombre]
Carpeta=Lista
Clave=Prov.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

