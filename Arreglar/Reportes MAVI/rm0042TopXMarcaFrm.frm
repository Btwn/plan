[Forma]
Clave=rm0042TopXMarcaFrm
Nombre=RM042 Top Por Marcas
Icono=681
Modulos=(Todos)
PosicionInicialIzquierda=323
PosicionInicialArriba=367
PosicionInicialAlturaCliente=252
PosicionInicialAncho=633
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Refresh
ExpresionesAlMostrar=Asigna(Mavi.RM0042MarcasArticulos,Nulo )<BR>Asigna(Mavi.RM0042ListaLineasArt,Nulo )<BR>Asigna(Mavi.RM0042ArticuloFD,Nulo )<BR>Asigna(Mavi.RM0042ArticuloFA, Nulo )<BR>Asigna(Info.Sucursal,Nulo )<BR>Asigna(Info.Cliente,Nulo )<BR>Asigna(Mavi.RM0042FacturaCliente,Nulo )<BR>Asigna(Mavi.RM0042NSerie,Nulo )<BR>Asigna(Mavi.RM0042NomTaller,Nulo )<BR>Asigna(Mavi.RM0042OrdenTaller,Nulo )<BR>Asigna(Mavi.RM0042EstatusSoporte,Nulo )<BR>Asigna(Mavi.RM0042AnnoFiltro,Nulo)<BR>Asigna(Mavi.RM0042MesFiltro,Nulo)<BR>Asigna(Mavi.RM0042DiasFiltro,Nulo)<BR>Asigna(Mavi.RM0042Concepto,Nulo)<BR>Asigna(Mavi.RM0042FechaDel,Nulo)<BR>Asigna(Mavi.RM0042FechaAl,Nulo)
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
ListaEnCaptura=Mavi.RM0042FechaDel<BR>Mavi.RM0042FechaAl<BR>Mavi.RM0042MesFiltro<BR>Mavi.RM0042DiasFiltro<BR>Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0042ArticuloFD<BR>Mavi.RM0042ArticuloFA<BR>Mavi.RM0042MarcasArticulos<BR>Mavi.RM0042ListaLineasArt<BR>Info.Cliente<BR>Mavi.RM0042FacturaCliente<BR>Info.Sucursal<BR>MAvi.RM0042FamiliasVentaRutas<BR>Mavi.RM0042OrdenTaller<BR>Mavi.RM0042EstatusSoporte<BR>Mavi.RM0042NSerie<BR>Mavi.RM0042NomTaller<BR>Mavi.RM0042AnnoFiltro<BR>Mavi.RM0042Concepto
CarpetaVisible=S
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
EjecucionCondicion=(((Info.FechaD)<=(Info.FechaA)) o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))) y<BR>(((Mavi.ArticuloFD)<=(Mavi.ArticuloFA)) o (Vacio(Mavi.ArticuloFD) y Vacio(Mavi.ArticuloFA)) o (ConDatos(Mavi.ArticuloFD) y Vacio(Mavi.ArticuloFA)))
EjecucionMensaje=<T>Los Datos Iniciales son Mayores a los Finales<T>
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Cerrar
Activo=S
Visible=S
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
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Sucursal]
Carpeta=(Variables)
Clave=Info.Sucursal
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
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
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Refresh]
Nombre=Refresh
Boton=0
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
ConAutoEjecutar=S
GuardarAntes=S
AutoEjecutarExpresion=1
[(Variables).Mavi.RM0042MarcasArticulos]
Carpeta=(Variables)
Clave=Mavi.RM0042MarcasArticulos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042ListaLineasArt]
Carpeta=(Variables)
Clave=Mavi.RM0042ListaLineasArt
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042ArticuloFD]
Carpeta=(Variables)
Clave=Mavi.RM0042ArticuloFD
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042ArticuloFA]
Carpeta=(Variables)
Clave=Mavi.RM0042ArticuloFA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).MAvi.RM0042FamiliasVentaRutas]
Carpeta=(Variables)
Clave=MAvi.RM0042FamiliasVentaRutas
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042FacturaCliente]
Carpeta=(Variables)
Clave=Mavi.RM0042FacturaCliente
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042NSerie]
Carpeta=(Variables)
Clave=Mavi.RM0042NSerie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042NomTaller]
Carpeta=(Variables)
Clave=Mavi.RM0042NomTaller
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042OrdenTaller]
Carpeta=(Variables)
Clave=Mavi.RM0042OrdenTaller
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042EstatusSoporte]
Carpeta=(Variables)
Clave=Mavi.RM0042EstatusSoporte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042DiasFiltro]
Carpeta=(Variables)
Clave=Mavi.RM0042DiasFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042MesFiltro]
Carpeta=(Variables)
Clave=Mavi.RM0042MesFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042AnnoFiltro]
Carpeta=(Variables)
Clave=Mavi.RM0042AnnoFiltro
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042Concepto]
Carpeta=(Variables)
Clave=Mavi.RM0042Concepto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042FechaDel]
Carpeta=(Variables)
Clave=Mavi.RM0042FechaDel
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0042FechaAl]
Carpeta=(Variables)
Clave=Mavi.RM0042FechaAl
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

