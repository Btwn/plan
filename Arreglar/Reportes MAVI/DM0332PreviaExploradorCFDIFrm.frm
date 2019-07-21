
[Forma]
Clave=DM0332PreviaExploradorCFDIFrm
Icono=0
Modulos=(Todos)
Nombre=Previa Explorador CFDI

ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialAlturaCliente=157
PosicionInicialAncho=395
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar
AccionesCentro=S
PosicionInicialIzquierda=485
PosicionInicialArriba=286
PosicionSec1=184
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionSec2=440
ExpresionesAlMostrar=Asigna( Mavi.DM0332EdicionCFDI, nulo )<BR>Asigna( Mavi.DM0332UUID, nulo )
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaOtroNombre=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata

PermiteEditar=S



ListaEnCaptura=Mavi.DM0332EdicionCFDI<BR>Mavi.DM0332UUID
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Aceptar
GuardarAntes=S
EnBarraAcciones=S
Activo=S
Visible=S
Multiple=S

ListaAccionesMultiples=Asignar<BR>expresiones
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.expresiones]
Nombre=expresiones
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  Condatos(Mavi.DM0332EdicionCFDI) y (Mavi.DM0332EdicionCFDI=<T>Importe<T>)<BR>Entonces<BR>    FormaModal(<T>DM0332Explorador1Frm<T>)<BR>Sino<BR>Si<BR> Condatos(Mavi.DM0332EdicionCFDI) y (Mavi.DM0332EdicionCFDI=<T>UUID/Importe<T>)<BR>Entonces<BR>        FormaModal(<T>DM0332ExploradorFrm<T>)<BR>Fin<BR><BR>Fin
[CFDValido.Columnas]
Empresa=45
UUID=259
RFCReceptor=304
Monto=64

Relaciones=64
RFCEmisor=133
FechaTimbrado=125

[Relaciones.Columnas]
Tipo=24
UUID=253
UUIDRelacionado=304
Importe=64
Suma=64

[Variables.Mavi.DM0332EdicionCFDI]
Carpeta=Variables
Clave=Mavi.DM0332EdicionCFDI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Mavi.DM0332UUID]
Carpeta=Variables
Clave=Mavi.DM0332UUID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=45
ColorFondo=Blanco

[CFDI De Egresos.Columnas]
Relaciones=64
UUID=276
RFCEmisor=101
FechaTimbrado=123
Monto=64


