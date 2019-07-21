[Forma]
Clave=DM0175JefesDeGrupoDimaFrm
Nombre=DM0175 Jefes De Grupo Dima
Icono=0
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>NuevoReporte
PosicionInicialIzquierda=473
PosicionInicialArriba=430
PosicionInicialAlturaCliente=124
PosicionInicialAncho=334
ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(MAVI.DM0175AgentesDima,<T><T>)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Preliminar
EspacioPrevio=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0175JefesDeGrupo
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Llamada<BR>Cerrar
RefrescarDespues=S
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaAlineacion=Izquierda
PermiteEditar=S
ListaEnCaptura=MAVI.DM0175AgentesDima<BR>mavi.DM0175Quincena<BR>MAVI.DM0175Ejercicio<BR>MAVI.DM0175TipoReporteCondensado
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Variables.MAVI.DM0175AgentesDima]
Carpeta=Variables
Clave=MAVI.DM0175AgentesDima
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.MAVI.DM0175Ejercicio]
Carpeta=Variables
Clave=MAVI.DM0175Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.mavi.DM0175Quincena]
Carpeta=Variables
Clave=mavi.DM0175Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.MAVI.DM0175TipoReporteCondensado]
Carpeta=Variables
Clave=MAVI.DM0175TipoReporteCondensado
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Expresion=Si<BR>    Mavi.DM0175TipoReporteCondensado = <T>DETALLADO<T><BR>Entonces<BR>    ReportePantalla(<T>DM0175JefesDeGrupoDima<T>)<BR>Fin<BR><BR>                                                  <BR>Si<BR>    Mavi.DM0175TipoReporteCondensado = <T>CONDENSADO<T><BR>Entonces<BR>     ReportePantalla(<T>DM0175JefesDeGrupoDimaConRep<T>)<BR>Fin
[Acciones.NuevoReporte]
Nombre=NuevoReporte
Boton=38
NombreDesplegar=Reporte Gerente
EnBarraHerramientas=S
TipoAccion=Formas
NombreEnBoton=S
EspacioPrevio=S
ClaveAccion=DM0175GerentesDeGrupoDimaFrm
Multiple=S
ListaAccionesMultiples=Reporte Gerente<BR>cerrar
Visible=S
ActivoCondicion=SI<BR>    SQL(<T>SELECT count(U.Usuario) FROM  Usuario U, TablaSTD s WHERE U.Usuario=:tusu AND U.Acceso= S.Nombre AND s.TablaSt =:ttablastd <T>,Usuario,<T>AccesoDm0175GDima<T>) >0<BR> ENTONCES<BR>    VERDADERO<BR> SINO<BR>    FALSO<BR><BR> FIN
[Acciones.NuevoReporte.Reporte Gerente]
Nombre=Reporte Gerente
Boton=0
TipoAccion=Formas
ClaveAccion=DM0175GerentesDeGrupoDimaFrm
Activo=S
Visible=S
[Acciones.NuevoReporte.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


