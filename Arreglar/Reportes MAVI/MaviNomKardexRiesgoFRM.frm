[Forma]
Clave=MaviNomKardexRiesgoFRM
Nombre=RM724 Kardex de Riesgos
Icono=152
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=539
PosicionInicialArriba=451
PosicionInicialAlturaCliente=122
PosicionInicialAncho=316
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Ace<BR>Cer
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.ConceptoInca,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.ConceptoInca<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.ConceptoInca]
Carpeta=(Variables)
Clave=Mavi.ConceptoInca
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ace.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Ace.Acep]
Nombre=Acep
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=MaviNomKardexRiesgoREPXLS
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Info.FechaD <= Info.FechaA
EjecucionMensaje=<T>Poner correctamente el rango de fechas.<T>
[Acciones.Ace]
Nombre=Ace
Boton=0
NombreDesplegar=Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
ListaAccionesMultiples=Asigna<BR>Acep
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cer]
Nombre=Cer
Boton=0
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


