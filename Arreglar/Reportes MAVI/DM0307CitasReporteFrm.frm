[Forma]
Clave=DM0307CitasReporteFrm
Icono=18
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=581
PosicionInicialArriba=275
PosicionInicialAlturaCliente=232
PosicionInicialAncho=187
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Reporte<BR>Limpiar
Nombre=<T>Reporte<T>
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEstadoInicial=Normal
VentanaExclusivaOpcion=0
ExpresionesAlActivar=Forma.Accion(<T>Limpiar<T>)
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
ListaEnCaptura=Mavi.DM0307FechaD<BR>Mavi.DM0307FechaA<BR>Mavi.DM0307Proveedor<BR>Mavi.DM0307Auxiliar<BR>Mavi.DM0307TipoReporte
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.DM0307FechaD]
Carpeta=(Variables)
Clave=Mavi.DM0307FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0307FechaA]
Carpeta=(Variables)
Clave=Mavi.DM0307FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0307Proveedor]
Carpeta=(Variables)
Clave=Mavi.DM0307Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.DM0307Auxiliar]
Carpeta=(Variables)
Clave=Mavi.DM0307Auxiliar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Reporte]
Nombre=Reporte
Boton=6
NombreEnBoton=S
NombreDesplegar=&Reporte
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=dm0307CitasReporteRep
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Validar
[Acciones.Reporte.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[(Variables).Mavi.DM0307TipoReporte]
Carpeta=(Variables)
Clave=Mavi.DM0307TipoReporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Reporte.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Si<BR>  ConDatos(Mavi.DM0307TipoReporte)<BR>Entonces<BR>  Si<BR>    Info.Numero = 1  //REPORTES DE PANTALLA    <BR>  Entonces<BR>    Si<BR>      (Mavi.DM0307TipoReporte = <T>Concentrado<T>)<BR>    Entonces<BR>      ReportePantalla(<T>DM0307CitasReporteRep<T>)<BR>    Sino<BR>      ReportePantalla(<T>DM0307CitasReporteDesglosadoRep<T>)<BR>    Fin<BR><BR>  Sino //Ejecucion de codigo cuando Info.Numero = 2 REPORTES EXCEL<BR>    Si<BR>      (Mavi.DM0307TipoReporte = <T>Concentrado<T>)<BR>    Entonces<BR>      ReporteExcel(<T>DM0307CitasReporteRepXls<T>)<BR>    Sino<BR>      ReporteExcel(<T>DM0307CitasReporteDesglosadoRepXls<T>)<BR>    Fin<BR>  Fin<BR><BR>Sino<BR>  Informacion(<T>¡DEBE ESPECIFICAR EL TIPO DE REPORTE!<T>)<BR>Fin


[Acciones.Limpiar]
Nombre=Limpiar
Boton=0
NombreDesplegar=Limpiar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Expresion=Asigna(Mavi.DM0307Auxiliar,<T><T>)<BR>Asigna(Mavi.DM0307Proveedor,<T><T>)


