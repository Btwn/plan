[Forma]
Clave=RM1072ReporteVPPyCPPGerentesFrm
Nombre=RM1072ReporteVPPyCPPGerentes
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=87
PosicionInicialAncho=367
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=456
PosicionInicialArriba=449
ListaAcciones=Acep<BR>Captura
ExpresionesAlMostrar=Asigna( Mavi.RM1072ReporteVPPyCPPGerentes,)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.RM1072ReporteVPPyCPPGerentes<BR>Info.Ano
CarpetaVisible=S



[Acciones.Acep]
Nombre=Acep
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>aceptar
Activo=S
Visible=S

ConCondicion=S

EjecucionCondicion=forma.accion(<T>captura<T>)<BR>Si<BR>  (Mavi.RM1072ReporteVPPyCPPGerentes<1) o (Mavi.RM1072ReporteVPPyCPPGerentes>24)<BR>Entonces<BR>  precaucion(<T>Ingrese una quincena correcta<T>)<BR> abortaroperacion<BR><BR>fin
[Acciones.Acep.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S









[Acciones.Captura]
Nombre=Captura
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[(Variables).Mavi.RM1072ReporteVPPyCPPGerentes]
Carpeta=(Variables)
Clave=Mavi.RM1072ReporteVPPyCPPGerentes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Acep.aceptar]
Nombre=aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[(Variables).Info.Ano]
Carpeta=(Variables)
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

