[Forma]
Clave=RepCampana
Nombre=RepCampana
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
PosicionInicialAlturaCliente=73
PosicionInicialAncho=306
ListaAcciones=Vista Correo<BR>Vista Telefonica
PosicionInicialIzquierda=339
PosicionInicialArriba=228
AccionesDerecha=S
AccionesDivision=S
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
ListaEnCaptura=Info.CampanaMovId
CarpetaVisible=S
[(Variables).Info.CampanaMovId]
Carpeta=(Variables)
Clave=Info.CampanaMovId
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Vista Preliminar.Asignar]
Nombre=Asignar
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Vista Preliminar.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=CAMPANA
Activo=S
Visible=S
[Acciones.Vista Correo]
Nombre=Vista Correo
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar2<BR>Rep2
Activo=S
Visible=S
[Acciones.Vista Telefonica.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Vista Telefonica.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=CampanaTelefonica
Activo=S
Visible=S
[Acciones.Vista Telefonica]
Nombre=Vista Telefonica
Boton=43
NombreEnBoton=S
NombreDesplegar=Vista Telefonica
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>rep
Activo=S
EspacioPrevio=S
[Acciones.Vista Correo.Rep2]
Nombre=Rep2
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=CampanaCorreo
[Acciones.Vista Correo.Asignar2]
Nombre=Asignar2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
