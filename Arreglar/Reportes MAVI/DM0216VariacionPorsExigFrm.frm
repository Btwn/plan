[Forma]
Clave=DM0216VariacionPorsExigFrm
Nombre=DM0216Variacion Porcentual de Exigibles VS Entero de Instituciones
Icono=0
Modulos=(Todos)
ListaCarpetas=variacion<BR>filtros
CarpetaPrincipal=variacion
PosicionInicialAlturaCliente=962
PosicionInicialAncho=1296
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=69
BarraHerramientas=S
ListaAcciones=Aceptar<BR>Cerrar<BR>CargaCSV<BR>Expresion<BR>aPDF
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Totalizadores=S
PosicionSec2=335
ExpresionesAlMostrar=Asigna( Info.InstitucionMAVI, nulo )<BR> Asigna(Info.Periodo,nulo)<BR> Asigna(Info.Ejercicio,nulo)
[variacion]
Estilo=Hoja
Clave=variacion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0216VariacionPorsExigVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=RFC<BR>NOMBRE<BR>EXIGIBLE<BR>CSV<BR>DIFERENCIA1<BR>PORCENTUAL
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[variacion.Columnas]
0=-2
1=96
2=226
3=76
4=91
5=-2
6=82
7=-2
RFC=94
NOMBRE=604
EXIGIBLE=64
CSV=64
DIFERENCIA1=65
PORCENTUAL=70
[(Variables).Periodo]
Carpeta=(Variables)
Clave=Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Columnas]
0=-2
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0169FiltroPeriodo, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroPeriodo) )<BR>Asigna(Mavi.DM0169FiltroQuincena, Reemplaza(ASCII(39),<T> <T> , Mavi.DM0169FiltroQuincena) )<BR>Si<BR>    SQL(<T>spValidarRecepcionMavi :tEmp, :tInst, :nEjer, :tPer, :nEst, :tQui<T>, <T>MAVI<T>, Info.InstitucionMAVI, Info.Ejercicio, Mavi.DM0169FiltroPeriodo, EstacionTrabajo, Mavi.DM0169FiltroQuincena) = 0<BR>  Entonces<BR>   informacion(<T>El csv correspondiente a la intutucion , ejercicio y periodo indicado no a sido cargado <T>)<BR>   abortaroperacion()<BR>  sino<BR>   ActualizarVista(<T>filtros<T>)<BR>fin
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S
[filtros]
Estilo=Ficha
Clave=filtros
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
ListaEnCaptura=Info.InstitucionMAVI<BR>Info.Ejercicio<BR>Mavi.DM0169FiltroPeriodo<BR>Mavi.DM0169FiltroQuincena
CarpetaVisible=S
[filtros.Info.InstitucionMAVI]
Carpeta=filtros
Clave=Info.InstitucionMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[filtros.Info.Ejercicio]
Carpeta=filtros
Clave=Info.Ejercicio
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=4
FichaEspacioNombres=45
FichaNombres=Arriba
FichaAlineacion=Derecha
FichaColorFondo=Plata
Totalizadores1=Total Exigible<BR>Total CSV<BR>Total Dif<BR>Porcentual 
Totalizadores2=SumaTotal(DM0216VariacionPorsExigVis:EXIGIBLE)<BR>SumaTotal( DM0216VariacionPorsExigVis:CSV )<BR>SumaTotal(DM0216VariacionPorsExigVis:DIFERENCIA1)<BR>(SumaTotal( DM0216VariacionPorsExigVis:CSV )*100)/SumaTotal(DM0216VariacionPorsExigVis:EXIGIBLE)
Totalizadores3=(Monetario)<BR>(Monetario)<BR>(Monetario)<BR>0.00
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=Total Exigible<BR>Total CSV<BR>Total Dif<BR>Porcentual
CarpetaVisible=S
TotCarpetaRenglones=variacion
TotExpresionesEnSumas=S
TotAlCambiar=S
FichaAlineacionDerecha=S
[Acciones.CargaCSV]
Nombre=CargaCSV
Boton=38
NombreEnBoton=S
NombreDesplegar=&CargarCSV
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=RecepcionLayuotMAVI
Activo=S
Visible=S
[Acciones.Expresion]
Nombre=Expresion
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.EnviarExcel(<T>variacion<T>)
[(Carpeta Totalizadores).Total Exigible]
Carpeta=(Carpeta Totalizadores)
Clave=Total Exigible
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Total CSV]
Carpeta=(Carpeta Totalizadores)
Clave=Total CSV
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Total Dif]
Carpeta=(Carpeta Totalizadores)
Clave=Total Dif
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Porcentual]
Carpeta=(Carpeta Totalizadores)
Clave=Porcentual
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.aPDF]
Nombre=aPDF
Boton=97
NombreEnBoton=S
NombreDesplegar=&GenerarPDF
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0216VariacionPorcentualRep
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=condatos(Info.InstitucionMAVI)<BR>condatos(Info.Ejercicio)<BR>condatos(Info.Periodo)
AntesExpresiones=/*Si<BR>    SQL(<T>spValidarRecepcionMavi :tEmp, :tInst, :nEjer, :nPer, :nEst<T>, <T>MAVI<T>, Info.InstitucionMAVI, Info.Ejercicio, Info.Periodo, EstacionTrabajo) = 0<BR>  Entonces<BR>   informacion(<T>El csv correspondiente a la intutucion , ejercicio y periodo indicado no a sido cargado <T>)<BR>   abortaroperacion()<BR>  <BR>fin*/
[filtros.Mavi.DM0169FiltroPeriodo]
Carpeta=filtros
Clave=Mavi.DM0169FiltroPeriodo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[filtros.Mavi.DM0169FiltroQuincena]
Carpeta=filtros
Clave=Mavi.DM0169FiltroQuincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[variacion.RFC]
Carpeta=variacion
Clave=RFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[variacion.NOMBRE]
Carpeta=variacion
Clave=NOMBRE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[variacion.EXIGIBLE]
Carpeta=variacion
Clave=EXIGIBLE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[variacion.CSV]
Carpeta=variacion
Clave=CSV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[variacion.DIFERENCIA1]
Carpeta=variacion
Clave=DIFERENCIA1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[variacion.PORCENTUAL]
Carpeta=variacion
Clave=PORCENTUAL
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


