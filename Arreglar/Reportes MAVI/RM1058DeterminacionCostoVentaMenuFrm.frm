[Forma]
Clave=RM1058DeterminacionCostoVentaMenuFrm
Nombre=RM1058 Determinacion de Costo de Venta
Icono=0
Modulos=(Todos)
FiltrarFechasSinHora=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Actualiza<BR>Cerrar
PosicionInicialAlturaCliente=126
PosicionInicialAncho=384
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=58
PosicionInicialIzquierda=671
PosicionInicialArriba=297
VentanaBloquearAjuste=S
BarraAcciones=S
ExpresionesAlMostrar=Asigna(Info.FechaD,   FechaTrabajo )<BR>Asigna(Info.FechaA,   FechaTrabajo )<BR>Asigna(Mavi.RM1042FamiliaFiltro,  nulo)<BR>Asigna(Mavi.RM1042OrdTraspasoPrincipal, nulo)<BR>Asigna(Mavi.RM1042TiposReportes, nulo)
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
FichaEspacioNombres=84
FichaColorFondo=Plata
FichaNombres=Arriba
FichaAlineacion=Izquierda
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>cerrar
[Acciones.Preliminar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=//((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))
EjecucionMensaje=//<T>Proporcione los Rangos De Fecha Correctamente<T>
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.Act.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Act.Act]
Nombre=Act
Boton=0
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualiza]
Nombre=Actualiza
Boton=0
NombreDesplegar=&Actualiza
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[Acciones.Preliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI (ConDatos(Info.FechaD) y ConDatos(Info.FechaA)) //y (Info.FechaD <= Info.FechaA)<BR>ENTONCES<BR>        ReportePantalla(<T>RM1058DeterminacionCostoVentaRep<T>)<BR>SINO<BR>    Error(<T>Seleccione Rango de Fechas Valido...<T>)<BR>FIN
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


