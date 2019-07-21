[Forma]
Clave=DM0130MovimientoFrm
Nombre=Movimiento
Icono=44
Modulos=(Todos)
ListaCarpetas=Movimientos
CarpetaPrincipal=Movimientos
PosicionInicialAlturaCliente=217
PosicionInicialAncho=153
PosicionInicialIzquierda=534
PosicionInicialArriba=152
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
[Movimientos]
Estilo=Hoja
Clave=Movimientos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Filtros=S
Vista=DM0130MovimientoVis
ListaEnCaptura=DM0130MovimientoTbl.MOV
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=CteEnviarA.CATEGORIA = <T>Credito Menudeo<T><BR>And MovTipo.Clave In (<T>CXC.F<T>,<T>CXC.CAP<T>,<T>CXC.CA<T>) And MovTipo.Modulo = <T>CXC<T><BR>And DM0130MovimientoTbl.MOV NOT IN(<T>Cargo Moratorio<T>, <T>React Incobrable F<T>, <T>React Incobrable NV<T>)
[Movimientos.DM0130MovimientoTbl.MOV]
Carpeta=Movimientos
Clave=DM0130MovimientoTbl.MOV
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Movimientos.Columnas]
MOV=124

