[Forma]
Clave=AnexoContaSAT
Nombre=Anexos - Contabilidad Electr�nica
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>CambiarEstilo<BR>Actualizar<BR>ConAcuse<BR>SinAcuse<BR>Todos<BR>Personalizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
ExpresionesAlMostrar=Asigna( Info.Accion, <T>Todos<T> )
PosicionInicialIzquierda=192
PosicionInicialArriba=155
PosicionInicialAlturaCliente=419
PosicionInicialAncho=982
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
FiltroTipo=M�ltiple (por Grupos)
FiltroGrupo1=AnexoContaSAT.Tipo
FiltroValida1=AnexoContaSAT.Tipo
FiltroGrupo2=AnexoContaSAT.Empresa
FiltroValida2=AnexoContaSAT.Empresa
FiltroGrupo3=AnexoContaSAT.Ejercicio
FiltroValida3=AnexoContaSAT.Ejercicio
FiltroGrupo4=AnexoContaSAT.Periodo
FiltroValida4=AnexoContaSAT.Periodo
IconosNombre=AnexoContaSAT:AnexoContaSAT.Nombre
FiltroGeneral=AnexoContaSAT.Empresa  = <T>{Empresa}<T><BR>{Si Info.Accion = <T>ConAcuse<T> Entonces <T> AND Acuse IS NOT NULL<T> Sino <T><T> Fin}<BR>{Si Info.Accion = <T>SinAcuse<T> Entonces <T> AND Acuse IS NULL<T> Sino <T><T> Fin}
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
ConCondicion=S
EjecucionCondicion=1<>0
[Acciones.Adjuntar]
Nombre=Adjuntar
Boton=0
NombreDesplegar=&Adjuntar Acuse
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna( Info.Nombre,BuscarArchivo( AnexoContaSAT:AnexoContaSAT.RutaArchivo, <T><T>, <T>*<T>, <T>*<T>, <T>Todo<T> ) )<BR><BR>Si<BR>    Info.Nombre <> <T><T><BR>Entonces<BR>    Asigna( Info.Mensaje,  SQL( <T>spImportaAcuseSAT :tEmpresa, :tEjercicio, :tPeriodo, :tTipo, :tRutaAcuse, Null  <T>, AnexoContaSAT:AnexoContaSAT.Empresa, AnexoContaSAT:AnexoContaSAT.Ejercicio, AnexoContaSAT:AnexoContaSAT.Periodo, AnexoContaSAT:AnexoContaSAT.Tipo, Info.Nombre ))<BR>    Informacion(Info.Mensaje, BotonAceptar)<BR>    ActualizarForma<BR>Fin
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
0=145
1=77
2=55
3=56
4=91
5=247
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

