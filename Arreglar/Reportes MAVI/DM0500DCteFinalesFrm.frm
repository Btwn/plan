
[Forma]
Clave=DM0500DCteFinalesFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
Nombre=DM0500D Cte Finales
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Preliminar<BR>Excel<BR>Txt<BR>Cerrar
PosicionInicialAlturaCliente=133
PosicionInicialAncho=491
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=395
PosicionInicialArriba=424
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.Ejercicio, Año(hoy))<BR>Asigna(Mavi.Quincena,si  Año(Hoy) > 15 entonces Mes(Hoy)*2 sino (Mes(Hoy)*2)-1 fin)<BR>Asigna(Mavi.DM0500DNivelCobranza,Nulo)<BR>Asigna(Mavi.DM0500DAgentes,Nulo)<BR>Asigna(Mavi.DM0500DEquipo,Nulo)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


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
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
ListaEnCaptura=Info.Ejercicio<BR>Mavi.Quincena<BR>Mavi.DM0500DNivelCobranza<BR>Mavi.DM0500DAgentes<BR>Mavi.DM0500DEquipo<BR>Mavi.DM0500DTipo

[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion
[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Txt
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar



[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar



[Acciones.Preliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



Expresion=Si<BR>  Mavi.DM0500DTipo = <T>DETALLADO<T><BR>Entonces<BR>   Informacion(<T>Reporte solo disponible en TXT<T>)<BR>Sino<BR>  Si<BR>    Mavi.DM0500DTipo = <T>COBROS<T><BR>Entonces<BR>    ReportePantalla(<T>DM0500DCobrosCteFinalesRepImp<T>)<BR>     Sino<BR>     Si<BR>  Mavi.DM0500DTipo = <T>CONCENTRADO<T><BR>Entonces<BR> ReportePantalla(<T>DM0500DConcentradoCteFinalesRepImp<T>)<BR>Fin<BR>Fin<BR>Fin
[Acciones.Txt.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Si<BR>  Mavi.DM0500DTipo = <T>DETALLADO<T><BR>Entonces<BR>   ReporteImpresora(<T>DM0500DetalladoCteFinalesRepTxt<T>)<BR>Sino<BR>  Si<BR>    Mavi.DM0500DTipo = <T>COBROS<T><BR>Entonces<BR>   ReporteImpresora(<T>DM0500DCobrosCteFinalesRepTxt<T>)<BR>Sino<BR> ReporteImpresora(<T>DM0500DConcentradoCteFinalesRepTxt<T>) <BR>Fin<BR>Fin
[Vista.Columnas]
NivelCobranza=604
0=-2
1=-2
AgenteCobrador=84
Equipo=94



[Acciones.Excel.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Si<BR>   Mavi.DM0500DTipo = <T>DETALLADO<T><BR>Entonces<BR>   Informacion(<T>Reporte solo disponible en TXT<T>)<BR>Sino<BR>  Si<BR>   Mavi.DM0500DTipo = <T>COBROS<T><BR>  Entonces<BR>   ReporteExcel(<T>DM0500DCobrosCteFinalesRepXls<T>)<BR>  Sino<BR>   ReporteExcel(<T>DM0500DConcentradoCteFinalesRepXls<T>)<BR>  Fin<BR>Fin
[(Variables).Mavi.DM0500DNivelCobranza]
Carpeta=(Variables)
Clave=Mavi.DM0500DNivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0500DAgentes]
Carpeta=(Variables)
Clave=Mavi.DM0500DAgentes
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0500DEquipo]
Carpeta=(Variables)
Clave=Mavi.DM0500DEquipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.DM0500DTipo]
Carpeta=(Variables)
Clave=Mavi.DM0500DTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco




