
[Forma]
Clave=DM0285COMSModificarDetalleListaFrm
Icono=390
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=132
PosicionInicialAncho=500
PosicionInicialIzquierda=433
PosicionInicialArriba=298
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
Nombre=<T>Modificar Articulo De La Lista De Prioridad<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
VentanaSinIconosMarco=S
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0285COMSDetalleListaPrioridadVis
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
ListaEnCaptura=DM0285COMSDetalleListaPrioridadTbl.Codigo<BR>DM0285COMSDetalleListaPrioridadTbl.Descripcion<BR>DM0285COMSDetalleListaPrioridadTbl.Orden
CarpetaVisible=S

[Principal.DM0285COMSDetalleListaPrioridadTbl.Codigo]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0285COMSDetalleListaPrioridadTbl.Descripcion]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0285COMSDetalleListaPrioridadTbl.Orden]
Carpeta=Principal
Clave=DM0285COMSDetalleListaPrioridadTbl.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=50

[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar<BR>Actualizar<BR>Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=AvanzarCaptura<BR><BR>Si(Vacio(DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo),Informacion(<T>Debe llenar el campo <Codigo><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Orden),Informacion(<T>Debe llenar el campo <Orden><T>) AbortarOperacion, Verdadero)<BR><BR>/*Comprobar si el articulo ingresado es valido de acuerdo al catalogo de articulos, considerando tambien su familia y linea*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Art WITH(NOLOCK)<BR>       WHERE Articulo = :tArticulo<T>,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo) > 0<BR>Entonces<BR>  Si<BR>    SQL(<T><BR>    DECLARE @Familia VARCHAR(50), @Linea VARCHAR(50)<BR>                                                                                                   <BR>    SELECT @Familia = Familia, @Linea = Linea<BR>    FROM COMSCListaPrioridadEcommerce WITH(NOLOCK)<BR>    WHERE IdListaPrioridadEcommerce = :nID<BR><BR>    SELECT COUNT(*)<BR>    FROM Art WITH(NOLOCK)<BR>    WHERE Articulo = :tArticulo<BR>    AND Familia = @Familia<BR>    AND Linea = @Linea<T>,<BR>    Info.Numero,<BR>    DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo) > 0<BR>  Entonces<BR>    Verdadero<BR>  Sino<BR>    Informacion(<T>El articulo ingresado no concuerda con la Familia-Linea de la lista de prioridad favor de corregir<T>)<BR>    AbortarOperacion<BR>  Fin<BR>Sino<BR>  Informacion(<T>El codigo ingresado del articulo no es valido<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>/*Validar que no se quiera ingresar un codigo repetido*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM COMSDListaPrioridad WITH(NOLOCK)<BR>       WHERE IdListaPrioridadEcommerce = :nIDLP<BR>       AND Codigo = :tArt<BR>       AND IdListaPrioridad <> :nID<T>,Info.Numero,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo,Info.Conteo) > 0<BR>Entonces<BR>  Informacion(<T>Error, ya existe el articulo en la lista<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>/*Validar que no se intente ingresar un orden ya existente*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM COMSDListaPrioridad WITH(NOLOCK)<BR>       WHERE IdListaPrioridadEcommerce = :nIDLP<BR>       AND Orden = :nOrden<BR>       AND IdListaPrioridad <> :nID<T>,<BR>       Info.Numero,<BR>       DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Orden,<BR>       Info.Conteo) > 0<BR>Entonces<BR>  Informacion(<T>El campo <Orden> es invalido ya que dicho orden ya existe en esta lista<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
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

[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Actualizar<BR>Cerrar
Activo=S
Visible=S
EspacioPrevio=S

[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Conteo,)<BR>OtraForma(<T>DM0285COMSDetalleListaPrioridadFrm<T>, Forma.Accion(<T>Actualizar<T>))<BR>Informacion(<T>Datos modificados con exito<T>)
[Acciones.Salir.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Conteo,)<BR>OtraForma(<T>DM0285COMSDetalleListaPrioridadFrm<T>, Forma.Accion(<T>Actualizar<T>))

