[Forma]
Clave=DM0256ReportePagaresFrm
Nombre=DM0256ReportePagares
Icono=0
Modulos=(Todos)
ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
PosicionInicialIzquierda=413
PosicionInicialArriba=263
PosicionInicialAlturaCliente=213
PosicionInicialAncho=183
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>Excel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(MAVI.DM0256Recibio,nulo)
[Filtros]
Estilo=Ficha
Clave=Filtros
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Cliente<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.DM0256Recibio
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Filtros.Info.Cliente]
Carpeta=Filtros
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Info.FechaD]
Carpeta=Filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Info.FechaA]
Carpeta=Filtros
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Filtros.Mavi.DM0256Recibio]
Carpeta=Filtros
Clave=Mavi.DM0256Recibio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Generar]
Nombre=Generar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Reporte
[Acciones.Generar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar / Ventana Aceptar
ConCondicion=S
EjecucionCondicion=Si<BR>    (ConDatos(Info.FechaD))y(ConDatos(Info.FechaA))<BR>Entonces<BR>    Si<BR>      Info.FechaD<Info.FechaA<BR>    Entonces<BR>       verdadero<BR>    Sino<BR>      Informacion(<T>El rango de Fechas es invalido<T>)<BR>    Fin<BR>Sino<BR>  Informacion(<T>Necesitas un Rango de fechas<T>)<BR>Fin
[Acciones.Excel]
Nombre=Excel
Boton=67
NombreEnBoton=S
NombreDesplegar=&Enviar a Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=DM0256CapturaPagareRepXls
Activo=S
Visible=S


