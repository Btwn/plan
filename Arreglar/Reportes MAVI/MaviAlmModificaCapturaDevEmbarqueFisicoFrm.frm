[Forma]
Clave=MaviAlmModificaCapturaDevEmbarqueFisicoFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=122
Modulos=(Todos)
ListaCarpetas=Captura
CarpetaPrincipal=Captura
PosicionInicialAlturaCliente=239
PosicionInicialAncho=239
PosicionInicialIzquierda=-2
PosicionInicialArriba=-2
AccionesTamanoBoton=3x3
AccionesDerecha=S
BarraHerramientas=S
Comentarios=<T>Eliminacion<T>
AccionesDivision=S
ListaAcciones=AceptarModifica<BR>Guardar<BR>EliminarRXE<BR>Agregar Registro<BR>Cancelar Registro<BR>Eliminar Registro<BR>EliminarTodosDLaCaptura
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=53
VentanaSiempreAlFrente=S
AutoGuardar=S
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
Vista=MaviAlmCapturaEliminacionRetEmbarqueFisicoVis
ConFuenteEspecial=S
Fuente={Tahoma, 6, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
GuardarAlSalir=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
ListaEnCaptura=MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Articulo<BR>MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Serie
[Captura.Columnas]
Articulo=62
Serie=134
ID=44
IDEmbarque=74
IDFactura=60
Validado=52
FechaRegistro=85
Usuario=204
Serie_1=84
IdTabla=44
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
ListaAccionesMultiples=Guardar<BR>ReferscarControlesDev<BR>RefrescaFormaDev
Activo=S
Visible=S
[Acciones.Eliminar Registro]
Nombre=Eliminar Registro
Boton=63
NombreDesplegar=<T>Eliminar Registro del Retorno<T>
EnBarraHerramientas=S
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Multiple=S
ListaAccionesMultiples=MotivoElimina<BR>Validacion<BR>GuardaDatosTabla<BR>EliminaDats<BR>Actualiza<BR>CambiaValor
EspacioPrevio=S
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
VisibleCondicion=1=2<BR>//SOLO ESTARA VISIBLE EL BOTON DE ELIMINACION TOTAL.
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
[Acciones.Eliminar Registro.Validacion]
Nombre=Validacion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
[Acciones.Eliminar Registro.CambiaValor]
Nombre=CambiaValor
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
[Acciones.EliminarRXE]
Nombre=EliminarRXE
Boton=63
NombreDesplegar=Eliminar
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
[Acciones.EliminarTodosDLaCaptura]
Nombre=EliminarTodosDLaCaptura
Boton=36
EnBarraHerramientas=S
Visible=S
NombreDesplegar=<T>Eliminar todos del retorno<T>
Multiple=S
ListaAccionesMultiples=MotivoEliminaTodos<BR>ValidacionEliminaTodos<BR>GuardaDatosTablaTodos<BR>EliminaTodos<BR>ActualizaTodos<BR>CambiaValorTodos
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
[Acciones.Eliminar Registro.MotivoElimina]
Nombre=MotivoElimina
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
[Acciones.Eliminar Registro.GuardaDatosTabla]
Nombre=GuardaDatosTabla
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Eliminar Registro.EliminaDats]
Nombre=EliminaDats
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval0,:tval1,:tval2,:tval3,:nval3,:tval4,:nval4<T>,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Id,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Articulo,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmDevEmbarqueFisicoTbl.Serie,Usuario,<T>Retornos<T>,2,Mavi.AlmCausaEliminacion,2)
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.Eliminar Registro.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.AceptarModifica]
Nombre=AceptarModifica
Boton=23
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=EjecutarSQL(<T>Exec SP_MaviAlmEliminaxEliminar<T>)
[Acciones.Guardar.ReferscarControlesDev]
Nombre=ReferscarControlesDev
Boton=0
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Refrescar Controles
Activo=S
Visible=S
[Acciones.Guardar.RefrescaFormaDev]
Nombre=RefrescaFormaDev
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.EliminarTodosDLaCaptura.MotivoEliminaTodos]
Nombre=MotivoEliminaTodos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
[Acciones.EliminarTodosDLaCaptura.ValidacionEliminaTodos]
Nombre=ValidacionEliminaTodos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
[Acciones.EliminarTodosDLaCaptura.GuardaDatosTablaTodos]
Nombre=GuardaDatosTablaTodos
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
[Acciones.EliminarTodosDLaCaptura.EliminaTodos]
Nombre=EliminaTodos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval0,:tval1,:tval2,:tval3,:nval3,:tval4,:nval4<T>,Mavi.AlmacenIdFactura,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Articulo,MaviAlmCapturaEliminacionRetEmbarqueFisicoVis:MaviAlmDevEmbarqueFisicoTbl.Serie,Usuario,<T>Retornos<T>,2,Mavi.AlmCausaEliminacion,1)
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.EliminarTodosDLaCaptura.ActualizaTodos]
Nombre=ActualizaTodos
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
[Acciones.EliminarTodosDLaCaptura.CambiaValorTodos]
Nombre=CambiaValorTodos
Boton=0
Activo=S
Visible=S
TipoAccion=Expresion
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
[Captura.MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Articulo]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Serie]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionRetEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

