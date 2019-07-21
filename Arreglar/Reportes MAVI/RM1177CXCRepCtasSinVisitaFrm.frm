
[Forma]
Clave=RM1177CXCRepCtasSinVisitaFrm
Icono=90
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=540
PosicionInicialArriba=213
PosicionInicialAlturaCliente=185
PosicionInicialAncho=342
AccionesTamanoBoton=15x5
AccionesDerecha=S
Nombre=Reporte de Cuentas sin Visita
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=TXT<BR>Excel
ExpresionesAlMostrar=asigna(Mavi.RM1177Agente,<T><T>)<BR>asigna(Mavi.RM1177Equipos,<T><T>)<BR>asigna(Mavi.RM1177Categorias,<T><T>)
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
ListaEnCaptura=Mavi.RM1177Agente<BR>Mavi.RM1177Equipos<BR>Mavi.RM1177EjercicioActual<BR>Mavi.Quincena<BR>Mavi.RM1177Categorias
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=14
FichaEspacioNombres=0
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
[(Variables).Mavi.RM1177Agente]
Carpeta=(Variables)
Clave=Mavi.RM1177Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.Columnas]
Agente=64
Nombre=304
Tipo=94

Equipo=127
Categoria=304
0=-2

[(Variables).Mavi.RM1177Equipos]
Carpeta=(Variables)
Clave=Mavi.RM1177Equipos
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1177Categorias]
Carpeta=(Variables)
Clave=Mavi.RM1177Categorias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Rama.Columnas]
Agente=64
Nombre=304
Tipo=94

[Agentes.Columnas]
0=-2
1=253
2=106

[Categoria.Columnas]
0=-2

[Equipo.Columnas]
0=-2

[Acciones.TXT]
Nombre=TXT
Boton=1
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=asigna<BR>reporte
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=asigna<BR>rep
[Acciones.TXT.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Excel.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.TXT.reporte]
Nombre=reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM1177CXCCtasSinVisitaRepTxt
Activo=S
Visible=S


ConCondicion=S

EjecucionCondicion=Si<BR>  vacio(Mavi.RM1177EjercicioActual) o vacio(Mavi.Quincena)<BR>Entonces<BR>  Error(<T>Los campos ejercicio y quincena son obligatorios<T>)<BR>  abortaroperacion<BR>Sino<BR>  verdadero<BR>Fin<BR>Si<BR>  (Mavi.RM1177EjercicioActual < 1) o (Mavi.Quincena < 1)<BR>Entonces<BR>  Error(<T>Los campos ejercicio y quincena deben ser mayores a 0<T>)<BR>  abortaroperacion<BR>Sino<BR>  verdadero<BR>Fin
[Acciones.Excel.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM1177CXCCtasSinVisitaRepXls
Activo=S
Visible=S
ConCondicion=S

EjecucionCondicion=Si<BR>  vacio(Mavi.RM1177EjercicioActual) o vacio(Mavi.Quincena)<BR>Entonces<BR>  Error(<T>Los campos ejercicio y quincena son obligatorios<T>)<BR>  abortaroperacion<BR>Sino<BR>  verdadero<BR>Fin<BR>Si<BR>  (Mavi.RM1177EjercicioActual < 1) o (Mavi.Quincena < 1)<BR>Entonces<BR>  Error(<T>Los campos ejercicio y quincena deben ser mayores a 0<T>)<BR>  abortaroperacion<BR>Sino<BR>  verdadero<BR>Fin
[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



[(Variables).Mavi.RM1177EjercicioActual]
Carpeta=(Variables)
Clave=Mavi.RM1177EjercicioActual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


