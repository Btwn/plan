[Forma]
Clave=EquipoAgenteListaMAVI
Nombre=Equipos de Agentes
Icono=44
Modulos=(Todos)
ListaCarpetas=Lista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
ExpresionesAlMostrar=
ExpresionesAlCerrar=
CarpetaPrincipal=Lista
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar<BR>Imprimir<BR>Preliminar<BR>Excel<BR>Informacion<BR>Propiedades<BR>Anexos<BR>Doc<BR>Servicios<BR>Actividades<BR>Agenda<BR>Personalizar
PosicionInicialIzquierda=179
PosicionInicialArriba=166
PosicionInicialAltura=421
PosicionInicialAncho=783
VentanaEscCerrar=S
BarraHerramientas=S
PosicionInicialAlturaCliente=431

[Lista]
Estilo=Iconos
Clave=Lista
BusquedaRapidaControles=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=EquipoAgenteMAVI
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
FiltroFechasNormal=S
MenuLocal=S
ListaAcciones=Actualizar<BR>ServiciosPendientesAgente<BR>VentaActividadAgente<BR>LocalAgenda
PermiteLocalizar=S
FiltroListaEstatus=(Todos menos uno)<BR>NORMAL<BR>BLOQ_AVISO<BR>BLOQUEADO<BR>BAJA
FiltroEstatusDefault=BAJA
PestanaOtroNombre=S
PestanaNombre=Agentes
FiltroSucursales=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroGrupo1=(Validaciones Memoria)
FiltroValida1=AgenteCat
FiltroGrupo2=(Validaciones Memoria)
FiltroValida2=AgenteTipo
FiltroAplicaEn1=Agente.Categoria
FiltroAplicaEn2=Agente.Tipo
FiltroTodo=S
ListaEnCaptura=Agente.Nombre<BR>Agente.Tipo<BR>Agente.Categoria<BR>Agente.Grupo<BR>Agente.Estatus<BR>Agente.Alta<BR>Agente.SucursalEmpresa<BR>Agente.Baja
IconosNombre=EquipoAgenteMAVI:Agente.Agente
IconosSubTitulo=Agente

[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Visible=S
Activo=S
EnBarraHerramientas=S
NombreEnBoton=S

[Lista.Columnas]
Agente=0
Nombre=320
0=105
1=247
2=65
3=67
4=42
5=-2
6=-2
7=-2
8=-2

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=Actualizar
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=Imprimir
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Presentación preliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=67
NombreDesplegar=Enviar a Excel
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S

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

[Acciones.ServiciosPendientesAgente]
Nombre=ServiciosPendientesAgente
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
NombreDesplegar=Servicios Pendientes del Agente
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ServiciosPendientesAgente
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)





[Acciones.Informacion]
Nombre=Informacion
Boton=34
NombreDesplegar=Información
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=AgenteInfo
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)

[Acciones.Propiedades]
Nombre=Propiedades
Boton=35
NombreDesplegar=Propiedades
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=PropInfo
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
Antes=S
AntesExpresiones=Asigna(Info.Rama, <T>AGENT<T>)<BR>Asigna(Info.Cuenta, Agente:Agente.Agente)<BR>Asigna(Info.Descripcion, Agente:Agente.Nombre)
Visible=S

[Acciones.Anexos]
Nombre=Anexos
Boton=77
NombreDesplegar=Ane&xos
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=AnexoCta
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
Antes=S
AntesExpresiones=Asigna(Info.Rama, <T>AGENT<T>)<BR>Asigna(Info.Cuenta, Agente:Agente.Agente)<BR>Asigna(Info.Descripcion, Agente:Agente.Nombre)
Visible=S

[Acciones.Doc]
Nombre=Doc
Boton=17
NombreDesplegar=&Documentación
EnBarraHerramientas=S
TipoAccion=Expresion
Expresion=VerDocumentacion(<T>AGENT<T>, Agente:Agente.Agente, <T>Documentación - <T>+Agente:Agente.Nombre)
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
Visible=S

[Acciones.VentaActividadAgente]
Nombre=VentaActividadAgente
Boton=0
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=Actividades Pendientes del Agente
EnMenu=S
TipoAccion=Formas
ClaveAccion=VentaActividadAgente
Activo=S
Visible=S
Antes=S
ConCondicion=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)

[Acciones.Servicios]
Nombre=Servicios
Boton=47
NombreEnBoton=S
NombreDesplegar=&Servicios Pendientes
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ServiciosPendientesAgente
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)

[Acciones.Actividades]
Nombre=Actividades
Boton=47
NombreEnBoton=S
NombreDesplegar=&Actividades Pendientes
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=VentaActividadAgente
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)

[Acciones.Agenda]
Nombre=Agenda
Boton=9
NombreEnBoton=S
NombreDesplegar=Agen&da
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=VerAgenteAgenda
Activo=S
Antes=S
ConCondicion=S
Visible=S
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)

[Acciones.LocalAgenda]
Nombre=LocalAgenda
Boton=0
NombreDesplegar=&Agenda
EnMenu=S
TipoAccion=Formas
ClaveAccion=VerAgenteAgenda
Activo=S
Antes=S
ConCondicion=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+D
EjecucionCondicion=ConDatos(Agente:Agente.Agente)
AntesExpresiones=Asigna(Info.Agente, Agente:Agente.Agente)<BR>Asigna(Info.Nombre, Agente:Agente.Nombre)
Visible=S
[Lista.Agente.Nombre]
Carpeta=Lista
Clave=Agente.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Tipo]
Carpeta=Lista
Clave=Agente.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Categoria]
Carpeta=Lista
Clave=Agente.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Grupo]
Carpeta=Lista
Clave=Agente.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Estatus]
Carpeta=Lista
Clave=Agente.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Alta]
Carpeta=Lista
Clave=Agente.Alta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.SucursalEmpresa]
Carpeta=Lista
Clave=Agente.SucursalEmpresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Agente.Baja]
Carpeta=Lista
Clave=Agente.Baja
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

