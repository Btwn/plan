[Forma]
Clave=AgenteFamMAVI
Nombre=Familias de Agentes
Icono=0
Modulos=INV
AccionesTamanoBoton=14x5
AccionesDerecha=S
ListaCarpetas=Lista
CarpetaPrincipal=Lista
ListaAcciones=Seleccionar<BR>Cerrar
PosicionInicialIzquierda=494
PosicionInicialArriba=224
PosicionInicialAltura=309
PosicionInicialAncho=292
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
ExpresionesAlMostrar=
ExpresionesAlCerrar=
BarraHerramientas=S
PosicionSeccion1=43
PosicionColumna1=46
VentanaEscCerrar=
PosicionInicialAlturaCliente=318

[Lista]
Estilo=Iconos
PestanaNombre=Lista
Clave=Lista
AlineacionAutomatica=S
AcomodAgenteexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=AgenteFamMAVI
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=AgenteFam.Familia
CarpetaVisible=S
PermiteEditar=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200

[Lista.AgenteFam.Familia]
Carpeta=Lista
Clave=AgenteFam.Familia
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
Tamano=45
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.AgenteFam.Familia]
Carpeta=Detalle
Clave=AgenteFam.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
Efectos=[Negritas]

[Detalle.AgenteFam.Icono]
Carpeta=Detalle
Clave=AgenteFam.Icono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10

[Lista.Columnas]
Familia=263
Descripcion=310
Precios=40
0=-2


[Detalle.Columnas]
Familia=64
Descripcion=304
Icono=64

[Detalle.AgenteFam.FamiliaMaestra]
Carpeta=Detalle
Clave=AgenteFam.FamiliaMaestra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[AgenteFamD.AgenteFamD.TipoPropiedad]
Carpeta=AgenteFamD
Clave=AgenteFamD.TipoPropiedad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[AgenteFamD.Columnas]
TipoPropiedad=194

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
GuardarAntes=S
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
ConCondicion=S
EjecucionCondicion=Asigna(Temp.Texto, ListaBuscarDuplicados(CampoEnLista(AgenteFam:AgenteFam.Familia)))<BR>Vacio(Temp.Texto)
EjecucionMensaje=Comillas(Temp.Texto)+<T> Duplicado<T>
EjecucionConError=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
