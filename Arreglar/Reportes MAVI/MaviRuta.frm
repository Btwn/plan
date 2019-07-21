[Forma]
Clave=MaviRuta
Nombre=Rutas de Supervisión
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Generales<BR>Detalle
CarpetaPrincipal=Generales
PosicionInicialIzquierda=178
PosicionInicialArriba=51
PosicionInicialAlturaCliente=627
PosicionInicialAncho=1004
ListaAcciones=Nuevo<BR>Abrir<BR>Guardar Cambios<BR>Evaluaciones<BR>Imprimir<BR>RepPantalla<BR>Afectar<BR>Eliminar<BR>Cancelar<BR>Asignar<BR>Anterior<BR>Siguiente<BR>MovPos<BR>Navegador<BR>Cerrar<BR>ConSuper
Menus=S
PosicionSec1=183
BarraAyuda=S
BarraAyudaBold=S
Totalizadores=S
PosicionSec2=525
VentanaEstadoInicial=Normal
DialogoAbrir=S
MenuPrincipal=&Archivo<BR>&Edicion<BR>&Ver
[Generales]
Estilo=Ficha
Clave=Generales
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviRuta
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
ListaEnCaptura=MaviRuta.Mov<BR>MaviRuta.MovID<BR>MaviRuta.UEN<BR>MaviRuta.FechaEmision<BR>MaviRuta.FechaDeAsignacionAlSupervisor<BR>MaviRuta.Agente<BR>Agente.Nombre<BR>MaviRuta.Ruta<BR>MaviRuta.Referencia<BR>MaviRuta.Observaciones
CarpetaVisible=S
[Generales.MaviRuta.Mov]
Carpeta=Generales
Clave=MaviRuta.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Generales.MaviRuta.MovID]
Carpeta=Generales
Clave=MaviRuta.MovID
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Editar=S
Pegado=S
[Generales.MaviRuta.UEN]
Carpeta=Generales
Clave=MaviRuta.UEN
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=8
[Generales.MaviRuta.FechaEmision]
Carpeta=Generales
Clave=MaviRuta.FechaEmision
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Generales.MaviRuta.Agente]
Carpeta=Generales
Clave=MaviRuta.Agente
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Generales.Agente.Nombre]
Carpeta=Generales
Clave=Agente.Nombre
Editar=S
3D=S
Pegado=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro
[Generales.MaviRuta.Ruta]
Carpeta=Generales
Clave=MaviRuta.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro
[Generales.MaviRuta.Referencia]
Carpeta=Generales
Clave=MaviRuta.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro
[Generales.MaviRuta.Observaciones]
Carpeta=Generales
Clave=MaviRuta.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Visible=S
Activo=S

[Acciones.Abrir]
Nombre=Abrir
Boton=2
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=&Abrir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Visible=S
Activo=S

[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Visible=S
Activo=S

[Acciones.Evaluaciones]
Nombre=Evaluaciones
Boton=0
Menu=&Archivo
NombreDesplegar=E&valuaciones
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna(Info.Modulo, <T>MSup<T>)<BR>Asigna(Info.Mov, SQL(<T>SELECT Mov FROM MaviSupervision WHERE ID = :nID<T>, MaviRutaD:MaviRutaD.SupervisionID))<BR>Asigna(Info.MovID, SQL(<T>SELECT MovID FROM MaviSupervision WHERE ID = :nID<T>, MaviRutaD:MaviRutaD.SupervisionID))<BR>Asigna(Info.Clave, <T>MSup<T>+MaviRutaD:MaviRutaD.SupervisionID)<BR>Asigna(Info.Nombre, Info.Mov + <T> <T> + Info.MovID)<BR>Asigna(Info.Aplica, <T>Movimientos<T>)<BR>Forma(Si(MaviRuta:MaviRuta.Estatus en (EstatusConcluido, EstatusCancelado), <T>EvaluacionCalificacionInfo<T>, <T>EvaluacionCalificacion<T>))
ActivoCondicion=(MaviRuta:MaviRuta.Estatus en (EstatusPendiente, EstatusConcluido, EstatusCancelado))
ConCondicion=S
EjecucionCondicion=ConDatos(MaviRutaD:MaviRutaD.SupervisionID)

[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
Menu=&Archivo
NombreDesplegar=&Imprimir...
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
ListaParametros1=Inv:Inv.ID
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
EspacioPrevio=S
Expresion=ReporteImpresora(<T>MaviRuta<T>, MaviRuta:MaviRuta.ID)
ActivoCondicion=Usuario.ImprimirMovs

[Acciones.RepPantalla]
Nombre=RepPantalla
Boton=6
Menu=&Archivo
UsaTeclaRapida=S
NombreDesplegar=&Presentación preliminar
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
ListaParametros1=Inv:Inv.ID
Visible=S
TeclaRapida=Alt+F11
Expresion=ReportePantalla(ReporteMovPantalla(<T>MaviRuta<T>,MaviRuta:MaviRuta.Mov,MaviRuta:MaviRuta.Estatus),MaviRuta:MaviRuta.ID)
ActivoCondicion=Usuario.PreliminarMovs

[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
Menu=&Archivo
NombreDesplegar=E&liminar
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Documento Eliminar
Visible=S
ConCondicion=S
EjecucionConError=S
ActivoCondicion=Vacio(MaviRuta:MaviRuta.MovID) y (MaviRuta:MaviRuta.Estatus en (EstatusSinAfectar)) y PuedeAfectar(Verdadero, Usuario.ModificarOtrosMovs, MaviRuta:MaviRuta.Usuario)
EjecucionCondicion=Vacio(SQL(<T>SELECT MovID FROM MaviRuta WHERE ID=:nID<T>, MaviRuta:MaviRuta.ID))
EjecucionMensaje=Forma.ActualizarForma<BR><T>El movimiento ya fue afectado por otro usuario<T>

[Acciones.Anterior]
Nombre=Anterior
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+,
NombreDesplegar=Anterior
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Anterior
Activo=S
Visible=S

[Acciones.Siguiente]
Nombre=Siguiente
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+.
NombreDesplegar=Siguiente
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Siguiente
Activo=S
Visible=S


[Acciones.MovPos]
Nombre=MovPos
Boton=0
Menu=&Ver
NombreDesplegar=&Posición del Movimiento
EnMenu=S
TipoAccion=Formas
ClaveAccion=MovPos
Antes=S
Visible=S
ActivoCondicion=ConDatos(MaviRuta:MaviRuta.MovID)
AntesExpresiones=Asigna(Info.Modulo, <T>MRuta<T>)<BR>Asigna(Info.ID, MaviRuta:MaviRuta.ID)<BR>Asigna(Info.Mov, MaviRuta:MaviRuta.Mov)<BR>Asigna(Info.MovID, MaviRuta:MaviRuta.MovID)

[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador (Documentos)
Visible=S
Activo=S
EspacioPrevio=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Visible=S
Activo=S
[Acciones.Afectar]
Nombre=Afectar
Boton=7
EnBarraHerramientas=S
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=F12
EnMenu=S
NombreDesplegar=A&fectar
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
ConCondicion=S
EjecucionConError=S
Visible=S
Antes=S
GuardarAntes=S
DespuesGuardar=S

ActivoCondicion=PuedeAfectar(Usuario.Afectar, Usuario.AfectarOtrosMovs, MaviRuta:MaviRuta.Usuario) y<BR>(MaviRuta:MaviRuta.Estatus en (EstatusSinAfectar, EstatusPendiente))
EjecucionCondicion=ConDatos(MaviRuta:MaviRuta.Mov) y ConDatos(MaviRuta:MaviRuta.Agente) y ConDatos(MaviRuta:MaviRuta.Ruta)
EjecucionMensaje=<T>Falta indicar el Movimiento,Ruta o Agente<T>
AntesExpresiones=Si<BR>  MaviRuta:MaviRuta.Estatus = EstatusPendiente<BR>Entonces<BR>  Si sql(<T>SELECT COUNT(ESTATUS) FROM dbo.MaviSupervision WHERE ESTATUS =:tEst AND RUTAID=:nID<T> ,<T>PENDIENTE<T>,MaviRutaD:MaviRutaD.ID) = 0 y<BR>    Precaucion( <T>¿Esta Seguro que Desea Concluir el Movimiento?<T> , BotonSi , BotonNo ) = BotonSi<BR>  Entonces<BR>    Asigna(Temp.Reg, SQL(<T>spMaviRutaAfectar :nID, :tAccion<T>, MaviRuta:MaviRuta.ID, <T>AFECTAR<T>))<BR>    Si(Temp.Reg[1] = 1, Error(Temp.Reg[2]))<BR>  sino<BR>      error(<T>Todas las Supervisiones deben estar CONCLUIDAS<T>)<BR>  Fin<BR>Sino<BR>  Asigna(Temp.Reg, SQL(<T>spMaviRutaAfectar :nID, :tAccion<T>, MaviRuta:MaviRuta.ID, <T>AFECTAR<T>))<BR>  Si(Temp.Reg[1] = 1, Error(Temp.Reg[2]))<BR>  SQL(<T>EXEC SP_MAVIDM0132HistSupAnalisis :nIDRuta <T>,MaviRuta:Ma<CONTINUA>
AntesExpresiones002=<CONTINUA>viRuta.ID)<BR>Fin

[Acciones.Cancelar]
Nombre=Cancelar
Boton=33
Menu=&Archivo
NombreDesplegar=<T>Cancela&r<T>
EnMenu=S
TipoAccion=Controles Captura
Visible=S
EnBarraHerramientas=S
Antes=S
RefrescarDespues=S
GuardarAntes=S
ClaveAccion=Actualizar Vista
DespuesGuardar=S
ActivoCondicion=PuedeAfectar(Usuario.Cancelar, Usuario.CancelarOtrosMovs, MaviRuta:MaviRuta.Usuario) y<BR>ConDatos(MaviRuta:MaviRuta.ID) y ConDatos(MaviRuta:MaviRuta.MovID) y<BR>(MaviRuta:MaviRuta.Estatus en (EstatusPendiente))
AntesExpresiones=Asigna(Afectar.Modulo, <T>MRuta<T>)<BR>Asigna(Afectar.ID, MaviRuta:MaviRuta.ID)<BR>Asigna(Afectar.Mov, MaviRuta:MaviRuta.Mov )<BR>Asigna(Afectar.MovID, MaviRuta:MaviRuta.MovID )<BR>Si<BR>  Precaucion(<T>¿Esta seguro que desea cancelar el movimiento ?<T>+NuevaLinea+NuevaLinea+Afectar.Mov+<T> <T>+Afectar.MovID, BotonSi, BotonNo ) = BotonSi<BR>Entonces<BR>  Asigna(Temp.Reg, SQL(<T>spMaviRutaAfectar :nID, :tAccion<T>, MaviRuta:MaviRuta.ID, <T>CANCELAR<T>))<BR>  Si(Temp.Reg[1] = 1,  Error(Temp.Reg[2]) )<BR>Fin
[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=MaviRuta
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
CarpetaVisible=S
ListaAcciones=AbrirLocalizar<BR>AbrirLocalizarSiguiente<BR>AbrirImprimir<BR>AbrirPreliminar<BR>AbrirExcel<BR>AbrirMostrar
FiltroEstatus=S
FiltroFechas=S
FiltroSucursales=S
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>PENDIENTE<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=PENDIENTE
FiltroUsuarioDefault=(Usuario)
FiltroFechasCampo=MaviRuta.FechaEmision
FiltroFechasDefault=Hoy
FiltroFechasCancelacion=MaviRuta.FechaCancelacion
BusquedaRapida=S
BusquedaEnLinea=S
BusquedaRespetarControles=S
IconosSubTitulo=<T>Movimiento<T>
ListaEnCaptura=MaviRuta.FechaEmision<BR>MaviRuta.Ruta<BR>MaviRuta.Referencia
PestanaOtroNombre=S
PestanaNombre=movimientos
IconosConPaginas=S
FiltroUsuarios=S
FiltroBuscarEn=S
IconosNombre=MaviRuta:MaviRuta.Mov + <T> <T> + MaviRuta:MaviRuta.MovID
[Acciones.AbrirLocalizar]
Nombre=AbrirLocalizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=Alt+F3
NombreDesplegar=&Localizar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.AbrirLocalizarSiguiente]
Nombre=AbrirLocalizarSiguiente
Boton=0
UsaTeclaRapida=S
TeclaRapida=F3
NombreDesplegar=Localizar &Siguiente
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar Siguiente
Activo=S
Visible=S
[Acciones.AbrirImprimir]
Nombre=AbrirImprimir
Boton=0
NombreDesplegar=&Imprimir
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Visible=S
EspacioPrevio=S
ActivoCondicion=Usuario.ImprimirMovs
[Acciones.AbrirPreliminar]
Nombre=AbrirPreliminar
Boton=0
NombreDesplegar=&Presentación preliminar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
ActivoCondicion=Usuario.PreliminarMovs
Visible=S
[Acciones.AbrirExcel]
Nombre=AbrirExcel
Boton=0
NombreDesplegar=Enviar a E&xcel
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
ActivoCondicion=Usuario.EnviarExcel
Visible=S
[Acciones.AbrirMostrar]
Nombre=AbrirMostrar
Boton=0
NombreDesplegar=Personalizar &Vista
EnMenu=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
EspacioPrevio=S
[Detalle]
Estilo=Hoja
Clave=Detalle
OtroOrden=S
ValidarCampos=S
Detalle=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MaviRutaD
Fuente={Tahoma, 8, Negro, []}
VistaMaestra=MaviRuta
LlaveLocal=MaviRutaD.ID
LlaveMaestra=MaviRuta.ID
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaOrden=MaviRutaD.SupervisionID<TAB>(Acendente)
CarpetaVisible=S
ListaEnCaptura=Movimiento<BR>MaviSupervision.Cliente<BR>MaviSupervision.CteCto<BR>MaviRutaD.Estado<BR>MaviRutaD.Observaciones<BR>MaviSupervision.Estatus<BR>MaviRutaD.Deducciones<BR>MaviRutaD.CuentaBono<BR>MaviRutaD.Pago
ListaCamposAValidar=MaviSupervision.FechaEmision<BR>MaviSupervision.Nombre<BR>MaviSupervision.CtoNombre<BR>MaviSupervision.Tipo
PermiteEditar=S
HojaFondoGrisAuto=S
[Detalle.Movimiento]
Carpeta=Detalle
Clave=Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=42
ColorFondo=Plata
ColorFuente=Negro
[Detalle.MaviRutaD.Estado]
Carpeta=Detalle
Clave=MaviRutaD.Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[Detalle.MaviRutaD.Observaciones]
Carpeta=Detalle
Clave=MaviRutaD.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[Detalle.Columnas]
Movimiento=145
Estado=87
Observaciones=268
Cliente=92
CteCto=51
Estatus=94
Deducciones=64
CuentaBono=64
Pago=64
[Detalle.MaviSupervision.Cliente]
Carpeta=Detalle
Clave=MaviSupervision.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Plata
ColorFuente=Negro
[(Carpeta Abrir).MaviRuta.FechaEmision]
Carpeta=(Carpeta Abrir)
Clave=MaviRuta.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).MaviRuta.Ruta]
Carpeta=(Carpeta Abrir)
Clave=MaviRuta.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).MaviRuta.Referencia]
Carpeta=(Carpeta Abrir)
Clave=MaviRuta.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Columnas]
0=156
1=-2
2=246
3=-2
[Detalle.MaviSupervision.CteCto]
Carpeta=Detalle
Clave=MaviSupervision.CteCto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Plata
ColorFuente=Negro
[Acciones.Asignar]
Nombre=Asignar
Boton=65
NombreEnBoton=S
Menu=&Edicion
UsaTeclaRapida=S
TeclaRapida=F7
NombreDesplegar=A&signar Movimientos
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Antes=S
DespuesGuardar=S
Visible=S
EspacioPrevio=S
ActivoCondicion=MaviRuta:MaviRuta.Estatus = EstatusSinAfectar
AntesExpresiones=Asigna(Info.ID, MaviRuta:MaviRuta.ID)<BR>Forma(<T>MaviRutaAsignar<T>)
[(Carpeta Totalizadores)]
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
Totalizadores1=Cuantos
Totalizadores2=Conteo(MaviRutaD:MaviRutaD.ID)
Totalizadores=S
TotCarpetaRenglones=Detalle
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=Cuantos
CarpetaVisible=S
[(Carpeta Totalizadores).Cuantos]
Carpeta=(Carpeta Totalizadores)
Clave=Cuantos
Editar=S
LineaNueva=S
3D=S
Tamano=10
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
[Generales.MaviRuta.FechaDeAsignacionAlSupervisor]
Carpeta=Generales
Clave=MaviRuta.FechaDeAsignacionAlSupervisor
3D=S
Pegado=N
Tamano=23
ColorFondo=$00D8E9EC
ColorFuente=Negro
ValidaNombre=S
[Detalle.MaviSupervision.Estatus]
Carpeta=Detalle
Clave=MaviSupervision.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ConSuper]
Nombre=ConSuper
Boton=7
NombreEnBoton=S
NombreDesplegar=Supervision
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Visible=S
GuardarAntes=S
Expresion=Asigna(Info.Id,MaviRutaD:MaviSupervision.ID)<BR>si condatos(MaviRutaD:MaviRutaD.Estado)<BR>entonces<BR>     si MaviRutaD:MaviRutaD.Estado = <T>En Espera<T><BR>     Entonces<BR>        error(<T>No puede Concluir si el Estado esta En Espera<T>)<BR>        ActualizarVista(<T>MaviRutaD.vis<T>)<BR>        AbortarOperacion<BR>     sino<BR>        si sql(<T>SELECT ESTATUS FROM dbo.MaviSupervision WHERE ID =:nId<T>,Info.ID) = <T>CONCLUIDO<T><BR>        entonces<BR>            ActualizarVista(<T>MaviRutaD.vis<T>)<BR>            error(<T>El movimiento ya esta Concluido<T>)<BR>        sino<BR>            EjecutarSQL(<T>EXEC spMaviSupervisionAfectar :nId,:tMov,:nNum,:tD,:tS<T>,Info.Id,<T>AFECTAR<T>,0,NULO,NULO)<BR>            informacion(<T>Supervision Concluida!!!<T>)<BR>            ActualizarVista(<<CONTINUA>
Expresion002=<CONTINUA>T>MaviRutaD.vis<T>) <BR>        fin<BR>     fin<BR>sino<BR>    error(<T>Selecione un Estado para poder Afectar<T>)<BR><BR>fin
ActivoCondicion=(MaviRuta:MaviRuta.Estatus en (EstatusSinAfectar, EstatusPendiente))
[Detalle.MaviRutaD.Deducciones]
Carpeta=Detalle
Clave=MaviRutaD.Deducciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[Detalle.MaviRutaD.CuentaBono]
Carpeta=Detalle
Clave=MaviRutaD.CuentaBono
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[Detalle.MaviRutaD.Pago]
Carpeta=Detalle
Clave=MaviRutaD.Pago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S

