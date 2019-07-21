[Forma]
Clave=MaviAlmReporteResumenCapturaServiciosFrm
Nombre=RM0857 Retorno de Servicios
Icono=631
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=83
PosicionInicialAncho=304
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=488
PosicionInicialArriba=453
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna(Mavi.AlmIdServiciosAlmacen,nulo)<BR>Asigna(Info.MovID,nulo)
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
ListaEnCaptura=Info.MovID
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
Expresion=Asigna(Mavi.AlmIdServiciosAlmacen,(SQl(<T>Select ID from soporte Where Mov=:tval1 and MovID=:tval2<T>,<T>Reporte Servicio<T>,Info.MovID)))
[Acciones.Aceptar.Lamareporte]
Nombre=Lamareporte
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=condatos(Mavi.AlmIdServiciosAlmacen) y (condatos(Info.MovId))
EjecucionMensaje=<T>Ingresar un Reporte de Servicio adecuado!<T>
[Acciones.Aceptar.AsignaVars]
Nombre=AsignaVars
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Info.MovID]
Carpeta=(Variables)
Clave=Info.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


