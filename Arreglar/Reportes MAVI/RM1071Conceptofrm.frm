[Forma]
Clave=RM1071Conceptofrm
Nombre=RM1071 Conceptos
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=lista
CarpetaPrincipal=lista
PosicionInicialAlturaCliente=272
PosicionInicialAncho=626
ListaAcciones=Selecion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Si<BR>   Vacio(Mavi.RM1071Rubro)<BR>Entonces<BR>  error(<T>Debes Seleccionar un Rubro Primero<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[lista]
Estilo=Iconos
Clave=lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1071ConceptoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Concepto
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
[lista.Concepto]
Carpeta=lista
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[lista.Columnas]
Concepto=604
0=601
[Acciones.Selecion]
Nombre=Selecion
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asig<BR>expre<BR>selec
[Acciones.Selecion.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Selecion.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>lista<T>)
Activo=S
Visible=S
[Acciones.Selecion.selec]
Nombre=selec
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1071concepto,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S

