[Forma]
Clave=MaviVentFacturasDiariasFrm
Nombre=RM120B Reporte de Facturas Diarias
Icono=152
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=352
PosicionInicialArriba=255
PosicionInicialAlturaCliente=230
PosicionInicialAncho=320
VentanaTipoMarco=Normal
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=asigna(mavi.gerencia,<T><T>)<BR>asigna(mavi.division,<T><T>)<BR>asigna(mavi.equipo,<T><T>)<BR>asigna(mavi.sucursalve,<T><T>)<BR>asigna(mavi.celula,<T><T>)<BR>Asigna(Mavi.EstatusConCan,Nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.SucursalVE<BR>Mavi.EstatusConCan<BR>Mavi.Gerencia<BR>Mavi.Division<BR>Mavi.Celula<BR>Mavi.Equipo
CarpetaVisible=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=0
FichaColorFondo=Negro
PermiteEditar=S
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
Efectos=[Negritas]
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
Efectos=[Negritas]
[(Variables).Mavi.Gerencia]
Carpeta=(Variables)
Clave=Mavi.Gerencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Efectos=[Negritas]
[(Variables).Mavi.Division]
Carpeta=(Variables)
Clave=Mavi.Division
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Mavi.Equipo]
Carpeta=(Variables)
Clave=Mavi.Equipo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Mavi.SucursalVE]
Carpeta=(Variables)
Clave=Mavi.SucursalVE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Efectos=[Negritas]
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
[(Variables).Mavi.Celula]
Carpeta=(Variables)
Clave=Mavi.Celula
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Mavi.EstatusConCan]
Carpeta=(Variables)
Clave=Mavi.EstatusConCan
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
