[Forma]
AccionesCentro=S
AccionesDivision=S
AccionesTamanoBoton=15x5
BarraHerramientas=S
CarpetaPrincipal=(Variables)
Clave=MaviAbaCompraNetaFrm
Icono=152
ListaAcciones=Preliminar<BR>Cerrar
ListaCarpetas=(Variables)
Modulos=(Todos)
Nombre=RM054 Compras Netas
PosicionInicialAltura=146
PosicionInicialAncho=554
PosicionInicialArriba=426
PosicionInicialIzquierda=363
VentanaEscCerrar=S
VentanaExclusiva=S
VentanaPosicionInicial=Centrado
VentanaTipoMarco=Diálogo
PosicionInicialAlturaCliente=143
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD, PrimerDiaMes)<BR>Asigna(Info.FechaA, UltimoDiaMes)<BR>Asigna(Info.ProveedorD, SQL(<T>SELECT Min(Proveedor) FROM Prov Where Proveedor Like <T>+Comillas(<T>P%<T>)))<BR>Asigna(Info.ProveedorA, SQL(<T>SELECT Max(Proveedor) FROM Prov Where Proveedor Like <T>+Comillas(<T>P%<T>)))<BR>Asigna(Rep.Compras, <T>Entradas y Devoluciones<T>)<BR>Asigna(MAvi.TexFechaEmiFac,<T>Emision<T>)<BR>Asigna(Mavi.ConRebate,Nulo)

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
CarpetaVisible=S
FichaEspacioEntreLineas=4
FichaEspacioNombres=65
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Info.ProveedorD<BR>Rep.Compras<BR>Mavi.TexFechaEmiFac<BR>Mavi.ConRebate
PermiteEditar=S

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Rep.Compras]
Carpeta=(Variables)
Clave=Rep.Compras
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S



[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Multiple=S
ListaAccionesMultiples=VAr<BR>ven

[(Variables).Info.ProveedorD]
Carpeta=(Variables)
Clave=Info.ProveedorD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.TexFechaEmiFac]
Carpeta=(Variables)
Clave=Mavi.TexFechaEmiFac
Editar=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.ConRebate]
Carpeta=(Variables)
Clave=Mavi.ConRebate
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.VAr]
Nombre=VAr
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.ven]
Nombre=ven
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA)) y (ConDatos(Mavi.ConRebate))<BR>Y (ConDatos(Mavi.TexfechaEmiFac)) Y (CONDATOS(INFO.PROVEEDORD))
EjecucionMensaje=<T>Favor de Introducir Correctamente los Datos. Rango de Fecha, Si usa REBATE, el tipo de Fecha y su respectivo Proveedor<T>
