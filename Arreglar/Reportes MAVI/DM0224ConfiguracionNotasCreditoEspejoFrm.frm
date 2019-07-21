
[Forma]
Clave=DM0224ConfiguracionNotasCreditoEspejoFrm
Icono=24
Modulos=(Todos)
Nombre=<T>DM0224 Configuracion Notas Credito Espejo<T>

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=51
PosicionInicialArriba=477
PosicionInicialAlturaCliente=196
PosicionInicialAncho=1134
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir
[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0224ConfiguracionNotasCreditoEspejoVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0224ConfiguracionNotasCreditoEspejoTbl.MovCargo<BR>DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargo<BR>DM0224ConfiguracionNotasCreditoEspejoTbl.MovCredito<BR>DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCredito<BR>DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargoNuevo<BR>DM0224ConfiguracionNotasCreditoEspejoTbl.FechaDesde
CarpetaVisible=S

MenuLocal=S
ListaAcciones=Registro Eliminar<BR>Registro Agregar
[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.MovCargo]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.MovCargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargo]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.MovCredito]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.MovCredito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCredito]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCredito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargoNuevo]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.ConceptoCargoNuevo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.DM0224ConfiguracionNotasCreditoEspejoTbl.FechaDesde]
Carpeta=Lista
Clave=DM0224ConfiguracionNotasCreditoEspejoTbl.FechaDesde
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.Columnas]
MovCargo=124
ConceptoCargo=232
MovCredito=124
ConceptoCredito=234
ConceptoCargoNuevo=263
FechaDesde=94

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar Cambios
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

[Acciones.Salir]
Nombre=Salir
Boton=5
NombreEnBoton=S
NombreDesplegar=&Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

[Acciones.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
NombreDesplegar=Registro Eliminar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Registro Agregar]
Nombre=Registro Agregar
Boton=0
NombreDesplegar=Registro Agregar
EnMenu=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S


