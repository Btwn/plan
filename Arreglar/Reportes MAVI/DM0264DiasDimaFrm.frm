
[Forma]
Clave=DM0264DiasDimaFrm
Icono=0
Modulos=(Todos)
Nombre=Configuración Red DIMAR

ListaCarpetas=DIMA
CarpetaPrincipal=DIMA
PosicionInicialIzquierda=522
PosicionInicialArriba=437
PosicionInicialAlturaCliente=111
PosicionInicialAncho=236
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Info<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[DIMA]
Estilo=Ficha
Clave=DIMA
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0264DiasDimaVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=12
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0264DiasDimaTbl.Dias<BR>DM0264DiasDimaTbl.Cuota

[DIMA.DM0264DiasDimaTbl.Dias]
Carpeta=DIMA
Clave=DM0264DiasDimaTbl.Dias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DIMA.DM0264DiasDimaTbl.Cuota]
Carpeta=DIMA
Clave=DM0264DiasDimaTbl.Cuota
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConfirmarAntes=S
DialogoMensaje=DM0264DiasDimaDlg
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cancela<BR>Cerrar
[Acciones.Cerrar.Cancela]
Nombre=Cancela
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



[Acciones.Info]
Nombre=Info
Boton=34
NombreEnBoton=S
NombreDesplegar=&Información
EnBarraHerramientas=S
TipoAccion=Expresion
Expresion=Informacion(<T>Días: Periodo de gracia en el que no se le exigirá cuota.<T> + NuevaLinea + NuevaLinea +<BR>            <T>Cuota: Importe total a facturar después del periodo de gracia.<T>)
Activo=S
Visible=S

