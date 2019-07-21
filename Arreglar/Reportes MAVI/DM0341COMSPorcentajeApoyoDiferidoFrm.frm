
[Forma]
Clave=DM0341COMSPorcentajeApoyoDiferidoFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Tabla - Apoyos Diferidos<T>

ListaCarpetas=Principal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar<BR>Salir
CarpetaPrincipal=Principal
PosicionInicialIzquierda=411
PosicionInicialArriba=228
PosicionInicialAlturaCliente=273
PosicionInicialAncho=544
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
[Principal]
Estilo=Hoja
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0341COMSPorcentajeApoyoDiferidoVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante<BR>DM0341COMSPorcentajeApoyoDiferidoTbl.PorcentajeDeApoyo
CarpetaVisible=S

[Principal.DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante]
Carpeta=Principal
Clave=DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0341COMSPorcentajeApoyoDiferidoTbl.PorcentajeDeApoyo]
Carpeta=Principal
Clave=DM0341COMSPorcentajeApoyoDiferidoTbl.PorcentajeDeApoyo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

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
EjecucionCondicion=//Validar el fabricante<BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM Fabricante WITH(NOLOCK) WHERE Fabricante = :tFab<T>,<BR>       DM0341COMSPorcentajeApoyoDiferidoVis:DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante)>0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Informacion(<T>El Fabricante: <T>+DM0341COMSPorcentajeApoyoDiferidoVis:DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante+NuevaLinea+<BR>               <T>No es valido<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>//Validar que no exista          <BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM COMSDApoyoFabricante WITH(NOLOCK) WHERE Fabricante = :tFab AND IdApoyoFabricante <> :nID<T>,<BR>       DM0341COMSPorcentajeApoyoDiferidoVis:DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante,<BR>       DM0341COMSPorcentajeApoyoDiferidoVis:DM0341COMSPorcentajeApoyoDiferidoTbl.IdApoyoFabricante)>0<BR>Entonces<BR>  Informacion(<T>El Fabricante: <T>+DM0341COMSPorcentajeApoyoDiferidoVis:DM0341COMSPorcentajeApoyoDiferidoTbl.Fabricante<BR>               +NuevaLinea+<T>Ya existe en esta tabla<T>)<BR>   Forma.CancelarCambios<BR>   Forma.Guardar<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios<BR>Actualizar Vista
[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
[Principal.Columnas]
Fabricante=413
PorcentajeDeApoyo=90

[Fabricante.Columnas]
Fabricante=304

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

[Acciones.Guardar.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
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

