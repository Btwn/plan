[Forma]
Clave=DM0239DistribucionAutomaticaFrm
Nombre=Distribucion Automatica
Icono=390
Modulos=(Todos)
ListaCarpetas=Distribucion<BR>(Variables)
CarpetaPrincipal=Distribucion
PosicionInicialIzquierda=179
PosicionInicialArriba=162
PosicionInicialAlturaCliente=616
PosicionInicialAncho=836
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Genera<BR>Actualizar<BR>ConfPerfiles<BR>Excel<BR>Cerrar<BR>CrearSeg<BR>AsigDesLineas<BR>EliminarSeg<BR>ConsultaSeg
PosicionSec1=51
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Menus=S
BarraHerramientas=S
ExpresionesAlMostrar=Asigna(Info.Dato,<T>No<T>)
MenuPrincipal=Configuraciones
[Distribucion]
Estilo=Hoja
Clave=Distribucion
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0239DistribucionAutomaticaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Articulo<BR>Descripcion1<BR>Sucursal<BR>MciaFacturada<BR>DisponibleCD<BR>Surtir<BR>ExisSuc<BR>Salidas x venta
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Distribucion.Articulo]
Carpeta=Distribucion
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Distribucion.Descripcion1]
Carpeta=Distribucion
Clave=Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[Distribucion.Sucursal]
Carpeta=Distribucion
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Distribucion.MciaFacturada]
Carpeta=Distribucion
Clave=MciaFacturada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Distribucion.DisponibleCD]
Carpeta=Distribucion
Clave=DisponibleCD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Distribucion.Surtir]
Carpeta=Distribucion
Clave=Surtir
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Distribucion.Columnas]
Articulo=107
Descripcion1=339
Sucursal=116
MciaFacturada=164
DisponibleCD=118
Surtir=125
ExisSuc=100
Venta=64
Salidas x venta=77
[Acciones.Genera]
Nombre=Genera
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Solicitudes
EnBarraHerramientas=S
Activo=S
Visible=S
TipoAccion=Expresion
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_DM0239DistAutoGSol :tUsr, :tAlm<T>,Usuario,Reemplaza(Comillas(<T>,<T>), <T>,<T>, Mavi.DM0239AlmacenVenta )))<BR> Informacion(Info.Dialogo)
EjecucionCondicion=ConDatos(Mavi.DM0239AlmacenVenta)
EjecucionMensaje=<T>Seleccione minimo un Almacen<T>
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
CarpetaVisible=S
PermiteEditar=S

ListaEnCaptura=Mavi.DM0239AlmacenVenta
[Acciones.Actualizar.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dato,<T>SI<T>)
[Acciones.Actualizar.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.forma]
Nombre=forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=exp<BR>asign<BR>forma
Activo=S
Visible=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreDesplegar=Enviar a E&xcel
EnBarraHerramientas=S
Carpeta=Distribucion
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Distribucion.ExisSuc]
Carpeta=Distribucion
Clave=ExisSuc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.Columnas]
0=-2
1=-2
2=192
3=-2


[Acciones.CrearSeg]
Nombre=CrearSeg
Boton=0
Menu=Configuraciones
NombreDesplegar=Crear segmento
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239CrearSegmentosFrm
[Acciones.EliminarSeg]
Nombre=EliminarSeg
Boton=0
NombreDesplegar=Eliminar Segmento
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239EliminarSegFrm
Menu=Configuraciones
[Acciones.AsigDesLineas]
Nombre=AsigDesLineas
Boton=0
NombreDesplegar=Asig/Des. Lineas
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S

ClaveAccion=DM0239AgreQuitLineaFrm
Menu=Configuraciones
[Acciones.ConsultaSeg]
Nombre=ConsultaSeg
Boton=0
NombreDesplegar=Consulta Segmento
EnMenu=S
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=DM0239ConsultaSegFrm
Menu=Configuraciones

[Acciones.ConfPerfiles]
Nombre=ConfPerfiles
Boton=83
NombreEnBoton=S
NombreDesplegar=Configurar Perfiles
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
ClaveAccion=DM0239AsignacionPerfilesFrm
EspacioPrevio=S

VisibleCondicion=Si<BR>  (SQL(<T>SELECT COUNT(Acceso) FROM Usuario U WHERE U.Acceso = :tAcc AND U.Usuario = :tUsu<T>,<T>GERAD_GERA<T>,  Usuario  )>0)<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
[Distribucion.Salidas x venta]
Carpeta=Distribucion
Clave=Salidas x venta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[(Variables).Mavi.DM0239AlmacenVenta]
Carpeta=(Variables)
Clave=Mavi.DM0239AlmacenVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

