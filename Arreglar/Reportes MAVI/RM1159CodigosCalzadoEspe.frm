[Forma]
Clave=RM1159CodigosCalzadoEspe
Nombre=Codigo Calzado Especial
Icono=175
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=152
PosicionInicialAncho=543
PosicionInicialIzquierda=368
PosicionInicialArriba=413
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=78
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Preliminar2
ExpresionesAlMostrar=Asigna(Mavi.RM1159Sucursales,<T>0<T>)<BR>Asigna(Mavi.RM1159Nomina,0 )<BR>Asigna(MAVI.RM1159Ejercicio,0 )
[sucursal.Sucursal]
Carpeta=sucursal
Clave=Sucursal
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[sucursal.Columnas]
Sucursal=74
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
ListaEnCaptura=Mavi.RM1159Sucursales<BR>Mavi.RM1159Nomina<BR>Mavi.RM1159Ejercicio
CondicionVisible=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionCondicion=SI SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1<BR>ENTONCES<BR>          SI Info.Ejercicio>0 y Info.NominaMavi>0 y Mavi.DM0175VTASSucursales<><T>0<T><BR>        ENTONCES<BR>            1=1<BR>        SINO<BR>            1=0<BR>            Informacion(<T>Seleccione El Ejercicio, Quincena y Sucursales a Mostrar...<T>)<BR>        FIN<BR>  SINO<BR>    1=0<BR>FIN
Visible=S
[Acciones.Preliminar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1<BR>ENTONCES<BR>    SI Mavi.RM1159Ejercicio>0 y Mavi.RM1159Nomina>0 y ConDatos(Mavi.RM1159Sucursales)<BR>        ENTONCES<BR>            1=1<BR>        SINO<BR>            1=0<BR>            Informacion(<T>Seleccione El Ejercicio, Quincena y Sucursales a Mostrar...<T>)<BR>        FIN<BR><BR>FIN
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Actual
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Salir
Activo=S
Visible=S
NombreEnBoton=S
BtnResaltado=S
[Acciones.Preliminar2.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar2.Salir]
Nombre=Salir
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Preliminar2.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.RM1159Nomina,33)
[Acciones.Preliminar2]
Nombre=Preliminar2
Boton=6
NombreEnBoton=S
NombreDesplegar=Anterior
Multiple=S
EnBarraHerramientas=S
BtnResaltado=S
ListaAccionesMultiples=Asignar<BR>Salir<BR>Expresion
Activo=S
VisibleCondicion=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=0
[(Variables).Mavi.RM1159Sucursales]
Carpeta=(Variables)
Clave=Mavi.RM1159Sucursales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1159Nomina]
Carpeta=(Variables)
Clave=Mavi.RM1159Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM1159Ejercicio]
Carpeta=(Variables)
Clave=Mavi.RM1159Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

