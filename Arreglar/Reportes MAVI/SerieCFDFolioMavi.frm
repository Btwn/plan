
[Forma]
Clave=SerieCFDFolioMavi
Icono=0
Modulos=(Todos)
Nombre=Serie CFD

ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
PosicionInicialIzquierda=508
PosicionInicialArriba=245
PosicionInicialAlturaCliente=273
PosicionInicialAncho=263
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=SerieCFDFolioMavi
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=(Lista)

[Lista.Serie]
Carpeta=Lista
Clave=Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Consecutivo]
Nombre=Consecutivo
Boton=18
NombreDesplegar=C&onsecutivo
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S

NombreEnBoton=S
ClaveAccion=ConsecutivoCFDFolioMavi
Antes=S
EspacioPrevio=S
GuardarAntes=S
AntesExpresiones=//Asigna(info.mov, <T>Factura<T>)<BR>Asigna(Temp.Texto,<T>[Consecutivo/<T> + Info.Mov + <T>/S<T> + SerieCFDFolioMavi:Sucursal + Reemplaza( <T> <T>, <T>_<T>, SerieCFDFolioMavi:Serie) + <T>]<T> )
[Lista.Columnas]
Serie=140

Sucursal=72
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




[Lista.ListaEnCaptura]
(Inicio)=Sucursal
Sucursal=Serie
Serie=(Fin)

[Lista.Sucursal]
Carpeta=Lista
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro















































[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=Consecutivo
Consecutivo=(Fin)

