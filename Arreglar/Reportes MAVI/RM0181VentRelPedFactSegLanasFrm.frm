[Forma]
Clave=RM0181VentRelPedFactSegLanasFrm
Nombre=RM0181 Relaci�n Pedidos Facturados Seguros Credilanas
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=411
PosicionInicialArriba=374
PosicionInicialAlturaCliente=242
PosicionInicialAncho=457
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>act
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM0181GerenciaVI,<T><T>)<BR>Asigna(Mavi.RM0181DIVIDivisiones,<T><T>)<BR>Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)<BR>Asigna(Mavi.RM0181CelulaVI,<T><T>)<BR>Asigna(Mavi.RM0181EquipoVI,<T><T>)<BR>Asigna(Mavi.RM0181TipoMov,<T><T>)<BR>Asigna(Mavi.RM0181SucursalVE,<T><T>)
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
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0181TipoMov<BR>Mavi.RM0181SucursalVE<BR>Mavi.RM0181GerenciaVI<BR>Mavi.RM0181DIVIDivisiones<BR>Mavi.RM0181CelulaVI<BR>Mavi.RM0181EquipoVI
CarpetaVisible=S
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
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
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
ConCondicion=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))
EjecucionMensaje=Si ((Info.FechaA)<(Info.FechaD)) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>
EjecucionConError=S
Visible=S
[Acciones.act]
Nombre=act
Boton=0
NombreDesplegar=act
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[(Variables).Mavi.RM0181CelulaVI]
Carpeta=(Variables)
Clave=Mavi.RM0181CelulaVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0181DIVIDivisiones]
Carpeta=(Variables)
Clave=Mavi.RM0181DIVIDivisiones
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0181EquipoVI]
Carpeta=(Variables)
Clave=Mavi.RM0181EquipoVI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0181GerenciaVI]
Carpeta=(Variables)
Clave=Mavi.RM0181GerenciaVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0181SucursalVE]
Carpeta=(Variables)
Clave=Mavi.RM0181SucursalVE
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0181TipoMov]
Carpeta=(Variables)
Clave=Mavi.RM0181TipoMov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

