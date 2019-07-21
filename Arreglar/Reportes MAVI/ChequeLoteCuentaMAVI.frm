[Forma]
Clave=ChequeLoteCuentaMAVI
Nombre=Cheques en lote
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=102
PosicionInicialAncho=205
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialIzquierda=458
PosicionInicialArriba=327
ListaAcciones=Siguente
BarraHerramientas=S
EsConsultaExclusiva=S
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
ListaEnCaptura=Info.CtaDinero
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Info.CtaDinero]
Carpeta=(Variables)
Clave=Info.CtaDinero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Siguente]
Nombre=Siguente
Boton=25
NombreEnBoton=S
NombreDesplegar=&Siguiente
EnMenu=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Froma
[Acciones.Siguente.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Siguente.Froma]
Nombre=Froma
Boton=0
TipoAccion=Formas
ClaveAccion=ChequeLoteChequesMAVI
Activo=S
Visible=S

