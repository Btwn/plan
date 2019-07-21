[Forma]
Clave=MaviAbaHistOrComFrm
Nombre=HISTORICO ORDENES DE COMPRA
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
PosicionInicialAltura=312
PosicionInicialAncho=492
ListaAcciones=Cerrar<BR>Preliminar
AccionesCentro=S
AccionesDivision=S
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
PosicionInicialIzquierda=266
PosicionInicialArriba=236
MovModulo=COMS
BarraHerramientas=S
PosicionInicialAlturaCliente=261
ExpresionesAlMostrar=Asigna(Info.ProveedorD, SQL(<T>SELECT Min(Proveedor) FROM Prov<T>))<BR>Asigna(Info.ProveedorA, SQL(<T>SELECT Max(Proveedor) FROM Prov<T>))<BR>Asigna(Info.AgenteD, SQL(<T>SELECT Min(Agente) FROM Agente<T>))<BR>Asigna(Info.AgenteA, SQL(<T>SELECT Max(Agente) FROM Agente<T>))<BR>Asigna(Info.Almacen, <T>(Todos)<T>)<BR>Asigna(Info.ProvCat, <T>(Todos)<T>)<BR>Asigna(Info.ProvFam, <T>(Todos)<T>)<BR>Asigna(Info.Sucursal, Nulo)<BR>Asigna(Info.UEN, Nulo)<BR>Asigna(Info.Modulo, <T>COMS<T>)<BR>Asigna(Info.Estatus,<T>Concluido<T>)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.AgenteD<BR>Info.AgenteA<BR>Info.ProveedorD<BR>Info.ProveedorA<BR>Info.ProvCat<BR>Info.ProvFam<BR>Info.Sucursal<BR>Info.UEN<BR>Info.Almacen<BR>Info.FechaD<BR>Info.FechaA<BR>Info.Estatus<BR>Info.MovClaveAfecta
CarpetaVisible=S
FichaEspacioEntreLineas=7
FichaEspacioNombres=105
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Blanco
FichaAlineacionDerecha=S
FichaEspacioNombresAuto=S
PermiteEditar=S

[(Variables).Info.AgenteA]
Carpeta=(Variables)
Clave=Info.AgenteA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[(Variables).Info.AgenteD]
Carpeta=(Variables)
Clave=Info.AgenteD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[(Variables).Info.Sucursal]
Carpeta=(Variables)
Clave=Info.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[(Variables).Info.Almacen]
Carpeta=(Variables)
Clave=Info.Almacen
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
EspacioPrevio=S
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


[(Variables).Info.ProveedorD]
Carpeta=(Variables)
Clave=Info.ProveedorD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
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

[(Variables).Info.ProvCat]
Carpeta=(Variables)
Clave=Info.ProvCat
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.ProvFam]
Carpeta=(Variables)
Clave=Info.ProvFam
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

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

[Acciones.Imprimir.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
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



[(Variables).Info.UEN]
Carpeta=(Variables)
Clave=Info.UEN
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.Estatus]
Carpeta=(Variables)
Clave=Info.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.MovClaveAfecta]
Carpeta=(Variables)
Clave=Info.MovClaveAfecta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
