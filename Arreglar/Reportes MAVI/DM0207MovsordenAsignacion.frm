[Forma]
Clave=DM0207MovsordenAsignacion
Nombre=DM0207MovsordenAsignacion
Icono=0
Modulos=(Todos)
ListaCarpetas=Campos
CarpetaPrincipal=Campos
PosicionInicialIzquierda=512
PosicionInicialArriba=236
PosicionInicialAlturaCliente=320
PosicionInicialAncho=450
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar<BR>Guardar<BR>Cerrar<BR>accionguardar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaExclusiva=S
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
PosicionSec1=138
PosicionSec2=138
ExpresionesAlMostrar=asigna(info.id,sql(<T>select  ISNULL(max(orden),0) from dm0207movsasignacion<T>))
[Campos]
Estilo=Hoja
Pestana=S
Clave=Campos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207MovsAsignacionVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
HojaConfirmarEliminar=S
PestanaOtroNombre=S
PestanaNombre=Orden de los movimientos para la Asignación
OtroOrden=S
ListaOrden=DM0207MovsASignacion.TipoOrden<TAB>(Acendente)<BR>DM0207MovsASignacion.Orden<TAB>(Acendente)
ListaEnCaptura=DM0207MovsASignacion.Mov<BR>DM0207MovsASignacion.TipoOrden<BR>DM0207MovsASignacion.Orden
[Campos.Columnas]
TipoOrden=144
Mov=163
Orden=44
Ordenado=74
[Acciones.Guarda.guarda]
Nombre=guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Registro Afectar
Activo=S
Visible=S
Carpeta=(Carpeta principal)
[Acciones.Guarda.refresca]
Nombre=refresca
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Activo=S
Visible=S
ConCondicion=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=borra<BR>guardaborrado<BR>actualiza
EjecucionCondicion=Si confirmacion(<T>Desea Eliminar el Registro ?<T>,Botonaceptar,Botoncancelar) =1<BR>Entonces<BR>verdadero<BR>sino<BR>falso<BR>FIN
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
EspacioPrevio=S
[Acciones.Eliminar.borra]
Nombre=borra
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Eliminar.guardaborrado]
Nombre=guardaborrado
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=ultimo<BR>Guarda<BR>refrezca
[Acciones.accionguardar]
Nombre=accionguardar
Boton=0
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[(Carpeta Totalizadores)]
Pestana=S
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=
Totalizadores2=
Totalizadores=S
TotAlCambiar=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
[campos2.DM0207MovsASignacion.Orden]
Carpeta=campos2
Clave=DM0207MovsASignacion.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[campos2.Columnas]
Orden=74
[Acciones.prubas.epersion]
Nombre=epersion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=//Informacion(ListaBuscarDuplicados( campoenlista(DM0207MovsAsignacionVis:DM0207MovsASignacion.Orden)))<BR><BR> //INFORMACION(CuantosListaID( <T>campos<T> )>4)<BR>// informacion( ListaSeleccion( <T>Campos<T> ) )<BR><BR> //RegistrarSeleccion( <T>Campos<T> )<BR><BR><BR>Registrarlista( campoenlista(DM0207MovsAsignacionVis:DM0207MovsASignacion.Mov),Falso)
[Acciones.prubas.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.prubas.resultado]
Nombre=resultado
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.Eliminar.actualiza]
Nombre=actualiza
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=//ejecutarsql(<T>EXEC SP_DM0207Ordenar <T>)<BR>Forma.ActualizarVista<BR>Forma.RegistroUltimo
[Campos.DM0207MovsASignacion.Mov]
Carpeta=Campos
Clave=DM0207MovsASignacion.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Campos.DM0207MovsASignacion.TipoOrden]
Carpeta=Campos
Clave=DM0207MovsASignacion.TipoOrden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Campos.DM0207MovsASignacion.Orden]
Carpeta=Campos
Clave=DM0207MovsASignacion.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.ultimo]
Nombre=ultimo
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Activo=S
Visible=S
[Acciones.Guardar.refrezca]
Nombre=refrezca
Boton=0
TipoAccion=Expresion
Expresion=Forma.ActualizarVista<BR>Forma.RegistroUltimo
Activo=S
Visible=S

