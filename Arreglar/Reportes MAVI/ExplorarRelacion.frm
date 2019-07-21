[Forma]
Clave=ExplorarRelacion
Nombre=Relación entre Clientes
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Enviar<BR>Kardex Origen<BR>KardexRelacion<BR>Cerrar
PosicionInicialAltura=445
PosicionInicialAncho=1124
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionInicialIzquierda=78
PosicionInicialArriba=207
Comentarios=Info.ClienteD
PosicionInicialAlturaCliente=512
VentanaEstadoInicial=Normal
VentanaAjustarZonas=S
VentanaRepetir=S
VentanaAvanzaTab=S
Menus=S
ExpresionesAlCerrar=Asigna(Temp.Texto,<T>A<T>)

[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CteRelacionBusca
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
OtroOrden=S
PestanaOtroNombre=S
PestanaNombre=Búsqueda Coincidencias
ListaEnCaptura=Cte.Nombre<BR>CteRelacionBusca.Relacion<BR>CteDestino.Nombre<BR>CteRelacionBusca.TipoRelacionMAVI<BR>CteRelacionBusca.CoincidenciaMAVI<BR>CteRelacionBusca.MaviEstatus<BR>CteRelacionBusca.Repetido<BR>CteRelacionBusca.FechaBusqueda<BR>CteRelacionBusca.UsuarioBusqueda
ListaOrden=CteRelacionBusca.CoincidenciaMAVI<TAB>(Acendente)
MenuLocal=S
ListaAcciones=SeleccionarTodo<BR>DeseleccionarTodo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosSubTitulo=<T>Cliente<T>
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosNombre=CteRelacionBusca:CteRelacionBusca.Cliente
FiltroGeneral=CteRelacionBusca.Estacion = {EstacionTrabajo}




[Lista.Columnas]
Relacion=97
Nombre=204
Cliente=64
Nombre_1=237
0=79
1=161
2=95
3=174
4=213
5=170
6=71
7=-2
8=-2
9=-2
10=-2
11=-2
12=-2
13=-2
14=-2
15=-2
TipoRelacionMAVI=304
CoincidenciaMAVI=604
FechaBusqueda=94
UsuarioBusqueda=87
FechaValidacion=94
UsuarioValidacion=87
Observaciones=304
UltimoCambioB=94
UsuarioUltimoCambioB=110
UltimoCambioV=94
UsuarioUltimoCambioV=110
Situacion=64
Repetido=47
MaviEstatus=184





[Lista.CteRelacionBusca.Relacion]
Carpeta=Lista
Clave=CteRelacionBusca.Relacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionBusca.TipoRelacionMAVI]
Carpeta=Lista
Clave=CteRelacionBusca.TipoRelacionMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionBusca.CoincidenciaMAVI]
Carpeta=Lista
Clave=CteRelacionBusca.CoincidenciaMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionBusca.FechaBusqueda]
Carpeta=Lista
Clave=CteRelacionBusca.FechaBusqueda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionBusca.UsuarioBusqueda]
Carpeta=Lista
Clave=CteRelacionBusca.UsuarioBusqueda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteRelacionBusca.Repetido]
Carpeta=Lista
Clave=CteRelacionBusca.Repetido
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.CteDestino.Nombre]
Carpeta=Lista
Clave=CteDestino.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Borrar.Borra]
Nombre=Borra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL( <T>xpCoincidenciasMAVIBorra :tCte<T>, Info.Cliente )
[Acciones.Borrar.Actualzia]
Nombre=Actualzia
Boton=0
TipoAccion=Formas
ClaveAccion=ExplorarRelacion
Activo=S
Visible=S
[Acciones.Borrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Enviar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccionID( <T>Lista<T> )<BR>SI CuantosSeleccionID(<T>Lista<T>)>0  ENTONCES<BR>    EjecutarSQL(<T>xpCoincidenciasMAVI :nEstacion<T>, EstacionTrabajo)<BR>    Informacion(<T>Los Datos han sido Enviados a Validación<T>,BotonAceptar)<BR>SINO<BR>    Informacion(<T>No se Seleccionaron Datos a ser Enviados a Validacion<T>,BotonAceptar)<BR>FIN
[Acciones.Enviar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=1=0
[Acciones.Enviar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Informacion(<T>Los Datos han sido Enviados a Validación<T>,BotonAceptar)
EjecucionCondicion=1=0
[Acciones.Enviar]
Nombre=Enviar
Boton=25
NombreEnBoton=S
NombreDesplegar=&Enviar Datos a Validación
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=Expresion<BR>Cerrar<BR>Mensaje
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Expresion
ListaAccionesMultiples=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.DeseleccionarTodo]
Nombre=DeseleccionarTodo
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Lista.CteRelacionBusca.MaviEstatus]
Carpeta=Lista
Clave=CteRelacionBusca.MaviEstatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Kardex Origen]
Nombre=Kardex Origen
Boton=104
NombreEnBoton=S
NombreDesplegar=Kardex Cliente Origen
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=formas
ClaveAccion=MaviServicasaCredKardexporClienteFrm
Activo=S
ConCondicion=S
Antes=S
Visible=S
Menu=Acciones
UsaTeclaRapida=S
EnMenu=S
EjecucionCondicion=ConDatos(CteRelacionBusca:CteRelacionBusca.Cliente)
AntesExpresiones=Asigna( Info.Cliente, CteRelacionBusca:CteRelacionBusca.Cliente)<BR>  Asigna( Info.ClienteD,CteRelacionBusca:CteRelacionBusca.Cliente)<BR>Asigna(Info.Numero,0)
[Acciones.KardexRelacion]
Nombre=KardexRelacion
Boton=104
NombreEnBoton=S
NombreDesplegar=Kardex del cliente relacionado
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=formas
ClaveAccion=MaviServicasaCredKardexporClienteFrm
Activo=S
ConCondicion=S
Antes=S
Visible=S
Multiple=S
ListaAccionesMultiples=llamaVentana<BR>AsignaValDespues
EjecucionCondicion=ConDatos(CteRelacionBusca:CteRelacionBusca.Relacion)
AntesExpresiones=Asigna(Info.ClienteA, Info.Cliente)<BR>Asigna(Mavi.ClienteA, Info.ClienteD)<BR>Asigna(Info.Cliente, CteRelacionBusca:CteRelacionBusca.Relacion )<BR>Asigna(Info.ClienteD,CteRelacionBusca:CteRelacionBusca.Relacion )<BR>Asigna(Info.Numero,1)
[Acciones.KardexRelacion.llamaVentana]
Nombre=llamaVentana
Boton=0
TipoAccion=formas
ClaveAccion=MaviServicasaCredKardexporClienteFrm
Activo=S
Visible=S
[Acciones.KardexRelacion.AsignaValDespues]
Nombre=AsignaValDespues
Boton=0
TipoAccion=expresion
Expresion=Asigna(Info.Cliente,Info.ClienteA)<BR>Asigna(Info.ClienteD,Mavi.ClienteA)
Activo=S
Visible=S

