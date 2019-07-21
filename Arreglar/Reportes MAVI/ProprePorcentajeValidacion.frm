[Forma]
Clave=ProprePorcentajeValidacion
Nombre=Porcentaje Validacion Propre
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=287
PosicionInicialAncho=390
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>PropreNuevoPorcentaje<BR>PropreEditarPorcentaje<BR>Cerrar<BR>Imprimir<BR>PropreConsecutivoCfg<BR>PropreEliminarPorcentaje
PosicionInicialIzquierda=445
PosicionInicialArriba=239
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Comentarios=//Info.PropreSeccionPorcentaje;
VentanaExclusiva=S
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ProprePorcentajeValidacion
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Rojo
CampoColorFondo=Blanco
ListaEnCaptura=ProprePorcentajeValidacion.Porcentaje
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Porcentaje Validación
Filtros=S
FiltroPredefinido=S
FiltroAutoCampo=ProprePorcentajeValidacion.Seccion
FiltroAutoValidar=ProprePorcentajeValidacion.Seccion
FiltroAutoOrden=ProprePorcentajeValidacion.Seccion
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroEstilo=Lista (Arriba)
FiltroRespetar=S
FiltroTipo=Predefinido
FiltroPredefinido1=Articulos<BR>Catálogo De Listas<BR>Empresas<BR>Lista De Contado<BR>Lista De Crédito<BR>Lista De Mayoreo<BR>Lista Doble<BR>Lista Doble M2<BR>Pagos Diferidos<BR>Sucursales<BR>UEN Clase
FiltroPredefinido2={Asigna(Info.PropreSeccionPorcentaje,<T>Articulos<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje,<T>Catálogo De Listas<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje,<T>Empresas<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Lista De Contado<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Lista De Crédito<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Lista<CONTINUA>
FiltroPredefinido3=ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion<BR>ProprePorcentajeValidacion.Seccion
FiltroPredefinido2002=<CONTINUA> De Mayoreo<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Lista Doble<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Lista Doble M2<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Pagos Diferidos<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>Sucursales<T>);<T>1=1 AND <T>}ProprePorcentajeValidacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T><BR>{Asigna(Info.PropreSeccionPorcentaje, <T>UEN Clase<T>);<T>1=1 AND <T>}ProprePorcentajeVali<CONTINUA>
FiltroPredefinido2003=<CONTINUA>dacion.Seccion = <T>{Info.PropreSeccionPorcentaje}<T>
MenuLocal=S
ListaAcciones=PropreEditarPorcentajeDet<BR>PropreNuevoPorcentajeDet<BR>PropreEliminarPorcentajeDet
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Codigo<T>
IconosConRejilla=S
IconosNombre=ProprePorcentajeValidacion:ProprePorcentajeValidacion.Codigo
[Lista.ProprePorcentajeValidacion.Porcentaje]
Carpeta=Lista
Clave=ProprePorcentajeValidacion.Porcentaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.Columnas]
Codigo=66
Porcentaje=73
Seccion=643
CodigoAct=64
CodigoMAximo=69
0=-2
1=134
[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreDesplegar=&Guardar y Cerrar
GuardarAntes=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.PropreConsecutivoCfg]
Nombre=PropreConsecutivoCfg
Boton=78
NombreEnBoton=S
NombreDesplegar=Consecutivo Sección
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=PropreConsecutivoCfg
Activo=S
Visible=S
[Acciones.PropreNuevoPorcentaje]
Nombre=PropreNuevoPorcentaje
Boton=1
NombreEnBoton=S
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mensaje, Nulo)<BR>Asigna(Info.PropreNuevoPorcentaje, Nulo)<BR>Si FormaModal(<T>PropreAgregarPorcentajePorSeccion<T>) Entonces<BR>  Si ConDatos(Info.PropreNuevoPorcentaje) Entonces<BR>    Asigna(Info.Mensaje, SQL(<T>EXEC xpValidaPropreConsecutivo :tSeccion, :tEmpresa, :nSucursal<T>, Info.PropreSeccionPorcentaje, Empresa, Sucursal))<BR>    Si Info.Mensaje = <T>0<T> Entonces<BR>      Asigna(Info.Mensaje, SQL(<T>EXEC spPropreActualizarPorcentajes :tAccion, :tSeccion, :tPorcentaje, NULL, :tEmpresa, :nSucursal, :nEstacion<T>, <T>INSERTAR<T>, Info.PropreSeccionPorcentaje, Info.PropreNuevoPorcentaje, Empresa, Sucursal, EstacionTrabajo))<BR>      Si Info.Mensaje = <T>0<T> Entonces<BR>        ActualizarVista<BR>      Sino<BR>        Error(Info.Mensaje)<BR>      Fin<BR>    Sino<BR>      E<CONTINUA>
Expresion002=<CONTINUA>rror(Info.Mensaje)<BR>    Fin<BR>  Sino<BR>    Error(<T>Porcentaje nulo<T>)<BR>  Fin<BR>Fin
[Acciones.PropreNuevoPorcentajeDet]
Nombre=PropreNuevoPorcentajeDet
Boton=0
NombreDesplegar=&Nuevo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Forma.Accion(<T>PropreNuevoPorcentaje<T>)
[Acciones.PropreEditarPorcentaje]
Nombre=PropreEditarPorcentaje
Boton=45
NombreEnBoton=S
NombreDesplegar=&Editar
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mensaje, Nulo)<BR>Si ConDatos(ProprePorcentajeValidacion:ProprePorcentajeValidacion.Codigo) Entonces<BR>  Asigna(Info.PropreNuevoPorcentaje, ProprePorcentajeValidacion:ProprePorcentajeValidacion.Porcentaje)<BR>  Si FormaModal(<T>PropreAgregarPorcentajePorSeccion<T>) Entonces<BR><BR>  Si ConDatos(Info.PropreNuevoPorcentaje) Entonces<BR>    Asigna(Info.Mensaje, SQL(<T>EXEC xpValidaPropreConsecutivo :tSeccion, :tEmpresa, :nSucursal<T>, Info.PropreSeccionPorcentaje, Empresa, Sucursal))<BR>    Si Info.Mensaje = <T>0<T> Entonces<BR>      Asigna(Info.Mensaje, SQL(<T>EXEC spPropreActualizarPorcentajes :tAccion, :tSeccion, :nPorcentaje, :tCodigo, :tEmpresa, :nSucursal, :nEstacion<T>, <T>EDITAR<T>, Info.PropreSeccionPorcentaje, Info.PropreNuevoPorcentaje, ProprePorcentajeValidacion:Propr<CONTINUA>
Expresion002=<CONTINUA>ePorcentajeValidacion.Codigo, Empresa, Sucursal, EstacionTrabajo))<BR>      Si Info.Mensaje = <T>0<T> Entonces<BR>        ActualizarVista<BR>      Sino<BR>        Error(Info.Mensaje)<BR>      Fin<BR>    Sino<BR>      Error(Info.Mensaje)<BR>    Fin<BR>  Sino<BR>    Error(<T>Porcentaje nulo<T>)<BR>  Fin<BR><BR>  Fin<BR>Fin
[Acciones.PropreEditarPorcentajeDet]
Nombre=PropreEditarPorcentajeDet
Boton=0
NombreDesplegar=&Editar
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
EnMenu=S
Expresion=Forma.Accion(<T>PropreEditarPorcentaje<T>)
[Acciones.PropreEliminarPorcentaje]
Nombre=PropreEliminarPorcentaje
Boton=5
NombreEnBoton=S
NombreDesplegar=Eliminar
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC spPropreEliminarPorcentajes :tCodigo, :tSeccion<T>, ProprePorcentajeValidacion:ProprePorcentajeValidacion.Codigo, ProprePorcentajeValidacion:ProprePorcentajeValidacion.Seccion)<BR>ActualizarVista
[Acciones.PropreEliminarPorcentajeDet]
Nombre=PropreEliminarPorcentajeDet
Boton=0
NombreDesplegar=Eliminar
EnMenu=S
TipoAccion=Expresion
Expresion=Forma.Accion(<T>PropreEliminarPorcentaje<T>)
Activo=S
Visible=S
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=ProprePorcentaje
Activo=S
Visible=S
EspacioPrevio=S

