[Forma]
Clave=RepRelacion
Nombre=Relacion Cheque Mayoreo
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=(Variables)
ListaAcciones=Vista Preliminar
PosicionInicialAlturaCliente=98
PosicionInicialAncho=279
PosicionInicialIzquierda=447
PosicionInicialArriba=307
ListaCarpetas=(Variables)
[(Variables).Info.EmbarqueMovId]
Carpeta=(Variables)
Clave=Info.EmbarqueMovId
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Vista Preliminar]
Nombre=Vista Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Vista Prelimiar
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=Relacion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Rep
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
ListaEnCaptura=Info.EmbarqueMovId
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Acciones.Vista Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Vista Preliminar.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=Relacion
Activo=S
Visible=S

