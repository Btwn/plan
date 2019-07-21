[Forma]
Clave=RM1115BackOrderFrm
Nombre=RM1115BackOrderFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
PosicionInicialIzquierda=557
PosicionInicialArriba=381
PosicionInicialAlturaCliente=100
PosicionInicialAncho=301
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=GenerarTxt<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(info.FechaD, PrimerDiaAño( Hoy ) )<BR>Asigna(Info.FechaA, Hoy )
[variables]
Estilo=Ficha
Clave=variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[variables.Info.FechaD]
Carpeta=variables
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[variables.Info.FechaA]
Carpeta=variables
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.GenerarTxt]
Nombre=GenerarTxt
Boton=55
NombreEnBoton=S
NombreDesplegar=Generar TXT&
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM1115BackOrderRep
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asignar<BR>rep
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar&
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.GenerarTxt.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.GenerarTxt.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=rm1115BackOrderRep
Activo=S
Visible=S

