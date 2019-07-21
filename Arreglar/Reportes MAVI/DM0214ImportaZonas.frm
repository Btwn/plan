[Forma]
Clave=DM0214ImportaZonas
Nombre=Importar Zonas
Icono=0
EsMovimiento=S
Modulos=(Todos)
TituloAuto=S
MovEspecificos=Todos
ListaCarpetas=Zonas<BR>Nivel
CarpetaPrincipal=Zonas
PosicionInicialAlturaCliente=538
PosicionInicialAncho=865
PosicionInicialIzquierda=118
PosicionInicialArriba=218
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar<BR>Limpiar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
PosicionSec1=85
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>ListaNivel<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )<BR><BR>asigna(info.nivel,<T><T>)
[Agentes.Columnas]
Valida=151
Zona=103
Agente=114
NivelCobranza=187
MaxCuentas=94
Ruta=80
[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Importar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Importar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Importar]
Nombre=Importar
Boton=11
NombreEnBoton=S
NombreDesplegar=&Importar Lista
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Enviar/Recibir Excel<BR>Guardar Cambios<BR>Actualizar Forma
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Guardar]
Nombre=Guardar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=asignavar<BR>actualizacontr<BR>Guardar Cambios<BR>Expresion<BR>expre
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=limpia<BR>cancelar<BR>cierra
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Si ( sql( <T>Select COUNT(NivelCobranza ) from ZonaCobranzaMenVal where Nivelcobranza = :tn and estaciontrab = :ne and isnull(valida, :ta) != :tm  <T> ,info.nivel, EstacionTrabajo,<T><T>,<T>ListaNivel<T> )) >0<BR> o (info.nivel = <T>TODO<T>)<BR>entonces<BR>SI<BR> SQL(<T>                                                <BR>      Select isnull(tot,0) c<BR>      from                                                                                                                             <BR>      (Select count (zona) tot<BR>      from zonaCobranzaMenVal<BR>      where estaciontrab = :Ne and isnull(valida,:tv) != :Tl<BR>      )t  <T>, EstacionTrabajo,<T><T>,<T>ListaNivel<T>  )>0<BR><BR>Entonces<BR><BR>EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>ImpZonas<T>+ASCII(39)+<T>,<T>+ASCII(39)+DM0214ImportaZonasVis:DM0214ZonasValidacion.NivelCobranza+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )<BR><BR><BR><BR>Si (SQL( <T>Select ISNULL(COUNT(Valida),0) from ZonaCobranzaMenVal WHERE Valida IS NOT NULL and EstacionTrab = :ne <T>,estaciontrabajo)) >0<BR>Entonces<BR> ERROR(<T>No es posible Realizar la importación<T>)<BR><BR>SINO<BR> Informacion(<T>IMPORTACION CORRECTA<T>)<BR>FIN<BR><BR>Sino                                                                           <BR>  ERROR(<T>No existen datos para ser importados<T>)<BR>Fin<BR><BR>sino<BR> informacion(<T>No existen datos en la lista<BR> con el nivel seleccionado<T>)<BR>fin<BR><BR>Forma.ActualizarVista<BR>asigna(info.nivel,<T><T>)
EjecucionCondicion=condatos(DM0214ImportaZonasVis:DM0214ZonasValidacion.NivelCobranza)
EjecucionMensaje=<T>Especifique el nivel<T>
[Acciones.Cerrar.cierra]
Nombre=cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar.limpia]
Nombre=limpia
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Borrar<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )
[Acciones.Limpiar.liimpia]
Nombre=liimpia
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Borrar<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+estaciontrabajo  +<T>,<T>+ASCII(39)+Usuario+ASCII(39))
[Acciones.Limpiar.actual]
Nombre=actual
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Limpiar]
Nombre=Limpiar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Limpiar Lista
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=liimpia<BR>cancelacamb<BR>actual
Activo=S
Visible=S
[Zonas]
Estilo=Hoja
Clave=Zonas
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0214ZonasValidacionVis
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
ListaEnCaptura=DM0214ZonasValidacion.Valida<BR>DM0214ZonasValidacion.NivelCobranza<BR>DM0214ZonasValidacion.region<BR>DM0214ZonasValidacion.division<BR>DM0214ZonasValidacion.equipo<BR>DM0214ZonasValidacion.Zona<BR>DM0214ZonasValidacion.Ruta
CarpetaVisible=S
[Zonas.DM0214ZonasValidacion.Valida]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.Valida
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.Zona]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.NivelCobranza]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.region]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.division]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.equipo]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.DM0214ZonasValidacion.Ruta]
Carpeta=Zonas
Clave=DM0214ZonasValidacion.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Zonas.Columnas]
Valida=139
NivelCobranza=173
region=98
division=133
equipo=85
Zona=80
Ruta=93
[Nivel]
Estilo=Ficha
Pestana=S
Clave=Nivel
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214ImportaZonasVis
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
CarpetaVisible=S
ListaEnCaptura=DM0214ZonasValidacion.NivelCobranza
PermiteEditar=S
[Nivel.DM0214ZonasValidacion.NivelCobranza]
Carpeta=Nivel
Clave=DM0214ZonasValidacion.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar.cancelar]
Nombre=cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Limpiar.cancelacamb]
Nombre=cancelacamb
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Guardar.actualizacontr]
Nombre=actualizacontr
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Afectar
Activo=S
Visible=S
[Acciones.ss.sdsd]
Nombre=sdsd
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=informacion(info.nivel)<BR>/*<BR>informacion(DM0214ImportaZonasVis:DM0214ZonasValidacion.NivelCobranza)<BR><BR>informacion(sqlenlista( <T>Select NivelCobranza from ZonaCobranzaMenVal where estaciontrab = :ne  and nivelcobranza = :tn and<BR><BR>isnull(valida, :ta) != :v <T><BR> , EstacionTrabajo,info.nivel,<T><T>,<T>Listanivel<T> ) )<BR><BR><BR> */
[Acciones.Guardar.asignavar]
Nombre=asignavar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar.expre]
Nombre=expre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ejecutarsql(<T>EXEC SP_MAVIDM0214GuardarZonasCategoria<T>)

