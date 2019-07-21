[Forma]
Clave=MaviAlmModificaCapturaServiciosEmbarqueFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=122
Modulos=(Todos)
ListaCarpetas=Captura
CarpetaPrincipal=Captura
PosicionInicialAlturaCliente=239
PosicionInicialAncho=239
PosicionInicialIzquierda=0
PosicionInicialArriba=0
AccionesTamanoBoton=3x3
AccionesDerecha=S
BarraHerramientas=S
Comentarios=<T>Eliminacion<T>
AccionesDivision=S
ListaAcciones=Aceptar<BR>Guardar<BR>EliminarRXE<BR>Agregar Registro<BR>Cancelar Registro<BR>Eliminar Registro<BR>EliminarTodosDLaCaptura
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
Vista=MaviAlmCapturaEliminacionServiciosVis
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
HojaIndicador=S
HojaTitulosEnBold=S
ListaEnCaptura=MaviAlmCapturaEliminacionServiciosTbl.Articulo<BR>MaviAlmCapturaEliminacionServiciosTbl.Serie
[Captura.Columnas]
Articulo=62
Serie=134
ID=44
IDEmbarque=71
IDFactura=60
Validado=52
FechaRegistro=85
Usuario=204
Serie_1=84
Empacada=62
Motivo=204
Unidad=44
idEmbarque_1=71
IdTabla=47
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
ListaAccionesMultiples=Guardar<BR>RefrescoCtrls<BR>RefrescaForma
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
Visible=S
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
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
NombreDesplegar=<T>Eliminar todos del retorno<T>
Multiple=S
ListaAccionesMultiples=MotivoEliminaTodos<BR>ValidacionTodos<BR>GuardaDatosTablaTdos<BR>EliminaDatosTodos<BR>ActualizaTodos<BR>CambiaValorTodos
Visible=S
ActivoCondicion=SQL(<T>Select count(serie) from MAVIEliminaEmbarqueFisicoAlmacen<T>) > 0
[Acciones.Eliminar Registro.MotivoElimina]
Nombre=MotivoElimina
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
Activo=S
Visible=S
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
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.IdTabla,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.idEmbarque,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.Articulo,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.Serie,Usuario,<T>Servicios<T>,3,Mavi.AlmCausaEliminacion,2)
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.Eliminar Registro.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Captura.MaviAlmCapturaEliminacionServiciosTbl.Articulo]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionServiciosTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.EliminarTodosDLaCaptura.MotivoEliminaTodos]
Nombre=MotivoEliminaTodos
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmEmbarqueFisicoCausaEliminacionRegFrm<T>)
Activo=S
Visible=S
[Acciones.EliminarTodosDLaCaptura.ValidacionTodos]
Nombre=ValidacionTodos
Boton=0
TipoAccion=Expresion
Expresion=FormaModal(<T>MaviAlmEliminarRegEmbFisicoFrm<T>)
Activo=S
Visible=S
[Acciones.EliminarTodosDLaCaptura.GuardaDatosTablaTdos]
Nombre=GuardaDatosTablaTdos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.EliminarTodosDLaCaptura.EliminaDatosTodos]
Nombre=EliminaDatosTodos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.IdTabla,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.idEmbarque,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.Articulo,MaviAlmCapturaEliminacionServiciosVis:MaviAlmCapturaEliminacionServiciosTbl.Serie,Usuario,<T>Servicios<T>,3,Mavi.AlmCausaEliminacion,1)
ConCondicion=S
EjecucionCondicion=Mavi.AlmEliminarRegCapFisica=1
[Acciones.EliminarTodosDLaCaptura.ActualizaTodos]
Nombre=ActualizaTodos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.EliminarTodosDLaCaptura.CambiaValorTodos]
Nombre=CambiaValorTodos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.AlmEliminarRegCapFisica,0)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=EjecutarSQL(<T>Exec SP_MaviAlmEliminaxEliminar<T>)
[Acciones.Guardar.RefrescoCtrls]
Nombre=RefrescoCtrls
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
[Captura.MaviAlmCapturaEliminacionServiciosTbl.Serie]
Carpeta=Captura
Clave=MaviAlmCapturaEliminacionServiciosTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

