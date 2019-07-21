
[Forma]
Clave=DM0285COMSCapturarDetalleListaFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Agregar Nuevo Codigo A La Lista De Prioridad<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=120
PosicionInicialAncho=495
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=435
PosicionInicialArriba=304
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
VentanaSinIconosMarco=S
IniciarAgregando=S
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
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0285COMSDetalleListaPrioridadTbl.Codigo<BR>DM0285COMSDetalleListaPrioridadTbl.Descripcion<BR>DM0285COMSDetalleListaPrioridadTbl.Orden
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
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
Editar=N
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
[Principal.Columnas]
Codigo=124
Descripcion=604
Orden=64

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
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
ListaAccionesMultiples=Guardar Cambios<BR>Expresion<BR>Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=AvanzarCaptura<BR><BR>Si(Vacio(DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo),Informacion(<T>Debe llenar el campo <Codigo><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Orden),Informacion(<T>Debe llenar el campo <Orden><T>) AbortarOperacion, Verdadero)<BR><BR>/*Comprobar si el articulo ingresado es valido de acuerdo al catalogo de articulos, considerando tambien su familia y linea*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM Art WITH(NOLOCK)<BR>       WHERE Articulo = :tArticulo<T>,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo) > 0<BR>Entonces<BR>  Si<BR>    SQL(<T><BR>    DECLARE @Familia VARCHAR(50), @Linea VARCHAR(50)<BR>                                                                                                   <BR>    SELECT @Familia = Familia, @Linea = Linea<BR>    FROM COMSCListaPrioridadEcommerce WITH(NOLOCK)<BR>    WHERE IdListaPrioridadEcommerce = :nID<BR><BR>    SELECT COUNT(*)<BR>    FROM Art WITH(NOLOCK)<BR>    WHERE Articulo = :tArticulo<BR>    AND Familia = @Familia<BR>    AND Linea = @Linea<T>,<BR>    Info.Numero,<BR>    DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo) > 0<BR>  Entonces<BR>    Verdadero<BR>  Sino<BR>    Informacion(<T>El articulo ingresado no concuerda con la Familia-Linea de la lista de prioridad favor de corregir<T>)<BR>    AbortarOperacion<BR>  Fin<BR>Sino<BR>  Informacion(<T>El codigo ingresado del articulo no es valido<T>)<BR>  AbortarOperacion<BR>Fin<BR><BR>/*Validar que no se quiera ingresar un codigo repetido*/<BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM COMSDListaPrioridad WITH(NOLOCK)<BR>       WHERE IdListaPrioridadEcommerce = :nID<BR>       AND Codigo = :tArt<T>,Info.Numero,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Codigo) > 0<BR>Entonces<BR>  Informacion(<T>Error, ya existe el articulo en la lista<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin<BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*)<BR>       FROM COMSDListaPrioridad WITH(NOLOCK)<BR>       WHERE IdListaPrioridadEcommerce = :nID<BR>       AND Orden = :nOrden<T>,Info.Numero,DM0285COMSDetalleListaPrioridadVis:DM0285COMSDetalleListaPrioridadTbl.Orden) > 0<BR>Entonces<BR>  Informacion(<T>El campo <Orden> es invalido ya que dicho orden ya existe en esta lista<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S


[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Cancelar Cambios<BR>Expresion<BR>Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>  Confirmacion( <T>¿Seguro que desea salir sin guardar?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  AbortarOperacion<BR>Fin
[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Info.Numero,)
Activo=S
Visible=S

[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Info.Numero,nulo)<BR>Informacion(<T>Datos almacenados con exito<T>)

