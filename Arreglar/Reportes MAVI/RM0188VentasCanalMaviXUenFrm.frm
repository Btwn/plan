[Forma]
Clave=RM0188VentasCanalMaviXUenFrm
Nombre=Canales de Venta
Icono=401
EsConsultaExclusiva=S
Modulos=(Todos)
ListaCarpetas=RM0188VentasCanalMaviXUenVis
CarpetaPrincipal=RM0188VentasCanalMaviXUenVis
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=501
PosicionInicialArriba=301
PosicionInicialAlturaCliente=383
PosicionInicialAncho=277
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Selecion
[RM0188VentasCanalMaviXUenVis]
Estilo=Iconos
Clave=RM0188VentasCanalMaviXUenVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0188VentasCanalMaviXUenVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Valor
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionPorLlave=S
IconosSeleccionMultiple=S
IconosNombre=RM0188VentasCanalMaviXUenVis:ID
IconosSubTitulo=Canal
[RM0188VentasCanalMaviXUenVis.Valor]
Carpeta=RM0188VentasCanalMaviXUenVis
Clave=Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[RM0188VentasCanalMaviXUenVis.Columnas]
Valor=235
0=-2
1=199
[Acciones.Selecion]
Nombre=Selecion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion<BR>Seleccionar/Resultado
[Acciones.Selecion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Selecion.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

