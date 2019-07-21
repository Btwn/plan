[Forma]
Clave=MaviAbaRecUnidProvsFrm
Nombre=RM064 Recepción de Unidades de Proveedores
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=337
PosicionInicialArriba=268
PosicionInicialAlturaCliente=197
PosicionInicialAncho=350
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Actualiza
Comentarios=Captura los Datos Solicitados
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.FamiliasVentaRutas,NULO)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.FormasDeEntregaArt,NULO)<BR>Asigna(Mavi.FiltarPor,<T>Fecha Entrega<T>)<BR>Asigna(Mavi.LineasVentas,NULO)
ExpresionesAlCerrar=si(Mavi.FiltarPor=<T>Fecha Requerida<T>,Asigna(Mavi.RececionUnid,<T>Pendiente<T>),Asigna(Mavi.RececionUnid,<T>Concluido<T>))<BR>si(Mavi.FiltarPor=<T>Fecha Requerida<T>,Asigna(Mavi.MovRecUnidProvs,<T>Orden Compra<T>),Asigna(Mavi.MovRecUnidProvs,<T>Entrada Compra<T>))
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
FichaEspacioEntreLineas=5
FichaEspacioNombres=67
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Blanco
ListaEnCaptura=Mavi.FiltarPor<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.FamiliasVentaRutas<BR>Mavi.LineasVentas<BR>Mavi.FormasDeEntregaArt
FichaEspacioNombresAuto=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.LineasVentas]
Carpeta=(Variables)
Clave=Mavi.LineasVentas
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.FiltarPor]
Carpeta=(Variables)
Clave=Mavi.FiltarPor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.FormasDeEntregaArt]
Carpeta=(Variables)
Clave=Mavi.FormasDeEntregaArt
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))   <BR>/*ConDatos(Info.FechaD) O CONDATOS(Info.FechaA)*/
EjecucionMensaje=Si  ((Info.FechaA)<(Info.FechaD)) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>     <BR><BR><BR>/*Si (Condatos(Info.FechaD)) y (VACIO(Info.FechaA))<BR>ENTONCES <T>Fecha2<T><BR><BR>fin*/<BR><BR><BR>/*<BR>Si<BR>  (Condatos(Info.FechaD)) y (9VACIO(Info.FechaA))<BR>Entonces<BR>  <T>e<T><BR>Sino<BR>  <T>r<T><BR>Fin*/
[(Variables).Mavi.FamiliasVentaRutas]
Carpeta=(Variables)
Clave=Mavi.FamiliasVentaRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualiza]
Nombre=Actualiza
Boton=-1
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1

