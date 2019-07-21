
[Forma]
Clave=RM1187ParametrosFrm
Icono=674
Modulos=(Todos)
Nombre=<T>Configuración reporte<T>

ListaCarpetas=Configuracion
CarpetaPrincipal=Configuracion
PosicionInicialIzquierda=507
PosicionInicialArriba=430
PosicionInicialAlturaCliente=126
PosicionInicialAncho=265
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
ExpresionesAlMostrar=Asigna(Mavi.RM1187FechaInicial,Hoy)<BR>Asigna(Mavi.RM1187FechaFinal,Hoy)<BR>Asigna(Mavi.RM1187UEN,NULO)
[Configuracion]
Estilo=Ficha
PestanaOtroNombre=S
PestanaNombre=Configuracion
Clave=Configuracion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=84
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1187FechaInicial<BR>Mavi.RM1187FechaFinal<BR>Mavi.RM1187UEN
CarpetaVisible=S

PermiteEditar=S

[Configuracion.Mavi.RM1187FechaInicial]
Carpeta=Configuracion
Clave=Mavi.RM1187FechaInicial
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco


[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    (Vacio(Mavi.RM1187FechaInicial)) o (Vacio(Mavi.RM1187FechaFinal)) o (Vacio(Mavi.RM1187UEN))<BR>Entonces<BR>    Error(<T>LOS RANGOS DE FECHA Y UEN SON OBLIGATORIOS<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si<BR>  Mavi.RM1187FechaInicial>Mavi.RM1187FechaFinal<BR>Entonces<BR>  Precaucion(<T>LA FECHA DESDE NO PUEDE SER MAYOR A LA FECHA HASTA<T>)<BR>  AbortarOperacion<BR>Sino                                                                                                  <BR>  Verdadero            <BR>Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=-1
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Aceptar
Activo=S
Visible=S

EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=-1
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

[RM1187ListadoUEN.Columnas]
0=-2
1=162

[Configuracion.Mavi.RM1187FechaFinal]
Carpeta=Configuracion
Clave=Mavi.RM1187FechaFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco



[Configuracion.Mavi.RM1187UEN]
Carpeta=Configuracion
Clave=Mavi.RM1187UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[RM1187ListadoUENFrm.Columnas]
0=-2
1=-2

