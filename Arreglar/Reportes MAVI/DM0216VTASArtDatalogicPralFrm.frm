
[Forma]
Clave=DM0216VTASArtDatalogicPralFrm
Icono=390
Modulos=(Todos)
Nombre=<T>Catalogo De Articulos DataLogic<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=438
PosicionInicialAncho=798
PosicionInicialIzquierda=241
PosicionInicialArriba=273
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Nuevo<BR>Modificar<BR>Actualizar
AccionesCentro=S
AccionesDivision=S
[Principal]
Estilo=Hoja
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0216VTASCatalogoDatalogicVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaAjustarColumnas=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=DM0216VTASArtDatalogicTbl.Codigo<BR>DM0216VTASArtDatalogicTbl.Nombre<BR>DM0216VTASArtDatalogicTbl.Tipo<BR>DM0216VTASArtDatalogicTbl.Prov<BR>DM0216VTASArtDatalogicTbl.Monto






[Principal.Columnas]
Codigo=116
Nombre=254
Prov=198
Monto=101
Tipo=77

[Acciones.Nuevo]
Nombre=Nuevo
Boton=0
NombreEnBoton=S
NombreDesplegar=Nuevo
EnBarraAcciones=S
Activo=S
Visible=S

TipoAccion=Formas
ClaveAccion=DM0216VTASNuevoArtDatalogicFrm
[Acciones.Modificar]
Nombre=Modificar
Boton=0
NombreEnBoton=S
NombreDesplegar=Modificar
EnBarraAcciones=S
Activo=S
Visible=S

TipoAccion=Formas
ClaveAccion=DM0216ModificarArtDatalogicFrm
Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Modificar
[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=ActualizarForma
[Acciones.Modificar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Info.Mensaje,DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Codigo)
[Acciones.Modificar.Modificar]
Nombre=Modificar
Boton=0
TipoAccion=Formas
ClaveAccion=DM0216VTASModificarArtDatalogicFrm
Activo=S
Visible=S



[Principal.DM0216VTASArtDatalogicTbl.Codigo]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=13
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Nombre]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=150
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Tipo]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Prov]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Prov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Monto]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

