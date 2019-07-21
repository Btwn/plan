[Forma]
Clave=RM0896AlmReporteResumenEliminacionesFrm
Nombre=RM896 Estadistico de Eliminaciones de Articulos
Icono=122
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=208
PosicionInicialAncho=317
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=481
PosicionInicialArriba=359
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna(Mavi.RM0896EmbMovTipoPocket,nulo)<BR>Asigna(Mavi.RM0896MovEmbarque,nulo)<BR>Asigna(Mavi.RM0896FechaI,nulo)<BR>Asigna(MAvi.RM0896FechaF,nulo)<BR>Asigna(Mavi.RM0896AlmacenIdEmbarque,nulo)
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
ListaEnCaptura=Mavi.RM0896EmbMovTipoPocket<BR>Mavi.RM0896MovEmbarque<BR>Mavi.RM0896FechaI<BR>Mavi.RM0896FechaF<BR>Mavi.RM0896AlmacenIdEmbarque
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ConFuenteEspecial=S
PermiteEditar=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=<T>Aceptar <T>
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviAlmReporteResumenCapEmbarqFisicoRep
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaVars<BR>ExisteMov<BR>Lamareporte
[Acciones.Aceptar.ExisteMov]
Nombre=ExisteMov
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=si(((condatos(Mavi.RM0896EmbMovTipoPocket)) y (condatos(Mavi.RM0896MovEmbarque)) y (vacio(Mavi.RM0896AlmacenIdEmbarque)) y (Mavi.RM0896EmbMovTipoPocket=<T>Reporte Servicio<T>)),Asigna(Mavi.RM0896AlmacenIdEmbarque,(SQl(<T>Select ID from Soporte Where Mov=:tval1 and MovID=:tval2<T>,Mavi.RM0896EmbMovTipoPocket,Mavi.RM0896MovEmbarque))),<T><T>)<BR>si(((condatos(Mavi.RM0896EmbMovTipoPocket)) y (condatos(Mavi.RM0896MovEmbarque)) y (vacio(Mavi.RM0896AlmacenIdEmbarque)) y (Mavi.RM0896EmbMovTipoPocket <> <T>Reporte Servicio<T>)),Asigna(Mavi.RM0896AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where Mov=:tval1 and MovID=:tval2<T>,Mavi.RM0896EmbMovTipoPocket,Mavi.RM0896MovEmbarque))),<T><T>)<BR>si(((condatos(Mavi.RM0896EmbMovTipoPocket)) y (vacio(Mavi.RM0896MovEmbarque)) y (condatos(Mavi.RM0896Alm<CONTINUA>
Expresion002=<CONTINUA>acenIdEmbarque)) y (Mavi.RM0896EmbMovTipoPocket = <T>Reporte Servicio<T>)),Asigna(Mavi.RM0896AlmacenIdEmbarque,(SQl(<T>Select ID from Soporte Where ID=:nval2 and Mov=:tval3<T>,Mavi.RM0896AlmacenIdEmbarque,Mavi.RM0896EmbMovTipoPocket))),<T><T>)<BR>si(((condatos(Mavi.RM0896EmbMovTipoPocket)) y (vacio(Mavi.RM0896MovEmbarque)) y (condatos(Mavi.RM0896AlmacenIdEmbarque)) y (Mavi.RM0896EmbMovTipoPocket <> <T>Reporte Servicio<T>)),Asigna(Mavi.RM0896AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where ID=:nval2 and Mov=:tval3<T>,Mavi.RM0896AlmacenIdEmbarque,Mavi.RM0896EmbMovTipoPocket))),<T><T>)<BR>si(condatos(Mavi.RM0896AlmacenIdEmbarque),Asigna(Info.Mov,Mavi.RM0896EmbMovTipoPocket),<T><T>)
[Acciones.Aceptar.Lamareporte]
Nombre=Lamareporte
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(condatos(Mavi.RM0896AlmacenIdEmbarque) y condatos(Info.Mov)) o (vacio(Mavi.RM0896AlmacenIdEmbarque) y vacio(Mavi.RM0896EmbMovTipoPocket))
EjecucionMensaje=<T>No existe el Movimiento<T>
[Acciones.Aceptar.AsignaVars]
Nombre=AsignaVars
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.RM0896EmbMovTipoPocket]
Carpeta=(Variables)
Clave=Mavi.RM0896EmbMovTipoPocket
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0896MovEmbarque]
Carpeta=(Variables)
Clave=Mavi.RM0896MovEmbarque
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0896FechaI]
Carpeta=(Variables)
Clave=Mavi.RM0896FechaI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0896FechaF]
Carpeta=(Variables)
Clave=Mavi.RM0896FechaF
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0896AlmacenIdEmbarque]
Carpeta=(Variables)
Clave=Mavi.RM0896AlmacenIdEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


