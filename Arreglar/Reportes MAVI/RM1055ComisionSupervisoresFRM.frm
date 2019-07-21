[Forma]
Clave=RM1055ComisionSupervisoresFRM
Nombre=RM1055 Comision de Supervisores
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=547
PosicionInicialArriba=252
PosicionInicialAlturaCliente=152
PosicionInicialAncho=245
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.RM1055Tipo,Nulo)
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1055Tipo<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asig]
Nombre=Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asig<BR>Cerrar
Activo=S
Visible=S
[(Variables).Mavi.RM1055Tipo]
Carpeta=(Variables)
Clave=Mavi.RM1055Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=31
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=SI CONDATOS(Info.FechaD) y CONDATOS(Info.FechaA) y CONDATOS(Mavi.RM1055Tipo)<BR>ENTONCES<BR>   SI Mavi.RM1055Tipo = <T>NOMINA QUINCENAL<T><BR>     ENTONCES<BR>        SI ((año(Info.FechaA)*365)+ (mes(Info.FechaA)*30)+dia(Info.FechaA))-((año(Info.FechaD)*365)+ (mes(Info.FechaD)*30)+dia(Info.FechaD))>=0<BR>          ENTONCES<BR>              SI ((año(Info.FechaA)*365)+ (mes(Info.FechaA)*30)+dia(Info.FechaA))-((año(Info.FechaD)*365)+ (mes(Info.FechaD)*30)+dia(Info.FechaD))<32<BR>               Entonces<BR>               1=1<BR>                 Sino<BR>                     ERROR(<T>El rango de fechas no debe ser mayor a 31 dias<T>)<BR>                 Fin<BR>         SINO<BR>           ERROR(<T>El rango de fechas es erroneo<T>)<BR>        FIN<BR>   SINO<BR>      SI SQL(<T>SELECT CASE WHEN MONT<CONTINUA>
EjecucionCondicion002=<CONTINUA>H(<T>+comillas(FechaFormatoServidor(Info.FechaD))+<T>)=MONTH(<T>+comillas(FechaFormatoServidor(Info.FechaA))+<T>) AND (DAY(<T>+comillas(FechaFormatoServidor(Info.FechaD))+<T>)=1 AND DAY(<T>+comillas(FechaFormatoServidor(Info.FechaA))+<T>)>=28 ) THEN 1 ELSE 0 END<T>) = 0<BR>         ENTONCES<BR>             ERROR(<T>Seleccione todo un Mes(1-30.1-31,1-28)<T>)<BR>      FIN<BR>   FIN<BR>SINO<BR>    ERROR(<T>Capture todos los Campos<T>)<BR>FIN

