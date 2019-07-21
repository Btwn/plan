[Forma]
Clave=MaviAlmModificaCapturaEmbarqueFisicoFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=122
Modulos=(Todos)
ListaCarpetas=Captura
CarpetaPrincipal=Captura
PosicionInicialAlturaCliente=239
PosicionInicialAncho=238
PosicionInicialIzquierda=-2
PosicionInicialArriba=-2
AccionesTamanoBoton=3x3
AccionesDerecha=S
BarraHerramientas=S
AccionesDivision=S
ListaAcciones=Aceptar<BR>Guardar<BR>EliminarRC<BR>Agregar Registro<BR>Cancelar Registro<BR>Eliminar Registro<BR>EliminarTodos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=53
AutoGuardar=S
VentanaSiempreAlFrente=S
Comentarios=<T>Eliminacion<T>
VentanaSinIconosMarco=S
ExpresionesAlMostrar=//Aqui insertamos los valores por default a la tabla<BR>Asigna(Mavi.AlmRealizoCapturaFisica,0)<BR>Asigna(Mavi.AlmEliminarRegCapFisica,0)
ExpresionesAlCerrar=EjecutarSQL(<T>Exec SP_MaviAlmEliminaxEliminar<T>)
[Detalle.Columnas]
ID=64
IDEmbarque=64
IDFactura=64
Articulo=45
Serie=94
Validado=64
FechaRegistro=94
Usuario=304
[Captura]
Estilo=Hoja
Clave=Captura
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviAlmCapturaEliminacionEmbarqueFisicoVis
ConFuenteEspecial=S
Fuente={Tahoma, 6, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
GuardarAlSalir=S
ListaEnCaptura=MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Articulo<BR>MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Serie
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
[Captura.Columnas]
Articulo=69
Serie=134
ID=44
IDEmbarque=74
IDFactura=60
Validado=52
FechaRegistro=85
Usuario=204
Serie_1=84
IdTabla=44
Articulo_1=84
idEmbarque_1=60
[(Variable).Mavi.AlmacenIdEmbarque]
Carpeta=(Variable)
Clave=Mavi.AlmacenIdEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=<T>&Guardar<T>
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
ListaAccionesMultiples=Guardar<BR>RefrescaControles<BR>RefrescaForma
Activo=S
Visible=S
[Acciones.Eliminar Registro]
Nombre=Eliminar Registro
Boton=63
NombreDesplegar=<T>Eliminar Registro de la toma fisica<T>
EnBarraHerramientas=S
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Multiple=S
ListaAccionesMultiples=MotivoElimina<BR>Validacion<BR>GuardaDatosTabla<BR>EliminarDatos<BR>Actualizacion<BR>ActualizaFormaEliminaUno<BR>CambioDValor
EspacioPrevio=S
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
VisibleCondicion=1=2
[Acciones.Agregar Registro]
Nombre=Agregar Registro
Boton=62
NombreDesplegar=<T>Agregar un Registro<T>
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Insertar
Activo=S
Visible=S
[Acciones.Cancelar Registro]
Nombre=Cancelar Registro
Boton=21
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Cancelar
Activo=S
Visible=S
NombreDesplegar=<T>Cancelar Registro<T>
[Acciones.Eliminar Registro.MotivoElimina]
Nombre=MotivoElimina
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
[Acciones.Eliminar Registro.Validacion]
Nombre=Validacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
[Acciones.Eliminar Registro.EliminarDatos]
Nombre=EliminarDatos
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisicoTbl.IdTabla,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Articulo,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Serie,Usuario,<T>Embarques<T>,1,Mavi.AlmCausaEliminacion,2)
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.Eliminar Registro.Actualizacion]
Nombre=Actualizacion
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar Registro.CambioDValor]
Nombre=CambioDValor
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
[Acciones.EliminarTodos]
Nombre=EliminarTodos
Boton=36
NombreDesplegar=<T>Eliminar Todo de la Toma Fisica <T>
EnBarraHerramientas=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=MotivoEliminaTodo<BR>ValidaEliminaTodo<BR>AhoraEliminaTodo<BR>RefrescaEliminaTodo<BR>ActualizaFormaEliminaTodos<BR>CambiaValorEliminaTodos
Visible=S
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
[Acciones.EliminarRC]
Nombre=EliminarRC
Boton=63
EnBarraHerramientas=S
Activo=S
Visible=S
NombreDesplegar=<T>Eliminar<T>
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Multiple=S
ListaAccionesMultiples=EliminaRegC<BR>RefrescaControlesRC<BR>RefrescaFormaRC
[Acciones.EliminarTodos.MotivoEliminaTodo]
Nombre=MotivoEliminaTodo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
[Acciones.EliminarTodos.ValidaEliminaTodo]
Nombre=ValidaEliminaTodo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
[Acciones.EliminarTodos.AhoraEliminaTodo]
Nombre=AhoraEliminaTodo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,0,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Articulo,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Serie,Usuario,<T>Embarques<T>,1,Mavi.AlmCausaEliminacion,1)
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.EliminarTodos.RefrescaEliminaTodo]
Nombre=RefrescaEliminaTodo
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.EliminarTodos.CambiaValorEliminaTodos]
Nombre=CambiaValorEliminaTodos
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
Activo=S
Visible=S
[Acciones.Eliminar Registro.GuardaDatosTabla]
Nombre=GuardaDatosTabla
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar<T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=EjecutarSQL(<T>Exec SP_MaviAlmEliminaxEliminar<T>)
[Acciones.Guardar.RefrescaControles]
Nombre=RefrescaControles
Boton=0
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Refrescar Controles
Activo=S
Visible=S
[Acciones.Guardar.RefrescaForma]
Nombre=RefrescaForma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.EliminarRC.EliminaRegC]
Nombre=EliminaRegC
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
Carpeta=Captura
[Acciones.EliminarRC.RefrescaControlesRC]
Nombre=RefrescaControlesRC
Boton=0
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Refrescar Controles
Activo=S
Visible=S
[Acciones.EliminarRC.RefrescaFormaRC]
Nombre=RefrescaFormaRC
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Eliminar Registro.ActualizaFormaEliminaUno]
Nombre=ActualizaFormaEliminaUno
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.EliminarTodos.ActualizaFormaEliminaTodos]
Nombre=ActualizaFormaEliminaTodos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Captura.MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Articulo]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Serie]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

