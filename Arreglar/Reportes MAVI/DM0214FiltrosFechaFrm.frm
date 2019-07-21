
[Forma]
Clave=DM0214FiltrosFechaFrm
Icono=0
Modulos=(Todos)
Nombre=Catálogo de Zonas

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=97
PosicionInicialAncho=325
PosicionInicialIzquierda=479
PosicionInicialArriba=446
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
AccionesCentro=S
AccionesDivision=S
VentanaBloquearAjuste=S
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
ListaEnCaptura=(Lista)

CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata




[(Variables).Mavi.DM0214Ejercicio]
Carpeta=(Variables)
Clave=Mavi.DM0214Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Mavi.DM0214Periodo]
Carpeta=(Variables)
Clave=Mavi.DM0214Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=(Lista)
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




































[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Dialogo,SQL(<T>select  dbo.FN_DM0214ValidarEjecucionZonas(:nPeriodo,:nEjercicio)<T>,Mavi.DM0214Periodo,Mavi.DM0214Ejercicio))<BR><BR><BR>Si Info.Dialogo=0<BR>    Entonces<BR>        SI (Confirmacion( <T>Se actualizaran las Zonas de la Quincena  y Periodo Actual  . Estas Seguro?<T> ,    BotonSi   , BotonNo   )=6)<BR>                          Entonces<BR>                               EjecutarSQLAnimado(<T>EXEC SP_MAVIDM0214agrupaZonasHist :nPeriodo,:nEjercicio<T>,Mavi.DM0214Periodo,Mavi.DM0214Ejercicio)<BR>                               informacion(<T>Historico actualizado correctamente<T>)<BR>                          sino<BR>                              AbortarOperacion<BR>                          fin<BR>    Sino Si Info.Dialogo=1<BR>            Entonces<BR>                SI (Confirmacion( <T>Se actualizaran las Zonas de la quincena <T>+comillas(Mavi.DM0214Periodo)+<T> y Periodo <T>+comillas(Mavi.DM0214Ejercicio)+<T> . Estas Seguro?<T> ,    BotonSi   , BotonNo   )=6)<BR>                          Entonces<BR>                               EjecutarSQLAnimado(<T>EXEC SP_MAVIDM0214agrupaZonasHist :nPeriodo,:nEjercicio<T>,Mavi.DM0214Periodo,Mavi.DM0214Ejercicio)<BR>                               informacion(<T>Historico actualizado correctamente<T>)<BR>                          sino<BR>                              AbortarOperacion<BR>                          fin<BR>            Sino Si Info.Dialogo=2<BR>                    Entonces<BR>                        SI (Confirmacion( <T>Se actualizaran las Zonas de la quincena <T>+comillas(Mavi.DM0214Periodo)+<T> y Periodo <T>+comillas(Mavi.DM0214Ejercicio)+<T> . Estas Seguro?<T> ,    BotonSi   , BotonNo   )=6)<BR>                          Entonces<BR>                              EjecutarSQLAnimado(<T>EXEC SP_MAVIDM0214agrupaZonasHist :nPeriodo,:nEjercicio<T>,Mavi.DM0214Periodo,Mavi.DM0214Ejercicio)<BR>                              informacion(<T>Historico actualizado correctamente<T>)<BR>                          sino<BR>                              AbortarOperacion<BR>                          fin<BR>                    Sino Si Info.Dialogo=3<BR>                            Entonces<BR>                                informacion(<T>Parametros no permitidos, intente de nuevo<T>)<BR>                            Fin<BR>                    Fin<BR>            Fin<BR>    Fin<BR>Fin
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[(Variables).ListaEnCaptura]
(Inicio)=Mavi.DM0214Periodo
Mavi.DM0214Periodo=Mavi.DM0214Ejercicio
Mavi.DM0214Ejercicio=(Fin)








[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=Expresion
Expresion=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cancelar
Cancelar=(Fin)


