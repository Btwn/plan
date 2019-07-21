
[Forma]
Clave=DM0130ReporteCampFrm
Icono=621
Modulos=(Todos)
Nombre=Reporte de Campañas

ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialAlturaCliente=173
PosicionInicialAncho=317
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=524
PosicionInicialArriba=278
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Excel<BR>Txt
ExpresionesAlMostrar=Asigna(Mavi.DM0130Categoria,<T><T>)<BR>Asigna(Mavi.DM0130Resultado,<T><T>)<BR>Asigna(Mavi.DM0130Ejercicio,NULO)<BR>Asigna(Mavi.DM0130Quincena,NULO)<BR>Asigna(Info.FechaD,NULO)<BR>Asigna(Info.FechaA,NULO)<BR>Asigna(Info.Numero,NULO)
[Variables]
Estilo=Ficha
Clave=Variables
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
ListaEnCaptura=Mavi.DM0130Categoria<BR>Mavi.DM0130Resultado<BR>Mavi.DM0130Ejercicio<BR>Mavi.DM0130Quincena<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[Variables.Info.FechaD]
Carpeta=Variables
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Info.FechaA]
Carpeta=Variables
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco





[Variables.Mavi.DM0130Categoria]
Carpeta=Variables
Clave=Mavi.DM0130Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Variables.Mavi.DM0130Resultado]
Carpeta=Variables
Clave=Mavi.DM0130Resultado
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Variables.Mavi.DM0130Quincena]
Carpeta=Variables
Clave=Mavi.DM0130Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Vista.Columnas]
Categoria=182

[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Reporte<BR>Cerrar
[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Generar TXT
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Reportes Impresora
ClaveAccion=DM0130ReporteCampRepTxt
Multiple=S
ListaAccionesMultiples=Asignar<BR>Reporte<BR>Cerrar
[Variables.Mavi.DM0130Ejercicio]
Carpeta=Variables
Clave=Mavi.DM0130Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.prueba.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.prueba.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=DM0130ReporteCampRep
Activo=S
Visible=S



[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[Acciones.Excel.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0130ReporteCampRepXls
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si((ConDatos(Info.FechaD) o ConDatos(Info.FechaA)) y (ConDatos(Mavi.DM0130Ejercicio) o ConDatos(Mavi.DM0130Quincena)),Informacion(<T>Solo se puede usar un tipo de filtro de fecha a la vez<T>) AbortarOperacion,Verdadero)<BR>Si(Info.FechaD>Info.FechaA,Error(<T>El rango de fechas no es valido<T>) AbortarOperacion,Verdadero)<BR>Si (ConDatos(Mavi.DM0130Ejercicio) y ConDatos(Mavi.DM0130Quincena)) o (ConDatos(Info.FechaD) y ConDatos(Info.FechaA))<BR>Entonces<BR>    Si ConDatos(Mavi.DM0130Ejercicio) y ConDatos(Mavi.DM0130Quincena)<BR>    Entonces Asigna(Info.Numero,1)<BR>    Sino<BR>        Si ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        Entonces Asigna(Info.Numero,2)<BR>        Sino Error(<T>Los filtros de fecha no estan llenados correctamente<T>) AbortarOperacion<BR>        Fin<BR>    Fin<BR>Sino Informacion(<T>Se debe utilizar un filtro de fecha<T>) AbortarOperacion<BR>Fin
[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Txt.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0130ReporteCampRepTxt
Activo=S
Visible=S





ConCondicion=S
EjecucionCondicion=Si((ConDatos(Info.FechaD) o ConDatos(Info.FechaA)) y (ConDatos(Mavi.DM0130Ejercicio) o ConDatos(Mavi.DM0130Quincena)),Informacion(<T>Solo se puede usar un tipo de filtro de fecha a la vez<T>) AbortarOperacion,Verdadero)<BR>Si(Info.FechaD>Info.FechaA,Error(<T>El rango de fechas no es valido<T>) AbortarOperacion,Verdadero)<BR>Si (ConDatos(Mavi.DM0130Ejercicio) y ConDatos(Mavi.DM0130Quincena)) o (ConDatos(Info.FechaD) y ConDatos(Info.FechaA))<BR>Entonces<BR>    Si ConDatos(Mavi.DM0130Ejercicio) y ConDatos(Mavi.DM0130Quincena)<BR>    Entonces Asigna(Info.Numero,1)<BR>    Sino<BR>        Si ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>        Entonces Asigna(Info.Numero,2)<BR>        Sino Error(<T>Los filtros de fecha no estan llenados correctamente<T>) AbortarOperacion<BR>        Fin<BR>    Fin<BR>Sino Informacion(<T>Se debe utilizar un filtro de fecha<T>) AbortarOperacion<BR>Fin
[Acciones.accionprueba.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.accionprueba.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=DM0130ReporteCampRepXls
Activo=S
Visible=S



[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Txt.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

