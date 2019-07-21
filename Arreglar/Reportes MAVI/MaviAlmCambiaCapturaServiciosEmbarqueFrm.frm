[Forma]
Clave=MaviAlmCambiaCapturaServiciosEmbarqueFrm
Nombre=<T>Modificacion Captura Fisica<T>+SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
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
Comentarios=<T>Cambios<T>
AccionesDivision=S
ListaAcciones=Aceptar<BR>Guardar<BR>Eliminar<BR>Cancelar Registro
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=53
VentanaSiempreAlFrente=S
AutoGuardar=S
VentanaSinIconosMarco=S
ExpresionesAlMostrar=//Aqui insertamos los valores por default a la tabla<BR>Asigna(Mavi.AlmRealizoCapturaFisica,0)
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
Vista=MaviAlmCapturaServiciosVis
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
ListaEnCaptura=MAVIAlmServiciosEmbarqueFisicoAlmacen.Articulo<BR>MAVIAlmServiciosEmbarqueFisicoAlmacen.Serie<BR>MAVIAlmServiciosEmbarqueFisicoAlmacen.Empacada<BR>MAVIAlmServiciosEmbarqueFisicoAlmacen.Motivo
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
NombreDesplegar=<T>&Guardar y Cerrar <T>
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
ListaAccionesMultiples=Guardar<BR>CerrarCambios
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
NombreDesplegar=<T>Cancelar Cambio<T>
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
[Acciones.Guardar.CerrarCambios]
Nombre=CerrarCambios
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Captura.MAVIAlmServiciosEmbarqueFisicoAlmacen.Articulo]
Carpeta=Captura
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacen.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MAVIAlmServiciosEmbarqueFisicoAlmacen.Serie]
Carpeta=Captura
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacen.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MAVIAlmServiciosEmbarqueFisicoAlmacen.Empacada]
Carpeta=Captura
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacen.Empacada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MAVIAlmServiciosEmbarqueFisicoAlmacen.Motivo]
Carpeta=Captura
Clave=MAVIAlmServiciosEmbarqueFisicoAlmacen.Motivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>Aceptar <T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=63
NombreDesplegar=<T>Eliminar<T>
EnBarraHerramientas=S
Carpeta=Captura
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

