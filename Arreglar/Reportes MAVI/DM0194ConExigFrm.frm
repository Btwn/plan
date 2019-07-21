[Forma]
Clave=DM0194ConExigFrm
Nombre=Explorador Concentrado de Exigibles
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=SQL
CarpetaPrincipal=SQL
PosicionInicialIzquierda=149
PosicionInicialArriba=447
PosicionInicialAlturaCliente=334
PosicionInicialAncho=782
ListaAcciones=XLS<BR>Cerrar<BR>Nva
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Totalizadores=S
PosicionSec1=248
PosicionSec2=240

[SQL]
Estilo=Iconos
Clave=SQL
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0194ConExigVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
ListaEnCaptura=DESCRIPCION<BR>Ejercicio<BR>Periodo<BR>Quincena<BR>ExigibleMensual
IconosSubTitulo=<T>Institución<T>
IconosNombre=DM0194ConExigVis:CV

[SQL.Columnas]
ID=64
Cliente=64
Nombre=215
ClienteEnviarA=78
SeccionCobranzaMavi=304
MOV=124
MOVID=124
FechaEmision=94
Vencimiento=94
Plazo=304
FechaUltVen=94
Saldo=64
ImporteVta=64
ImporteDescMens=90
ExigibleMensual=79
0=148
1=202
2=79
3=113
4=-2
5=76
6=78
7=-2
8=-2
9=-2
10=71
11=70
12=77
13=95
14=93

[Acciones.XLS]
Nombre=XLS
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.EnviarExcel(<T>SQL<T>)

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
Zona=B1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=48
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
Totalizadores1=TotalExigibleMensual
Totalizadores2=SumaTotal(DM0194ConExigVis:ExigibleMensual)
Totalizadores3=(Monetario)<BR>(Monetario)
Totalizadores=S
TotCarpetaRenglones=SQL
TotExpresionesEnSumas=S
TotAlCambiar=S
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=TotalSaldo<BR>TotalExigibleMensual
CarpetaVisible=S
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S

[(Carpeta Totalizadores).TotalExigibleMensual]
Carpeta=(Carpeta Totalizadores)
Clave=TotalExigibleMensual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro

[Acciones.Nva]
Nombre=Nva
Boton=72
NombreEnBoton=S
NombreDesplegar=Nueva Consulta
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=cierra<BR>asigna<BR>dialog
[Acciones.Nva.cierra]
Nombre=cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Nva.asigna]
Nombre=asigna
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0194PrincipalExigiblesFrm
[Acciones.Nva.dialog]
Nombre=dialog
Boton=0
TipoAccion=Dialogos
ClaveAccion=MaviNuevaConsultaDlg
Activo=S
Visible=S








[SQL.DESCRIPCION]
Carpeta=SQL
Clave=DESCRIPCION
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[SQL.Ejercicio]
Carpeta=SQL
Clave=Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SQL.Periodo]
Carpeta=SQL
Clave=Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SQL.Quincena]
Carpeta=SQL
Clave=Quincena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[SQL.ExigibleMensual]
Carpeta=SQL
Clave=ExigibleMensual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

