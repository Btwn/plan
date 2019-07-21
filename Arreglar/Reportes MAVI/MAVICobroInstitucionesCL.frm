[Forma]
Clave=MAVICobroInstitucionesCL
Nombre=Cobro Instituciones
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)<BR>Lista
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=498
PosicionInicialAncho=632
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=324
PosicionInicialArriba=137
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionSec1=104
ListaAcciones=GenerarCobro
SinCondicionDespliege=S
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
ListaEnCaptura=Info.Institucion<BR>Info.DepositoAnticipado
FichaEspacioNombresAuto=S
[(Variables).Info.Institucion]
Carpeta=(Variables)
Clave=Info.Institucion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.DepositoAnticipado]
Carpeta=(Variables)
Clave=Info.DepositoAnticipado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista]
Estilo=Iconos
Clave=Lista
Filtros=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=MAVICxc
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosSeleccionMultiple=S
ListaEnCaptura=Movimiento<BR>Cxc.Situacion<BR>Cte.Nombre<BR>Cxc.Importe<BR>Cxc.Impuestos
IconosNombre=MAVICxc:Cxc.ID
FiltroGeneral=Cxc.Estatus=<T>PENDIENTE<T> AND Cxc.Situacion=<T>Cobro Diferido<T>
CondicionVisible=Info.Institucion = <T>MENUDEO<T>
[Lista.Movimiento]
Carpeta=Lista
Clave=Movimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Importe]
Carpeta=Lista
Clave=Cxc.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Cxc.Impuestos]
Carpeta=Lista
Clave=Cxc.Impuestos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
0=-2
1=122
2=88
3=-2
4=84
5=-2
[Lista.Cxc.Situacion]
Carpeta=Lista
Clave=Cxc.Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.GenerarCobro]
Nombre=GenerarCobro
Boton=7
NombreDesplegar=& Generar Cobro Institucion
EnBarraHerramientas=S
EnBarraAcciones=S
BtnResaltado=S
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Actualizar Vista
[Acciones.GenerarCobro.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Lista<T>)<BR>EjecutarSQL( <T>spMAVICobroInstituciones :nEstacionT, :tEmpresa, :tUsuario, :tMovD, :tMovIDD, :nImporte<T>,EstacionTrabajo, Empresa, Usuario, Info.MAVIMov, Info.MAVIMovId, Info.SaldoMAVI)
[Acciones.GenerarCobro.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


