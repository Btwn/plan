[Forma]
Clave=RM0988CXCMovimientosVisFrm
Nombre=Tipo de Movimientos
Icono=0
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialIzquierda=567
PosicionInicialArriba=322
PosicionInicialAlturaCliente=255
PosicionInicialAncho=183
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlCerrar=ActualizarForma(<T>RM0988CXCMovimientosFrm<T>)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccion
[RM0988CXCMovimientosVis.Columnas]
VALOR=125
0=-2
[Vista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Tipo de Movimientos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0988CXCMovimientosVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=VALOR
CarpetaVisible=S
[Vista.VALOR]
Carpeta=Vista
Clave=VALOR
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccion.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Seleccion.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Seleccion.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)
Activo=S
Visible=S
[Acciones.Seleccion]
Nombre=Seleccion
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Seleccion
Activo=S
Visible=S
NombreEnBoton=S
[Vista.Columnas]
0=-2

