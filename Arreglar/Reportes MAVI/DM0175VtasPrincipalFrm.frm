[Forma]
Clave=DM0175VtasPrincipalFrm
Nombre=DM0175 Ventas por Agente
Icono=0
Modulos=(Todos)
MovModulo=VTAS
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=107
PosicionInicialAncho=334
PosicionInicialIzquierda=447
PosicionInicialArriba=434
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Preliminar-1<BR>Cerrar
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Info.Ejercicio,0)<BR>Asigna(Info.NominaMavi,0)<BR>Asigna(Mavi.DM0175VTASSucursales,<T>0<T>)<BR>Asigna(Mavi.DM0175TipoReporte,<T>Tienda<T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0175VTASSucursales<BR>Mavi.DM0175TipoReporte<BR>Info.Ejercicio<BR>Info.NominaMavi
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CondicionVisible= SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0175VTASSucursales]
Carpeta=(Variables)
Clave=Mavi.DM0175VTASSucursales
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
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar<BR>Cerrar
NombreEnBoton=S
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=SI Mavi.DM0175TipoReporte = <T>Tienda<T><BR>ENTONCES<BR>    ReportePantalla(<T>DM0175VTASVentasXAgenteRep<T>)<BR>SINO<BR>    SI Mavi.DM0175TipoReporte=<T>Supervisor<T><BR>    ENTONCES<BR>        ReportePantalla(<T>DM0175VTASVentasXSupervisorRep<T>)<BR>    SINO<BR>        1=0<BR>    FIN<BR>FIN
EjecucionCondicion=SI SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1<BR>ENTONCES<BR>    SI Mavi.DM0175TipoReporte = <T>Tienda<T><BR>    ENTONCES<BR>        SI Info.Ejercicio>0 y Info.NominaMavi>0 y Mavi.DM0175VTASSucursales<><T>0<T><BR>        ENTONCES<BR>            1=1<BR>        SINO<BR>            1=0<BR>            Informacion(<T>Seleccione El Ejercicio, Quincena y Sucursales a Mostrar...<T>)<BR>        FIN<BR>    SINO<BR>        SI Mavi.DM0175TipoReporte = <T>Supervisor<T><BR>        ENTONCES<BR>            SI Info.Ejercicio>0 y Info.NominaMavi>0<BR>            ENTONCES<BR>                1=1<BR>            SINO<BR>                1=0<BR>                Inform<CONTINUA>
EjecucionCondicion002=<CONTINUA>acion(<T>Seleccione El Ejercicio y Quincena a Mostrar...<T>)<BR>            FIN<BR>        SINO<BR>            1=0<BR>        FIN<BR>    FIN<BR>SINO<BR>    1=1<BR>FIN
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.DM0175TipoReporte]
Carpeta=(Variables)
Clave=Mavi.DM0175TipoReporte
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar-1]
EspacioPrevio=S
Nombre=Preliminar-1
Boton=6
NombreDesplegar=Periodo &Anterior
Multiple=S
EnBarraHerramientas=S
Activo=S
NombreEnBoton=S
ListaAccionesMultiples=Variables Asignar<BR>Aceptar<BR>Cerrar
VisibleCondicion=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=0
[Acciones.Preliminar-1.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar-1.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.NominaMavi,-1)<BR><BR>SI Mavi.DM0175TipoReporte = <T>Tienda<T><BR>ENTONCES<BR>    ReportePantalla(<T>DM0175VTASVentasXAgenteRep<T>)<BR>SINO<BR>    SI Mavi.DM0175TipoReporte=<T>Supervisor<T><BR>    ENTONCES<BR>        ReportePantalla(<T>DM0175VTASVentasXSupervisorRep<T>)<BR>    SINO<BR>        1=0<BR>    FIN<BR>FIN
EjecucionCondicion=SI SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1<BR>ENTONCES<BR>    SI Mavi.DM0175TipoReporte = <T>Tienda<T><BR>    ENTONCES<BR>        SI Info.Ejercicio>0 y Info.NominaMavi>0 y Mavi.DM0175VTASSucursales<><T>0<T><BR>        ENTONCES<BR>            1=1<BR>        SINO<BR>            1=0<BR>            Informacion(<T>Seleccione El Ejercicio, Quincena y Sucursales a Mostrar...<T>)<BR>        FIN<BR>    SINO<BR>        SI Mavi.DM0175TipoReporte = <T>Supervisor<T><BR>        ENTONCES<BR>            SI Info.Ejercicio>0 y Info.NominaMavi>0<BR>            ENTONCES<BR>                1=1<BR>            SINO<BR>                1=0<BR>                Inform<CONTINUA>
EjecucionCondicion002=<CONTINUA>acion(<T>Seleccione El Ejercicio y Quincena a Mostrar...<T>)<BR>            FIN<BR>        SINO<BR>            1=0<BR>        FIN<BR>    FIN<BR>SINO<BR>    1=1<BR>FIN
[Acciones.Preliminar-1.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


