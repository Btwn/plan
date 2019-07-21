[Forma]
Clave=DM0224FiltroSucursalFrm
Nombre=DM0224 Filtro Sucursal
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=944
PosicionInicialArriba=214
PosicionInicialAlturaCliente=344
PosicionInicialAncho=182
ListaAcciones=Seleccion
[Vista]
Estilo=Iconos
Pestana=S
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0224FiltroSucursalVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Almacen
BusquedaRapidaControles=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
PestanaOtroNombre=S
PestanaNombre=Sucursal
MenuLocal=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
ListaAcciones=Seltodo<BR>quitar
BusquedaRespetarFiltros=S
BusquedaEnLinea=S
[Vista.Almacen]
Carpeta=Vista
Clave=Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Vista.Columnas]
Almacen=64
0=84
1=80
[Acciones.Selección.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=Asigna(DM0224SucursalFiltro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seltodo]
Nombre=Seltodo
Boton=0
NombreDesplegar=Seleccionar &Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Seleccion.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Seleccion.Exp]
Nombre=Exp
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.DM0224SucursalFiltro,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>Exp<BR>selec
Activo=S
Visible=S
[Acciones.quitar]
Nombre=quitar
Boton=0
NombreDesplegar=&Quitar Selección
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
EnMenu=S
