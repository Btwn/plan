[Forma]
Clave=RM0430DLiberadorDimasFRM
Nombre=RM 0430-D Liberador Automatico  Dimas
Icono=0
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=135
PosicionInicialAncho=416
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=453
PosicionInicialArriba=316
ListaAcciones=Preliminar<BR>Cerrar
Plantillas=S
PermiteCopiarDoc=S
ExpresionesAlMostrar=Asigna(Info.FechaD,Hoy)<BR>Asigna(Info.FechaA,Hoy)
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
CarpetaVisible=S
FichaEspacioEntreLineas=19
FichaEspacioNombres=62
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
FichaNombres=Izquierda
FichaAlineacion=Izquierda
PermiteEditar=S
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=4
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=25
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
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
EspacioPrevio=S
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.NVACONS.Cerar]
Nombre=Cerar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

