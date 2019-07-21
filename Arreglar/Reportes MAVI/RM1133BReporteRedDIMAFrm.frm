[Forma]
Clave=RM1133BReporteRedDIMAFrm
Nombre=Desglose Red DIMA
Icono=363
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=145
PosicionInicialAncho=250
PosicionInicialIzquierda=348
PosicionInicialArriba=418
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Mavi.RM1133FechaFin, Hoy ),<BR>  Asigna( Mavi.RM1133FechaIni,Hoy )
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
ListaEnCaptura=Mavi.RM1133FechaIni<BR>Mavi.RM1133FechaFin
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=18
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Rango de Fechas


[Acciones.Aceptar]
Nombre=Aceptar
Boton=108
NombreEnBoton=S
NombreDesplegar=&Mostrar Reporte
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S

[(Variables).Mavi.RM1133FechaIni]
Carpeta=(Variables)
Clave=Mavi.RM1133FechaIni
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1133FechaFin]
Carpeta=(Variables)
Clave=Mavi.RM1133FechaFin
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


