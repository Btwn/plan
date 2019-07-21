
[Forma]
Clave=RM1175GestionesIntelisisFrm
Icono=0
Modulos=(Todos)
Nombre=RM1175GestionesIntelisisFrm

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Txt<BR>Excel<BR>Cerrar
PosicionInicialAlturaCliente=152
PosicionInicialAncho=461
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=409
PosicionInicialArriba=417
ExpresionesAlMostrar=Asigna(Info.Ejercicio,Año(Hoy))<BR>Asigna(Mavi.RM1175Agente,<T><T>))<BR>Asigna(Mavi.RM1175Equipo,<T><T>)<BR>Asigna(Mavi.RM1175NivelCob,<T><T>)<BR>Asigna(Mavi.Quincena,<BR>    Si Dia(Hoy)=1 Entonces<BR>        Si Mes(Hoy)=1 Entonces<BR>            24<BR>        Sino<BR>            (Mes(Hoy)*2)-2<BR>        Fin<BR>    Sino<BR>        Si Dia(Hoy)>=17 Entonces<BR>                Mes(Hoy)*2<BR>        Sino<BR>            (Mes(Hoy)*2)-1<BR>        Fin<BR>    Fin)
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

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.RM1175Agente<BR>Mavi.RM1175Equipo<BR>Info.Ejercicio<BR>Mavi.Quincena<BR>Mavi.RM1175NivelCob
PermiteEditar=S
[Acciones.Txt]
Nombre=Txt
Boton=54
NombreEnBoton=S
NombreDesplegar=&Txt
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Txt
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Excel
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Excel
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[(Variables).Mavi.RM1175Agente]
Carpeta=(Variables)
Clave=Mavi.RM1175Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[(Variables).Mavi.RM1175Equipo]
Carpeta=(Variables)
Clave=Mavi.RM1175Equipo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[(Variables).Mavi.RM1175NivelCob]
Carpeta=(Variables)
Clave=Mavi.RM1175NivelCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[RM1175AgenteVis.Columnas]
Agente=69
Nombre=367
Estatus=94

0=88
1=318
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

[RM1175EquipoVis.Columnas]
Equipo=225
Zona=94
NivelCobranza=304
Region=184
Division=184
Agente=94
Maxcuentas=64
MaxAsociados=72
MaxCtesFinales=79
Categoria=304
UsrMod=94
FechaMod=94

0=361
[RM1175NivelCobVis.Columnas]
Nombre=604

0=462
[Acciones.Txt.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Txt.Txt]
Nombre=Txt
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1175GestionesIntelisisRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si ConDatos(Info.Ejercicio)<BR>Entonces<BR>    Si ConDatos(Mavi.Quincena)<BR>    Entonces<BR>        Verdadero<BR>    Sino<BR>        Informacion(<T>Especifica Quincena<T>)<BR>        Falso<BR>    Fin<BR>Sino<BR>    Informacion(<T>Especifica Ejercicio<T>)<BR>    Falso<BR>Fin
[Acciones.Excel.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.Excel]
Nombre=Excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1175GestionesIntelisisRepXls
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si ConDatos(Info.Ejercicio)<BR>Entonces<BR>    Si ConDatos(Mavi.Quincena)<BR>    Entonces<BR>        Verdadero<BR>    Sino<BR>        Informacion(<T>Especifica Quincena<T>)<BR>        Falso<BR>    Fin<BR>Sino<BR>    Informacion(<T>Especifica Ejercicio<T>)<BR>    Falso<BR>Fin


