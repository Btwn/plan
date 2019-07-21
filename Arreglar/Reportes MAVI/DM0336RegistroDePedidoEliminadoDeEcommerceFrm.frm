
[Forma]
Clave=DM0336RegistroDePedidoEliminadoDeEcommerceFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Filtro
CarpetaPrincipal=Filtro
PosicionInicialAlturaCliente=172
PosicionInicialAncho=349


PosicionInicialIzquierda=116
PosicionInicialArriba=98
CarpetasMultilinea=S
PosicionCol1=290
PosicionSec1=88
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Generar
AccionesDivision=S
AccionesCentro=S
Nombre=Filtro de Registros de pedidos eliminados de Ecommerce
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna( Mavi.DM0336FechaEliminacion,nulo )<BR>Asigna( Mavi.DM0336UEN,nulo )<BR>Asigna( Mavi.DM0336PedEcommerce,nulo )<BR>Asigna( Mavi.DM0336UsuarioElimino,nulo )
[RegistroDePedidoEliminadoDeEcommersVis.Columnas]
IDVenta=64


[UEN.Columnas]
IDVenta=64

UsuarioElimino=94
FechaEliminacion=94
ReferenciaOrdenCompra=304


Estatus=94






[Usuario que eliminó.Columnas]
UsuarioElimino=94
ReferenciaOrdenCompra=304
FechaEliminacion=94

[Acciones.Usuario que elimino]
Nombre=Usuario que elimino
Boton=0
NombreDesplegar=Usuario
EnBarraHerramientas=S
TipoAccion=Wizards
ClaveAccion=Asistente Cxc
Activo=S
Visible=S
Carpeta=(Carpeta principal)
ListaParametros=S

[Acciones.Edicion 2 (Registros)]
Nombre=Edicion 2 (Registros)
Boton=0
NombreDesplegar=Edicion 2 (Registros)
EnMenu=S
TipoAccion=Herramientas Captura
ClaveAccion=Edicion 2 (Registros)
Activo=S
Visible=S

[Usuario que eliminó.RegistroDePedidoEliminadoDeEcommersTbl.UsuarioElimino]
Carpeta=Usuario que eliminó
Clave=RegistroDePedidoEliminadoDeEcommersTbl.UsuarioElimino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Usuario que eliminó.RegistroDePedidoEliminadoDeEcommersTbl.FechaEliminacion]
Carpeta=Usuario que eliminó
Clave=RegistroDePedidoEliminadoDeEcommersTbl.FechaEliminacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Usuario que eliminó.RegistroDePedidoEliminadoDeEcommersTbl.ReferenciaOrdenCompra]
Carpeta=Usuario que eliminó
Clave=RegistroDePedidoEliminadoDeEcommersTbl.ReferenciaOrdenCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Fecha eliminado.RegistroDePedidoEliminadoDeEcommersTbl.FechaEliminacion]
Carpeta=Fecha eliminado
Clave=RegistroDePedidoEliminadoDeEcommersTbl.FechaEliminacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Fecha eliminado.RegistroDePedidoEliminadoDeEcommersTbl.UsuarioElimino]
Carpeta=Fecha eliminado
Clave=RegistroDePedidoEliminadoDeEcommersTbl.UsuarioElimino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Fecha eliminado.RegistroDePedidoEliminadoDeEcommersTbl.ReferenciaOrdenCompra]
Carpeta=Fecha eliminado
Clave=RegistroDePedidoEliminadoDeEcommersTbl.ReferenciaOrdenCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Fecha eliminado.Columnas]
FechaEliminacion=94
UsuarioElimino=94
ReferenciaOrdenCompra=304






[Acciones.Buscar]
Nombre=Buscar
Boton=0
NombreDesplegar=<T>Buscar<T>
RefrescarDespues=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
EsDefault=S
Multiple=S

[Filtro]
Estilo=Ficha
PestanaNombre=Filtros
Clave=Filtro
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=3
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0336UEN<BR>Mavi.DM0336UsuarioElimino<BR>Mavi.DM0336FechaEliminacion<BR>Mavi.DM0336PedEcommerce
AlinearTodaCarpeta=S

[Filtro.Mavi.DM0336UEN]
Carpeta=Filtro
Clave=Mavi.DM0336UEN
Editar=S
ValidaNombre=S
3D=S
Pegado=N
Tamano=20
ColorFondo=Blanco

AccionAlEnter=
LineaNueva=S
EspacioPrevio=N
[Filtro.Mavi.DM0336UsuarioElimino]
Carpeta=Filtro
Clave=Mavi.DM0336UsuarioElimino
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

EspacioPrevio=N
[Filtro.Mavi.DM0336FechaEliminacion]
Carpeta=Filtro
Clave=Mavi.DM0336FechaEliminacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

EspacioPrevio=N
[Filtro.Mavi.DM0336PedEcommerce]
Carpeta=Filtro
Clave=Mavi.DM0336PedEcommerce
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco



EspacioPrevio=N
[Acciones.Generar]
Nombre=Generar
Boton=50
NombreEnBoton=S
NombreDesplegar=&Generar
EnBarraAcciones=S
TipoAccion=Reportes Pantalla
ClaveAccion=DM0336RegistroDePedidoEliminadoDeEcommersRep
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=asignar<BR>generar
[Acciones.Generar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Generar.generar]
Nombre=generar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

