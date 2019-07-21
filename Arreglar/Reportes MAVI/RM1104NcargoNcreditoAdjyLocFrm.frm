[Forma]
Clave=RM1104NcargoNcreditoAdjyLocFrm
Nombre=RM1104 Cargos con Notas de Crédito Espejo
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Var Tipo Rep<BR>Var Rep 1
CarpetaPrincipal=Var Tipo Rep
PosicionInicialIzquierda=425
PosicionInicialArriba=296
PosicionInicialAlturaCliente=144
PosicionInicialAncho=515
ListaAcciones=Prelimi<BR>Excel<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionSec1=42



PosicionSec2=131
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna( Mavi.RM1104TipoReporte,<T>Abonos a Cargos por Adj/Loc Generados Manualmente<T> )<BR>Asigna( Info.Ejercicio, Año(hoy) )<BR>Asigna( Info.MesSTMAVI, MesNombre(hoy) )  Info.Ejercicio           <BR><BR>Asigna(Info.FechaD , hoy )<BR>Asigna(Info.FechaA , hoy )
[Acciones.Prelimi]
Nombre=Prelimi
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Seleccionar<BR>Expresion Rep
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=RM1104NcargoNcreditoAdjyLocRepXls
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Seleccionar<BR>Expresion Rep



[Acciones.Prelimi.Expresion Rep]
Nombre=Expresion Rep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Caso Mavi.RM1104TipoReporte<BR>  Es <T>Abonos a Cargos por Adj/Loc Generados Manualmente<T><BR>  Entonces  ReportePantalla(<T>RM1104NcargoNcreditoAdjyLocRep<T>)<BR>  Es <T>Notas a Crédito Espejo y Posteriores Generados Automáticamente<T><BR>  Entonces   ReportePantalla(<T>RM1104CxcNotasCreditoEspejoYPosterioresRep<T>)<BR>  Es <T>Bitácora de Errores<T><BR>  Entonces  ReportePantalla(<T>RM1104CxcBitacoraErroresRep<T>)<BR>Fin
[Acciones.Prelimi.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S

ClaveAccion=Variables Asignar
[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Excel.Expresion Rep]
Nombre=Expresion Rep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S





Expresion=Caso Mavi.RM1104TipoReporte<BR>  Es <T>Abonos a Cargos por Adj/Loc Generados Manualmente<T><BR>  Entonces   ReporteExcel(<T>RM1104NcargoNcreditoAdjyLocRepXls<T>)<BR>  Es <T>Notas a Crédito Espejo y Posteriores Generados Automáticamente<T><BR>  Entonces   ReporteExcel(<T>RM1104CxcNotasCreditoEspejoYPosterioresRepXls<T>)<BR>  Es <T>Bitácora de Errores<T><BR>  Entonces ReporteExcel(<T>RM1104CxcBitacoraErroresRepXls<T>)<BR>Fin
[Acciones.Prelimi.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
ConCondicion=S
Visible=S

EjecucionCondicion=Caso  Mavi.RM1104TipoReporte<BR><BR> Es <T>Abonos a Cargos por Adj/Loc Generados Manualmente<T><BR> Entonces<BR>        SI  ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        ENTONCES<BR>                    Si Info.FechaD> Info.FechaA<BR>                    Entonces<BR>                          Error(<T>El filtro De la Fecha debe ser igual o menor que A la Fecha<T>)<BR>                          AbortarOperacion<BR>                   Sino                                     <BR>                          VERDADERO<BR>                   Fin<BR>        SINO<BR>             Error(<T>Por favor selecciona filtros De la Fecha Inicio y A la Fecha para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR><BR>Es   <T>Notas a Crédito Espejo y Posteriores Generados Automáticamente<T><BR> Entonces<BR>SI  ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        ENTONCES<BR>                    Si Info.FechaD> Info.FechaA<BR>                    Entonces<BR>                          Error(<T>El filtro De la Fecha debe ser igual o menor que A la Fecha<T>)<BR>                          AbortarOperacion<BR>                   Sino<BR>                          VERDADERO<BR>                   Fin<BR>        SINO<BR>             Error(<T>Por favor selecciona filtros De la Fecha Inicio y A la Fecha para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR><BR>Fin
[Acciones.Excel.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
ConCondicion=S
Visible=S



EjecucionCondicion=Caso  Mavi.RM1104TipoReporte<BR><BR> Es <T>Abonos a Cargos por Adj/Loc Generados Manualmente<T><BR> Entonces<BR>        SI  ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        ENTONCES<BR>            VERDADERO<BR>        SINO<BR>             Error(<T>Por favor selecciona filtros De la Fecha Inicio y A la Fecha para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR>Es   <T>Notas a Crédito Espejo y Posteriores Generados Automáticamente<T><BR> Entonces<BR>        SI  ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        ENTONCES<BR>            VERDADERO<BR>        SINO<BR>             Error(<T>Por favor selecciona filtros De la Fecha Inicio y A la Fecha para continuar<T>)<BR>             AbortarOperacion<BR>        FIN<BR> Es <T>Bitácora de Errores<T><BR> Entonces<BR>       SI  ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>       ENTONCES<BR>            VERDADERO<BR>       SINO<BR>            Error(<T>Por favor selecciona filtros De la Fecha Inicio y A la Fecha para continuar<T>)<BR>         AbortarOperacion<BR>       FIN<BR>Fin
[Variables 1.Info.FechaD]
Carpeta=Variables 1
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables 1.Info.FechaA]
Carpeta=Variables 1
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco




[Var Tipo Rep]
Estilo=Ficha
Clave=Var Tipo Rep
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
ListaEnCaptura=Mavi.RM1104TipoReporte
CarpetaVisible=S

[Var Tipo Rep.Mavi.RM1104TipoReporte]
Carpeta=Var Tipo Rep
Clave=Mavi.RM1104TipoReporte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco





[Var Rep 1]
Estilo=Ficha
Clave=Var Rep 1
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 8, Gris, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

PermiteEditar=S
FichaEspacioNombresAuto=S
[Var Rep 1.Info.FechaD]
Carpeta=Var Rep 1
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Var Rep 1.Info.FechaA]
Carpeta=Var Rep 1
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Var Rep 2.Info.Ejercicio]
Carpeta=Var Rep 2
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Var Rep 2.Info.MesSTMAVI]
Carpeta=Var Rep 2
Clave=Info.MesSTMAVI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


