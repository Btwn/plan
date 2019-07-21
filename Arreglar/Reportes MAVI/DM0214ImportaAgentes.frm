[Forma]
Clave=DM0214ImportaAgentes
Nombre=Importa Agentes
Icono=0
EsMovimiento=S
Modulos=(Todos)
TituloAuto=S
MovEspecificos=Todos
ListaCarpetas=Agentes
CarpetaPrincipal=Agentes
PosicionInicialAlturaCliente=370
PosicionInicialAncho=679
PosicionInicialIzquierda=271
PosicionInicialArriba=261
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Importar<BR>Guardar<BR>Limpiar<BR>Cerrar<BR>Exel
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Agentes]
Estilo=Hoja
Clave=Agentes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214ZonasValidacionVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
HojaPermiteInsertar=S
ListaEnCaptura=(Lista)
[Agentes.Columnas]
Valida=151
Zona=103
Agente=114
NivelCobranza=187
MaxCuentas=65
Ruta=80
MaxAsociados=76
MaxCtesFinales=88
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
[Acciones.Exel]
Nombre=Exel
Boton=115
NombreEnBoton=S
NombreDesplegar=E&xportar
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=dm0214exportar
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
AntesExpresiones=asigna(info.modulo,<T>Agentes<T>)
[Acciones.Guardar]
Nombre=Guardar
Boton=7
NombreEnBoton=S
NombreDesplegar=&Procesar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
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
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=limpia<BR>cierra
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
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Importar<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T>Agente<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39) ) <BR><BR>Forma.ActualizarVista<BR><BR>Si (SQL( <T>Select ISNULL(COUNT(Valida),0) from ZonaCobranzaMenVal WHERE Valida IS NOT NULL <T>)) >0<BR>Entonces<BR> ERROR(<T>No es posible Realizar la importación<T>)<BR><BR>SINO<BR> Informacion(<T>IMPORTACION CORRECTA<T>)<BR>FIN
EjecucionCondicion=SI<BR> SQL(<T><BR>      Select isnull(tot,0) c<BR>      from<BR>      (Select count (zona) tot<BR>      from zonaCobranzaMenVal<BR>      where estaciontrab = :Ne and isnull(valida,:tv) != :Tl<BR>      )t  <T>, EstacionTrabajo,<T><T>,<T>ListaNivel<T>  )>0<BR><BR>Entonces<BR>Verdadero<BR>sino<BR>falso<BR>Fin
EjecucionMensaje=<T>No existen datos para ser importados<T>
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
[Agentes.DM0214ZonasValidacion.Zona]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Agentes.DM0214ZonasValidacion.Agente]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Agentes.DM0214ZonasValidacion.MaxCuentas]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.MaxCuentas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Agentes.DM0214ZonasValidacion.Valida]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.Valida
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Limpiar.liimpia]
Nombre=liimpia
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>Borrar<T>+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+ASCII(39)+ASCII(39)+<T>,<T>+estaciontrabajo+<T>,<T>+ASCII(39)+Usuario+ASCII(39)  )
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
ListaAccionesMultiples=liimpia<BR>actual
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


[Agentes.ListaEnCaptura]
(Inicio)=DM0214ZonasValidacion.Valida
DM0214ZonasValidacion.Valida=DM0214ZonasValidacion.Zona
DM0214ZonasValidacion.Zona=DM0214ZonasValidacion.Agente
DM0214ZonasValidacion.Agente=DM0214ZonasValidacion.MaxCuentas
DM0214ZonasValidacion.MaxCuentas=DM0214ZonasValidacion.MaxAsociados
DM0214ZonasValidacion.MaxAsociados=DM0214ZonasValidacion.MaxCtesFinales
DM0214ZonasValidacion.MaxCtesFinales=(Fin)

[Agentes.DM0214ZonasValidacion.MaxAsociados]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.MaxAsociados
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[Agentes.DM0214ZonasValidacion.MaxCtesFinales]
Carpeta=Agentes
Clave=DM0214ZonasValidacion.MaxCtesFinales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro























[Forma.ListaAcciones]
(Inicio)=Importar
Importar=Guardar
Guardar=Limpiar
Limpiar=Cerrar
Cerrar=Exel
Exel=(Fin)

