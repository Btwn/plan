[Forma]
Clave=RM0156ARelFactyNotasVtaArtFrm
Nombre=RM156A Relaci�n de Facturas y Notas de Venta por Articulo
Icono=570
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=410
PosicionInicialArriba=302
PosicionInicialAlturaCliente=130
PosicionInicialAncho=540
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Mavi.RM0156ASucursal,Nulo)<BR>Asigna(Info.Cliente,Nulo)<BR>Asigna(Mavi.RM0156ACanalesVta,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Mavi.TipoMovVenta,Nulo)
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
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Mavi.RM0156ASucursal<BR>Info.Cliente<BR>Mavi.RM0156ACanalesVta<BR>Mavi.TipoMovVenta<BR>Info.FechaD<BR>Info.FechaA
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
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.TipoMovVenta]
Carpeta=(Variables)
Clave=Mavi.TipoMovVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ASIGNAR<BR>CERR
[Acciones.Preliminar.ASIGNAR]
Nombre=ASIGNAR
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.CERR]
Nombre=CERR
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=si (vacio(Mavi.RM0156ASucursal)) entonces<BR>Error(<T>Debe seleccionar m�nimo una Sucursal<T>)<BR>sino<BR>(SQL(<T>Exec sp_MaviRM0156ValidaSuc :tusu,:tsuc<T>,usuario,Mavi.RM0156ASucursal))=1 y Condatos(Mavi.RM0156ASucursal)<BR>Fin
EjecucionMensaje=<T>Verificar si tiene Acceso a las Sucursales Seleccionadas<T>
[(Variables).Mavi.RM0156ASucursal]
Carpeta=(Variables)
Clave=Mavi.RM0156ASucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0156ACanalesVta]
Carpeta=(Variables)
Clave=Mavi.RM0156ACanalesVta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

