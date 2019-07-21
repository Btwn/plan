[Forma]
Clave=RM0827AlmReporteResumenCapEmbarqFisicoFrm
Nombre=RM827 Escaneo de Embarques
Icono=602
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=183
PosicionInicialAncho=295
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=492
PosicionInicialArriba=403
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM0827EmbMovTipo,nulo)<BR>Asigna(Mavi.RM0827MovEmbarque,nulo)<BR>Asigna(Mavi.RM0827AlmacenIdEmbarque,nulo)
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
ListaEnCaptura=Mavi.RM0827EmbMovTipo<BR>Mavi.RM0827MovEmbarque<BR>Mavi.RM0827AlmacenIdEmbarque
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
NombreDesplegar=&Aceptar 
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviAlmReporteResumenCapEmbarqFisicoRep
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=AsignaVars<BR>ExisteMov<BR>AsignaDatos<BR>Lamareporte
[Acciones.Aceptar.ExisteMov]
Nombre=ExisteMov
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarForma<BR>si(((condatos(Mavi.RM0827EmbMovTipo) y condatos(Mavi.RM0827MovEmbarque)) y (vacio(Mavi.RM0827AlmacenIdEmbarque))),Asigna(Mavi.RM0827AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where Mov=:tval1 and MovID=:tval2<T>,Mavi.RM0827EmbMovTipo,Mavi.RM0827MovEmbarque))),<T><T>)<BR>si(((condatos(Mavi.RM0827EmbMovTipo) y condatos(Mavi.RM0827MovEmbarque)) y (vacio(Mavi.RM0827AlmacenIdEmbarque))),Asigna(Info.Mov,Mavi.RM0827EmbMovTipo),<T><T>)<BR>//Asigna(Info.Mov,Mavi.RM0827EmbMovTipo)<BR>si(((condatos(Mavi.RM0827AlmacenIdEmbarque)) y (vacio(Mavi.RM0827EmbMovTipo) y vacio(Mavi.RM0827MovEmbarque))),Asigna(Mavi.RM0827AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where ID=:nval1<T>,Mavi.RM0827AlmacenIdEmbarque))),<T><T>)<BR>si(((condatos(Mavi.RM0827AlmacenIdEmbarque)) y (<CONTINUA>
Expresion002=<CONTINUA>vacio(Mavi.RM0827EmbMovTipo) y vacio(Mavi.RM0827MovEmbarque))),Asigna(Info.Mov,(SQl(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.RM0827AlmacenIdEmbarque))),<T><T>)<BR><BR>si(((condatos(Mavi.RM0827AlmacenIdEmbarque)) y (condatos(Mavi.RM0827EmbMovTipo) y vacio(Mavi.RM0827MovEmbarque))),Asigna(Mavi.RM0827AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where ID=:nval1<T>,Mavi.RM0827AlmacenIdEmbarque))),<T><T>)<BR>si(((condatos(Mavi.RM0827AlmacenIdEmbarque)) y (condatos(Mavi.RM0827EmbMovTipo) y vacio(Mavi.RM0827MovEmbarque))),Asigna(Info.Mov,(SQl(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.RM0827AlmacenIdEmbarque))),<T><T>)<BR>//informacion(Mavi.RM0827EmbMovTipo)  //embarque sucursales<BR>//informacion(Mavi.RM0827MovEmbarque) //<BR>//informacion(Mavi.RM0827AlmacenIdEmbarque)   <CONTINUA>
Expresion003=<CONTINUA> //2773
[Acciones.Aceptar.AsignaDatos]
Nombre=AsignaDatos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
[Acciones.Aceptar.Lamareporte]
Nombre=Lamareporte
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(condatos(Mavi.RM0827AlmacenIdEmbarque) y condatos(Mavi.RM0827EmbMovTipo)y (sql(<T>select mov from embarque where id=:nid<T>,Mavi.RM0827AlmacenIdEmbarque)=Mavi.RM0827EmbMovTipo) )
EjecucionMensaje=<T>No Existe Movimiento<T>
[Acciones.Aceptar.AsignaVars]
Nombre=AsignaVars
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.RM0827EmbMovTipo]
Carpeta=(Variables)
Clave=Mavi.RM0827EmbMovTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0827MovEmbarque]
Carpeta=(Variables)
Clave=Mavi.RM0827MovEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0827AlmacenIdEmbarque]
Carpeta=(Variables)
Clave=Mavi.RM0827AlmacenIdEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


