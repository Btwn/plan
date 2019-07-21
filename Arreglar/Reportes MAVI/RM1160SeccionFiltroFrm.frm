[Forma]
Clave=RM1160SeccionFiltroFrm
Nombre=RM1160 Seccion Filtro
Icono=0
Modulos=(Todos)
PosicionInicialAlturaCliente=247
PosicionInicialAncho=344
ListaCarpetas=Listado
CarpetaPrincipal=Listado
PosicionInicialIzquierda=328
PosicionInicialArriba=128
EsConsultaExclusiva=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
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
Vista=RM1160SeccionFiltroVis
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Sección<T>
IconosSeleccionMultiple=S
IconosNombre=RM1160SeccionFiltroVis:SeccionCobranzaMAVI
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
[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Listado<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Seleccionar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+Estaciontrabajo+<T>,2<T>)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

