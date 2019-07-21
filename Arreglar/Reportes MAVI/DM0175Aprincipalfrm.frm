[Forma]
Clave=DM0175Aprincipalfrm
Nombre=DM0175 A ventas Auxiliares
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=209
PosicionInicialArriba=186
PosicionInicialAlturaCliente=84
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Prel1<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Ejercicio,0)<BR>Asigna(Info.NominaMavi,0)<BR>Asigna(Mavi.DM0175Asuc,<T>0<T>)
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
ListaEnCaptura=Mavi.DM0175Asuc<BR>Info.NominaMavi<BR>Info.Ejercicio
CondicionVisible=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1
[(Variables).Mavi.DM0175Asuc]
Carpeta=(Variables)
Clave=Mavi.DM0175Asuc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.NominaMavi]
Carpeta=(Variables)
Clave=Info.NominaMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.venta]
Nombre=venta
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1<BR>ENTONCES<BR>    SI Info.Ejercicio>0 y Info.NominaMavi>0 y ConDatos(Mavi.DM0175Asuc)<BR>        ENTONCES<BR>            1=1<BR>        SINO<BR>            1=0<BR>            Informacion(<T>Seleccione El Ejercicio, Quincena y Sucursales a Mostrar...<T>)<BR>        FIN<BR><BR>FIN
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asign<BR>venta
Activo=S
Visible=S
[Acciones.Prel1]
Nombre=Prel1
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar -1
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
ListaAccionesMultiples=asign<BR>cerrar<BR>exp
VisibleCondicion=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=0
[Acciones.Prel1.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Prel1.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.NominaMavi,-1)
[Acciones.Prel1.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

