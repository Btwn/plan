
[Forma]
Clave=DM0341COMSPorcentajeBonificacionFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Tabla - Bonificacion<T>




ListaCarpetas=Bonificacion
CarpetaPrincipal=Bonificacion
PosicionInicialIzquierda=411
PosicionInicialArriba=228
PosicionInicialAlturaCliente=273
PosicionInicialAncho=544
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>Salir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Bonificacion]
Estilo=Hoja
Clave=Bonificacion
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0341COMSPorcentajeBonificacionVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0341COMSPorcentajeBonificacionTbl.Fabricante<BR>DM0341COMSPorcentajeBonificacionTbl.PorcentajeDeBonificacion
CarpetaVisible=S

[Bonificacion.DM0341COMSPorcentajeBonificacionTbl.Fabricante]
Carpeta=Bonificacion
Clave=DM0341COMSPorcentajeBonificacionTbl.Fabricante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Bonificacion.DM0341COMSPorcentajeBonificacionTbl.PorcentajeDeBonificacion]
Carpeta=Bonificacion
Clave=DM0341COMSPorcentajeBonificacionTbl.PorcentajeDeBonificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Bonificacion.Columnas]
Fabricante=423
PorcentajeDeBonificacion=81

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ListaAccionesMultiples=Registro Siguiente<BR>Guardar Cambios<BR>Actualizar Vista
ConCondicion=S
EjecucionCondicion=//Validar el fabricante<BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM Fabricante WITH(NOLOCK) WHERE Fabricante = :tFab<T>,<BR>       DM0341COMSPorcentajeBonificacionVis:DM0341COMSPorcentajeBonificacionTbl.Fabricante)>0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El Fabricante: <T>+DM0341COMSPorcentajeBonificacionVis:DM0341COMSPorcentajeBonificacionTbl.Fabricante+NuevaLinea+<BR>               <T>No es valido<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>//Validar que no exista<BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM COMSDBonificacionFabricante WITH(NOLOCK) WHERE Fabricante = :tFab AND IdBonificacionFabricante <> :nID<T>,<BR>       DM0341COMSPorcentajeBonificacionVis:DM0341COMSPorcentajeBonificacionTbl.Fabricante,<BR>       DM0341COMSPorcentajeBonificacionVis:DM0341COMSPorcentajeBonificacionTbl.IdBonificacionFabricante)>0<BR>Entonces<BR>  Informacion(<T>El Fabricante: <T>+DM0341COMSPorcentajeBonificacionVis:DM0341COMSPorcentajeBonificacionTbl.Fabricante<BR>               +NuevaLinea+<T>Ya existe en esta tabla<T>)<BR>   Forma.CancelarCambios<BR>   Forma.Guardar               <BR>  AbortarOperacion<BR>Sino                                                                                     <BR>  Verdadero                                          <BR>Fin
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

EspacioPrevio=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Vista
[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S

ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
[Fabricante.Columnas]
Fabricante=304

[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

