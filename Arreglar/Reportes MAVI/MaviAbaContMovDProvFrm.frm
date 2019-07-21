[Forma]
Clave=MaviAbaContMovDProvFrm
Nombre=Relacion de Moviminetos de Proveedores
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
PosicionInicialAltura=360
PosicionInicialAncho=491
ListaAcciones=Cerrar<BR>Preliminar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
PosicionInicialIzquierda=266
PosicionInicialArriba=288
MovModulo=CXP
BarraHerramientas=S
PosicionInicialAlturaCliente=128
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
SinCondicionDespliege=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.ProveedorD, SQL(<T>SELECT Min(Proveedor) FROM Prov<T>))<BR>Asigna(Info.ProveedorA, SQL(<T>SELECT Max(Proveedor) FROM Prov<T>))<BR>Asigna(Info.Estatus, <T>Concluido<T>)  <BR>Asigna(Info.Modulo, <T>CXP<T>)<BR>Asigna(Info.MovClaveAfecta, <T><T>)<BR>Asigna(Info.FechaD,Primerdiames(hoy))<BR>Asigna(Info.FechaA,Ultimodiames(hoy))
















[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S



[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar




[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=7
FichaEspacioNombres=105
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Blanco
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.ProveedorD<BR>Info.ProveedorA<BR>Info.FechaD<BR>Info.FechaA<BR>Info.MovClaveAfecta
CarpetaVisible=S
[(Variables).Info.ProveedorD]
Carpeta=(Variables)
Clave=Info.ProveedorD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.ProveedorA]
Carpeta=(Variables)
Clave=Info.ProveedorA
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
[(Variables).Info.MovClaveAfecta]
Carpeta=(Variables)
Clave=Info.MovClaveAfecta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

