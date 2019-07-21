
[Forma]
Clave=CodigoPostalCEVentas
Icono=4
Modulos=(Todos)
Nombre=Códigos Postales
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaCarpetas=Lista<BR>(Variables)
CarpetaPrincipal=Lista
ListaAcciones=Seleccionar<BR>actualizar<BR>Cerrar
PosicionInicialIzquierda=0
PosicionInicialArriba=0
PosicionInicialAlturaCliente=1002
PosicionInicialAncho=1296
MovModulo=(Todos)
PosicionSec1=68
ExpresionesAlMostrar=Asigna(Mavi.DM0169CPEstado,Comillas(SQL(<T>Select Estado From Sucursal Where Sucursal=:tSuc<T>,Sucursal )))<BR>Asigna(Mavi.DM0169CPDelegacion,Comillas(SQL(<T>Select Delegacion From Sucursal Where Sucursal=:tSuc<T>,Sucursal)))
[Lista]
Estilo=Hoja
Clave=Lista
Filtros=S
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=CodigoPostalCEVentas
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CodigoPostal.Estado<BR>CodigoPostal.Delegacion<BR>CodigoPostal.Colonia<BR>CodigoPostal.CodigoPostal

FiltroPredefinido=S
FiltroGrupo1=CodigoPostal.Estado
FiltroGrupo2=CodigoPostal.Delegacion
FiltroGrupo3=CodigoPostal.Colonia
FiltroGrupo4=CodigoPostal.CodigoPostal
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=25
FiltroRespetar=S
FiltroTipo=General
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=25
BusquedaEnLinea=S
CarpetaVisible=S
BusquedaRespetarFiltros=S
BusquedaRespetarUsuario=S
FiltroIgnorarEmpresas=S

[Lista.CodigoPostal.CodigoPostal]
Carpeta=Lista
Clave=CodigoPostal.CodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CodigoPostal.Colonia]
Carpeta=Lista
Clave=CodigoPostal.Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CodigoPostal.Delegacion]
Carpeta=Lista
Clave=CodigoPostal.Delegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Lista.CodigoPostal.Estado]
Carpeta=Lista
Clave=CodigoPostal.Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
Activo=S
ConCondicion=S
Antes=S
Visible=S

NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Regis<BR>selec<BR>cerrar
EjecucionConError=S
EjecucionCondicion=ConDatos(CodigoPostalCEVentas:CodigoPostal.CodigoPostal)
AntesExpresiones=asigna(info.copiar,verdadero)<BR>Asigna(Info.Colonia, CodigoPostalCEVentas:CodigoPostal.Colonia)<BR>Asigna(Info.CodigoPostal, CodigoPostalCEVentas:CodigoPostal.CodigoPostal)<BR>Asigna(Info.Delegacion, CodigoPostalCEVentas:CodigoPostal.Delegacion)<BR>Asigna(Info.Estado, CodigoPostalCEVentas:CodigoPostal.Estado)


[Lista.Columnas]
Estado=135
Delegacion=152
Colonia=235
CodigoPostal=94










[Acciones.filtro.asign]
Nombre=asign
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0169EstadoFrm
[Acciones.actualizar]
Nombre=actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>actualizar vista
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0169CPEstado<BR>Mavi.DM0169CPDelegacion<BR>Mavi.DM0169CodigoPos
CarpetaVisible=S
[(Variables).Mavi.DM0169CPEstado]
Carpeta=(Variables)
Clave=Mavi.DM0169CPEstado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0169CPDelegacion]
Carpeta=(Variables)
Clave=Mavi.DM0169CPDelegacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Regis]
Nombre=Regis
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>carpeta<T>)
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Seleccionar.selec]
Nombre=selec
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(info.codigopostal,CodigoPostalCEVentas:CodigoPostal.CodigoPostal)    <BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.actualizar.actualizar vista]
Nombre=actualizar vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.actualizar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.DM0169CodigoPos]
Carpeta=(Variables)
Clave=Mavi.DM0169CodigoPos
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

