
[Forma]
Clave=DM0321TipoSegurosVidaFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Tipo Seguros Vista
CarpetaPrincipal=Tipo Seguros Vista
Nombre=DM0321 Tipo de Seguros
PosicionInicialAlturaCliente=706
PosicionInicialAncho=1382
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cancelar
[Tipo Seguros Vista]
Estilo=Hoja
Clave=Tipo Seguros Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0321TipoSegurosVidaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0321TipoSegurosVidaTbl.Codigo<BR>DM0321TipoSegurosVidaTbl.SumaAsegurada<BR>DM0321TipoSegurosVidaTbl.Clase<BR>DM0321TipoSegurosVidaTbl.SubGrupo<BR>DM0321TipoSegurosVidaTbl.CoberturaBase<BR>DM0321TipoSegurosVidaTbl.CoberturaAdicional<BR>DM0321TipoSegurosVidaTbl.Proveedor<BR>Texto
CarpetaVisible=S

HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.SumaAsegurada]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.SumaAsegurada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.Clase]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.Clase
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.SubGrupo]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.SubGrupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.CoberturaBase]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.CoberturaBase
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.CoberturaAdicional]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.CoberturaAdicional
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.Proveedor]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Tipo Seguros Vista.Columnas]
CodigoNVP=124
SumaAsegurada=119
Clase=118
SubGrupo=130
CoberturaBase=184
CoberturaAdicional=304
Texto=604
Proveedor=78

Codigo=124
[Tipo Seguros Vista.Texto]
Carpeta=Tipo Seguros Vista
Clave=Texto
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Plata

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si(Vacio(DM0321TipoSegurosVidaVis:DM0321TipoSegurosVidaTbl.Codigo),Error(<T>El campo Código no puede quedar vacio<T>) AbortarOperacion,Verdadero)<BR>Si(Vacio(DM0321TipoSegurosVidaVis:DM0321TipoSegurosVidaTbl.Proveedor),Error(<T>El campo Proveedor no puede quedar vacio<T>) AbortarOperacion,Verdadero)
[Acciones.Cancelar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar Cambios
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
ListaAccionesMultiples=Cancelar<BR>Cerrar
Activo=S
Visible=S

[Tipo Seguros Vista.DM0321TipoSegurosVidaTbl.Codigo]
Carpeta=Tipo Seguros Vista
Clave=DM0321TipoSegurosVidaTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

