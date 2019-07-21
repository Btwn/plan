
[Forma]
Clave=ContSATMonitorPolizas
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
Nombre=ContSATMonitorPolizas
ListaCarpetas=Lista<BR>Detalle
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>CambiarEstilo<BR>Actualizar<BR>ConAcuse<BR>SinAcuse<BR>Todos<BR>GenerarArchivo<BR>Personalizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna( Info.Accion, <T>Todos<T> )
PosicionInicialIzquierda=192
PosicionInicialArriba=155
PosicionInicialAlturaCliente=419
PosicionInicialAncho=982
PosicionSec1=227
[Lista]
Estilo=Iconos
PestanaOtroNombre=S
PestanaNombre=Anexo(s)
Clave=Lista
OtroOrden=S
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=AnexoContaSAT
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=AnexoContaSAT.Empresa<BR>AnexoContaSAT.Ejercicio<BR>AnexoContaSAT.Periodo<BR>AnexoContaSAT.Tipo<BR>AnexoContaSAT.RutaArchivo<BR>AnexoContaSAT.RutaAcuse
ListaOrden=AnexoContaSAT.Ejercicio<TAB>(Acendente)<BR>AnexoContaSAT.Periodo<TAB>(Acendente)
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
BusquedaRespetarControlesNum=S
CarpetaVisible=S
ListaAcciones=Examinar<BR>Adjuntar<BR>VerAcuse
IconosCampo=AnexoContaSAT.Icono
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Archivo<T>
ElementosPorPagina=200
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroGrupo1=AnexoContaSAT.Tipo
FiltroValida1=AnexoContaSAT.Tipo
FiltroGrupo2=AnexoContaSAT.Empresa
FiltroValida2=AnexoContaSAT.Empresa
FiltroGrupo3=AnexoContaSAT.Ejercicio
FiltroValida3=AnexoContaSAT.Ejercicio
FiltroGrupo4=AnexoContaSAT.Periodo
FiltroValida4=AnexoContaSAT.Periodo
IconosNombre=AnexoContaSAT:AnexoContaSAT.Nombre
FiltroGeneral={<T>AnexoContaSAT.Empresa = <T>   & Comillas(Empresa)}<BR>{<T>AND AnexoContaSAT.Tipo = <T>) & Comillas(<T>Polizas<T>)}<BR>{Si Info.Accion = <T>ConAcuse<T> Entonces <T> AND Acuse IS NOT NULL<T> Sino <T><T> Fin}<BR>{Si Info.Accion = <T>SinAcuse<T> Entonces <T> AND Acuse IS NULL<T> Sino <T><T> Fin}
[Lista.AnexoContaSAT.Empresa]
Carpeta=Lista
Clave=AnexoContaSAT.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
[Lista.AnexoContaSAT.Ejercicio]
Carpeta=Lista
Clave=AnexoContaSAT.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=4
ColorFondo=Blanco
[Lista.AnexoContaSAT.Periodo]
Carpeta=Lista
Clave=AnexoContaSAT.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco
[Lista.AnexoContaSAT.Tipo]
Carpeta=Lista
Clave=AnexoContaSAT.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Lista.AnexoContaSAT.RutaArchivo]
Carpeta=Lista
Clave=AnexoContaSAT.RutaArchivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Lista.AnexoContaSAT.RutaAcuse]
Carpeta=Lista
Clave=AnexoContaSAT.RutaAcuse
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
[Acciones.Examinar]
Nombre=Examinar
Boton=0
NombreDesplegar=&Examinar Archivo
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=URL(AnexoContaSAT:AnexoContaSAT.RutaArchivo)
[Acciones.Adjuntar]
Nombre=Adjuntar
Boton=0
NombreDesplegar=&Adjuntar Acuse
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna( Info.Nombre,BuscarArchivo( AnexoContaSAT:AnexoContaSAT.RutaArchivo, <T><T>, <T>*<T>, <T>*<T>, <T>Todo<T> ) )<BR><BR>Si<BR>    Info.Nombre <> <T><T><BR>Entonces<BR>    Asigna( Info.Mensaje,  SQL( <T>spImportaAcuseSAT :tEmpresa, :tEjercicio, :tPeriodo, :tTipo, :tRutaAcuse,  <T>+  Comillas(Archivo.Leer(Info.Nombre)), AnexoContaSAT:AnexoContaSAT.Empresa, AnexoContaSAT:AnexoContaSAT.Ejercicio, AnexoContaSAT:AnexoContaSAT.Periodo, AnexoContaSAT:AnexoContaSAT.Tipo, Info.Nombre ))<BR>    Informacion(Info.Mensaje, BotonAceptar)<BR>    ActualizarForma<BR>Fin
ActivoCondicion=ConDatos(AnexoContaSAT:AnexoContaSAT.RutaAcuse)= Falso
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.CambiarEstilo]
Nombre=CambiarEstilo
Boton=0
NombreDesplegar=&Cambiar Estilo
EnBarraHerramientas=S
TipoAccion=Herramientas Captura
ClaveAccion=Cambiar Estilo (Iconos)
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Actualizar]
Nombre=Actualizar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ConAcuse]
Nombre=ConAcuse
Boton=71
NombreEnBoton=S
NombreDesplegar=&ConAcuse
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>ConAcuse<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>ConAcuse<T> )
Visible=S
[Acciones.SinAcuse]
Nombre=SinAcuse
Boton=71
NombreEnBoton=S
NombreDesplegar=&Sin Acuse
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>SinAcuse<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>SinAcuse<T> )
Visible=S
[Acciones.Todos]
Nombre=Todos
Boton=71
NombreEnBoton=S
NombreDesplegar=&Todos
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
ActivoCondicion=Info.Accion <> <T>Todos<T>
Antes=S
AntesExpresiones=Asigna( Info.Accion, <T>Todos<T> )
Visible=S
[Acciones.VerAcuse]
Nombre=VerAcuse
Boton=0
NombreDesplegar=Ver &Acuse
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=URL( AnexoContaSAT:AnexoContaSAT.RutaAcuse )
ActivoCondicion=ConDatos(AnexoContaSAT:AnexoContaSAT.RutaAcuse)
[Lista.Columnas]
0=138
1=77
2=55
3=56
4=91
5=222
6=166
[Acciones.Personalizar]
Nombre=Personalizar
Boton=45
NombreDesplegar=Personalizar Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

[Acciones.GenerarArchivo]
Nombre=GenerarArchivo
Boton=7
NombreEnBoton=S
NombreDesplegar=&Generar Archivo SAT
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Parametros<BR>Actualzia<BR>Actualizar
[Detalle]
Estilo=Iconos
Clave=Detalle
Detalle=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=AuxiliaresContaSAT
Fuente={Tahoma, 8, Negro, []}
IconosCampo=AuxiliaresContaSAT.Icono
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Archivo<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=AuxiliaresContaSAT.Empresa<BR>AuxiliaresContaSAT.Ejercicio<BR>AuxiliaresContaSAT.Periodo<BR>AuxiliaresContaSAT.Tipo<BR>AuxiliaresContaSAT.RutaArchivo<BR>AuxiliaresContaSAT.RutaAcuse

VistaMaestra=AnexoContaSAT
LlaveLocal=AuxiliaresContaSAT.RID
LlaveMaestra=AnexoContaSAT.Id
MenuLocal=S
ListaAcciones=Examina<BR>Adjunta<BR>VerAcusee
IconosNombre=AuxiliaresContaSAT:AuxiliaresContaSAT.Nombre
[Detalle.AuxiliaresContaSAT.Empresa]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[Detalle.AuxiliaresContaSAT.Ejercicio]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=4
ColorFondo=Blanco

[Detalle.AuxiliaresContaSAT.Periodo]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=2
ColorFondo=Blanco

[Detalle.AuxiliaresContaSAT.Tipo]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.AuxiliaresContaSAT.RutaArchivo]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.RutaArchivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[Detalle.AuxiliaresContaSAT.RutaAcuse]
Carpeta=Detalle
Clave=AuxiliaresContaSAT.RutaAcuse
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[Detalle.Columnas]
0=93
1=102
2=100
3=80
4=102
5=219
6=-2

[Acciones.GenerarArchivo.Parametros]
Nombre=Parametros
Boton=0
TipoAccion=formas
ClaveAccion=ParPolizasSAT
Activo=S
Visible=S

[Acciones.GenerarArchivo.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.GenerarArchivo.Actualzia]
Nombre=Actualzia
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S

[Acciones.Examina]
Nombre=Examina
Boton=0
NombreDesplegar=&Examinar Archivo
EnMenu=S
TipoAccion=Expresion
Expresion=URL(AuxiliaresContaSAT:AuxiliaresContaSAT.RutaArchivo)
Activo=S
Visible=S

[Acciones.Adjunta]
Nombre=Adjunta
Boton=0
NombreDesplegar=&Adjuntar Acuse
EnMenu=S
TipoAccion=EXpresion
Visible=S

Expresion=Asigna( Info.Nombre, <T><T>)<BR>Asigna( Info.Nombre,BuscarArchivo( AnexoContaSAT:AnexoContaSAT.RutaArchivo, <T><T>, <T>*<T>, <T>*<T>, <T>Todo<T> ) )<BR><BR>Si<BR>    Info.Nombre <> <T><T><BR>Entonces<BR>    Asigna( Info.Observaciones, <T><T>)<BR>    Asigna( Info.Observaciones,  SQL( <T>spImportaAcuseSAT :tEmpresa, :tEjercicio, :tPeriodo, :tTipo, :tRutaAcuse, :tAcuse, :nBandera <T>, AuxiliaresContaSAT:AuxiliaresContaSAT.Empresa, AuxiliaresContaSAT:AuxiliaresContaSAT.Ejercicio, AuxiliaresContaSAT:AuxiliaresContaSAT.Periodo, AuxiliaresContaSAT:AuxiliaresContaSAT.Tipo, Info.Nombre, Comillas(Archivo.Leer(Info.Nombre)), 1 ))<BR>    Informacion(Info.Observaciones, BotonAceptar)<BR>    ActualizarForma<BR>Fin
ActivoCondicion=ConDatos(AuxiliaresContaSAT:AuxiliaresContaSAT.RutaAcuse)= Falso
[Acciones.VerAcusee]
Nombre=VerAcusee
Boton=0
NombreDesplegar=Ver &Acuse
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=URL(AuxiliaresContaSAT:AuxiliaresContaSAT.RutaAcuse)
ActivoCondicion=ConDatos(AuxiliaresContaSAT:AuxiliaresContaSAT.RutaAcuse)

