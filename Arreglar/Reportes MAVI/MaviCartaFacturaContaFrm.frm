[Forma]
Clave=MaviCartaFacturaContaFrm
Nombre=RM806 Carta Factura Contabilidad
Icono=0
Modulos=(Todos)
PosicionInicialAlturaCliente=126
PosicionInicialAncho=320
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=480
PosicionInicialArriba=307
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=asigna(Filtro.Factura,<T><T>)<BR>asigna(Info.MovID,<T><T>)<BR>asigna(Mavi.Nomina,Nulo)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar / Ventana Aceptar
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
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
CarpetaVisible=S
ListaEnCaptura=Filtro.Factura<BR>Info.MovID<BR>Mavi.Nomina
[(Variables).Filtro.Factura]
Carpeta=(Variables)
Clave=Filtro.Factura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[(Variables).Mavi.Nomina]
Carpeta=(Variables)
Clave=Mavi.Nomina
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
ClaveAccion=variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=(ConDatos(Mavi.Nomina))y(ConDatos(Filtro.Factura))y(ConDatos(Info.MovID))y<BR>(Si(SQL(<T>Select Mov From Venta Where Mov = :tMv And MovID = :tID<T>,Filtro.Factura,Info.MovID)<>Nulo,Verdadero,Falso))y<BR>(Si(SQL(<T>Select Personal From Personal Where Personal = :tPer<T>,Mavi.Nomina)<>Nulo,Verdadero,Falso))<BR><BR>//(Si((ConDatos(Filtro.Factura))y(ConDatos(Info.MovID)),
EjecucionMensaje=Si(Vacio(Filtro.Factura),<T>Seleccione Factura<T>,Si(Vacio(Info.MovID),<T>Seleccione Consecutivo<T>,Si(Vacio(Mavi.Nomina),<T>Seleccionar el No. de Nomina!<T>,<BR>Si(SQL(<T>Select Mov From Venta Where Mov = :tMv And MovID = :tID<T>,Filtro.Factura,Info.MovID)=Nulo,<T>No Existe la <T>+Filtro.Factura+<T> <T>+Info.MovID,<BR>Si(SQL(<T>Select Personal From Personal Where Personal =:tPer<T>,Mavi.Nomina)=Nulo,<T>No. de Nómina Inválido: <T>+Mavi.Nomina,)))))<BR><BR><BR>//(Si(SQL(<T>Select Mov From Venta Where Mov = :tMv And MovID = :tID<T>,Filtro.Factura,Info.MovID)<>Nulo,Verdadero,Falso))

