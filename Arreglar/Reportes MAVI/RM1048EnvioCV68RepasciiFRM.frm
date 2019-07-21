[Forma]
Clave=RM1048EnvioCV68RepasciiFRM
Nombre=RM1048 FILTRO
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1048EnvioCV68RepasciiFRM
CarpetaPrincipal=RM1048EnvioCV68RepasciiFRM
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=ENVIAR
AccionesCentro=S
PosicionInicialAlturaCliente=83
PosicionInicialAncho=240
PosicionInicialIzquierda=365
PosicionInicialArriba=346
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Mavi.RM1048subdependencias,nulo)
[RM1048EnvioCV68RepasciiFRM]
Estilo=Ficha
Clave=RM1048EnvioCV68RepasciiFRM
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1048Subdependencias
PermiteEditar=S
[Acciones.Text.text]
Nombre=text
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM1048EnvioCV68asciiRep
Activo=S
Visible=S
[Acciones.Text.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.ENVIAR]
Nombre=ENVIAR
Boton=23
NombreEnBoton=S
NombreDesplegar=&ENVIAR
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=variable<BR>enviar
Activo=S
Visible=S
[RM1048EnvioCV68RepasciiFRM.Mavi.RM1048Subdependencias]
Carpeta=RM1048EnvioCV68RepasciiFRM
Clave=Mavi.RM1048Subdependencias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ENVIAR.enviar]
Nombre=enviar
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1048EnvioCV68asciiRep
[Acciones.ENVIAR.variable]
Nombre=variable
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


