
[Forma]
Clave=RM1201RepFinalesXAgenteFrm
Icono=143
Modulos=(Todos)

ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=588
PosicionInicialArriba=309
PosicionInicialAlturaCliente=111
PosicionInicialAncho=235
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
Nombre=DIMA X Agente
ListaAcciones=Prel
ExpresionesAlMostrar=Asigna(Mavi.RM1201Agente,NULO)
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
ListaEnCaptura=Mavi.RM1201Agente
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S

[Vista.Columnas]
Agente=72
Nombre=362


[Acciones.Prel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Prel.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Prel]
Nombre=Prel
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar
Activo=S
Visible=S

[Variables.Mavi.RM1201Agente]
Carpeta=Variables
Clave=Mavi.RM1201Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


