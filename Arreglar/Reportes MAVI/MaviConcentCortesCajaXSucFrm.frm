[Forma]
Clave=MaviConcentCortesCajaXSucFrm
Nombre=RM556 Concentrado de Cortes de Caja Por Sucursal
Icono=126
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=409
PosicionInicialArriba=433
PosicionInicialAlturaCliente=129
PosicionInicialAncho=461
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
VentanaEscCerrar=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Mavi.SucursalD,Nulo)<BR>Asigna(Mavi.SucursalA,Nulo)<BR>//Asigna(Info.Sucursal,Nulo)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>//Asigna(Mavi.caracter1,Nulo)<BR>//Asigna(Mavi.caracter2,Nulo)<BR>//Asigna(Mavi.caracteres,Nulo)
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
FichaEspacioEntreLineas=7
FichaEspacioNombres=51
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.SucursalD<BR>Mavi.SucursalA<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioNombresAuto=S
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
ListaAccionesMultiples=Asignar<BR>Cerrar
GuardarAntes=S
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
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))) y  <BR>(((Mavi.SucursalD)<=(Mavi.SucursalA))o (Vacio(Mavi.SucursalD) y Vacio(Mavi.SucursalA)) o (ConDatos(Mavi.SucursalD) y Vacio(Mavi.SucursalA)))
EjecucionMensaje=<T>Alguno de los Parametros se Encuentran Fuera de Rango<T>
[(Variables).Mavi.SucursalA]
Carpeta=(Variables)
Clave=Mavi.SucursalA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.SucursalD]
Carpeta=(Variables)
Clave=Mavi.SucursalD
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

