
[Forma]
Clave=RM1149CertHuellasPorLoteFrm
Icono=137
Modulos=(Todos)
Nombre=<T>RM1149 Certificación de Huellas por Lote<T>
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=433
PosicionInicialArriba=228
BarraHerramientas=S

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
ExpresionesAlMostrar=asigna(Info.FechaD,Nulo)<BR>asigna(Info.FechaA,Nulo)<BR>asigna(Mavi.RM1194Tipo,Nulo)<BR>asigna(Mavi.RM1194TipoC,Nulo)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
TipoAccion=Controles Captura

Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>Entonces    <BR>    Si<BR>       Info.FechaD > Info.FechaA<BR>    Entonces<BR>       Error(<T>Rango de Fechas no Valido<T>)<BR>       AbortarOperacion<BR>    Sino<BR>       Verdadero<BR>    Fin<BR>Fin<BR><BR>Si<BR>  ConDatos(Info.FechaD)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Error(<T>Fecha de inicio debe ser obligatoria<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>Si<BR>  ConDatos(Mavi.RM1194Tipo)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>   Error(<T>El campo Tipo debe ser obligatorio<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si<BR>  ConDatos(Mavi.RM1194TipoC)<BR>Entonces<BR> Verdadero<BR>Sino<BR>  Error(<T>El campo tipo consulta es obligatorio<T>)<BR>   AbortarOperacion<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



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
FichaEspacioEntreLineas=7
FichaEspacioNombres=62
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1194Tipo<BR>Mavi.RM1194TipoC
CarpetaVisible=S

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco









AccionAlEnter=

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
AccionAlEnter=

[(Variables).Mavi.RM1194Tipo]
Carpeta=(Variables)
Clave=Mavi.RM1194Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1194TipoC]
Carpeta=(Variables)
Clave=Mavi.RM1194TipoC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

