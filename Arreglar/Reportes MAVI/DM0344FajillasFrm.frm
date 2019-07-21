
[Forma]
Clave=DM0344FajillasFrm
Icono=0
EsMovimiento=S
Modulos=(Todos)
Nombre=Alertas Fajillas
TituloAuto=S
MovEspecificos=Todos

CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=231
PosicionInicialAncho=300
PosicionInicialIzquierda=490
PosicionInicialArriba=377
BarraHerramientas=S
AccionesTamanoBoton=15x5

ListaAcciones=Cerrar<BR>Aceptar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaCarpetas=Lista
BarraAcciones=S
AccionesCentro=S
ExpresionesAlMostrar=Asigna( Mavi.DM0344Cajero, nulo )<BR>  Asigna( Mavi.DM0344Sucursal, nulo )
[lsita.Info.FechaD]
Carpeta=lsita
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[lsita.Info.FechaA]
Carpeta=lsita
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[lsita.Mavi.DM00125ReporteFajillaWebCaj]
Carpeta=lsita
Clave=Mavi.DM00125ReporteFajillaWebCaj
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[lsita.Mavi.DM00125ReporteFajillaWebSuc]
Carpeta=lsita
Clave=Mavi.DM00125ReporteFajillaWebSuc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[usuarios.Columnas]
Sucursal=64
usuario=64
cajero=64
nombre=336

Defcajero=64
0=-2
1=-2
[sucursal.Columnas]
Sucursal=64
usuario=143
cajero=64
nombre=604

[lisat.Columnas]
Sucursal=64
nombre=604


0=67
1=-2
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Reporte.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Reporte.Report]
Nombre=Report
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR> Info.FechaD= nulo<BR>Entonces<BR> informacion(<T>Se Requier fecha<T>)<BR> AbortarOperacion<BR>Sino<BR><BR>Si<BR> Info.FechaA= nulo<BR>Entonces<BR> informacion(<T>Se Requier fecha<T>)<BR> AbortarOperacion<BR>Sino<BR><BR> Si<BR> Info.FechaD>Info.FechaA<BR>Entonces<BR> informacion(<T>La Fecha Inicial no puede ser mayor a la final.<T>)<BR> AbortarOperacion<BR>Sino<BR>  verdadero<BR>Fin<BR><BR>Fin<BR><BR>Fin
[Lista.Info.FechaD]
Carpeta=Lista
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Info.FechaA]
Carpeta=Lista
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco









[Lista]
Estilo=Ficha
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0344Cajero<BR>Mavi.DM0344Sucursal
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PestanaOtroNombre=S
PestanaNombre=Reporte de Fajillas en Web
ConFuenteEspecial=S



PermiteEditar=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=35
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Asignar<BR>Reporte
Activo=S
Visible=S


[Acciones.Aceptar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar







ConCondicion=S
EjecucionCondicion=Si<BR>    Info.FechaD = nulo<BR>Entonces<BR>  Informacion(<T>Se requiere fecha<T>)<BR>  AbortarOperacion<BR>Sino<BR>    Si<BR>      Info.FechaA = nulo<BR>    Entonces<BR>      Informacion(<T>Se requiere Fecha<T>)<BR>      AbortarOperacion<BR>    Sino<BR>     Si<BR>      Info.FechaD > Info.FechaA<BR>     Entonces<BR>      Informacion(<T>La fecha inicial no puede ser mayor a la inicial<T>)<BR>      AbortarOperacion<BR>    Sino<BR>      Verdadero<BR>    Fin<BR>  Fin<BR>Fin
[Lista.Mavi.DM0344Cajero]
Carpeta=Lista
Clave=Mavi.DM0344Cajero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



[Lista.Mavi.DM0344Sucursal]
Carpeta=Lista
Clave=Mavi.DM0344Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


