[Forma]
Clave=RM1119filtrouenfrm
Nombre=RM1119 Filtro Uen
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=uen
CarpetaPrincipal=uen
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
ListaAcciones=seleccion
[uen]
Estilo=Iconos
Clave=uen
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1119filtrouen
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaEnCaptura=uen
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaEnLinea=S
[uen.uen]
Carpeta=uen
Clave=uen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[uen.Columnas]
0=-2
[Acciones.seleccion]
Nombre=seleccion
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asign<BR>Regis<BR>Select
NombreEnBoton=S
[Acciones.seleccion.Asig]
Nombre=Asig
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.seleccion.Asign]
Nombre=Asign
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.seleccion.Regis]
Nombre=Regis
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion( <T>uen<T> )
[Acciones.seleccion.Select]
Nombre=Select
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1119NivelCob,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
