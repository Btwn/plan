
[Forma]
Clave=DM0285COMSListaPrioridadFrm
Icono=62
Modulos=(Todos)
Nombre=<T>Listas De Prioridad Ecommerce<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=421
PosicionInicialAncho=849
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=258
PosicionInicialArriba=154
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=NuevaLista<BR>ModificarLista<BR>EliminarLista<BR>Actualizar
ExpresionesAlMostrar=Asigna(Info.Numero,)<BR>Asigna(Info.Conteo,)
[Principal]
Estilo=Hoja
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0285COMSListaPrioridadVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0285COMSListaPrioridadTbl.Nombre<BR>DM0285COMSListaPrioridadTbl.FechaInicio<BR>DM0285COMSListaPrioridadTbl.FechaFin<BR>DM0285COMSListaPrioridadTbl.Familia<BR>DM0285COMSListaPrioridadTbl.Linea<BR>DM0285COMSListaPrioridadTbl.UEN
CarpetaVisible=S

MenuLocal=S
ListaAcciones=ArticulosLista<BR>MostrarArticulosDeLista
PermiteEditar=S
[Principal.DM0285COMSListaPrioridadTbl.Nombre]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Nombre
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

[Principal.DM0285COMSListaPrioridadTbl.FechaInicio]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.FechaInicio
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.DM0285COMSListaPrioridadTbl.FechaFin]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.FechaFin
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco


[Principal.DM0285COMSListaPrioridadTbl.Linea]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Linea
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0285COMSListaPrioridadTbl.UEN]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.UEN
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Principal.Columnas]
Nombre=180
FechaInicio=94
FechaFin=94
Familia=192
Linea=181
UEN=64

[Acciones.NuevaLista]
Nombre=NuevaLista
Boton=18
NombreEnBoton=S
NombreDesplegar=Crear Nueva Lista De Prioridad
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Formas
ClaveAccion=DM0285COMSNuevaListaFrm

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
NombreDesplegar=Expresion
TipoAccion=Expresion
Expresion=ActualizarForma
Activo=S
Visible=S

[Principal.DM0285COMSListaPrioridadTbl.Familia]
Carpeta=Principal
Clave=DM0285COMSListaPrioridadTbl.Familia
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Acciones.ArticulosLista]
Nombre=ArticulosLista
Boton=0
NombreDesplegar=Asignar Articulos A La Lista
EnMenu=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asigna<BR>InvocaForma
[Acciones.EliminarLista.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.EliminarLista.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.EliminarLista]
Nombre=EliminarLista
Boton=36
NombreDesplegar=Eliminar Lista De Prioridad
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

ConCondicion=S
EjecucionCondicion=Si<BR>    Confirmacion( <T>¿Desea eliminar el registro?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>  Entonces<BR>    Verdadero<BR>  Sino<BR>    AbortarOperacion<BR>  Fin
[Acciones.ModificarLista]
Nombre=ModificarLista
Boton=75
NombreEnBoton=S
NombreDesplegar=Modificar Lista De Prioridad
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Asigna<BR>Modifica
[Acciones.ModificarLista.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.ModificarLista.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Numero,DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.IdListaPrioridadEcommerce)
Activo=S
Visible=S

[Acciones.ModificarLista.Modifica]
Nombre=Modifica
Boton=0
TipoAccion=Formas
ClaveAccion=DM0285COMSModificarListaFrm
Activo=S
Visible=S


[Acciones.ArticulosLista.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Numero,DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.IdListaPrioridadEcommerce)
[Acciones.ArticulosLista.InvocaForma]
Nombre=InvocaForma
Boton=0
Activo=S
Visible=S

TipoAccion=Formas
ClaveAccion=DM0285COMSCapturarDetalleListaFrm

[Acciones.MostrarArticulosDeLista]
Nombre=MostrarArticulosDeLista
Boton=0
NombreDesplegar=Mostrar Articulos De La Lista
EnMenu=S
TipoAccion=Formas
ClaveAccion=DM0285COMSDetalleListaPrioridadFrm
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Asignar<BR>InvocaForma
[Acciones.MostrarArticulosDeLista.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Numero,DM0285COMSListaPrioridadVis:DM0285COMSListaPrioridadTbl.IdListaPrioridadEcommerce)
Activo=S
Visible=S

[Acciones.MostrarArticulosDeLista.InvocaForma]
Nombre=InvocaForma
Boton=0
TipoAccion=Formas
ClaveAccion=DM0285COMSDetalleListaPrioridadFrm
Activo=S
Visible=S

[Acciones.MostrarArticulosDeLista.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

