[Forma]
Clave=DM0213ConsultaFinalFrm
Nombre=DM0213 Catalogo Vehiculos-Proveedores
Icono=0
ListaCarpetas=FICHAS<BR>DETALLE
CarpetaPrincipal=FICHAS
PosicionInicialIzquierda=145
PosicionInicialArriba=222
PosicionInicialAncho=989
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
PosicionSeccion1=60
PosicionSeccion2=93
PosicionColumna3=50
BarraAyudaBold=S
BarraAyuda=S
PosicionInicialAlturaCliente=541
PosicionSec1=110
PosicionSec2=520
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=CERRA<BR>Actualiza<BR>CataVeh<BR>CataRef<BR>ConfProv
PosicionCol1=1058
ExpresionesAlMostrar=asigna(Mavi.DM0213MenuGrid,<T><T>)<BR>asigna(Mavi.DM0213MenuRefaccionesServicios,<T><T>)<BR>asigna(Mavi.DM0213MenuTipoVehiculo,<T><T>)<BR>asigna(Mavi.DM0213MenuProveedor,<T><T>)<BR>asigna(Mavi.DM0213MenuProveedorPrincipal,<T><T>)<BR>asigna(Info.Observaciones,<T><T>)




[Detalle.Columnas]
0=74
1=382
2=73
3=258
4=327
5=113
6=137
7=155
8=78
9=91
10=341
11=-2
12=-2
Proveedores=65
Precio=64
TipoUnidadVehicular=604
ServicioRefaccion=604
Observaciones=604





[FICHAS]
Estilo=Ficha
Clave=FICHAS
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Mavi.DM0213MenuProveedorPrincipal<BR>Mavi.DM0213MenuTipoVehiculo<BR>Mavi.DM0213MenuRefaccionesServicios<BR>Info.Observaciones
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Proveedores
ExpAntesRefrescar=//Si(Mavi.DM0211Movimiento<><T>Solicitud Cheque<T>,Asigna(Mavi.DM0211TipoCheque,nulo),1=1)
[DETALLE]
Estilo=Iconos
Clave=DETALLE
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0213ConsultaFinalVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre<BR>Precio<BR>TipoUnidadVehicular<BR>ServicioRefaccion<BR>Observaciones
MenuLocal=S
ListaAcciones=AFECTARLOTA<BR>Imprime
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSubTitulo=<T>Proveedor<T>
IconosNombre=DM0213ConsultaFinalVIS:Proveedores
CondicionVisible=Si<BR>  Mavi.DM0211Movimiento = <T>Pago<T><BR>Entonces<BR>  1=0<BR>sino<BR>1=1<BR>Fin<BR><BR>//(USUARIO.ACCESO)=<T>Tesom_Gera<T>
[Acciones.CERRA]
Nombre=CERRA
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Actualizar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Actualizar.asinaruno]
Nombre=asinaruno
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=asigna(Mavi.DM0211Vacio,1)
[Acciones.Actualizar.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
[Acciones.Actualiza]
Nombre=Actualiza
Boton=82
NombreEnBoton=S
NombreDesplegar=&Actualizar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=asig<BR>actvista
Activo=S
RefrescarDespues=S
Visible=S
[Acciones.Actualiza.asig]
Nombre=asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Actualiza.actvista]
Nombre=actvista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista

[Acciones.selTodo]
Nombre=selTodo
Boton=0
NombreDesplegar=&selTodo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitarSel]
Nombre=quitarSel
Boton=0
NombreDesplegar=&quitarSel
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.AFECTARLOTA]
Nombre=AFECTARLOTA
Boton=0
NombreDesplegar=&Enviar Excell
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Multiple=S
ListaAccionesMultiples=ASIGNA<BR>SEL<BR>SELECT<BR>Enviar_Excell
Visible=S
[Acciones.AFECTARLOTA.ASIGNA]
Nombre=ASIGNA
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.AFECTARLOTA.SEL]
Nombre=SEL
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=registrarseleccion(<T>DETALLE<T>)
[Acciones.AFECTARLOTA.SELECT]
Nombre=SELECT
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0213MenuGrid,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)

[DETALLE.Precio]
Carpeta=DETALLE
Clave=Precio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.TipoUnidadVehicular]
Carpeta=DETALLE
Clave=TipoUnidadVehicular
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.ServicioRefaccion]
Carpeta=DETALLE
Clave=ServicioRefaccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[DETALLE.Observaciones]
Carpeta=DETALLE
Clave=Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=200
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Mavi.DM0213MenuRefaccionesServicios]
Carpeta=FICHAS
Clave=Mavi.DM0213MenuRefaccionesServicios
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Mavi.DM0213MenuTipoVehiculo]
Carpeta=FICHAS
Clave=Mavi.DM0213MenuTipoVehiculo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.AFECTARLOTA.Enviar_Excell]
Nombre=Enviar_Excell
Boton=0
TipoAccion=Reportes Excel
Activo=S
Visible=S
ClaveAccion=DM0213ExcellRepXLS
ConCondicion=S
EjecucionCondicion=Si<BR>       VACIO(Mavi.DM0213MenuGrid) Entonces INFORMACION(<T> No Tiene Seleccionado Ningun Registro . . . !<T>)<BR><BR>     FIN
[Acciones.Imprime]
Nombre=Imprime
Boton=0
NombreDesplegar=Imprimir_Reporte
EnMenu=S
TipoAccion=Reportes Impresora
ClaveAccion=DM0213ImprimirRepImp
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asigna<BR>sel<BR>select<BR>Imprime
[Acciones.Imprime.Imprime]
Nombre=Imprime
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0213ImprimirRepImp
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Si<BR>       VACIO(Mavi.DM0213MenuGrid) Entonces INFORMACION(<T> No Tiene Seleccionado Ningun Registro . . . !<T>)<BR><BR>     FIN
[Acciones.Imprime.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprime.sel]
Nombre=sel
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=registrarseleccion(<T>DETALLE<T>)
[Acciones.Imprime.select]
Nombre=select
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0213MenuGrid,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.CataVeh]
Nombre=CataVeh
Boton=1
NombreDesplegar=Catalogo Tipo Vehiculo
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
NombreEnBoton=S
Expresion=forma(<T>DM0213CatalogoVehiculoFrm<T>)
VisibleCondicion=Si<BR>  ((USUARIO.ACCESO)=<T>GERAD_GERA<T>) O ((USUARIO.ACCESO)=<T>GEROP_GERA<T>)<BR>Entonces<BR>  1=1<BR>Sino<BR>     si ((USUARIO.ACCESO)=<T>VEHIC_GERA<T>) entonces 1=1 fin<BR><BR>Fin
[Acciones.CataRef]
Nombre=CataRef
Boton=1
NombreDesplegar=Catalogo Refacciones / Servicios
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
NombreEnBoton=S
Expresion=forma(<T>DM0213CatServRefacFrm<T>)
VisibleCondicion=Si<BR>  ((USUARIO.ACCESO)=<T>GERAD_GERA<T>) O ((USUARIO.ACCESO)=<T>GEROP_GERA<T>)<BR>Entonces<BR>  1=1<BR>Sino<BR>     si ((USUARIO.ACCESO)=<T>VEHIC_GERA<T>) entonces 1=1 fin<BR><BR>Fin
[Acciones.ConfProv]
Nombre=ConfProv
Boton=1
NombreDesplegar=&Configurar Proveedor
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
NombreEnBoton=S
Expresion=forma(<T>DM0213ConfigurarProveedorFrm<T>)
VisibleCondicion=Si<BR>  ((USUARIO.ACCESO)=<T>GERAD_GERA<T>) O ((USUARIO.ACCESO)=<T>GEROP_GERA<T>)<BR>Entonces<BR>  1=1<BR>Sino<BR>     si ((USUARIO.ACCESO)=<T>VEHIC_GERA<T>) entonces 1=1 fin<BR><BR>Fin
[FICHAS.Mavi.DM0213MenuProveedorPrincipal]
Carpeta=FICHAS
Clave=Mavi.DM0213MenuProveedorPrincipal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[DETALLE.Nombre]
Carpeta=DETALLE
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[FICHAS.Info.Observaciones]
Carpeta=FICHAS
Clave=Info.Observaciones
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro


