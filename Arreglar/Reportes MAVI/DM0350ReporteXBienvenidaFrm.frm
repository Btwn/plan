
[Forma]
Clave=DM0350ReporteXBienvenidaFrm
Icono=744
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=105
PosicionInicialAncho=441
Nombre=REPORTE MONEDERO POR BONO BIENVENIDA
PosicionInicialIzquierda=462
PosicionInicialArriba=312
VentanaTipoMarco=Chico
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=aExcel<BR>Preliminar<BR>Cerrar<BR>Empty
ExpresionesAlMostrar=ASIGNA(Mavi.DM0350FechaIni,Hoy)<BR>ASIGNA(Mavi.DM0350FechaFin,Hoy)
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
ListaEnCaptura=Mavi.DM0350FechaIni<BR>Mavi.DM0350FechaFin
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.DM0350FechaIni]
Carpeta=(Variables)
Clave=Mavi.DM0350FechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0350FechaFin]
Carpeta=(Variables)
Clave=Mavi.DM0350FechaFin
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Cerrar
EspacioPrevio=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=SI Vacio(Mavi.DM0350FechaFin) o Vacio(Mavi.DM0350FechaIni) ENTONCES<BR>    INFORMACION(<T>Es necesario especificar un rango de fecha.<T>)<BR>    SI Vacio(Mavi.DM0350FechaIni) y Vacio(Mavi.DM0350FechaFin) ENTONCES<BR>        ASIGNA(Mavi.DM0350FechaIni,Hoy)<BR>        ASIGNA(Mavi.DM0350FechaFin,Hoy)<BR>    SINO<BR>        SI Vacio(Mavi.DM0350FechaIni) ENTONCES<BR>            ASIGNA(Mavi.DM0350FechaIni,Mavi.DM0350FechaFin)<BR>        FIN<BR>        SI Vacio(Mavi.DM0350FechaFin) ENTONCES<BR>            ASIGNA(Mavi.DM0350FechaFin,Mavi.DM0350FechaIni)<BR>        FIN<BR>    FIN<BR>    AbortarOperacion<BR>SINO<BR>    SI Mavi.DM0350FechaFin < Mavi.DM0350FechaIni ENTONCES<BR>         INFORMACION(<T>Rango de fecha inválido.<T>)<BR>         Asigna(Mavi.DM0350FechaIni,Mavi.DM0350FechaFin)<BR>         AbortarOperacion<BR>    FIN<BR>FIN<BR><BR>VERDADERO
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Empty]
Nombre=Empty
Boton=0
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S

[Acciones.aExcel]
Nombre=aExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Importar<BR>Cerrar
[Acciones.aExcel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.aExcel.Importar]
Nombre=Importar
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0350MonederoXBienvenidaRepXls
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=SI Vacio(Mavi.DM0350FechaFin) o Vacio(Mavi.DM0350FechaIni) ENTONCES<BR>    INFORMACION(<T>Es necesario especificar un rango de fecha.<T>)<BR>    SI Vacio(Mavi.DM0350FechaIni) y Vacio(Mavi.DM0350FechaFin) ENTONCES<BR>        ASIGNA(Mavi.DM0350FechaIni,Hoy)<BR>        ASIGNA(Mavi.DM0350FechaFin,Hoy)<BR>    SINO<BR>        SI Vacio(Mavi.DM0350FechaIni) ENTONCES<BR>            ASIGNA(Mavi.DM0350FechaIni,Mavi.DM0350FechaFin)<BR>        FIN<BR>        SI Vacio(Mavi.DM0350FechaFin) ENTONCES<BR>            ASIGNA(Mavi.DM0350FechaFin,Mavi.DM0350FechaIni)<BR>        FIN<BR>    FIN<BR>    AbortarOperacion<BR>SINO<BR>    SI Mavi.DM0350FechaFin < Mavi.DM0350FechaIni ENTONCES<BR>         INFORMACION(<T>Rango de fecha inválido.<T>)<BR>         Asigna(Mavi.DM0350FechaIni,Mavi.DM0350FechaFin)<BR>         AbortarOperacion<BR>    FIN<BR>FIN<BR><BR>VERDADERO
[Acciones.aExcel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

