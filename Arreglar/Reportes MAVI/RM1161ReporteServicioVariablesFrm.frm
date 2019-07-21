[Forma]
Clave=RM1161ReporteServicioVariablesFrm
Nombre=RM1161Reporte Servicio
Icono=747
Modulos=(Todos)
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=565
PosicionInicialArriba=354
PosicionInicialAlturaCliente=208
PosicionInicialAncho=272
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM1161Estatus,<T><T>)<BR>Asigna(Mavi.RM1161Sucursal,NULO)
ListaAcciones=Pre
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
FichaEspacioEntreLineas=6
FichaEspacioNombres=148
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1161Estatus<BR>Mavi.RM1161Sucursal
PermiteEditar=S
FichaNombres=Clasico
FichaAlineacion=Centrado
[Variables.Mavi.RM1161Estatus]
Carpeta=Variables
Clave=Mavi.RM1161Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1161Sucursal]
Carpeta=Variables
Clave=Mavi.RM1161Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Pre.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Pre]
Nombre=Pre
Boton=29
NombreEnBoton=S
NombreDesplegar=Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=variables Asignar<BR>Aceptar
Activo=S
Visible=S
[Acciones.Pre.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Si<BR>  (Condatos(Mavi.RM1161Estatus)) y (Condatos(Mavi.RM1161Sucursal))<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Informacion(<T>Ingrese valor a todos los campos.<T>)<BR>    AbortarOperacion<BR>Fin


