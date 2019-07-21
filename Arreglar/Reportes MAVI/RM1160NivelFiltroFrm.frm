[Forma]
Clave=RM1160NivelFiltroFrm
Nombre=RM1160 Nivel Filtro
Icono=622
Modulos=(Todos)
ListaCarpetas=Listado
CarpetaPrincipal=Listado
PosicionInicialIzquierda=424
PosicionInicialArriba=36
PosicionInicialAlturaCliente=620
PosicionInicialAncho=323
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Listado]
Estilo=Iconos
Clave=Listado
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=RM1160NivelFiltroVis
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Nivel<T>
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
IconosSeleccionMultiple=S
BusquedaRapida=S
BusquedaAncho=20
BusquedaInicializar=S
IconosNombre=RM1160NivelFiltroVis:Nombre
BusquedaEnLinea=S
[Listado.Columnas]
0=-2
1=-2
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Listado<T>)
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+Estaciontrabajo+<T>,2<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Seleccion
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S

