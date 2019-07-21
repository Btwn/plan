
[Forma]
Clave=RM1202CxcAquienLocalizarFrm
Icono=0
Modulos=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=88
PosicionInicialAncho=325

ListaAcciones=Preliminar<BR>Cerrar<BR>Excel<BR>Txt
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=558
PosicionInicialArriba=343
Nombre=RM1202CxcAquienLocalizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Info.Ejercicio, Año(Hoy) )<BR>Asigna(Mavi.Quincena,si  Dia(Hoy) > 15 entonces Mes(Hoy)*2 sino (Mes(Hoy)*2)-1 fin)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Cerrar
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S




[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Mavi.Quincena
CarpetaVisible=S

[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
TipoAccion=Reportes Excel
ClaveAccion=PruebaAquienRepXls
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>Excel<BR>Cerrar
[Acciones.Excel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Excel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1202CxcAquienLocalizarRepXls
Activo=S
Visible=S

[Acciones.Excel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Txt
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Generar<BR>Cerrar
[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Txt.Generar]
Nombre=Generar
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1202CxcAquienLocalizarRepTxt
Activo=S
Visible=S

[Acciones.Txt.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


