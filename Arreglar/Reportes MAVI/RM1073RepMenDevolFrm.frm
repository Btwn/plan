[Forma]
Clave=RM1073RepMenDevolFrm
Nombre=RM1073 Rep Men Devoluciones
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1073 FILTRO<BR>RM1073Ayuda
CarpetaPrincipal=RM1073 FILTRO
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=RM1073Genera
PosicionInicialIzquierda=459
PosicionInicialArriba=288
PosicionInicialAlturaCliente=153
PosicionInicialAncho=442
PosicionCol1=227
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Info.Clase,<T>Se corre cada primero de Mes<T>)<BR>Asigna(Info.Clase1,<T>De la Fecha:  es el primer dia del mes<T>)<BR>Asigna(Info.Clase2,<T>A la Fecha:  es el Ultimo dia del mes<T>)
[RM1073 FILTRO]
Estilo=Ficha
Clave=RM1073 FILTRO
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[RM1073 FILTRO.Info.FechaD]
Carpeta=RM1073 FILTRO
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1073 FILTRO.Info.FechaA]
Carpeta=RM1073 FILTRO
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1073Ayuda]
Estilo=Ficha
Clave=RM1073Ayuda
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=15
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.Clase<BR>Info.Clase1<BR>Info.Clase2
[Acciones.RM1073Genera.RM1073Asigna]
Nombre=RM1073Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.RM1073Genera.RM1073Reporte]
Nombre=RM1073Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1073RepMenDevolrep
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=ConDatos(Info.FechaD) y ConDatos(Info.FechaA) y Info.FechaD <= Info.FechaA
EjecucionMensaje=Error(<T>Selecciona Rango de Fechas...<T>)
[Acciones.RM1073Genera]
Nombre=RM1073Genera
Boton=65
NombreEnBoton=S
NombreDesplegar=&Genera Txt
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=RM1073Asigna<BR>RM1073Reporte
Activo=S
Visible=S
[RM1073Ayuda.Info.Clase1]
Carpeta=RM1073Ayuda
Clave=Info.Clase1
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[RM1073Ayuda.Info.Clase2]
Carpeta=RM1073Ayuda
Clave=Info.Clase2
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[RM1073Ayuda.Info.Clase]
Carpeta=RM1073Ayuda
Clave=Info.Clase
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro



