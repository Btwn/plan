[Forma]
Clave=DM0313FiltrosIncremento
Nombre=DM0313 Filtros Incremento  
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=262
PosicionInicialArriba=210
PosicionInicialAlturaCliente=102
PosicionInicialAncho=530
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Preliminar-1<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
MovModulo=(Todos)
ExpresionesAlMostrar=Asigna(Mavi.DM0313Quincena,NULO)<BR>Asigna(Mavi.DM0313UEN,<T><T>)<BR>Asigna(Info.Ejercicio,NULO)<BR>Asigna(Mavi.DM0313Suc,NULO)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.DM0313Suc<BR>Mavi.DM0313UEN<BR>Mavi.DM0313Quincena<BR>Info.Ejercicio
PermiteEditar=S
CondicionVisible=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=1
[Acciones.Preliminar.asignsd]
Nombre=asignsd
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Actual
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asignsd<BR>aceptar
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
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Conteo.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.tequiste.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.tequiste.Texsquiste]
Nombre=Texsquiste
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1142CarteraPubliciadRepTxt
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si (Mavi.RM1142CV = comillas(2)) o (Mavi.RM1142CV = comillas(6)) o (Mavi.RM1142CV = (Comillas(2)+<T>,<T>+comillas(6)))<BR>Entonces Verdadero<BR>Sino<BR>     Si (ConDatos(Mavi.RM1142DV) y ConDatos(Mavi.RM1142MHDV))<BR>     Entonces Verdadero<BR>     Sino<BR>         Error(<T>Los filtros dias vencidos y maximo de dias vencidos son obligatorios<T>)<BR>         AbortarOperacion<BR>     Fin<BR>Fin<BR><BR>Si Mavi.RM1142UltVta>Mavi.RM1142UltCom<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Compras.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142UltVta) O ConDatos(Mavi.RM1142UltCom)<BR>Entonces<BR>Si Vacio(Mavi.RM1142UltVta) O Vacio(Mavi.RM1142UltCom)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenarse en Compras.<T>)<BR>    Abort<CONTINUA>
EjecucionCondicion002=<CONTINUA>arOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si Mavi.RM1142ExpiD>Mavi.RM1142ExpiA<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Expira.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR><BR>Si ConDatos(Mavi.RM1142ExpiA) O ConDatos(Mavi.RM1142ExpiD)<BR>Entonces<BR>Si Vacio(Mavi.RM1142ExpiA) O Vacio(Mavi.RM1142ExpiD)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenarse en Expira.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si Mavi.RM1142LiqIni>Mavi.RM1142LiqFin<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Liquida.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142LiqIni) O ConDatos(Mavi.RM1142LiqFin)<BR>Entonces<BR>Si Vacio(Mavi.RM1142LiqIni) O Vac<CONTINUA>
EjecucionCondicion003=<CONTINUA>io(Mavi.RM1142LiqFin)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenarse en Liquida.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142CV) y ConDatos(Mavi.RM1142CCVInc)<BR>Entonces<BR>    Error(<T>Solo se puede elegir o categoria incluir o canal de venta<BR>                             no ambas.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin
[Acciones.Conteo.asignsd]
Nombre=asignsd
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=Asigna(Mavi.DM0169Dialogo,SQL(<T>EXEC Sp_MaviRM1142Totalizador :nDv, :nMhDv, :tCv, :tSal, :nFecCum, :tMed, :tFam, :tlin, :fultVe, :tSalmon, :fultcomp, :fFechaExpD, :fFechaExpA, :tEst, :tcvin, :tcvex, :fFechai, :fFechafi <T>, Mavi.RM1142DV,Mavi.RM1142MHDV,Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CV),Mavi.RM1142Saldo,Mavi.RM1142Cumple,Mavi.RM1142Medios,Reemplaza(ASCII(39),<T><T>,Mavi.RM1142FamArt),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142lineaArt),FechaFormatoServidor(Mavi.RM1142UltVta),Mavi.RM1142SaldoMon,FechaFormatoServidor(Mavi.RM1142Ultcom),FechaFormatoServidor(Mavi.RM1142ExpiD),FechaFormatoServidor(Mavi.RM1142ExpiA),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142Estados),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CCVInc),Reemplaza(ASCII(39),<T><T>,Mavi.RM1142CCVIgn),Mavi.RM1142LiqIni,Mavi.RM1142LiqFin ))<<CONTINUA>
Expresion002=<CONTINUA>BR>Informacion(<T>los parametros actuales da un total de:<T>+Mavi.DM0169Dialogo))
EjecucionCondicion=Si (Mavi.RM1142CV = comillas(1)) o (Mavi.RM1142CV = comillas(2)) o (Mavi.RM1142CV = comillas(5)) o (Mavi.RM1142CV = comillas(6)) o (Mavi.RM1142CV = (Comillas(2)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(2)+<T>,<T>+comillas(5))) o (Mavi.RM1142CV = (Comillas(5)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(2)+<T>,<T>+comillas(5)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(2))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(5))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(5)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(2)+<T>,<T>+comillas(5)+<T>,<T>+comillas(6))) o (Mavi.RM1142CV = (Comillas(1)+<T>,<T>+comillas(2)+<T>,<T>+comillas(5))) o (Mavi.RM1142CV = (Comillas(1)<CONTINUA>
EjecucionCondicion002=<CONTINUA>+<T>,<T>+comillas(2)+<T>,<T>+comillas(6)))<BR>Entonces Verdadero<BR>Sino<BR>     Si (ConDatos(Mavi.RM1142DV) y ConDatos(Mavi.RM1142MHDV))<BR>     Entonces Verdadero<BR>     Sino<BR>         Error(<T>Los filtros dias vencidos y maximo de dias vencidos son obligatorios<T>)<BR>         AbortarOperacion<BR>     Fin<BR>Fin<BR><BR>Si Mavi.RM1142UltVta>Mavi.RM1142UltCom<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Compras.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142UltVta) O ConDatos(Mavi.RM1142UltCom)<BR>Entonces<BR>Si Vacio(Mavi.RM1142UltVta) O Vacio(Mavi.RM1142UltCom)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenarse en Compras.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si Mavi.RM1142Expi<CONTINUA>
EjecucionCondicion003=<CONTINUA>D>Mavi.RM1142ExpiA<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Expira.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR><BR>Si ConDatos(Mavi.RM1142ExpiA) O ConDatos(Mavi.RM1142ExpiD)<BR>Entonces<BR>Si Vacio(Mavi.RM1142ExpiA) O Vacio(Mavi.RM1142ExpiD)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenarse en Expira.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si Mavi.RM1142LiqIni>Mavi.RM1142LiqFin<BR>Entonces<BR>    Error(<T>Ingrese un rango de fechas correcto en Liquida.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142LiqIni) O ConDatos(Mavi.RM1142LiqFin)<BR>Entonces<BR>Si Vacio(Mavi.RM1142LiqIni) O Vacio(Mavi.RM1142LiqFin)<BR>Entonces<BR>    Error(<T>Ambas fechas deben llenars<CONTINUA>
EjecucionCondicion004=<CONTINUA>e en Liquida.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin<BR>Fin<BR><BR>Si ConDatos(Mavi.RM1142CV) y ConDatos(Mavi.RM1142CCVInc)<BR>Entonces<BR>    Error(<T>Solo se puede elegir o categoria incluir o canal de venta<BR>                             no ambas.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin
[(Variables).Mavi.DM0313UEN]
Carpeta=(Variables)
Clave=Mavi.DM0313UEN
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar-1]
Nombre=Preliminar-1
Boton=6
NombreEnBoton=S
NombreDesplegar=Anterior
Multiple=S
EnBarraHerramientas=S
Visible=S
ListaAccionesMultiples=Asignar<BR>expresion
ActivoCondicion=SQL(<T>SELECT COUNT(U.Acceso) FROM dbo.TablaStD T<BR>INNER JOIN dbo.Usuario U ON U.Acceso=T.Nombre<BR>WHERE T.TablaSt=:tNom AND U.Usuario=:tUser<T>,<T>ACCESOVTASXAGENTEXSUCURSAL<T>,Usuario)=0
[Acciones.Preliminar-1.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[(Variables).Mavi.DM0313Quincena]
Carpeta=(Variables)
Clave=Mavi.DM0313Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar-1.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0313Quincena,-1)
[(Variables).Mavi.DM0313Suc]
Carpeta=(Variables)
Clave=Mavi.DM0313Suc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.aceptar]
Nombre=aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Si ConDatos(Mavi.DM0313UEN) y ConDatos(Mavi.DM0313Suc)<BR>Entonces<BR>    Error(<T>Solo se puede elegir o UEN o Sucursales<BR>                     no ambas.<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin

