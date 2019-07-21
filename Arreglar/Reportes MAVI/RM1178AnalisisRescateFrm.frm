
[Forma]
Clave=RM1178AnalisisRescateFrm
Icono=363
Modulos=(Todos)

ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=EnvioXls<BR>EnviarTxt<BR>Cerrar
PosicionInicialIzquierda=524
PosicionInicialArriba=299
PosicionInicialAlturaCliente=131
PosicionInicialAncho=317
Nombre=Reporte Analisis de Rescate
ExpresionesAlMostrar=Asigna(Info.FechaD,PrimerDiaMes(Ahora))<BR>Asigna(Info.FechaA,UltimoDiaMes(Ahora))<BR>Asigna(Mavi.RM1178Claves,NULO)
[Filtros]
Estilo=Ficha
Clave=Filtros
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM1178Claves
CarpetaVisible=S

[Filtros.Info.FechaD]
Carpeta=Filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Info.FechaA]
Carpeta=Filtros
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.EnvioXls]
Nombre=EnvioXls
Boton=115
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Reporte Excel
[Acciones.EnviarTxt]
Nombre=EnviarTxt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Enviar a TXT
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Reporte TXT
[Filtros.Mavi.RM1178Claves]
Carpeta=Filtros
Clave=Mavi.RM1178Claves
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Columnas]
0=81
1=255

[Acciones.EnvioXls.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.EnvioXls.Reporte Excel]
Nombre=Reporte Excel
Boton=0
TipoAccion=Reportes Excel
Activo=S
Visible=S

ConCondicion=S
ClaveAccion=RM1178AnalisisRescateRepXls
EjecucionCondicion=Si<BR>  Vacio(Info.FechaD) o Vacio(Info.FechaA)<BR>Entonces<BR>  Error(<T>Los filtros de fechas son obligatorios<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Si<BR>    Info.FechaD > Info.FechaA<BR>  Entonces<BR>    Error(<T>Seleccione un rango de fechas valido<T>)<BR>    AbortarOperacion<BR>  Sino<BR>    Verdadero<BR>  Fin<BR>Fin
[Acciones.EnviarTxt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.EnviarTxt.Reporte TXT]
Nombre=Reporte TXT
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
ConCondicion=S
ClaveAccion=RM1178AnalisisRescateRepTxt
EjecucionCondicion=Si<BR>  Vacio(Info.FechaD) o Vacio(Info.FechaA)<BR>Entonces<BR>  Error(<T>Los filtros de fechas son obligatorios<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Si<BR>    Info.FechaD > Info.FechaA<BR>  Entonces<BR>    Error(<T>Seleccione un rango de fechas valido<T>)<BR>    AbortarOperacion<BR>  Sino<BR>    Verdadero<BR>  Fin<BR>Fin

