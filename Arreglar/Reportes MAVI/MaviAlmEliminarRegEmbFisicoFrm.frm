[Forma]
Clave=MaviAlmEliminarRegEmbFisicoFrm
Nombre=Eliminar?
Icono=122
BarraAcciones=S
Modulos=(Todos)
AccionesTamanoBoton=10x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialAlturaCliente=35
PosicionInicialAncho=132
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=6
PosicionInicialArriba=11
VentanaTipoMarco=Normal
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
VentanaSiempreAlFrente=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.AlmEliminarRegCapFisica,0)
[Acciones.Aceptar.AsignarAceptar]
Nombre=AsignarAceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,1)
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=<T>Si<T>
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=AsignarAceptar<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cancelar.AsignarCanc]
Nombre=AsignarCanc
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)   
[Acciones.Cancelar.CerrarCanc]
Nombre=CerrarCanc
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=<T>No<T>
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=AsignarCanc<BR>CerrarCanc
Activo=S
Visible=S
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
CampoColorFondo=Negro
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata


