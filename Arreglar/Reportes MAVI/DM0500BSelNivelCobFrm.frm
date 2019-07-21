[Forma]
Clave=DM0500BSelNivelCobFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Mavi.DM0500BNivelCobra
CarpetaPrincipal=Mavi.DM0500BNivelCobra
PosicionInicialIzquierda=515
PosicionInicialArriba=91
PosicionInicialAlturaCliente=79
PosicionInicialAncho=317
Nombre=<T>Seleccionar el Nivel de cobranza<T>
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=seleccionar<BR>Cerrar
BarraAcciones=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Acciones.seleccionar]
Nombre=seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
BtnResaltado=S
Activo=S
Visible=S
EnBarraAcciones=S
Multiple=S
ListaAccionesMultiples=sel<BR>Expresion<BR>Cerrar
[Acciones.seleccionar.sel]
Nombre=sel
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=//informacion(Mavi.RM0497BNivelCob)<BR> Asigna( Mavi.DM0500Bvisible, 1 ) <BR>Forma(<T>DM0500BCuotasPerifericasFrm<T>).actualizarforma<BR>//Forma(<T>DM0500BCuotasPerifericasFrm<T>).RefrescarControles (<T>variables<T>)
[Acciones.seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=regresar a ventana<BR>cerrar
[Mavi.DM0500BNivelCobra]
Estilo=Ficha
Clave=Mavi.DM0500BNivelCobra
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
ListaEnCaptura=Mavi.DM0500BNivelCobra
CarpetaVisible=S
[Mavi.DM0500BNivelCobra.Mavi.DM0500BNivelCobra]
Carpeta=Mavi.DM0500BNivelCobra
Clave=Mavi.DM0500BNivelCobra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar.regresar a ventana]
Nombre=regresar a ventana
Boton=0
TipoAccion=formas
ClaveAccion=DM0500BCuotasPerifericasFrm
Activo=S
Visible=S
[Acciones.Cerrar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

