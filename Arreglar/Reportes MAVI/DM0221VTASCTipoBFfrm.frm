
[Forma]
Clave=DM0221VTASCTipoBFfrm
Icono=0
Modulos=(Todos)
Nombre=Limite Tipo de Beneficiario Final

ListaCarpetas=DM0221Configura Liberador
CarpetaPrincipal=DM0221Configura Liberador
PosicionInicialIzquierda=462
PosicionInicialArriba=282
PosicionInicialAlturaCliente=165
PosicionInicialAncho=442
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar Cambios<BR>Cancelar Cambios
VentanaSinIconosMarco=S
[DM0221Configura Liberador]
Estilo=Hoja
Clave=DM0221Configura Liberador
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0221VTASCTipoBFvis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0221VTASCTipoBFtbl.TipoBF<BR>DM0221VTASCTipoBFtbl.LimiteCredito<BR>DM0221VTASCTipoBFtbl.LimiteCredilana<BR>DM0221VTASCTipoBFtbl.ValidacionTel
CarpetaVisible=S

[DM0221Configura Liberador.DM0221VTASCTipoBFtbl.TipoBF]
Carpeta=DM0221Configura Liberador
Clave=DM0221VTASCTipoBFtbl.TipoBF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DM0221Configura Liberador.DM0221VTASCTipoBFtbl.LimiteCredito]
Carpeta=DM0221Configura Liberador
Clave=DM0221VTASCTipoBFtbl.LimiteCredito
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0221Configura Liberador.DM0221VTASCTipoBFtbl.LimiteCredilana]
Carpeta=DM0221Configura Liberador
Clave=DM0221VTASCTipoBFtbl.LimiteCredilana
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0221Configura Liberador.DM0221VTASCTipoBFtbl.ValidacionTel]
Carpeta=DM0221Configura Liberador
Clave=DM0221VTASCTipoBFtbl.ValidacionTel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DM0221Configura Liberador.Columnas]
TipoBF=124
LimiteCredito=97
LimiteCredilana=97

ValidacionTel=65
[Acciones.Guardar Cambios.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar Cambios.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Cambios
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Registro Siguiente<BR>Guardar Cambios<BR>Aceptar
Activo=S
Visible=S

RefrescarDespues=S
ConCondicion=S
EjecucionCondicion=Si<BR>  CONDATOS(DM0221VTASCTipoBFvis:DM0221VTASCTipoBFtbl.TipoBF) y<BR>  CONDATOS(DM0221VTASCTipoBFvis:DM0221VTASCTipoBFtbl.LimiteCredito) y<BR>  CONDATOS(DM0221VTASCTipoBFvis:DM0221VTASCTipoBFtbl.LimiteCredilana)<BR>Entonces<BR>  VERDADERO<BR>Sino<BR>  FALSO<BR>Fin
[Acciones.Cancelar Cambios.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar Cambios.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cancelar Cambios
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Aceptar
Activo=S
Visible=S

[Acciones.Guardar Cambios.Registro Siguiente]
Nombre=Registro Siguiente
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

