
[Forma]
Clave=DM0207EtiquetaCategoriaFrm
Icono=0
Modulos=(Todos)
Nombre=DM0207 Etiquetas de Jerarquias Categoria

ListaCarpetas=demandaPendiente
CarpetaPrincipal=demandaPendiente
PosicionInicialIzquierda=205
PosicionInicialArriba=192
PosicionInicialAlturaCliente=273
PosicionInicialAncho=500
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=guarda
[demandaPendiente]
Estilo=Hoja
Clave=demandaPendiente
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207EtiquetaCategoriaVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaTitulosEnBold=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0207EtiquetaJerarquiaTbl.Nombre<BR>DM0207EtiquetaJerarquiaTbl.Jerarquia
CarpetaVisible=S

[demandaPendiente.DM0207EtiquetaJerarquiaTbl.Nombre]
Carpeta=demandaPendiente
Clave=DM0207EtiquetaJerarquiaTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[demandaPendiente.DM0207EtiquetaJerarquiaTbl.Jerarquia]
Carpeta=demandaPendiente
Clave=DM0207EtiquetaJerarquiaTbl.Jerarquia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[demandaPendiente.Columnas]
Nombre=154
Jerarquia=64

[Acciones.guarda.guard]
Nombre=guard
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.guarda.clos]
Nombre=clos
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.guarda]
Nombre=guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Cambios Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=guard<BR>clos
Activo=S
Visible=S
