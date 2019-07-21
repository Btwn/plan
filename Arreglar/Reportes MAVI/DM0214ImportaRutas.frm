[Forma]
Clave=DM0214ImportaRutas
Nombre=Import Rutas
Icono=0
Modulos=(Todos)
ListaCarpetas=DeducPromCobCampoMAVI
CarpetaPrincipal=DeducPromCobCampoMAVI
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
PosicionInicialAlturaCliente=537
PosicionInicialAncho=875
PosicionInicialIzquierda=266
PosicionInicialArriba=207
ListaAcciones=Importar<BR>Guardar<BR>Limpiar<BR>Cerrar<BR>Exel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaSinIconosMarco=S
PosicionSec1=57
[DeducPromCobCampoMAVI]
Estilo=Hoja
Clave=DeducPromCobCampoMAVI
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214ZonasValidacionVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
ListaEnCaptura=DM0214ZonasValidacion.Valida<BR>DM0214ZonasValidacion.Zona<BR>DM0214ZonasValidacion.Ruta
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[DeducPromCobCampoMAVI.Columnas]
Valida=163
NivelCobranza=147
Zona=94
Ruta=107
Agente=109
MaxCuentas=91
EstacionTrab=78
[Acciones.Importar]
Nombre=Importar
Boton=11
NombreEnBoton=S
NombreDesplegar=&Importar Lista
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Enviar/Recibir Excel<BR>Guardar Cambios<BR>Actualizar Forma
[Acciones.Guardar]
Nombre=Guardar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=quitavacios<BR>Guardar Cambios<BR>Expresion
EspacioPrevio=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>Cerrar
EspacioPrevio=S
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
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Importar<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T>Ruta<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )<BR><BR> Forma.ActualizarVista<BR> <BR>Si (SQL( <T>Select ISNULL(COUNT(Valida),0) from ZonaCobranzaMenVal WHERE Valida IS NOT NULL <T>)) >0<BR>Entonces<BR><BR> ERROR(<T>No es posible Realizar la importación<T>)<BR><BR>SINO<BR> Informacion(<T>IMPORTACION CORRECTA<T>)<BR>FIN
EjecucionCondicion=SI<BR> SQL(<T><BR>      Select isnull(tot,0) c<BR>      from<BR>      (Select count (zona) tot<BR>      from zonaCobranzaMenVal<BR>      where estaciontrab = :Ne and isnull(valida,:tv) != :Tl<BR>      )t  <T>, EstacionTrabajo,<T><T>,<T>ListaNivel<T>  )>0<BR><BR>Entonces<BR>Verdadero<BR>sino<BR>falso<BR>Fin
EjecucionMensaje=<T>No existen datos para ser importados<T>
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
[Acciones.Exel]
Nombre=Exel
Boton=115
NombreEnBoton=S
NombreDesplegar=E&xportar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=dm0214exportar
Antes=S
AntesExpresiones=asigna(info.modulo,<T>Rutas<T>)
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
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Borrar<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=<BR>Asigna(Info.Nivel,DM0214AgrupaZonasRutasCobranzaVis:ZonaCobranzaMen.NivelCobranza)<BR>Informacion(Info.Nivel)
Activo=S
Visible=S
[Acciones.Expresion.Siguiente]
Nombre=Siguiente
Boton=0
TipoAccion=Expresion
Expresion=AvanzarCaptura
Activo=S
Visible=S
[Variable.DM0214ZonaCobranzaMen.NivelCobranza]
Carpeta=Variable
Clave=DM0214ZonaCobranzaMen.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[DeducPromCobCampoMAVI.DM0214ZonasValidacion.Valida]
Carpeta=DeducPromCobCampoMAVI
Clave=DM0214ZonasValidacion.Valida
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
[DeducPromCobCampoMAVI.DM0214ZonasValidacion.Zona]
Carpeta=DeducPromCobCampoMAVI
Clave=DM0214ZonasValidacion.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[DeducPromCobCampoMAVI.DM0214ZonasValidacion.Ruta]
Carpeta=DeducPromCobCampoMAVI
Clave=DM0214ZonasValidacion.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Limpiar]
Nombre=Limpiar
Boton=21
NombreEnBoton=S
NombreDesplegar=&Limpiar Lista
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=expresion<BR>actual
EspacioPrevio=S
[Acciones.Limpiar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Borrar<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+Estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) )
[Acciones.Limpiar.actual]
Nombre=actual
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Guardar.quitavacios]
Nombre=quitavacios
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Activo=S
Visible=S

