[Forma]
Clave=RM0430ECREDIAnalisisLibAutFrm
Nombre=RM0430 - E Analisis de Credito Liberador Automatico de Empleados
Icono=17
Modulos=(Todos)
PosicionInicialAlturaCliente=99
PosicionInicialAncho=700
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=333
PosicionInicialArriba=315
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Excel<BR>Cerrar
ExpresionesAlMostrar=Asigna(Info.FechaD,Hoy)<BR>Asigna(Info.FechaA,Hoy)<BR>Asigna(Mavi.RM0430Cliente,Nulo)
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
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0430Cliente
CarpetaVisible=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>RM0430ECREDIAnalisisLibAutDRep<BR>Cerrar
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



[(Variables).Mavi.RM0430Cliente]
Carpeta=(Variables)
Clave=Mavi.RM0430Cliente
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Excel
ClaveAccion=RM0430ECREDIAnalisisLibAutDRep
Activo=S
Visible=S

ConCondicion=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>RM0430ECREDIAnalisisLibAutDRep
EjecucionCondicion=Si (Info.FechaA=nulo) o  (Info.FechaD=nulo)<BR>    Entonces<BR>          informacion(<T>Falta indicar Fecha<T>)<BR>    Fin
[Acciones.Preliminar.RM0430ECREDIAnalisisLibAutDRep]
Nombre=RM0430ECREDIAnalisisLibAutDRep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0430ECREDIAnalisisLibAutDRep
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si (Info.FechaA=nulo) o  (Info.FechaD=nulo)<BR>    Entonces<BR>          informacion(<T>Falta indicar Fecha<T>)<BR><BR>    Fin


[Acciones.Excel.REPORTE ]
Nombre=REPORTE 
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0430ECREDIAnalisisLibAutDRep
Activo=S
Visible=S

[Acciones.Excel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.RM0430ECREDIAnalisisLibAutDRep]
Nombre=RM0430ECREDIAnalisisLibAutDRep
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0430ECREDIAnalisisLibAutDRep
ConCondicion=S
EjecucionCondicion=Si (Info.FechaA=nulo) o  (Info.FechaD=nulo)<BR>    Entonces<BR>          informacion(<T>Falta indicar Fecha<T>)<BR>    Fin
