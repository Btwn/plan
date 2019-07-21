[Forma]
Clave=RM1128CDimasRecomendadosRecomendadorFrm
Nombre=Selección de Filtros
Icono=0
Modulos=(Todos)
PosicionInicialAlturaCliente=100
PosicionInicialAncho=254
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancel 
ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=189
PosicionInicialArriba=407
ExpresionesAlMostrar=Asigna( Mavi.RM1128Rec, <T><T> )
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asig<BR>cerra
[Variables]
Estilo=Ficha
Clave=Variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Mavi.RM1128Rec
[Acciones.Cancel]
Nombre=Cancel
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Variables.Mavi.RM1128Rec]
Carpeta=Variables
Clave=Mavi.RM1128Rec
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.cerra]
Nombre=cerra
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Mavi.RM1128Rec)
EjecucionMensaje=<T>Seleccione un Recomendador<T>

