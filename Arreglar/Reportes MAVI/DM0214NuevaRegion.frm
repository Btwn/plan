[Forma]
Clave=DM0214NuevaRegion
Nombre=MANEJO DE REGIONES
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar<BR>Divisiones<BR>Guarda<BR>cerrar
PosicionInicialAlturaCliente=537
PosicionInicialAncho=359
PosicionInicialIzquierda=470
PosicionInicialArriba=139
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
CarpetaPrincipal=campos
PosicionSec1=104
VentanaSinIconosMarco=S
ListaCarpetas=campos
VentanaExclusiva=S
[ZONA.ZonaCobranzaMen.NivelCobranza]
Carpeta=Zona
Clave=ZonaCobranzaMen.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[ZONA.ZonaCobranzaMen.Zona]
Carpeta=Zona
Clave=ZonaCobranzaMen.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Zona.Info.Nivel]
Carpeta=Zona
Clave=Info.Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Zona.Info.Zona]
Carpeta=Zona
Clave=Info.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Zona.Columnas]
NivelCobranza=124
Zona=94
Ruta=604
Agente=94
MaxCuentas=64
[(Variables).Info.Nivel]
Carpeta=(Variables)
Clave=Info.Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DM0214niveles.Nombre]
Carpeta=DM0214niveles
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[DM0214niveles.Columnas]
Nombre=604
[Acciones.Agregar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Mavi.DM0214Region=<T><T><BR>Entonces<BR>  1=1<BR>Sino<BR>  Si<BR>    Mavi.DM0214Region = SQL( <T>Select Top 1 Region from ZonaCobranzaMen Where Region =<T>+ASCII(39)+ Mavi.DM0214Region+ASCII(39) )<BR>  Entonces<BR>    Informacion(<T>Region Existente<T>)<BR>  Sino<BR>      EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>AgrReg<T>+ASCII(39)+<T>,<T><BR>          +ASCII(39)+DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonaCobranzaMen.NivelCobranza+ASCII(39)+<T>,<T><BR>          +ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+Mavi.DM0214Region+ASCII(39)+<T>,<T><BR>          +ASCII(39) +ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)<BR>             )<BR>  Fin<BR>Fin
[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cambiar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cambiar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cambiar.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Zona,<T><T>)
[Acciones.Cambiar.Edicion de datos]
Nombre=Edicion de datos
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Mavi.DM0214Region= SQL( <T>Select Top 1 Region from ZonaCobranzaMen Where Region=<T>+ASCII(39)+Mavi.DM0214Region+ASCII(39) )<BR>Entonces<BR>  EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>EdtReg<T>+ASCII(39)+<T>,<T><BR>          +ASCII(39)+DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonaCobranzaMen.NivelCobranza+ASCII(39)+<T>,<T><BR>          +ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+Mavi.DM0214Region+ASCII(39)+<T>,<T><BR>          +ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)<BR>             )<BR>Sino<BR>   Informacion(<T>Region No Existente<T>)<BR>Fin
[Acciones.Agregar.Siguiente]
Nombre=Siguiente
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=AvanzarCaptura
[Acciones.Agregar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Agregar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Agregar.Borrar Variable]
Nombre=Borrar Variable
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Zona,<T><T>)
[Acciones.Agregar.Cerrar Forma]
Nombre=Cerrar Forma
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cambiar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=AvanzarCaptura
[Acciones.Cambiar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSQL( <T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>BorZona<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+Info.Zona+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39) )
EjecucionCondicion=Si<BR>  Info.Zona =  SQL(<T>Select Top 1 Zona from ZonaCobranzaMen Where Zona = <T> + ASCII(39) + Info.Zona + ASCII(39))<BR>Entonces                       <BR>  1=1<BR>Sino<BR>  2=1<BR>Fin
EjecucionMensaje=<T>Esa Zona No Existe<T>
[Acciones.Eliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Eliminar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Eliminar.Borrar Variable]
Nombre=Borrar Variable
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Zona,<T><T>)
Activo=S
Visible=S
[Acciones.Eliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[deducPromCobCampoMAVI.DM0214ZonaCobranzaMen.NivelCobranza]
Carpeta=deducPromCobCampoMAVI
Clave=DM0214ZonaCobranzaMen.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Exel.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Exel.deducPromCobCampoImpMAVI]
Nombre=deducPromCobCampoImpMAVI
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=DM0214UnaZonaRep
Activo=S
Visible=S
[Acciones.Exel.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.DM0214Region]
Carpeta=(Variables)
Clave=Mavi.DM0214Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[campos]
Estilo=Hoja
Pestana=S
Clave=campos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214RegionesVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
ListaEnCaptura=DM0214Regiones.Region
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
PestanaOtroNombre=S
PestanaNombre=REGIONES
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
OtroOrden=S
ListaOrden=DM0214Regiones.Region<TAB>(Acendente)
HojaConfirmarEliminar=S
[campos.DM0214Regiones.Region]
Carpeta=campos
Clave=DM0214Regiones.Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[campos.Columnas]
Region=191
ID=39
[Acciones.cerrar]
Nombre=cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
AntesExpresiones=asigna(info.bloqueo,2)
[Acciones.Guarda]
Nombre=Guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=ultreg<BR>salvar<BR>refrezca<BR>ult
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=E&liminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ConCondicion=S
ListaAccionesMultiples=elimina<BR>gruadar
EjecucionConError=S
EjecucionCondicion=SI (Sql( <T> Select isnull(tot,0)<BR>       from ( Select count (region) tot from dm0214zonascobranza where region = :tr )t<T>,DM0214RegionesVis:DM0214Regiones.Region))=0<BR> entonces<BR>Si (Sql( <T> Select isnull(tot,0)<BR>       from ( Select count (d.Division) tot<BR>              from DM0214Divisiones  d<BR>              JOIN dm0214zonascobranza z ON z.Division = d.Division<BR>              where d.region = :tr )t<T>,DM0214RegionesVis:DM0214Regiones.Region))=0<BR><BR>entonces<BR> SI (Confirmacion( <T>Desea eliminar la Región?<T> ,    BotonSi   , BotonNo   )=6)<BR>  Entonces<BR>  1=1<BR>  sino<BR>     AbortarOperacion<BR>  fin<BR><BR> sino<BR> falso<BR> fin<BR> sino<BR> falso<BR> fin
EjecucionMensaje=<T>Existen zonas en esta Región<BR>o en sus  Divisiones <T>
[Acciones.Eliminar.elimina]
Nombre=elimina
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Guarda.salvar]
Nombre=salvar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guarda.refrezca]
Nombre=refrezca
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Guarda.ult]
Nombre=ult
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Activo=S
Visible=S
[Acciones.Eliminar.gruadar]
Nombre=gruadar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Divisiones]
Nombre=Divisiones
Boton=78
NombreEnBoton=S
NombreDesplegar=Divisiones
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0214nuevadivision
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Guarda.ultreg]
Nombre=ultreg
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Activo=S
Visible=S

