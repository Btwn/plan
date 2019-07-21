[Forma]
Clave=RM1142ImportarSembrados
Nombre=RM1142ImportarSembrados
Icono=67
Modulos=(Todos)
ListaCarpetas=importar
CarpetaPrincipal=importar
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=ImportarExcel
PosicionInicialAlturaCliente=331
PosicionInicialAncho=746
PosicionSec1=-32
PosicionInicialIzquierda=160
PosicionInicialArriba=116
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_RM1142Funciones  Sembrados<T>)
[importar]
Estilo=Hoja
Clave=importar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM1142ImportarSembradosVis
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
ListaEnCaptura=RM1142ImportarSembradosTbl.telefono<BR>RM1142ImportarSembradosTbl.Nombre
CarpetaVisible=S
PermiteEditar=S
[importar.RM1142ImportarSembradosTbl.telefono]
Carpeta=importar
Clave=RM1142ImportarSembradosTbl.telefono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[importar.RM1142ImportarSembradosTbl.Nombre]
Carpeta=importar
Clave=RM1142ImportarSembradosTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ImportarExcel]
Nombre=ImportarExcel
Boton=126
NombreEnBoton=S
NombreDesplegar=&ImportarExcel
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=importar<BR>guardar<BR>cerrarforma<BR>cerrar
[importar.Columnas]
telefono=94
Nombre=604
[Acciones.ImportarExcel.importar]
Nombre=importar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.ImportarExcel.guardar]
Nombre=guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.ImportarExcel.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.ImportarExcel.cerrarforma]
Nombre=cerrarforma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>RM1142GenerarCampFrm<T>,Forma.Accion(<T>Aceptar<T>))




