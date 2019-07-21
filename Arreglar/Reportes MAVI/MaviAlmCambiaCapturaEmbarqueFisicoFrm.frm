[Forma]
Clave=MaviAlmCambiaCapturaEmbarqueFisicoFrm
Nombre=SQL(<T>Select Mov from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)+<T> <T>+SQL(<T>Select MovID from Embarque Where ID=:nval1<T>,Mavi.AlmacenIdEmbarque)
Icono=122
Modulos=(Todos)
ListaCarpetas=Captura
CarpetaPrincipal=Captura
PosicionInicialAlturaCliente=242
PosicionInicialAncho=238
PosicionInicialIzquierda=1
PosicionInicialArriba=1
AccionesTamanoBoton=3x3
AccionesDerecha=S
BarraHerramientas=S
AccionesDivision=S
ListaAcciones=Aceptar<BR>Guardar<BR>Cancelar Registro
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=53
VentanaSiempreAlFrente=S
Comentarios=<T>Cambios<T>
VentanaSinIconosMarco=S
VentanaBloquearAjuste=S
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
Vista=MaviAlmCapturaEmbarqueFisicoVis
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
HojaVistaOmision=Automática
ListaEnCaptura=MaviAlmCapturaEmbarqueFisicoTbl.Articulo<BR>MaviAlmCapturaEmbarqueFisicoTbl.Serie
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
NombreDesplegar=<T>&Guardar y Cerrar<T>
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
ListaAccionesMultiples=Guardar
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
NombreDesplegar=<T>Cancelar Cambios<T>
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
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.IdTabla,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.Articulo,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.Serie,Usuario,<T>Embarques<T>,1,Mavi.AlmCausaEliminacion,2)
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
Expresion=EjecutarSQL(<T>Exec SP_MAVIEmbarqueFisicoHistorialEliminXSerie :nval0,:nval1,:tval1,:tval2,:tval3,:tval4,:nval2,:tval5,:nval3<T>,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.IdTabla,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEmbarqueFisicoTbl.idEmbarque,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.Articulo,MaviAlmCapturaEliminacionEmbarqueFisicoVis:MaviAlmCapturaEliminacionEmbarqueFisico.Serie,Usuario,<T>Embarques<T>,1,Mavi.AlmCausaEliminacion,1)
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
[Captura.MaviAlmCapturaEmbarqueFisicoTbl.Articulo]
Carpeta=Captura
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Captura.MaviAlmCapturaEmbarqueFisicoTbl.Serie]
Carpeta=Captura
Clave=MaviAlmCapturaEmbarqueFisicoTbl.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
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

