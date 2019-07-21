[Forma]
Clave=MaviExistenciasFrm
Nombre=Filtro Reporte
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=552
PosicionInicialArriba=412
PosicionInicialAlturaCliente=90
PosicionInicialAncho=236
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna(Mavi.InvListexistAlmProforma,<T>Sin Existencias<T>)
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
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.InvListexistAlmProforma
[(Variables).Mavi.InvListexistAlmProforma]
Carpeta=(Variables)
Clave=Mavi.InvListexistAlmProforma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=MaviInvListexistAlmProformaRepImp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Aceptar
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


