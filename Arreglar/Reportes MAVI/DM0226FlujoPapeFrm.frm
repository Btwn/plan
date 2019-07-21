[Forma]
Clave=DM0226FlujoPapeFrm
Nombre=Info.ModuloInventariosNombre
Icono=0
Modulos=INV
ListaCarpetas=Ficha<BR>Detalle<BR>valida
CarpetaPrincipal=Ficha
PosicionInicialIzquierda=250
PosicionInicialArriba=210
PosicionInicialAltura=526
PosicionInicialAncho=779
PosicionSeccion1=42
Totalizadores=S
PosicionSeccion2=92
BarraHerramientas=S
BarraAyuda=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
DialogoAbrir=S
ListaAcciones=Nuevo<BR>Guardar Cambios<BR>Cancelar<BR>Cambios<BR>Disponible<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
EsMovimiento=S
Movimientos=Devolucion Interna<BR>Entrada Diversa<BR>Salida Interna<BR>Salida Diversa<BR>Transferencia<BR>Prestamo<BR>Ajuste<BR>Ajuste Fisico
TituloAuto=S
PosicionColumna3=50
BarraAyudaBold=S
MovTipo=Todos
MovModulo=INV
AutoGuardarEncabezado=S
PosicionInicialAlturaCliente=565
TituloAutoNombre=S
PosicionSec1=248
PosicionSec2=445
VentanaEstadoInicial=Normal
PosicionCol1=388
ExpresionesAlMostrar=Asigna(Info.Copiar, Falso)<BR>Asigna(Info.Espacio, Nulo)<BR>Asigna(Info.Articulo, Nulo)
ExpresionesAlCerrar=EjecutarSQL(<T>Exec SP_MAVIDM0226Actualizasuc :nId, :nSuc<T>, Info.ID, Sucursal )

[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=InvA
Fuente={MS Sans Serif, 8, Negro, []}
IconosCampo=(Situación)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
OtroOrden=S
ListaEnCaptura=Inv.Almacen<BR>Inv.AlmacenDestino<BR>Inv.FechaEmision<BR>Inv.Referencia<BR>Inv.Concepto
PestanaOtroNombre=S
PestanaNombre=movimientos
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroFechasCambiar=S
FiltroUsuarios=S
FiltroUsuarioDefault=(Usuario)
FiltroFechasCampo=Inv.FechaEmision
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroEstatus=S
FiltroListaEstatus=(Todos)<BR>SINAFECTAR<BR>CONFIRMAR<BR>BORRADOR<BR>PENDIENTE<BR>SINCRO<BR>CONCLUIDO<BR>CANCELADO
FiltroEstatusDefault=PENDIENTE
FiltroFechas=S
FiltroFechasDefault=(Todo)
BusquedaAvanzada=
BusquedaRespetarControlesNum=S
BusquedaRespetarFiltros=S
Filtros=S
FiltroMovs=S
FiltroMovDef=Devolucion Interna
FiltroMovDefault=(Todos)
IconosConPaginas=S
MenuLocal=S
ListaAcciones=AbrirPropiedades<BR>AbrirLocalizar<BR>AbrirLocalizarSiguiente<BR>AbrirImprimir<BR>AbrirPreliminar<BR>AbrirExcel<BR>AbrirMostrar
IconosSeleccionUnitaria=S
FiltroFechasNormal=S
BusquedaRespetarUsuario=S
FiltroPredefinido=S
FiltroEstilo=Directorio
FiltroAncho=30
FiltroAutoCampo=(Validaciones Memoria)
FiltroAutoValidar=Alm
FiltroAplicaEn=Inv.Almacen
FiltroAplicaO=Inv.AlmacenDestino
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=(Todos)
FiltroNullNombre=(sin clasificar)
FiltroRespetar=S
FiltroTipo=Automático
FiltroGrupo1=(Validaciones Memoria)
FiltroSituacion=S
FiltroSituacionTodo=S
FiltroFechasCancelacion=Inv.FechaCancelacion
FiltroSucursales=S
ListaOrden=Inv.ID<TAB>(Decendente)
FiltroMovsTodos=S
FiltroBuscarEn=S
FiltroSucursalesTodasPorOmision=S
IconosNombre=InvA:Inv.Mov+<T> <T>+InvA:Inv.MovID
FiltroGeneral={Si(SQL(<T>SELECT ISNULL(Filtrar, 0) FROM SubModulo WHERE Modulo=:tModulo AND SubModulo=:tSub<T>, <T>INV<T>, Info.SubModuloInv), <T>Inv.SubModulo=<T>+Comillas(Info.SubModuloInv), <T>1=1<T>)}

[(Carpeta Abrir).Columnas]
0=184
1=85
2=93
3=83
4=96
5=169
6=71
7=-2

[(Carpeta Abrir).Inv.Almacen]
Carpeta=(Carpeta Abrir)
Clave=Inv.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro

[(Carpeta Abrir).Inv.AlmacenDestino]
Carpeta=(Carpeta Abrir)
Clave=Inv.AlmacenDestino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro

[(Carpeta Abrir).Inv.FechaEmision]
Carpeta=(Carpeta Abrir)
Clave=Inv.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro










[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=guarda<BR>afec<BR>inserta<BR>alms
ConCondicion=S
EspacioPrevio=S
Antes=S
ActivoCondicion=(DM0226InvVis:Inv.Estatus en (EstatusSinAfectar, EstatusBorrador, EstatusPorConfirmar))
EjecucionCondicion=Caso  DM0226InvVis:Inv.Mov<BR>  Es <T>Solicitud Papeleria<T> Entonces<BR><BR><BR>            Si<BR>                  ((ConDatos(DM0226InvVis:Inv.Almacen))  y (ConDatos(DM0226InvVis:Inv.ContUsoMAVI))  y (ConDatos(DM0226InvVis:Inv.Personal)) y (Condatos(DM0226InvDVis:InvD.Articulo)))<BR>                Entonces<BR><BR>                      verdadero<BR>                Sino<BR>                      Error(<T>Debe llenar los campos de Centro de costos, almacen, Personal y Articulo en detalle<T>)<BR>                      AbortarOperacion<BR>            Fin<BR><BR><BR><BR><BR>  Es <T>Solicitud<T>  Entonces                                         <BR>                      <BR>        Si<BR>          ((ConDatos(DM0226InvVis:Inv.AlmacenDestino)) y (Condatos(DM0226InvDVis:InvD.Articulo)) )<BR>       <CONTINUA>
EjecucionCondicion002=<CONTINUA>     Entonces<BR><BR>                  Verdadero<BR>            Sino<BR>                  Error(<T>Debe llenar los campos de AlmacenDestino y Articulo en detalle<T>)<BR>                  AbortarOperacion<BR><BR>         Fin                                                                                <BR>    Si<BR>      SQL(<T>Select Count(Almacen) From UsuarioAlm Where Usuario=:tUsr and Almacen=:talm<T>, Usuario,DM0226InvVis:Inv.AlmacenDestino) > 0<BR>        Entonces<BR>          Verdadero<BR>        Sino<BR>          Error(<T>El AlmacenDestino es incorrecto no pertenece a la Sucursal<T>)<BR>          AbortarOperacion<BR>    Fin<BR><BR><BR>Sino<BR>  Falso<BR><BR>Fin
AntesExpresiones=Asigna(Info.ID, DM0226InvVis:Inv.ID)







[Acciones.Totalizar]
Nombre=Totalizar
Boton=0
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=F8
NombreDesplegar=&Totalizar
EnMenu=S
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Visible=S
Activo=
ActivoCondicion=Inv:Inv.Estatus=EstatusSinAfectar

[Acciones.Verificar]
Nombre=Verificar
Boton=41
Menu=&Archivo
NombreDesplegar=<T>&Verificar<T>
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Visible=S
EspacioPrevio=S
GuardarAntes=S
ConCondicion=S
Expresion=Asigna(Afectar.Modulo, <T>INV<T>)<BR>Asigna(Afectar.ID, Inv:Inv.ID)<BR>Asigna(Afectar.Mov, Inv:Inv.Mov)<BR>Asigna(Afectar.MovID, Inv:Inv.MovID)<BR>Asigna(Afectar.GenerarMov, Nulo)<BR>Si(MovTipo(<T>INV<T>,Inv:Inv.Mov)=INV.IF, Asigna(Afectar.GenerarMov, ConfigMov.InvAjuste))<BR>Verificar(Afectar.Modulo, Afectar.ID, Afectar.Mov, Afectar.MovID, <T>Todo<T>, Afectar.GenerarMov)
ActivoCondicion=Inv:Inv.Estatus en (EstatusSinAfectar,EstatusPorConfirmar,EstatusBorrador)
EjecucionCondicion=ConDatos(Inv:Inv.Mov)

[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C1
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=Total<BR>Conteo
Totalizadores2=Si(Usuario.Costos y ((MovTipoEn(<T>INV<T>,DM0226InvVis:Inv.Mov,(INV.E,INV.EP,INV.EI,INV.A,INV.TIS)) o (DM0226InvVis:Inv.Estatus=EstatusConcluido)) y (no MovTipoEn(<T>INV<T>,DM0226InvVis:Inv.Mov,(INV.T, INV.TG, INV.P, INV.R, INV.IF))) y (DM0226InvVis:Alm.Tipo<><T>Garantias<T>)), Suma(DM0226InvDVis:Importe), Nulo)<BR>Conteo(DM0226InvDVis:InvD.Articulo)
Totalizadores3=(Monetario)
Totalizadores=S
TotCarpetaRenglones=Detalle
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=Total<BR>Conteo
CondicionVisible=MovTipo(<T>INV<T>, DM0226InvVis:Inv.Mov) noen (INV.SOL, INV.OT, INV.OI, INV.TI, INV.DTI, INV.SM)

[Detalle]
Estilo=Hoja
Clave=Detalle
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0226InvDVis
Fuente={MS Sans Serif, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=InvD.ProdSerieLote<BR>InvD.Producto<BR>InvD.SubProducto<BR>InvD.AplicaID<BR>AplicaNombre<BR>InvD.Destino<BR>InvD.DestinoID<BR>DestinoNombre<BR>InvD.Codigo<BR>InvD.Articulo<BR>ClaveIdioma<BR>InvD.Cantidad<BR>InvD.SegundoConteo<BR>CantidadNeta<BR>UltimoConteo<BR>InvD.Merma<BR>InvD.Desperdicio<BR>CantidadInvNeta<BR>InvD.Precio<BR>InvD.Tipo<BR>InvD.FechaRequerida<BR>InvD.Cliente<BR>InvD.CantidadReservada<BR>InvD.CantidadPendiente<BR>InvD.Costo<BR>InvD.CostoInv<BR>Importe<BR>InvD.Almacen<BR>InvD.Posicion<BR>InvD.ContUso<BR>InvD.DescripcionExtra<BR>InvD.CantidadA
CarpetaVisible=S
Detalle=S
VistaMaestra=DM0226InvVis
LlaveLocal=InvD.ID
LlaveMaestra=Inv.ID
ControlRenglon=S
CampoRenglon=InvD.Renglon
ValidarCampos=S
HojaSubCta=Si
HojaSubNS=Si
MenuLocal=S
ListaAcciones=dispon
OtroOrden=S
ListaOrden=InvD.Renglon<TAB>(Acendente)<BR>InvD.RenglonSub<TAB>(Acendente)
ControlRenglonID=S
ControlRenglonTipo=S
HojaColoresPorTipo=S
CampoDespliegaTipo=Art.Tipo
ConResumen=S
ResumenVista=InvR
ResumenLlave=ID
ResumenCampos=Articulo<BR>Descripcion1<BR>Cantidad<BR>Pendiente<BR>Costo<BR>Importe<BR>Almacen
VistaOmision=Resumén
ResumenVistaMaestra=DM0226InvVis
ResumenLlaveMaestra=Inv.ID
HojaVistaOmision=Automática
HojaFondoGrisAuto=S
PermiteLocalizar=S
HojaAjustarColumnas=S
CampoDespliegaTipoOpcion=Art.TipoOpcion
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
ListaCamposAValidar=Art.Descripcion1<BR>OpcionDesc<BR>Art.Tipo<BR>Art.UnidadCompra<BR>Art.Unidad
FiltroGeneral={Si((Info.MovTipo=INV.IF) y (Config.InvFisicoConteo=3), <T>(Inv.Estatus=<T>+Comillas(EstatusConcluido)+<T> OR InvD.SegundoConteo IS NULL OR InvD.Cantidad<>InvD.SegundoConteo)<T>, <T><T>)}

[Detalle.Columnas]
Cantidad=51
Articulo=103
SubCuenta=99
Costo=76
Importe=76
CantidadPendiente=54
CantidadA=49
Disponible=63
Estatus=110
Renglon=64
RenglonID=64
RenglonTipo=54
DisponibleCuenta=75
Aplica=115
AplicaID=66
Paquete=46
CentroCostos=108
ContUso=73
CantidadOrdenada=53
CantidadReservada=57
ArticuloDestino=148
SegundoConteo=58
Unidad=53
CantidadInventario=53
CantidadNeta=49
Almacen=67
FechaRequerida=88
ProdSerieLote=60
Grupo=60
Producto=56
SubProducto=56
Tipo=64
Merma=38
Desperdicio=34
AplicaNombre=125
ClaveIdioma=99
Precio=73
CostoInv=85
Espacio=94
Destino=70
DestinoID=63
DestinoNombre=118
Cliente=64
CantidadInvNeta=56
NumeroEconomico=93
SubCuentaDestino=147
UltimoConteo=71
Codigo=86
Posicion=64
DescripcionExtra=223

[Detalle.ColumnasResumen]
Articulo=117
Descripcion1=175
Cantidad=68
Costo=75
Importe=82
Pendiente=56
Almacen=62




[Detalle.InvD.Articulo]
Carpeta=Detalle
Clave=InvD.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Detalle.InvD.Cantidad]
Carpeta=Detalle
Clave=InvD.Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro





[Ficha]
Estilo=Ficha
Clave=Ficha
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0226InvVis
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Inv.Mov<BR>Inv.MovID<BR>Inv.Moneda<BR>Inv.FechaEmision<BR>Inv.Personal<BR>Inv.ContUsoMAVI<BR>Inv.Almacen<BR>Inv.AlmacenDestino<BR>Inv.Concepto<BR>Inv.Largo<BR>Inv.Condicion<BR>Inv.Vencimiento<BR>Inv.VerDestino<BR>Inv.Observaciones<BR>Inv.Agente<BR>Inv.Referencia
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Datos Generales
Pestana=S

[Ficha.Inv.Almacen]
Carpeta=Ficha
Clave=Inv.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
Pegado=N
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Inv.AlmacenDestino]
Carpeta=Ficha
Clave=Inv.AlmacenDestino
Editar=S
3D=S
Tamano=20
ValidaNombre=S
ColorFondo=Blanco
ColorFuente=Negro


[Ficha.Inv.Concepto]
Carpeta=Ficha
Clave=Inv.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=N

[Ficha.Inv.Condicion]
Carpeta=Ficha
Clave=Inv.Condicion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
Pegado=N
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Inv.FechaEmision]
Carpeta=Ficha
Clave=Inv.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
EspacioPrevio=S
IgnoraFlujo=N
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Inv.Largo]
Carpeta=Ficha
Clave=Inv.Largo
Editar=S
ValidaNombre=N
3D=S
Tamano=7
ColorFondo=Blanco
ColorFuente=Negro


[Ficha.Inv.Mov]
Carpeta=Ficha
Clave=Inv.Mov
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Inv.MovID]
Carpeta=Ficha
Clave=Inv.MovID
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=8
ColorFondo=Plata
ColorFuente=Negro
Pegado=S
IgnoraFlujo=S

[Ficha.Inv.Observaciones]
Carpeta=Ficha
Clave=Inv.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro




[Ficha.Inv.Vencimiento]
Carpeta=Ficha
Clave=Inv.Vencimiento
Editar=S
ValidaNombre=N
3D=S
Tamano=16
Pegado=N
ColorFondo=Blanco
ColorFuente=Negro

[(Carpeta Abrir).Inv.Referencia]
Carpeta=(Carpeta Abrir)
Clave=Inv.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Localizar]
Nombre=Localizar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Mayús+F3
NombreDesplegar=L&ocalizar...
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Localizar
Activo=S
Visible=S

[(Carpeta Abrir).Inv.Concepto]
Carpeta=(Carpeta Abrir)
Clave=Inv.Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
























[Acciones.ArtListaDisponible]
Nombre=ArtListaDisponible
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+L
NombreDesplegar=&Lista Artículos Disponibles
EnMenu=S
TipoAccion=Formas
ClaveAccion=ArtListaDisponible
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.Almacen, Si(MovTipo(<T>INV<T>, Inv:Inv.Mov)=INV.EI, Inv:Inv.AlmacenDestino, Inv:Inv.Almacen))<BR>Asigna(Info.Origen, <T>INV<T>)








[Acciones.Propiedades]
Nombre=Propiedades
Boton=0
Menu=&Archivo
NombreDesplegar=Propie&dades
EnMenu=S
TipoAccion=Formas
ClaveAccion=MovPropiedades
Antes=S
Visible=S
ActivoCondicion=ConDatos(Inv:Inv.ID)
AntesExpresiones=Asigna(Info.Modulo, <T>INV<T>)<BR>Asigna(Info.ID, Inv:Inv.ID)

[Acciones.MovCopiar]
Nombre=MovCopiar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Mayús+F11
NombreDesplegar=&Copiar
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=CopiarMovimiento(<T>INV<T>, Inv:Inv.ID, <T>Inv<T>)

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


[(Carpeta Totalizadores).Conteo]
Carpeta=(Carpeta Totalizadores)
Clave=Conteo
Editar=S
ValidaNombre=N
3D=S
Pegado=S
Tamano=5
ColorFondo=Plata
ColorFuente=Negro

[(Carpeta Totalizadores).Total]
Carpeta=(Carpeta Totalizadores)
Clave=Total
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]


[Acciones.AbrirLocalizar]
Nombre=AbrirLocalizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=Alt+F3
NombreDesplegar=&Localizar
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S

[Acciones.AbrirLocalizarSiguiente]
Nombre=AbrirLocalizarSiguiente
Boton=0
UsaTeclaRapida=S
TeclaRapida=F3
NombreDesplegar=Localizar &Siguiente
EnMenu=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Localizar Siguiente
Activo=S
Visible=S





[Detalle.InvD.Almacen]
Carpeta=Detalle
Clave=InvD.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

























[Ficha.Inv.VerDestino]
Carpeta=Ficha
Clave=Inv.VerDestino
Editar=S
3D=S
Tamano=9
ColorFondo=Blanco
ColorFuente=Negro














































[Acciones.Guardar Cambios.guarda]
Nombre=guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar Cambios.afec]
Nombre=afec
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  DM0226InvVis:Inv.Mov =<T>Solicitud Papeleria<T><BR>Entonces<BR>    Asigna(Afectar.Modulo, <T>INV<T>)<BR>    Asigna(Afectar.ID, DM0226InvVis:Inv.ID)<BR>    Asigna(Afectar.Mov, DM0226InvVis:Inv.Mov)<BR>    Asigna(Afectar.MovID, DM0226InvVis:Inv.MovID)<BR>    Asigna(Afectar.Base, <T>Todo<T>)<BR>    Asigna(Afectar.GenerarMov, <T><T>)<BR>    Asigna(Afectar.FormaCaptura, <T>DM0226PruebaInv<T>)<BR>    Asigna(Info.Respuesta2,DM0226InvVis:Inv.Observaciones)<BR><BR>    Afectar(Afectar.Modulo, Afectar.ID, Afectar.Mov, Afectar.MovID, Afectar.Base, Afectar.GenerarMov, Afectar.FormaCaptura,Usuario)<BR>     Asigna(Info.Respuesta1,SI(SQL(<T>Select ID From Inv Where Id=:nId and Estatus=:tEst<T>,DM0226InvVis:Inv.ID,<T>PENDIENTE<T>),<T>YES<T>,<T>NO<T>))<BR>                                    <CONTINUA>
Expresion002=<CONTINUA>         <BR>     ActualizarForma(<T>DM0226FlujoPapeFrm<T>)<BR>                                                                 <BR>Fin
[Ficha.]
Carpeta=Ficha
ColorFondo=Negro
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Elim<BR>Abri
[Ficha.Inv.Agente]
Carpeta=Ficha
Clave=Inv.Agente
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Inv.ContUsoMAVI]
Carpeta=Ficha
Clave=Inv.ContUsoMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cancelar.Elim]
Nombre=Elim
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Afectar.Modulo, <T>INV<T>)<BR>Asigna(Afectar.ID, DM0226InvVis:Inv.ID)<BR>Asigna(Afectar.Mov, DM0226InvVis:Inv.Mov )<BR>Asigna(Afectar.MovID, DM0226InvVis:Inv.MovID )<BR>Si<BR>  (DM0226InvVis:Inv.Estatus=EstatusPendiente) y (MovTipo(<T>INV<T>,DM0226InvVis:Inv.Mov) en (INV.SOL, INV.OT, INV.OI, INV.SM))<BR>Entonces<BR>  Asigna(Info.TituloDialogo, <T>Cancelar: <T>+Afectar.Mov+<T> <T>+Afectar.MovID)<BR>  Dialogo(<T>CancelarPendiente<T>)<BR>Sino<BR>  Si<BR>    Precaucion(<T>¿ Esta seguro que desea cancelar el movimiento ?<T>+NuevaLinea+NuevaLinea+Afectar.Mov+<T> <T>+Afectar.MovID, BotonSi, BotonNo ) = BotonSi<BR>  Entonces<BR>    Cancelar(<T>INV<T>, DM0226InvVis:Inv.ID, Afectar.Mov, Afectar.MovID, <T>Todo<T>, <T><T>, <T>Inv<T>)<BR>  Fin<BR>Fin
[Acciones.Cancelar.Abri]
Nombre=Abri
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Documento Abrir
[Valida.Articulo]
Carpeta=valida
Clave=Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Valida.Cantidad]
Carpeta=valida
Clave=Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Valida.Columnas]
Articulo=124
Cantidad=64
[Acciones.Guardar Cambios.inserta]
Nombre=inserta
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  (Info.Respuesta1=<T>YES<T>) y (DM0226InvVis:Inv.Mov=<T>Solicitud Papeleria<T>)<BR>Entonces<BR>  SQL(<T>Exec SP_MAVIDM0226InsertaInvMov :nID<T>,DM0226InvVis:Inv.ID)         <BR>Sino<BR>  Falso<BR>Fin
[valida]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Valida
Clave=valida
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0226InvMovVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0226InvMovtbl.Articulo<BR>DM0226InvMovtbl.Cantidad
CarpetaVisible=S
PermiteEditar=S
ExpAntesRefrescar=Asigna(Info.ID,DM0226InvVis:Inv.ID)
Detalle=S
VistaMaestra=DM0226InvVis
LlaveLocal=DM0226InvMovtbl.ID
LlaveMaestra=Inv.ID
MenuLocal=S
ListaAcciones=Elimina
HojaMantenerSeleccion=S
[valida.DM0226InvMovtbl.Articulo]
Carpeta=valida
Clave=DM0226InvMovtbl.Articulo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
[valida.DM0226InvMovtbl.Cantidad]
Carpeta=valida
Clave=DM0226InvMovtbl.Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EditarConBloqueo=S
IgnoraFlujo=N
[Acciones.Cambios]
Nombre=Cambios
Boton=18
NombreEnBoton=S
NombreDesplegar=Cambios en &Validacion
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Visible=S
Multiple=S
ListaAccionesMultiples=Validar<BR>Regresa
ActivoCondicion=(DM0226InvVis:Inv.Mov=<T>Solicitud Papeleria<T>)  y (DM0226InvVis:Inv.Estatus=<T>PENDIENTE<T>)
[Detalle.InvD.ProdSerieLote]
Carpeta=Detalle
Clave=InvD.ProdSerieLote
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Producto]
Carpeta=Detalle
Clave=InvD.Producto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.SubProducto]
Carpeta=Detalle
Clave=InvD.SubProducto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.AplicaID]
Carpeta=Detalle
Clave=InvD.AplicaID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.AplicaNombre]
Carpeta=Detalle
Clave=AplicaNombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Destino]
Carpeta=Detalle
Clave=InvD.Destino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.DestinoID]
Carpeta=Detalle
Clave=InvD.DestinoID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DestinoNombre]
Carpeta=Detalle
Clave=DestinoNombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Codigo]
Carpeta=Detalle
Clave=InvD.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.ClaveIdioma]
Carpeta=Detalle
Clave=ClaveIdioma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.SegundoConteo]
Carpeta=Detalle
Clave=InvD.SegundoConteo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CantidadNeta]
Carpeta=Detalle
Clave=CantidadNeta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.UltimoConteo]
Carpeta=Detalle
Clave=UltimoConteo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Merma]
Carpeta=Detalle
Clave=InvD.Merma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Desperdicio]
Carpeta=Detalle
Clave=InvD.Desperdicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.CantidadInvNeta]
Carpeta=Detalle
Clave=CantidadInvNeta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Precio]
Carpeta=Detalle
Clave=InvD.Precio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Tipo]
Carpeta=Detalle
Clave=InvD.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.FechaRequerida]
Carpeta=Detalle
Clave=InvD.FechaRequerida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Cliente]
Carpeta=Detalle
Clave=InvD.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.CantidadReservada]
Carpeta=Detalle
Clave=InvD.CantidadReservada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.CantidadPendiente]
Carpeta=Detalle
Clave=InvD.CantidadPendiente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Costo]
Carpeta=Detalle
Clave=InvD.Costo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.CostoInv]
Carpeta=Detalle
Clave=InvD.CostoInv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Importe]
Carpeta=Detalle
Clave=Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.Posicion]
Carpeta=Detalle
Clave=InvD.Posicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.ContUso]
Carpeta=Detalle
Clave=InvD.ContUso
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.DescripcionExtra]
Carpeta=Detalle
Clave=InvD.DescripcionExtra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.InvD.CantidadA]
Carpeta=Detalle
Clave=InvD.CantidadA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Inv.Moneda]
Carpeta=Ficha
Clave=Inv.Moneda
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
NombreEnBoton=S
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S
[Acciones.cerrar]
Nombre=cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Info.ID,DM0226InvVis:Inv.ID)
[Ficha.Inv.Personal]
Carpeta=Ficha
Clave=Inv.Personal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Inv.Referencia]
Carpeta=Ficha
Clave=Inv.Referencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=40
[Acciones.Guardar Cambios.alms]
Nombre=alms
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Sucursal, SQL(<T>Select Sucursal From Alm Where Almacen=:tAlm<T>,DM0226InvVis:Inv.Almacen))<BR>DM0226InvVis:Inv.Sucursal=Info.sucursal<BR>DM0226InvVis:Inv.SucursalOrigen=Info.sucursal<BR>EjecutarSQL(<T>Exec SP_MAVIDM0226Actualizasuc :nId, :nSuc<T>, Info.ID, Sucursal )
[Acciones.Disponible]
Nombre=Disponible
Boton=78
NombreDesplegar=&disponible 
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
Expresion=Asigna(Info.Origen, <T>INV<T>)<BR>Asigna(Info.Articulo, DM0226InvDVis:InvD.Articulo)<BR>Asigna(Info.Descripcion, DM0226InvDVis:Art.Descripcion1)<BR>Asigna(Info.ArtTipo, DM0226InvDVis:Art.Tipo)<BR>Asigna(Info.ArtTipoOpcion, DM0226InvDVis:Art.TipoOpcion)<BR>Asigna(Info.Almacen, Si(Config.InvMultiAlmacen y (MovTipo(<T>INV<T>, DM0226InvVis:Inv.Mov) noen (INV.IF, INV.EI, INV.P, INV.R)), DM0226InvDVis:InvD.Almacen, Si(MovTipo(<T>INV<T>, DM0226InvVis:Inv.Mov)=INV.EI, DM0226InvVis:Inv.AlmacenDestino, DM0226InvVis:Inv.Almacen)))<BR>Forma(<T>ArtAlmExistencia<T>)
AntesExpresiones=Asigna(Info.ID,DM0226InvVis:Inv.ID)
[Acciones.dispon]
Nombre=dispon
Boton=0
NombreDesplegar=Disponible
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+D
Expresion=Asigna(Info.Origen, <T>INV<T>)<BR>Asigna(Info.Articulo, DM0226InvDVis:InvD.Articulo)<BR>Asigna(Info.Descripcion, DM0226InvDVis:Art.Descripcion1)<BR>Asigna(Info.ArtTipo, DM0226InvDVis:Art.Tipo)<BR>Asigna(Info.ArtTipoOpcion, DM0226InvDVis:Art.TipoOpcion)<BR>Asigna(Info.Almacen, Si(Config.InvMultiAlmacen y (MovTipo(<T>INV<T>, DM0226InvVis:Inv.Mov) noen (INV.IF, INV.EI, INV.P, INV.R)), DM0226InvDVis:InvD.Almacen, Si(MovTipo(<T>INV<T>, DM0226InvVis:Inv.Mov)=INV.EI, DM0226InvVis:Inv.AlmacenDestino, DM0226InvVis:Inv.Almacen)))<BR>Forma(<T>ArtAlmExistencia<T>)
[Acciones.Elimina]
Nombre=Elimina
Boton=0
NombreDesplegar=Eliminar
EnMenu=S
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>EXEC SP_DM0226ElimnaInvmov  :nID,:tArt<T>, DM0226InvMovVis:DM0226InvMovtbl.ID, DM0226InvMovVis:DM0226InvMovtbl.Articulo)<BR>  ActualizarVista
Activo=S
Visible=S
[Acciones.Cambios.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.ID,DM0226InvVis:Inv.ID)<BR>Asigna(Info.Respuesta3,DM0226InvMovVis:DM0226InvMovtbl.Articulo)                /*Guarda el Articulo*/<BR>Asigna(Info.Cantidad2,DM0226InvMovVis:DM0226InvMovtbl.Cantidad)           /*Guarda Cantidad inicial*/<BR><BR>GuardarCambios(DM0226InvMovVis:DM0226InvMovtbl.Cantidad)                      /*Guarda Cantidad afectada*/<BR><BR>Asigna(Info.Cantidad3, SQL(<T>SELECT Cantidad FROM DM0226InvMov WHERE Articulo=:tArticulo  AND ID=:nID<T>,Info.Respuesta3,DM0226InvMovVis:DM0226InvMovtbl.ID))<BR><BR>SI (Info.Cantidad3 = nulo )<BR>    ENTONCES<BR>         Error( <T>Inserte una cantidad<T>,BotonAceptar )<BR>SINO<BR>    Asigna(Info.CadenaCanal,SQL(<T>SELECT * FROM  FN_MAVIDM02226ValidacionCantidad (:tMovID, :nCantidad, :tArticulo)<T>,DM0226InvVis:Inv.MovID,Info.Ca<CONTINUA>
Expresion002=<CONTINUA>ntidad3,Info.Respuesta3))<BR>    SI<BR>        Info.CadenaCanal = <T>IGUALES<T><BR>    ENTONCES<BR>      Informacion(<T>Las cantidades coinciden<T>,BotonAceptar)<BR>      Asigna(Info.Mensaje,<T>correcto<T>)<BR>    SINO<BR>      Si(Error(<T>Diferentes Cantidades <T>,BotonCancelar,BotonAceptar)=BotonCancelar,Asigna(Info.Mensaje,<T>Regresar<T>),Asigna(Info.Mensaje,<T>correcto<T>))<BR>    FIN<BR>FIN
[Acciones.Cambios.Regresa]
Nombre=Regresa
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=SI (Info.Mensaje = <T>Regresar<T>)<BR>    ENTONCES)<BR>      EJECUTARSQL(<T>Exec SP_MAVIDM0226RegresaCantidadOriginal <T>+DM0226InvMovVis:DM0226InvMovtbl.ID+<T>,<T>+Info.Cantidad2+<T>,<T>+Info.Respuesta3+<T><T>)<BR>       ActualizarForma(<T>DM0226FlujoPapeFrm<T>)<BR>SINO<BR>    ActualizarForma(<T>DM0226FlujoPapeFrm<T>)<BR>FIN

