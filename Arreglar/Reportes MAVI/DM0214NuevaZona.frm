[Forma]
Clave=DM0214NuevaZona
Nombre=MANEJO DE ZONAS
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar<BR>Localizar<BR>Nuevo<BR>Guardar<BR>Cancelar
PosicionInicialAlturaCliente=252
PosicionInicialAncho=459
PosicionInicialIzquierda=467
PosicionInicialArriba=279
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionSec1=216
VentanaSinIconosMarco=S
ListaCarpetas=DM0214ZonasVis
CarpetaPrincipal=DM0214ZonasVis
Menus=S
VentanaExclusiva=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Cerrar
Visible=S
EspacioPrevio=S
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
Region=354
Division=284
Equipo=284
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
[(Variables).Info.Zona]
Carpeta=(Variables)
Clave=Info.Zona
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
Expresion=Si<BR>  Info.Zona=<T><T><BR>Entonces<BR>  1=1<BR>Sino<BR> Si<BR>    Info.Zona= SQL( <T>Select Top 1 Zona from ZonaCobranzaMen Where Zona=<T>+ASCII(39)+Info.Zona+ASCII(39) )<BR>  Entonces<BR>    Informacion(<T>Zona Existente<T>)<BR>  Sino<BR>     EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>AgrZona<T>+ASCII(39)+<T>,<T><BR>                    +ASCII(39)+ASCII(39)+<T>,<T><BR>                    +ASCII(39)+Info.Zona+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39) +<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39) +<T>,<T>+ASCII(39)+Mavi.DM0214Equipo+ASCII(39)<BR>             )<BR>  Fin<BR>Fin
[Acciones.Cancelar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
Carpeta=(Carpeta principal)
ClaveAccion=Registro Cancelar
[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cambiar.asig]
Nombre=asig
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Agente,SQL(<T>Select Top 1 Agente From ZonaCobranzaMen where Zona= <T> + ASCII(39) + Info.Zona + ASCII(39))  )
[Acciones.Agregar.Cerrar Forma]
Nombre=Cerrar Forma
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
Multiple=S
EnBarraHerramientas=S
Visible=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
ConCondicion=S
Activo=S
EjecucionCondicion=SI (Confirmacion( <T> Se borrará la Zona<BR>y las Rutas que tenga asignadas<BR><BR>Desa continuar?<T> ,    BotonSi   , BotonNo   )=6)<BR>  Entonces<BR>  1=1<BR>  sino<BR>     AbortarOperacion<BR>  fin
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=AVANZARCAPTURA<BR>//EjecutarSQL( <T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>BorZona<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+Info.Zona+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39))<BR><BR>EjecutarSQL( <T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>BorZona<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)<BR>+<T>,<T>+ASCII(39)+DM0214ZonasCobranzaVis:DM0214ZonasCobranza.Zona+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )<BR><BR><BR><BR><BR>Forma.ActualizarVista
EjecucionCondicion=(SQL(<T>Select count(Zona) from DM0214ZonasCobranza Where Zona = :tz <T>,DM0214ZonasCobranzaVis:DM0214ZonasCobranza.Zona )>0)
EjecucionMensaje=<T>Esa Zona No Existe<T>
[Acciones.Eliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
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
[(Variables).Mavi.DM0214Equipo]
Carpeta=(Variables)
Clave=Mavi.DM0214Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Localizar]
Nombre=Localizar
Boton=73
NombreEnBoton=S
NombreDesplegar=&Localizar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Pregunta(info.Zona,<T>Zona<T>,<T>Localizar Zona<T>)<BR><BR>Actualizarvista
[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0214ZonasVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroTipo=General
OtroOrden=S
RefrescarAlEntrar=S
BusquedaRapida=S
BusquedaEnLinea=S
IconosSubTitulo=Zona
ListaEnCaptura=DM0214ZonasCobranza.NivelCobranza<BR>DM0214ZonasCobranza.Region<BR>DM0214ZonasCobranza.Division<BR>DM0214ZonasCobranza.Equipo
IconosNombre=DM0214ZonasVis:DM0214ZonasCobranza.Zona
[(Carpeta Abrir).Columnas]
0=93
1=113
2=156
3=123
4=-2
5=-2
[Zona.DM0214ZonasCobranza.Zona]
Carpeta=Zona
Clave=DM0214ZonasCobranza.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Zona.DM0214ZonasCobranza.NivelCobranza]
Carpeta=Zona
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Zona.DM0214ZonasCobranza.Region]
Carpeta=Zona
Clave=DM0214ZonasCobranza.Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Zona.DM0214ZonasCobranza.Division]
Carpeta=Zona
Clave=DM0214ZonasCobranza.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Zona.DM0214ZonasCobranza.Equipo]
Carpeta=Zona
Clave=DM0214ZonasCobranza.Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Cambiar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[DM0214ZonasVis]
Estilo=Ficha
Clave=DM0214ZonasVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214ZonasCobranzaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura=(Lista)
PermiteEditar=S
GuardarPorRegistro=S
CarpetaVisible=S
[DM0214ZonasVis.DM0214ZonasCobranza.Zona]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[DM0214ZonasVis.DM0214ZonasCobranza.NivelCobranza]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DM0214ZonasVis.DM0214ZonasCobranza.Region]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DM0214ZonasVis.DM0214ZonasCobranza.Division]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DM0214ZonasVis.DM0214ZonasCobranza.Equipo]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).DM0214ZonasCobranza.NivelCobranza]
Carpeta=(Carpeta Abrir)
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).DM0214ZonasCobranza.Region]
Carpeta=(Carpeta Abrir)
Clave=DM0214ZonasCobranza.Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).DM0214ZonasCobranza.Division]
Carpeta=(Carpeta Abrir)
Clave=DM0214ZonasCobranza.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).DM0214ZonasCobranza.Equipo]
Carpeta=(Carpeta Abrir)
Clave=DM0214ZonasCobranza.Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=acepta<BR>Guarda<BR>actcriterios
Activo=S
Visible=S
EspacioPrevio=S
[zonasdetalle.DM0214ZonaCobranzaMen.NivelCobranza]
Carpeta=zonasdetalle
Clave=DM0214ZonaCobranzaMen.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[zonasdetalle.DM0214ZonaCobranzaMen.Zona]
Carpeta=zonasdetalle
Clave=DM0214ZonaCobranzaMen.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[zonasdetalle.DM0214ZonaCobranzaMen.Ruta]
Carpeta=zonasdetalle
Clave=DM0214ZonaCobranzaMen.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[zonasdetalle.DM0214ZonaCobranzaMen.Agente]
Carpeta=zonasdetalle
Clave=DM0214ZonaCobranzaMen.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[zonasdetalle.DM0214ZonaCobranzaMen.MaxCuentas]
Carpeta=zonasdetalle
Clave=DM0214ZonaCobranzaMen.MaxCuentas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[zonasdetalle.Columnas]
NivelCobranza=97
Zona=140
Ruta=200
Agente=109
MaxCuentas=74
[Acciones.Guardar.actcriterios]
Nombre=actcriterios
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ejecutarsql( <T>exec SP_MAVIDM0214ZonasAgente :tv ,:tm, :tz, :ne<T>+<T>,<T>+ASCII(39)+Usuario+ASCII(39),<T>Criterios<T>,<T><T>,<T><T>,0)
[Acciones.Guardar.acepta]
Nombre=acepta
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Registro Afectar
Activo=S
Visible=S
Carpeta=(Carpeta principal)
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[DM0214ZonasVis.DM0214ZonasCobranza.Categoria]
Carpeta=DM0214ZonasVis
Clave=DM0214ZonasCobranza.Categoria
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[DM0214ZonasVis.ListaEnCaptura]
(Inicio)=DM0214ZonasCobranza.Zona
DM0214ZonasCobranza.Zona=DM0214ZonasCobranza.NivelCobranza
DM0214ZonasCobranza.NivelCobranza=DM0214ZonasCobranza.Region
DM0214ZonasCobranza.Region=DM0214ZonasCobranza.Division
DM0214ZonasCobranza.Division=DM0214ZonasCobranza.Equipo
DM0214ZonasCobranza.Equipo=DM0214ZonasCobranza.Categoria
DM0214ZonasCobranza.Categoria=(Fin)





[Forma.ListaAcciones]
(Inicio)=Eliminar
Eliminar=Localizar
Localizar=Nuevo
Nuevo=Guardar
Guardar=Cancelar
Cancelar=(Fin)

