[Forma]
Clave=MaviAlmDetalleFisicoEmbarqueFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=602
Modulos=(Todos)
ListaCarpetas=Facturas<BR>Articulos
CarpetaPrincipal=Articulos
PosicionInicialAlturaCliente=241
PosicionInicialAncho=240
PosicionInicialIzquierda=0
PosicionInicialArriba=0
Menus=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=82
VentanaTipoMarco=Normal
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ListaAcciones=Aceptar<BR>CapturaDatos<BR>Elimina<BR>Cambia<BR>Actualizar
Comentarios=<T>Embarque<T>
VentanaSinIconosMarco=S
;MODIFICACION VICTOR DE LOS SANTOS PARA QUE PERMITA MANIPULAR LA VENTANA 05/05/2011
;VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.ID,nulo)<BR>Asigna(Filtro.actividad,1)
ExpresionesAlCerrar=Asigna(Mavi.AlmacenIdEmbarque,nulo)
[Facturas]
Estilo=Iconos
Clave=Facturas
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=MaviAlmDetalleFisicoEmbarqueVis
Fuente={Tahoma, 7, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Captura Fisica
ConFuenteEspecial=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Factura(s)<T>
ElementosPorPagina=200
;RefrescarAlEntrar=N
IconosNombre=MaviAlmDetalleFisicoEmbarqueVis:Factura
[Facturas.Columnas]
Factura=47
0=-2
1=-2
[Acciones.Captura Fisica]
Nombre=Captura Fisica
Boton=0
NombreDesplegar=Captura de Articulos
EnMenu=S
TipoAccion=Formas
ClaveAccion=MaviAlmCapturaEmbarqueFisicoFrm
Multiple=S
ListaAccionesMultiples=Asigna<BR>Forma<BR>ActualizaVista
ConCondicion=S
EjecucionConError=S
ActivoCondicion=Vacio(SQL(<T>Select situacion from VerMovTiempo Where ID=:nval1 and Modulo=:tval2 and Situacion=:tval3<T>,Mavi.AlmacenIdEmbarque,<T>EMB<T>,<T>Revisión de Escaneo<T>))
EjecucionCondicion=Vacio(SQL(<T>Select situacion from VerMovTiempo Where ID=:nval1 and Modulo=:tval2 and Situacion=:tval3<T>,Mavi.AlmacenIdEmbarque,<T>EMB<T>,<T>Revisión de Escaneo<T>))
EjecucionMensaje=<T>No es posible editar<T>
VisibleCondicion=Vacio(SQL(<T>Select situacion from VerMovTiempo Where ID=:nval1 and Modulo=:tval2 and Situacion=:tval3<T>,Mavi.AlmacenIdEmbarque,<T>EMB<T>,<T>Revisión de Escaneo<T>))
[Articulos]
Estilo=Iconos
Clave=Articulos
AlineacionAutomatica=S
AcomodarTexto=S
Zona=B1
Vista=MaviAlmCapturaEmbarqueFisicoVis
ConFuenteEspecial=S
Fuente={Tahoma, 7, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Detalle=S
VistaMaestra=MaviAlmDetalleFisicoEmbarqueVis
LlaveLocal=MaviAlmCapturaEmbarqueFisicoTbl.IDEmbarque
LlaveMaestra=IDEmbarque
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Articulo<T>
ElementosPorPagina=200
MenuLocal=S
ListaAcciones=Actualizar Vista
ListaEnCaptura=MaviAlmCapturaEmbarqueFisicoTbl.Articulo<BR>MaviAlmCapturaEmbarqueFisicoTbl.Serie
OtroOrden=S
ListaOrden=MaviAlmCapturaEmbarqueFisicoTbl.FechaRegistro<TAB>(Acendente)
RefrescarAlEntrar=S
IconosNombre=MaviAlmCapturaEmbarqueFisicoVis:CB.Cuenta
[Articulos.Columnas]
Factura=47
Articulo=71
Serie=145
0=69
1=77
2=72
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
[Acciones.Captura Fisica.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=MaviAlmCapturaEmbarqueFisicoFrm
Activo=S
Visible=S
[Acciones.Captura Fisica.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque)<BR>//Informacion(Mavi.AlmCapturaDetalleFisicoFact)<BR>//Asigna(Mavi.AlmRefrescaCapturaFisica,0)
[Acciones.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
NombreDesplegar=<T>Actualizar<T>
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
TeclaFuncion=F5
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreDesplegar=<T>Actualizar<T>
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Visible=S
UsaTeclaRapida=S
TeclaRapida=F5
TeclaFuncion=F5
EnBarraHerramientas=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Pasa a Escanear<T>))
EjecucionCondicion=(((SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Pasa a Escanear<T>) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Revision de Escaneo<T>) )o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Completar<T>)))
EjecucionMensaje=<T>Situacion  debe ser Pasa a Escanear o Revision de Escaneo<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Procesar.Proceso]
Nombre=Proceso
Boton=0
TipoAccion=Expresion
Expresion=Asigna()
Activo=S
Visible=S
[Acciones.Procesar.Afectarr]
Nombre=Afectarr
Boton=0
Activo=S
Visible=S
[Acciones.Captura Fisica.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Articulos.MaviAlmCapturaEmbarqueFisicoTbl.Serie]
Carpeta=Articulos
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CapturaDatos]
Nombre=CapturaDatos
Boton=39
NombreDesplegar=Capturar
EnBarraHerramientas=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignaciones<BR>Forma<BR>ActualizaVis
ActivoCondicion=((SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Pasa a Escanear<T>) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Revision de Escaneo<T>)) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Completar<T>))
[Acciones.CapturaDatos.Asignaciones]
Nombre=Asignaciones
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmacenIdEmbarque,MaviAlmDetalleFisicoEmbarqueVis:IDEmbarque)<BR>Asigna(Mavi.AlmacenIdFactura,MaviAlmDetalleFisicoEmbarqueVis:IDFactuta)<BR>Asigna(Mavi.Factura,MaviAlmDetalleFisicoEmbarqueVis:Mov)
[Acciones.CapturaDatos.Forma]
Nombre=Forma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmCapturaEmbarqueFisicoFrm<T>)
[Acciones.Elimina]
Nombre=Elimina
Boton=32
NombreDesplegar=<T>Elimina Capturas<T>
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
Multiple=S
ListaAccionesMultiples=FormaPassWD<BR>ActualizaVisElim
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (((SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Pasa a Escanear<T>) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Revision de Escaneo<T>)) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Completar<T>))))
[Acciones.Cambia]
Nombre=Cambia
Boton=59
EnBarraHerramientas=S
Visible=S
NombreDesplegar=<T>Modifica Captura<T>
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=FormaCambia<BR>ActualizaCambia
ActivoCondicion=Asigna(Info.Id,(SQL(<T>Select IDEmbarque from MAVIEmbarqueFisicoAlmacen Where IDEmbarque=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>(Condatos(Info.Id) y (((SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Pasa a Escanear<T>) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Revision de Escaneo<T>)) o (SQL(<T>Select situacion from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)=<T>Completar<T>))))
[Articulos.MaviAlmCapturaEmbarqueFisicoTbl.Articulo]
Carpeta=Articulos
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CapturaDatos.ActualizaVis]
Nombre=ActualizaVis
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Elimina.FormaPassWD]
Nombre=FormaPassWD
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmPassModificacionesFrm<T>)
Activo=S
Visible=S
[Acciones.Elimina.ActualizaVisElim]
Nombre=ActualizaVisElim
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Cambia.FormaCambia]
Nombre=FormaCambia
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmCambiaCapturaEmbarqueFisicoFrm<T>)
[Acciones.Cambia.ActualizaCambia]
Nombre=ActualizaCambia
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
