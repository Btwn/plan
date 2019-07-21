
[Forma]
Clave=RM1171AsignaDIMAFrm
Icono=51
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=162
PosicionInicialAncho=317
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=524
PosicionInicialArriba=284
Nombre=Reporte de Movimientos DIMA
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>TXT<BR>Salir
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(info.FechaA,NULO)<BR>Asigna(info.FechaD,NULO)<BR>Asigna(Mavi.RM1171Vencimiento ,NULO)<BR>Asigna(Mavi.RM1171soloDimas ,NULO)<BR>Asigna(Mavi.RM1171TipoCteFinal ,NULO)<BR>Asigna(Mavi.RM1171TipoReporte ,NULO)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1171TipoReporte<BR>Mavi.RM1171Vencimiento<BR>Mavi.RM1171soloDimas<BR>Mavi.RM1171TipoCteFinal
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Salir]
Nombre=Salir
Boton=36
NombreEnBoton=S
NombreDesplegar=&Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=115
NombreDesplegar=&Excel
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Reportes
NombreEnBoton=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S






[(Variables).Mavi.RM1171Vencimiento]
Carpeta=(Variables)
Clave=Mavi.RM1171Vencimiento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco







[Acciones.TXT.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.TXT.RepTxt]
Nombre=RepTxt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1171AsignaDIMARepTxt
Activo=S
Visible=S

[Acciones.TXT]
Nombre=TXT
Boton=65
NombreEnBoton=S
NombreDesplegar=&TXT
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Reportes
[Acciones.TXT.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[(Variables).Mavi.RM1171TipoReporte]
Carpeta=(Variables)
Clave=Mavi.RM1171TipoReporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

EspacioPrevio=N

[(Variables).Mavi.RM1171TipoCteFinal]
Carpeta=(Variables)
Clave=Mavi.RM1171TipoCteFinal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Columnas]
0=241

[(Variables).Mavi.RM1171soloDimas]
Carpeta=(Variables)
Clave=Mavi.RM1171soloDimas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar.Reportes]
Nombre=Reportes
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S

Expresion=Caso Mavi.RM1171TipoReporte<BR>  Es <T>Detallado<T> Entonces ReporteExcel(<T>RM1171AsignaDIMARepXls<T>)<BR>  Es <T>Concentrado Cte Final<T> Entonces ReporteExcel(<T>RM1171ConcentradoFinalesRepXls<T>)<BR>  Es <T>Concentrado DIMA<T> Entonces ReporteExcel(<T>RM1171ConcentradoDIMARepXls<T>)<BR>Fin
EjecucionCondicion=SI (info.FechaD > info.FechaA)<BR>ENTONCES<BR>    Error(<T>Seleccione un rango de fechas válido.<T>)<BR>    AbortarOperacion<BR>SINO<BR>    Verdadero<BR>FIN<BR><BR>Si<BR>  (Mavi.RM1171TipoReporte <> <T>Concentrado Cte Final<T>) y (ConDatos(Mavi.RM1171TipoCteFinal))<BR>Entonces<BR>  Informacion(<T>El filtro [Tipo de Cliente Final] no aplica para el reporte seleccionado<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.TXT.Reportes]
Nombre=Reportes
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S

Expresion=Caso Mavi.RM1171TipoReporte<BR>  Es <T>Detallado<T> Entonces ReporteImpresora(<T>RM1171AsignaDIMARepTxt<T>)<BR>  Es <T>Concentrado Cte Final<T> Entonces ReporteImpresora(<T>RM1171ConcentradoFinalesRepTxt<T>)<BR>  Es <T>Concentrado DIMA<T> Entonces ReporteImpresora(<T>RM1171ConcentradoDIMARepTxt<T>)<BR>Fin
EjecucionCondicion=SI (info.FechaD > info.FechaA)<BR>ENTONCES<BR>    Error(<T>Seleccione un rango de fechas válido.<T>)<BR>    AbortarOperacion<BR>SINO<BR>    Verdadero<BR>FIN<BR><BR>Si<BR>  (Mavi.RM1171TipoReporte <> <T>Concentrado Cte Final<T>) y (ConDatos(Mavi.RM1171TipoCteFinal))<BR>Entonces<BR>  Informacion(<T>El filtro [Tipo de Cliente Final] no aplica para el reporte seleccionado<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin

[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(Mavi.RM1171TipoReporte)<BR>Informacion(Mavi.RM1171Vencimiento)<BR>Informacion(Mavi.RM1171soloDimas)<BR>Informacion(Mavi.RM1171TipoCteFinal)
Activo=S
Visible=S

[Acciones.Expresion.Crear Plantilla]
Nombre=Crear Plantilla
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


