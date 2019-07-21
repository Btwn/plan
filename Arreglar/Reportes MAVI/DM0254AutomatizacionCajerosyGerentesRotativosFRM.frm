[Forma]
Clave=DM0254AutomatizacionCajerosyGerentesRotativosFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=Variables<BR>hoja
CarpetaPrincipal=Variables
PosicionInicialIzquierda=46
PosicionInicialArriba=172
PosicionInicialAlturaCliente=229
PosicionInicialAncho=564
PosicionSec1=104
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Verifica<BR>cambio<BR>cerrar
Nombre=Cambios de Sucursal
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0254Nomina,<T><T>)<BR>Asigna(Mavi.Sucursal,0)
[vkldfgkl.Columnas]
Agente=92
Sucursal=64
Nombre=246
[hoja]
Estilo=Hoja
Clave=hoja
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0254detalleVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Nombre<BR>Usr<BR>Nomina<BR>Sucursal
Filtros=S
FiltroPredefinido=S
TablaIndependiente=DM0254Tbl
FiltroIndependiente=S
FiltroExpresion=DM0254detalleVis:Nomina=DM0254Vis:DM0254Tbl.Agente
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroTipo=General
FiltroTodoFinal=S
FiltroRespetar=S
FiltroDistintos=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
FiltroGeneral={SI(ConDatos(Mavi.DM0254Nomina), <T>  Propiedad= <T>+Comillas(Mavi.DM0254Nomina) ,<T>   Propiedad=<T>+Comillas(<T> <T>))}
[hoja.Columnas]
Nombre=262
Usuario=104
Sucursal=64
Usr=79
Nomina=52
[hoja.Nombre]
Carpeta=hoja
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[hoja.Sucursal]
Carpeta=hoja
Clave=Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[hoja.Usr]
Carpeta=hoja
Clave=Usr
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
[Acciones.Verifica]
Nombre=Verifica
Boton=7
NombreDesplegar=&Verificar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=asign<BR>actu
EspacioPrevio=S
[Acciones.Verifica.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Verifica.actu]
Nombre=actu
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Variables]
Estilo=Ficha
Clave=Variables
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
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
ListaEnCaptura=Mavi.DM0254Nomina<BR>Mavi.Sucursal
CarpetaVisible=S
[Variables.Mavi.Sucursal]
Carpeta=Variables
Clave=Mavi.Sucursal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.cambio]
Nombre=cambio
Boton=23
NombreEnBoton=S
NombreDesplegar=&Realizar Cambio
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=asig<BR>expr<BR>acep
[Acciones.cerrar]
Nombre=cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.cambio.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.cambio.expr]
Nombre=expr
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si (mavi.Sucursal=DM0254detalleVis:Sucursal) Entonces<BR>  Informacion(<T>YA SE ENCUENTRA ASIGNADO A LA SUCURSAL INDICADA<T>)<BR>Sino<BR>    SI SQL(<T>Select dbo.fn_MaviDM0254ValidarCajas (:nsuc)<T> , Mavi.Sucursal) = 1 ENTONCES<BR>        Precaucion(<T>Todas las cajas estan asignadas<T>)<BR>    SINO<BR>        Asigna(info.dialogo,  SQL(<T>EXEC dbo.SP_MAVIDM0254AutomatizacionCajerosyGerentesRotativos :tusu, :nsuc, :tacc<T> , Mavi.DM0254Nomina, Mavi.Sucursal,USUARIO))<BR>        Asigna(Mavi.DM0153Accesos,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>        sql(<T>exec SP_MAVIACTUALIZANIVELACCESO :tAcceso<T>,<T>CONDICIONES,CUENTAS DINERO<T>)<BR>        Informacion(info.dialogo)<BR>    FIN<BR>FIN
[Acciones.cambio.acep]
Nombre=acep
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Variables.Mavi.DM0254Nomina]
Carpeta=Variables
Clave=Mavi.DM0254Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[hoja.Nomina]
Carpeta=hoja
Clave=Nomina
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


[Acciones.Test.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Informacion ( ProcesarSQL (<T>SELECT ACCESO FROM USUARIO WITH(NOLOCK) WHERE USUARIO = :tUsuario<T>,<T>VENTP02978<T>))


