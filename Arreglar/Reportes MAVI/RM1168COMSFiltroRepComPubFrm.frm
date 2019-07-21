
[Forma]
Clave=RM1168COMSFiltroRepComPubFrm
Icono=134
Modulos=(Todos)
MovModulo=COMS
Nombre=<T>Generador De Reportes<T>

ListaCarpetas=FiltrosDimasTiendasVirtuales
CarpetaPrincipal=FiltrosDimasTiendasVirtuales
PosicionInicialIzquierda=253
PosicionInicialArriba=301
PosicionInicialAlturaCliente=254
PosicionInicialAncho=500




BarraAcciones=S
AccionesTamanoBoton=20x5
ListaAcciones=GenerarReporte<BR>LimpiarCampos
AccionesCentro=S
AccionesDivision=S
[principal.Columnas]
Articulo=124
Descripcion1=604
0=-2
Familia=304

[FiltrosDimasTiendasVirtuales]
Estilo=Ficha
Clave=FiltrosDimasTiendasVirtuales
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
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1168TipoAuditoria<BR>Mavi.RM1168Departamento<BR>Mavi.RM1168Familia<BR>Mavi.RM1168Linea
CarpetaVisible=S

[FiltrosDimasTiendasVirtuales.Mavi.RM1168TipoAuditoria]
Carpeta=FiltrosDimasTiendasVirtuales
Clave=Mavi.RM1168TipoAuditoria
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[FiltrosDimasTiendasVirtuales.Mavi.RM1168Familia]
Carpeta=FiltrosDimasTiendasVirtuales
Clave=Mavi.RM1168Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[FiltrosDimasTiendasVirtuales.Mavi.RM1168Linea]
Carpeta=FiltrosDimasTiendasVirtuales
Clave=Mavi.RM1168Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Acciones.GenerarReporte.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarReporte]
Nombre=GenerarReporte
Boton=0
NombreEnBoton=S
NombreDesplegar=Generar Reporte
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Capturar<BR>Reporte
Activo=S
Visible=S





[FiltrosDimasTiendasVirtuales.Mavi.RM1168Departamento]
Carpeta=FiltrosDimasTiendasVirtuales
Clave=Mavi.RM1168Departamento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco


[Acciones.GenerarReporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Mavi.RM1168TipoAuditoria = <T>DIMAS<T><BR>Entonces<BR>      Si<BR>      ConDatos(Mavi.RM1168Departamento)<BR>    Entonces<BR>      ReportePantalla(<T>RM1168ComprasDIMASRep<T>)<BR>    Sino<BR>      ReportePantalla(<T>RM1168COMSDIMASResumenRep<T>)<BR>    Fin<BR>Sino<BR>      Si<BR>      ConDatos(Mavi.RM1168Departamento)<BR>    Entonces<BR>      ReportePantalla(<T>RM1168ComprasTiendaVirtualRep<T>)<BR>    Sino<BR>      ReportePantalla(<T>RM1168COMSTiendaVirtualResumenRep<T>)<BR>Fin


[Acciones.LimpiarCampos]
Nombre=LimpiarCampos
Boton=0
NombreEnBoton=S
NombreDesplegar=&Limpiar Campos
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1168Familia,nulo)<BR>Asigna(Mavi.RM1168Linea,nulo)<BR>Asigna(Mavi.RM1168Departamento,nulo)  <BR>ActualizarForma(<T>RM1168COMSFiltroRepComPubFrm<T>)
