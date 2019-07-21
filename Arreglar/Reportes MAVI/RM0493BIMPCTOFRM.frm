[Forma]
Clave=RM0493BIMPCTOFRM
Icono=0
Modulos=(Todos)
ListaCarpetas=RM0493BIMPCTOVIS
CarpetaPrincipal=RM0493BIMPCTOVIS
PosicionInicialAlturaCliente=272
PosicionInicialAncho=236
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Import Information<BR>Guardar
AutoGuardar=S
PosicionInicialIzquierda=713
PosicionInicialArriba=173
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
[RM0497IMPCTOVIS.Columnas]
Nivel=68
Agente=73
[Acciones.Import Information]
Nombre=Import Information
Boton=54
NombreDesplegar=Enviar/Recibir Excel
Carpeta=RM0497IMPCTOVIS
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
EnBarraHerramientas=S
[RM0493BIMPCTOVIS]
Estilo=Hoja
Clave=RM0493BIMPCTOVIS
Detalle=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0493BIMPCTOVIS
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
ListaEnCaptura=RM0493BIMPCTOTBL.Nivel<BR>RM0493BIMPCTOTBL.Agente
CarpetaVisible=S
[RM0493BIMPCTOVIS.RM0493BIMPCTOTBL.Nivel]
Carpeta=RM0493BIMPCTOVIS
Clave=RM0493BIMPCTOTBL.Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM0493BIMPCTOVIS.RM0493BIMPCTOTBL.Agente]
Carpeta=RM0493BIMPCTOVIS
Clave=RM0493BIMPCTOTBL.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[RM0493BIMPCTOVIS.Columnas]
Nivel=109
Agente=68
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=Guardar
Activo=S
Visible=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=Guardar<BR>exp<BR>GuardaHistorial
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.GuardaHistorial]
Nombre=GuardaHistorial
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Mavi.DM0169Dialogo = <T>NO<T><BR>Entonces<BR>  ejecutarSQL(<T>exec SP_DM0193NivelcobAgenteHist<T>)<BR>Sino<BR>  Error(Mavi.DM0169Dialogo)<BR>  ActualizarVista<BR>Fin
[Acciones.Guardar.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Expresion=Asigna(Mavi.DM0169Dialogo,SQL(<T>EXEC SP_MAVIRM0493BEliminaduplicidad<T>) )
Activo=S
Visible=S

