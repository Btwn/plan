
[Forma]
Clave=CONTCDevolucionesActBandfrm
Icono=0
CarpetaPrincipal=CONTCDevolucionesActBandvis
Modulos=(Todos)
Nombre=Devoluciones Masivas de NC

ListaCarpetas=CONTCDevolucionesActBandvis
PosicionInicialIzquierda=466
PosicionInicialArriba=150
PosicionInicialAlturaCliente=272
PosicionInicialAncho=537
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Activar<BR>Bitacora<BR>Exportar






Totalizadores=S
[CONTCDevolucionesActBandvis.Columnas]
MovID=124
FechaEmision=94
Cliente=64
Importe=64
OrigenID=124


[Acciones.Bitacora]
Nombre=Bitacora
Boton=58
NombreEnBoton=S
NombreDesplegar=&Bitacora Errores
EnBarraHerramientas=S
BtnResaltado=S
EspacioPrevio=S
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=CONTCBitErroresfrm
[Acciones.Activar]
Nombre=Activar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Activar 2000 Polizas
EnBarraHerramientas=S
BtnResaltado=S
TipoAccion=Expresion
Visible=S
Activo=S
RefrescarDespues=S



ConCondicion=S
Expresion=procesarsql(<T>EXEC dbo.SpCONTDevMasivNotasCreditoRep)
EjecucionCondicion=Si<BR>Confirmacion( <T>Estas seguro de continuar?<T>, BotonAceptar, BotonCancelar )  =1<BR>Entonces<BR>Verdadero                                                                                 <BR>sino<BR>abortaroperacion<BR>fin
[Acciones.Exportar]
Nombre=Exportar
Boton=115
NombreEnBoton=S
NombreDesplegar=&Exportar
RefrescarDespues=S
EnBarraHerramientas=S
BtnResaltado=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
Carpeta=CONTCDevolucionesActBandvis







[CONTCDevolucionesActBandvis]
Estilo=Hoja
Pestana=S
Clave=CONTCDevolucionesActBandvis
RefrescarAlEntrar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CONTCDevolucionesActBandvis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CONTCDevolucionesActBandtbl.MovID<BR>CONTCDevolucionesActBandtbl.FechaEmision<BR>CONTCDevolucionesActBandtbl.Cliente<BR>CONTCDevolucionesActBandtbl.Importe<BR>CONTCDevolucionesActBandtbl.OrigenID
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Devoluciones Generadas 
[CONTCDevolucionesActBandvis.CONTCDevolucionesActBandtbl.MovID]
Carpeta=CONTCDevolucionesActBandvis
Clave=CONTCDevolucionesActBandtbl.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[CONTCDevolucionesActBandvis.CONTCDevolucionesActBandtbl.FechaEmision]
Carpeta=CONTCDevolucionesActBandvis
Clave=CONTCDevolucionesActBandtbl.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CONTCDevolucionesActBandvis.CONTCDevolucionesActBandtbl.Cliente]
Carpeta=CONTCDevolucionesActBandvis
Clave=CONTCDevolucionesActBandtbl.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[CONTCDevolucionesActBandvis.CONTCDevolucionesActBandtbl.Importe]
Carpeta=CONTCDevolucionesActBandvis
Clave=CONTCDevolucionesActBandtbl.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[CONTCDevolucionesActBandvis.CONTCDevolucionesActBandtbl.OrigenID]
Carpeta=CONTCDevolucionesActBandvis
Clave=CONTCDevolucionesActBandtbl.OrigenID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Carpeta Totalizadores)]
Pestana=S
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores1=Total de Devoluciones por Actualizar<BR>Total de Devoluciones
Totalizadores2=Maximo( CONTCDevolucionesActBandvis:CONTCDevolucionesActBandtbl.idDevolucionesActBand )<BR>SQL(<T>SELECT COUNT (MovID) FROM CONTCDevolucionesActBand<T>+ <T> <T> +<T>WITH (NOLOCK)<T>)
Totalizadores3=0<BR>0
TotCarpetaRenglones=CONTCDevolucionesActBandvis
TotAlCambiar=S
ListaEnCaptura=Total de Devoluciones

PestanaOtroNombre=S
PestanaNombre=Total de Devoluciones
[(Carpeta Totalizadores).Total de Devoluciones]
Carpeta=(Carpeta Totalizadores)
Clave=Total de Devoluciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata


