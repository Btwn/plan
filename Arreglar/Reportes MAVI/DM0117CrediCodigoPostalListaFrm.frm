[Forma]
Clave=DM0117CrediCodigoPostalListaFrm
Nombre=Códigos Postales
Icono=4
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=190
PosicionInicialArriba=231
PosicionInicialAltura=443
PosicionInicialAncho=899
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=523
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.DM0117Colonia,<T><T>)<BR>asigna(Mavi.DM0117CP,<T><T>)<BR>asigna(Mavi.DM0117Delegacion,<T><T>)<BR>asigna(Mavi.DM0117Estado,<T><T>)<BR>asigna(Mavi.DM0117Pais,<T><T>)
ExpresionesAlCerrar=Asigna(Mavi.DM0117CP, CodigoPostal:CodigoPostal.CodigoPostal)<BR>Asigna(Mavi.DM0117Colonia, CodigoPostal:CodigoPostal.Colonia)<BR>Asigna(Mavi.DM0117Delegacion, CodigoPostal:CodigoPostal.Delegacion)<BR>Asigna(Mavi.DM0117Estado, CodigoPostal:CodigoPostal.Estado)<BR>Asigna(Mavi.DM0117Pais, <T>Mexico<T>)

[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CodigoPostal
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
CarpetaVisible=S
ListaEnCaptura=CodigoPostal.Estado<BR>CodigoPostal.Delegacion<BR>CodigoPostal.Colonia<BR>CodigoPostal.CodigoPostal<BR>CodigoPostal.Ruta<BR>CodigoPostal.LocalidadCNBV
Filtros=S
FiltroPredefinido=S
FiltroGrupo1=CodigoPostal.Estado
FiltroGrupo2=CodigoPostal.Delegacion
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=Todo
FiltroAncho=25
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
BusquedaRapidaControles=S
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
FiltroGrupo3=CodigoPostal.Colonia
FiltroGrupo4=CodigoPostal.CodigoPostal

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

[Lista.Columnas]
Delegacion=129
Colonia=189
CodigoPostal=71
Zona=32
Ruta=67
Estado=150
LocalidadCNBV=77

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(CodigoPostal:CodigoPostal.CodigoPostal)
AntesExpresiones=Asigna(Mavi.DM0117CP, CodigoPostal:CodigoPostal.CodigoPostal)<BR>Asigna(Mavi.DM0117Colonia, CodigoPostal:CodigoPostal.Colonia)<BR>Asigna(Mavi.DM0117Delegacion, CodigoPostal:CodigoPostal.Delegacion)<BR>Asigna(Mavi.DM0117Estado, CodigoPostal:CodigoPostal.Estado)<BR>Asigna(Mavi.DM0117Pais, <T>Mexico<T>)

[Lista.CodigoPostal.Ruta]
Carpeta=Lista
Clave=CodigoPostal.Ruta
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
[Lista.CodigoPostal.LocalidadCNBV]
Carpeta=Lista
Clave=CodigoPostal.LocalidadCNBV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

