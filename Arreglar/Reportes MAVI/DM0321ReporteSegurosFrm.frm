
[Forma]
Clave=DM0321ReporteSegurosFrm
Icono=621
Modulos=(Todos)
Nombre=DM0321 Reporte - Seguros de Vida

ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialAlturaCliente=109
PosicionInicialAncho=902
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=232
PosicionInicialArriba=313
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Txt<BR>Parametros<BR>Compras<BR>Histórico
ExpresionesAlMostrar=Asigna(Mavi.DM0321TipoReporte,NULO)<BR>Asigna(Mavi.DM0321Clase,NULO)<BR>Asigna(Mavi.DM0321Ano,NULO)<BR>Asigna(Mavi.DM0321Semana,NULO)<BR>Asigna(Mavi.DM0321Mes,NULO)<BR>Asigna(Mavi.DM0321Periodo,NULO)
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
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.DM0321TipoMovimiento<BR>Mavi.DM0321TipoReporte<BR>Mavi.DM0321Clase<BR>Mavi.DM0321Ano<BR>Mavi.DM0321Semana<BR>Mavi.DM0321Mes<BR>Mavi.DM0321Periodo

[Variables.Mavi.DM0321TipoMovimiento]
Carpeta=Variables
Clave=Mavi.DM0321TipoMovimiento
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Mavi.DM0321TipoReporte]
Carpeta=Variables
Clave=Mavi.DM0321TipoReporte
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco

[Variables.Mavi.DM0321Clase]
Carpeta=Variables
Clave=Mavi.DM0321Clase
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco


[Variables.Mavi.DM0321Semana]
Carpeta=Variables
Clave=Mavi.DM0321Semana
Editar=S
ValidaNombre=S
3D=S
Tamano=24
ColorFondo=Blanco

[Variables.Mavi.DM0321Mes]
Carpeta=Variables
Clave=Mavi.DM0321Mes
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Variables.Mavi.DM0321Periodo]
Carpeta=Variables
Clave=Mavi.DM0321Periodo
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco


[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Generar TXT
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Reportes

[Vista clases.Columnas]
Clase=127

[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Variables.Mavi.DM0321Ano]
Carpeta=Variables
Clave=Mavi.DM0321Ano
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco


[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S



[Acciones.Excel.Reportes]
Nombre=Reportes
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S

Expresion=Si(Mavi.DM0321TipoReporte = <T>Venta de Seguros<T>,OtraForma(<T>DM0321ReporteSegurosFrm<T>,Forma.Accion(<T>Reporte1<T>)))
EjecucionCondicion=Si(ConDatos(Mavi.DM0321TipoReporte),Verdadero,Error(<T>El filtro <T>+Comillas(<T>Tipo de Reporte<T>)+<T> es obligatorio<T>) AbortarOperacion)<BR>Si(((Mavi.DM0321TipoReporte=<T>Venta de Seguros<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Aseguradora)<T>)) y (Vacio(Mavi.DM0321Clase)),Error(<T>El filtro <T>+Comillas(<T>Clase<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(Condatos(Mavi.DM0321Clase),Si(SQL(<T>SELECT COUNT(Clase) FROM TcIDM0321_TipoSegurosVida WHERE Clase = :tClase<T>,Mavi.DM0321Clase)>0,Verdadero,Error(<T>Valor incorrecto en el filtro <T>+Comillas(<T>Clase<T>)) AbortarOperacion))<BR>Si(((Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Asistencia)<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Aseguradora)<T>)) y (Vacio(Mavi.DM0321Ano)),Error(<T>El filtro <T>+Comillas(<T>Año<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(((Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Asistencia)<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Aseguradora)<T>)) y (Vacio(Mavi.DM0321Mes)),Error(<T>El filtro <T>+Comillas(<T>Mes<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si((Mavi.DM0321Mes=<T>Completo<T>) y Vacio(Mavi.DM0321Periodo),Error(<T>El filtro <T>+Comillas(<T>Periodo<T>)+<T> es obligatorio si el mes a consultar es completo<T>) AbortarOperacion)<BR>Si((Mavi.DM0321TipoReporte=<T>Venta de Seguros<T>) y (Vacio(Mavi.DM0321Semana)),Error(<T>El filtro <T>+comillas(<T>Semana<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(ConDatos(Mavi.DM0321Semana),Si(DiaNombre(Mavi.DM0321Semana)<><T>Lunes<T>,Error(<T>El tipo de reporte <T>+Comillas(<T>Venta de Seguros<T>)+<T> solo se puede consultar en día Lunes<T>)))

[Acciones.Txt.Reportes]
Nombre=Reportes
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S


Expresion=Si(Mavi.DM0321TipoReporte = <T>Venta de Seguros (Asistencia)<T>,ReporteImpresora(<T>DM0321ReporteVentaSegurosRepTxt<T>))<BR>Si(Mavi.DM0321TipoReporte = <T>Cobro de Seguros (Asistencia)<T>,ReporteImpresora(<T>DM0321ReporteCobrosAsistenciaTxt<T>))<BR>Si(Mavi.DM0321TipoReporte = <T>Cobro de Seguros (Aseguradora)<T>,ReporteImpresora(<T>DM0321ReporteCobrosAseguradoraTxt<T>))
EjecucionCondicion=Si(ConDatos(Mavi.DM0321TipoReporte),Verdadero,Error(<T>El filtro <T>+Comillas(<T>Tipo de Reporte<T>)+<T> es obligatorio<T>) AbortarOperacion)<BR>Si(((Mavi.DM0321TipoReporte=<T>Venta de Seguros (Asistencia)<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Asistencia)<T>)) y (Vacio(Mavi.DM0321Clase)),Error(<T>El filtro <T>+Comillas(<T>Clase<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(Condatos(Mavi.DM0321Clase),Si(SQL(<T>SELECT COUNT(Clase) FROM TcIDM0321_TipoSegurosVida WHERE Clase = :tClase<T>,Mavi.DM0321Clase)>0,Verdadero,Error(<T>Valor incorrecto en el filtro <T>+Comillas(<T>Clase<T>)) AbortarOperacion))<BR>Si(((Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Asistencia)<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Aseguradora)<T>)) y (Vacio(Mavi.DM0321Ano)),Error(<T>El filtro <T>+Comillas(<T>Año<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(((Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Asistencia)<T>) o (Mavi.DM0321TipoReporte=<T>Cobro de Seguros (Aseguradora)<T>)) y (Vacio(Mavi.DM0321Mes)),Error(<T>El filtro <T>+Comillas(<T>Mes<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si((Mavi.DM0321Mes=<T>Completo<T>) y Vacio(Mavi.DM0321Periodo),Error(<T>El filtro <T>+Comillas(<T>Periodo<T>)+<T> es obligatorio si el mes a consultar es completo<T>) AbortarOperacion)<BR>Si((Mavi.DM0321TipoReporte=<T>Venta de Seguros (Asistencia)<T>) y (Vacio(Mavi.DM0321Semana)),Error(<T>El filtro <T>+comillas(<T>Lunes (Inicio Semana Reporte)<T>)+<T> es obligatorio para el tipo de reporte seleccionado<T>) AbortarOperacion)<BR>Si(ConDatos(Mavi.DM0321Semana),Si(DiaNombre(Mavi.DM0321Semana)<><T>Lunes<T>,Error(<T>El tipo de reporte <T>+comillas(<T>Venta de Seguros (Asistencia)<T>)+<T> solo permite seleccionar un día que sea lunes en el filtro <T>+comillas(<T>Lunes (Inicio Semana Reporte)<T>))))

[Acciones.Parametros]
Nombre=Parametros
Boton=35
NombreEnBoton=S
NombreDesplegar=&Parametros
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0321CatalogoConfigSegurosFrm
Activo=S
Visible=S

[Acciones.Compras]
Nombre=Compras
Boton=57
NombreEnBoton=S
NombreDesplegar=&Reporte Emisiones
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=DM0321ReporteSegComprasFrm

[Acciones.Histórico]
Nombre=Histórico
Boton=57
NombreEnBoton=S
NombreDesplegar=&Histórico
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Formas
ClaveAccion=DM0321ReporteHistSegvidaFrm


