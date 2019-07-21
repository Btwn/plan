[Forma]
Clave=RM1142CVFiltrofrm
Nombre=RMM142 Canales de Venta
Icono=0
Modulos=(Todos)
ListaCarpetas=CV
CarpetaPrincipal=CV
PosicionInicialIzquierda=354
PosicionInicialArriba=113
PosicionInicialAlturaCliente=225
PosicionInicialAncho=324
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccio
[CV]
Estilo=Iconos
Clave=CV
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1142CvfiltroVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Canal Venta<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosNombre=RM1142CvfiltroVis:ID
ListaEnCaptura=Cadena
[CV.Columnas]
0=86
1=-2
[Acciones.Seleccio]
Nombre=Seleccio
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=asigna<BR>regis<BR>selc
[Acciones.Seleccio.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccio.regis]
Nombre=regis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>CV<T>)
[Acciones.Seleccio.selc]
Nombre=selc
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.RM1142CV,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[CV.Cadena]
Carpeta=CV
Clave=Cadena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
