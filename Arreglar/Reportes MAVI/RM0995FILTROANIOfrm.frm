[Forma]
Clave=RM0995FILTROANIOfrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Rama
CarpetaPrincipal=Rama
PosicionInicialIzquierda=258
PosicionInicialArriba=266
PosicionInicialAlturaCliente=270
PosicionInicialAncho=160
VentanaTipoMarco=Chico
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=asig<BR>Canc
[Rama]
Estilo=Iconos
Clave=Rama
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0995FILTROANIOVIS
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=RM0995FILTROANIOVIS:ANIO
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosNombre=RM0995FILTROANIOVIS:ANIO
[Rama.Columnas]
0=128
[Acciones.asig]
Nombre=asig
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asigna<BR>Expresion<BR>Seleccionar/Resultado
[Acciones.Canc]
Nombre=Canc
Boton=21
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
[Acciones.asig.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.asig.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.asig.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUEN <T>+Estaciontrabajo+<T>,2<T>)
