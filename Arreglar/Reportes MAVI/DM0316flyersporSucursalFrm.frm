[Forma]
Clave=DM0316flyersporSucursalFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=257
PosicionInicialArriba=214
PosicionInicialAlturaCliente=147
PosicionInicialAncho=494
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=140
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec2=538
ListaAcciones=consulcampana<BR>PDF<BR>Configura<BR>Salir
ExpresionesAlMostrar=Asigna(Info.UENMAVI,0)
Nombre=CALCULO PARA TIRAJE DE FLYER DE MUEBLES AMERICA
SinTransacciones=S
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
FichaAlineacion=Izquierda
FichaColorFondo=$00FFB56A
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0316FechaCamapaña<BR>Mavi.DM0316DiasCampaña<BR>Mavi.DM0316flyerpack<BR>Mavi.DM0316Muestra<BR>Mavi.DM0316sucapertura
CarpetaVisible=S
[(Variables).Mavi.DM0316FechaCamapaña]
Carpeta=(Variables)
Clave=Mavi.DM0316FechaCamapaña
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0316DiasCampaña]
Carpeta=(Variables)
Clave=Mavi.DM0316DiasCampaña
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0316Muestra]
Carpeta=(Variables)
Clave=Mavi.DM0316Muestra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0316sucapertura]
Carpeta=(Variables)
Clave=Mavi.DM0316sucapertura
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N
[(Variables).Mavi.DM0316flyerpack]
Carpeta=(Variables)
Clave=Mavi.DM0316flyerpack
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.SucursalOrigen]
Carpeta=Detalle
Clave=SucursalOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Nombre]
Carpeta=Detalle
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Poblacion]
Carpeta=Detalle
Clave=Poblacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.RepartoMasivo]
Carpeta=Detalle
Clave=RepartoMasivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.ContadorRecibos]
Carpeta=Detalle
Clave=ContadorRecibos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.nCtes]
Carpeta=Detalle
Clave=nCtes
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Promrecibos]
Carpeta=Detalle
Clave=Promrecibos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Fajillas]
Carpeta=Detalle
Clave=Fajillas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Columnas]
SucursalOrigen=76
Nombre=336
Poblacion=184
RepartoMasivo=76
ContadorRecibos=86
nCtes=64
Promrecibos=64
Fajillas=64
FlyersXSucursal=99
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores1=Total Recibos<BR>Total Cuentas Diferentes<BR>Total Promedio Recibos<BR>Total Fajillas<BR>Total Flyers x Sucursal
Totalizadores2=SumaTotal(DM0316FlyersVis:ContadorRecibos)<BR>SumaTotal(DM0316FlyersVis:nCtes)<BR>DM0316FlyersVis:TotalPromReci<BR>SumaTotal(DM0316FlyersVis:Fajillas)<BR>(SumaTotal(DM0316FlyersVis:FlyersXSucursal))+Info.Cantidad2+Info.Cantidad3
Totalizadores3=(Cantidades)<BR>(Cantidades)<BR><BR>(Cantidades)<BR>(Cantidades)
ListaEnCaptura=Total Recibos<BR>Total Cuentas Diferentes<BR>Total Fajillas<BR>Total Flyers x Sucursal<BR>Total Promedio Recibos
TotAlCambiar=S
TotCarpetaRenglones=Detalle
TotExpresionesEnSumas=S
[Acciones.consulcampana]
Nombre=consulcampana
Boton=114
NombreEnBoton=S
NombreDesplegar=&Consultar Campaña
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=asigna<BR>actua
[Acciones.consulcampana.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.consulcampana.actua]
Nombre=actua
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.UENMAVI,1)<BR>Asigna(Info.Cantidad3,SQL(<T>Select dbo.fnDM0316Calculos(:nv1,:nv2)<T>,Mavi.DM0316flyerpack,Mavi.DM0316Muestra))<BR>Asigna(Info.Cantidad2,SQL(<T>Select dbo.fnDM0316Calculos(:nv1,:nv2)<T>,Mavi.DM0316flyerpack,Mavi.DM0316sucapertura))<BR>ReportePantalla(<T>DM0316PantallaRep<T>)
[Acciones.Configura]
Nombre=Configura
Boton=45
NombreEnBoton=S
NombreDesplegar=Configurar &Municipios 
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=DM0316MunicipiosrepartoFlyersFrm
Activo=S
Visible=S
[Acciones.Salir]
Nombre=Salir 
Boton=36
NombreEnBoton=S
NombreDesplegar=&Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[(Carpeta Totalizadores).Total Recibos]
Carpeta=(Carpeta Totalizadores)
Clave=Total Recibos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
Pegado=N
[(Carpeta Totalizadores).Total Cuentas Diferentes]
Carpeta=(Carpeta Totalizadores)
Clave=Total Cuentas Diferentes
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Totalizadores).Total Fajillas]
Carpeta=(Carpeta Totalizadores)
Clave=Total Fajillas
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
LineaNueva=S
[(Carpeta Totalizadores).Total Flyers x Sucursal]
Carpeta=(Carpeta Totalizadores)
Clave=Total Flyers x Sucursal
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.reporte.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.reporte.repor]
Nombre=repor
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S
[Detalle.FlyersXSucursal]
Carpeta=Detalle
Clave=FlyersXSucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Totalizadores).Total Promedio Recibos]
Carpeta=(Carpeta Totalizadores)
Clave=Total Promedio Recibos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.PDF]
Nombre=PDF
Boton=97
NombreEnBoton=S
NombreDesplegar=PDF
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=asign<BR>expre
[Acciones.PDF.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.PDF.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Cantidad3,SQL(<T>Select dbo.fnDM0316Calculos(:nv1,:nv2)<T>,Mavi.DM0316flyerpack,Mavi.DM0316Muestra))<BR>Asigna(Info.Cantidad2,SQL(<T>Select dbo.fnDM0316Calculos(:nv1,:nv2)<T>,Mavi.DM0316flyerpack,Mavi.DM0316sucapertura))<BR>ReportePDF(<T>DM0316Pantalla<T>,<T>(Especifico)<T>)
Activo=S
Visible=S

