[Forma]
Clave=MaviAlmReporteResumenRetEmbarqFisicoFrm
Nombre=RM828  Retorno de Mercancia
Icono=602
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=120
PosicionInicialAncho=226
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=527
PosicionInicialArriba=438
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna(Mavi.EmbMovTipo,nulo)<BR>Asigna(Mavi.MovEmbarque,nulo)
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
ListaEnCaptura=Mavi.EmbMovTipo<BR>Mavi.MovEmbarque
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ConFuenteEspecial=S
PermiteEditar=S
[(Variables).Mavi.EmbMovTipo]
Carpeta=(Variables)
Clave=Mavi.EmbMovTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[(Variables).Mavi.MovEmbarque]
Carpeta=(Variables)
Clave=Mavi.MovEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
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
ListaAccionesMultiples=AsignaVars<BR>ExisteMov<BR>AsignaDatos<BR>Lamareporte
[Acciones.Aceptar.ExisteMov]
Nombre=ExisteMov
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,(SQl(<T>Select ID from Embarque Where Mov=:tval1 and MovID=:tval2<T>,Mavi.EmbMovTipo,Mavi.MovEmbarque)))<BR>Asigna(Info.Mov,Mavi.EmbMovTipo)
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
EjecucionCondicion=condatos(Mavi.AlmacenIdEmbarque) y condatos(Mavi.EmbMovTipo) y condatos(Mavi.MovEmbarque)
EjecucionMensaje=<T>No existe el Movimiento<T>
[Acciones.Aceptar.AsignaVars]
Nombre=AsignaVars
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


