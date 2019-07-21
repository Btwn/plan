[Forma]
Clave=DM0278CancelacionSegurosPrincFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=Principal
CarpetaPrincipal=Principal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Cancelacion Ventas<BR>Cancelacion Cobranza<BR>Cerrar
PosicionInicialIzquierda=361
PosicionInicialArriba=479
PosicionInicialAlturaCliente=28
PosicionInicialAncho=558
Nombre=Cancelación de Seguro de Vida
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[Acciones.Cancelacion Ventas]
Nombre=Cancelacion Ventas
Boton=35
NombreEnBoton=S
NombreDesplegar=Cancelacion Seguros de Vida          .
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0278CancelacionSegurosVidaCrearFRM
Visible=S
EspacioPrevio=S
BtnResaltado=S
ActivoCondicion=SQL(<T>select  dbo.FN_DM0278VerificarUsuarioAcceso(<T>+comillas(Usuario)+<T>)<T>)=1
[Acciones.Cancelacion Cobranza]
Nombre=Cancelacion Cobranza
Boton=18
NombreEnBoton=S
NombreDesplegar=Tablero Cancelacion de Seguros          .
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0278ExploradorCancelacionSegurosVidaFRM
Visible=S
BtnResaltado=S
ActivoCondicion=SQL(<T>select  dbo.FN_DM0278VerificarUsuarioAcceso(<T>+comillas(Usuario)+<T>)<T>)=2
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar Ventana          .
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
BtnResaltado=S


