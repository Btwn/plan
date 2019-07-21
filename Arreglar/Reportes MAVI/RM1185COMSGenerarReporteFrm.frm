
[Forma]
Clave=RM1185COMSGenerarReporteFrm
Icono=0
Modulos=(Todos)
MovModulo=COMS
Nombre=Reporte - Analisis De Inventario

ListaCarpetas=Filtro
CarpetaPrincipal=Filtro

PosicionInicialAlturaCliente=154
PosicionInicialAncho=302
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preeliminar<BR>Cerrar<BR>CapturarDatos
PosicionInicialIzquierda=459
PosicionInicialArriba=392
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1185DiasDeVenta,)<BR>Asigna(Mavi.RM1185TipoDeReporte,)
[Filtro]
Estilo=Ficha
Clave=Filtro
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
ListaEnCaptura=Mavi.RM1185DiasDeVenta<BR>Mavi.RM1185TipoDeReporte
CarpetaVisible=S

PermiteEditar=S
[Filtro.Mavi.RM1185DiasDeVenta]
Carpeta=Filtro
Clave=Mavi.RM1185DiasDeVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preeliminar]
Nombre=Preeliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Preeliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
Expresion=Si<BR>  Mavi.RM1185TipoDeReporte = <T>Unificado<T><BR>Entonces<BR>   ReportePantalla( <T>RM1185COMSInventarioUnificadoRep<T> )<BR>Fin<BR><BR>Si<BR>  Mavi.RM1185TipoDeReporte = <T>Extendido<T><BR>Entonces<BR>   ReportePantalla( <T>RM1185COMSInventarioExtendidoRep<T> )<BR>Fin<BR><BR>Si<BR>  Mavi.RM1185TipoDeReporte = <T>Articulos Sin Costo<T><BR>Entonces<BR>   ReportePantalla( <T>RM1185COMSInventarioArtSinCostoRep<T> )<BR>Fin
EjecucionCondicion=Forma.Accion(<T>CapturarDatos<T>)<BR>Si(Vacio(Mavi.RM1185DiasDeVenta),Informacion(<T>Debe llenar el campo <Dias De Venta><T>) AbortarOperacion, Verdadero )<BR>Si(Vacio(Mavi.RM1185TipoDeReporte),Informacion(<T>Debe llenar el campo <Tipo De Reporte><T>) AbortarOperacion, Verdadero )
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.CapturarDatos]
Nombre=CapturarDatos
Boton=0
NombreDesplegar=Capturar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Filtro.Mavi.RM1185TipoDeReporte]
Carpeta=Filtro
Clave=Mavi.RM1185TipoDeReporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


