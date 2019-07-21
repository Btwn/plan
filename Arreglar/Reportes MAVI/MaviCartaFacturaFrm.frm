[Forma]
Clave=MaviCartaFacturaFrm
Nombre=RM806 Carta Factura Contabilidad
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=144
PosicionInicialAncho=321
ListaAcciones=preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=479
PosicionInicialArriba=421
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Filtro.Factura,<T><T>)<BR>Asigna(Info.MovID,<T><T>)<BR>Asigna(Mavi.MaviRM0806Empleados,<T><T>)
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
ListaEnCaptura=Filtro.Factura<BR>Info.MovID<BR>Mavi.MaviRM0806Empleados
CarpetaVisible=S
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
[Acciones.preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(ConDatos(Mavi.MaviRM0806Empleados))y(ConDatos(Filtro.Factura))y(ConDatos(Info.MovID))y      <BR>(Si(SQL(<T>Select Mov From Venta Where Mov = :tMv And MovID = :tID<T>,Filtro.Factura,Info.MovID)<>Nulo,Verdadero,Falso))y<BR>(Si(SQL(<T>Select Personal From Personal Where Personal = :tPer<T>,Mavi.MaviRM0806Empleados)<>Nulo,Verdadero,Falso))
EjecucionMensaje=Si(Vacio(Filtro.Factura),<T>Seleccione Factura<T>,Si(Vacio(Info.MovID),<T>Seleccione Consecutivo<T>,Si(Vacio(Mavi.MaviRM0806Empleados),<T>Seleccionar el No. de Nomina!<T>,<BR>Si(SQL(<T>Select Mov From Venta Where Mov = :tMv And MovID = :tID<T>,Filtro.Factura,Info.MovID)=Nulo,<T>No Existe la <T>+Filtro.Factura+<T> <T>+Info.MovID,<BR>Si(SQL(<T>Select Personal From Personal Where Personal =:tPer<T>,Mavi.MaviRM0806Empleados)=Nulo,<T>No. de Nómina Inválido: <T>+Mavi.MaviRM0806Empleados,)))))
[Acciones.preliminar]
Nombre=preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.MaviRM0806Empleados]
Carpeta=(Variables)
Clave=Mavi.MaviRM0806Empleados
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

