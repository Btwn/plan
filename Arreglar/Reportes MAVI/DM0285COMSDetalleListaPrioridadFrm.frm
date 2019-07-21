
[Forma]
Clave=DM0285COMSDetalleListaPrioridadFrm
Icono=390
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=273
PosicionInicialAncho=833
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=266
PosicionInicialArriba=228
Nombre=<T>Articulos De La Lista De Prioridad<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Eliminar<BR>Modificar<BR>Actualizar<BR>Salir
ExpresionesAlCerrar=Asigna(Info.Numero,)<BR>Asigna(Info.Conteo,)
[Principal]
Estilo=Hoja
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0285COMSDetalleListaPrioridadVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0285COMSDetalleListaPrioridadTbl.Codigo<BR>DM0285COMSDetalleListaPrioridadTbl.Descripcion<BR>DM0285COMSDetalleListaPrioridadTbl.Orden
CarpetaVisible=S

PermiteEditar=S
HojaConfirmarEliminar=S
[Principal.DM0285COMSDetalleListaPrioridadTbl.Codigo]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Codigo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Principal.DM0285COMSDetalleListaPrioridadTbl.Descripcion]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Descripcion
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

[Principal.DM0285COMSDetalleListaPrioridadTbl.Orden]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Orden
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.Columnas]
Codigo=124
Descripcion=604
Orden=64

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

[Acciones.Eliminar]
Nombre=Eliminar
Boton=36
NombreEnBoton=S
NombreDesplegar=Eliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    Confirmacion( <T>¿Desea eliminar el registro?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>  Entonces<BR>    Verdadero<BR>  Sino<BR>    AbortarOperacion<BR>  Fin
[Acciones.Modificar]
Nombre=Modificar
Boton=75
NombreEnBoton=S
NombreDesplegar=Modificar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Asigna<BR>InvocaForma
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ActualizarForma

[Acciones.Modificar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Conteo,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.IdListaPrioridad)
Activo=S
Visible=S

[Acciones.Modificar.InvocaForma]
Nombre=InvocaForma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0285COMSModificarDetalleListaFrm
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

