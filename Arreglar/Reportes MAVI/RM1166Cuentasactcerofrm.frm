[Forma]
Clave=RM1166Cuentasactcerofrm
Nombre=RM1166 Cuentas Activas Saldo cero
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)<BR>sucursal
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=244
PosicionInicialArriba=333
PosicionInicialAlturaCliente=157
PosicionInicialAncho=523
ListaAcciones=Preli<BR>cerrar
PosicionCol1=323
PosicionSec1=91
PosicionCol2=288
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(MAVI.RM1166Sucursal,nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Info.Ejercicio<BR>Info.Periodo<BR>Mavi.RM1166DVD<BR>Mavi.RM1166DVH<BR>MAVI.RM1166CV
CarpetaVisible=S
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.RM1166DVD]
Carpeta=(Variables)
Clave=Mavi.RM1166DVD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.RM1166DVH]
Carpeta=(Variables)
Clave=Mavi.RM1166DVH
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).MAVI.RM1166CV]
Carpeta=(Variables)
Clave=MAVI.RM1166CV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preli.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preli.cerr]
Nombre=cerr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI (Info.Ejercicio > 0 y Info.Periodo > 0 )<BR>    entonces<BR>     Verdadero<BR> sino<BR> Error(<T>El ejercicio y periodo deden ser mayores a cero<T>)<BR>fin<BR><BR><BR>SI<BR> (Mavi.RM1166DVH > 0)<BR>  Entonces<BR>    Verdadero<BR> sino<BR>    Error(<T>Los dias vencidos a deben ser mayores a cero<T>)<BR>Fin
[Acciones.Preli]
Nombre=Preli
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asig<BR>cerr
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar

[Canales.Columnas]
0=-2


[filtroSucursal.Sucursal]
Carpeta=filtroSucursal
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[sucursalCombo.sucursal]
Carpeta=sucursalCombo
Clave=sucursal
Editar=S
EditarConBloqueo=N
ValidaNombre=S
3D=S
Pegado=S
ColorFondo=Blanco


[Lista.Columnas]
0=91
1=267





[sucursal.Sucursal]
Carpeta=sucursal
Clave=sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=8



[sucursalLista.MAVI.RM1166ComboSucursal]
Carpeta=sucursalLista
Clave=MAVI.RM1166ComboSucursal
Editar=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Pegado=S
Tamano=20
ColorFondo=Blanco


[SUC.MAVI.RM1166Sucursal]
Carpeta=SUC
Clave=MAVI.RM1166Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[sucursalMultiple.MAVI.RM1166Sucursal]
Carpeta=sucursalMultiple
Clave=MAVI.RM1166Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[sucursal]
Estilo=Ficha
Clave=sucursal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
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
ListaEnCaptura=MAVI.RM1166Sucursal

PermiteEditar=S
CondicionVisible=si (SQL(<T>SELECT td.valor<BR>FROM<BR>usuario u WITH (NOLOCK)<BR>JOIN tablastd td WITH (NOLOCK)<BR>ON U.Acceso = td.Nombre<BR>WHERE td.TablaSt = <T>+Comillas(<T>ACCESOVTASXAGENTEXSUCURSAL<T>)+<T>AND u.Usuario = :tUsr<T>,usuario))=1<BR>entonces<BR>verdadero<BR>sino<BR>falso
[sucursal.MAVI.RM1166Sucursal]
Carpeta=sucursal
Clave=MAVI.RM1166Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

EspacioPrevio=N
[Sucursalvista.Columnas]
Sucursal=64
0=96
1=93

