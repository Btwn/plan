[Forma]
Clave=MaviServConceProdServFrm
Nombre=RM037 Concentrado Productividad de Servicios
Icono=132
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=266
PosicionInicialArriba=305
PosicionInicialAlturaCliente=130
PosicionInicialAncho=492
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.ArticuloD,<T><T>)<BR>Asigna(Info.ArticuloA,<T><T>)<BR>Asigna(Mavi.ClienteD,<T><T>)<BR>Asigna(Mavi.ClienteA,<T><T>)<BR>Asigna(Info.Sucursal,Sucursal)
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
ListaEnCaptura=Info.ArticuloD<BR>Info.ArticuloA<BR>Mavi.ClienteD<BR>Mavi.ClienteA<BR>Info.Sucursal<BR>Mavi.TipoServ
CarpetaVisible=S
[(Variables).Info.ArticuloD]
Carpeta=(Variables)
Clave=Info.ArticuloD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Info.ArticuloA]
Carpeta=(Variables)
Clave=Info.ArticuloA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
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
Efectos=[Negritas]
[(Variables).Mavi.ClienteD]
Carpeta=(Variables)
Clave=Mavi.ClienteD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Efectos=[Negritas]
[(Variables).Mavi.ClienteA]
Carpeta=(Variables)
Clave=Mavi.ClienteA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
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
[(Variables).Mavi.TipoServ]
Carpeta=(Variables)
Clave=Mavi.TipoServ
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]

