[Forma]
Clave=MaviCostFletFRM
Nombre=<T>RM0096 HISTORIAL DE COSTEO FLETES<T>
Icono=0
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=129
PosicionInicialAncho=500
PosicionInicialIzquierda=227
PosicionInicialArriba=67
BarraHerramientas=S
ListaAcciones=Expresion
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlActivar=asigna(Mavi.RM0096TipoRep,nulo)<BR>asigna(Mavi.RM0096TipoMov,nulo)<BR>asigna(Mavi.RM0096TipoUnidad,nulo)<BR>asigna(Mavi.RM0096Vehiculo,nulo)
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
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0096TipoMov<BR>Mavi.RM0096TipoUnidad<BR>Mavi.RM0096Vehiculo<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
InicializarVariables=S

[(Variables).Mavi.RM0096TipoUnidad]
Carpeta=(Variables)
Clave=Mavi.RM0096TipoUnidad
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Expresion]
Nombre=Expresion
Boton=47
NombreEnBoton=S
NombreDesplegar=&Mostrar Reporte
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Acciones.Expresion.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MaviCostFletOneFRM
[(Variables).Mavi.RM0096TipoMov]
Carpeta=(Variables)
Clave=Mavi.RM0096TipoMov
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.RM0096Vehiculo]
Carpeta=(Variables)
Clave=Mavi.RM0096Vehiculo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
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

[RM0096TipoUnidadVIS.Columnas]
TipoUnidadVehicular=604

[RM0096VehiculoVIS.Columnas]
vehiculo=64

