
[Forma]
Clave=RM1186GrupoFrm
Icono=0
Modulos=(Todos)
Nombre=Grupos

ListaCarpetas=RM1186GrupoVis
CarpetaPrincipal=RM1186GrupoVis
PosicionInicialIzquierda=513
PosicionInicialArriba=178
PosicionInicialAlturaCliente=374
PosicionInicialAncho=339
VentanaSiempreAlFrente=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ExpresionesAlCerrar=Asigna(MAVI.RM1186Grupo,RM1186GrupoVis:ArtGrupo.Grupo)
[RM1186GrupoVis]
Estilo=Hoja
Clave=RM1186GrupoVis
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1186GrupoVis
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
ListaEnCaptura=ArtGrupo.Grupo
CarpetaVisible=S

[RM1186GrupoVis.ArtGrupo.Grupo]
Carpeta=RM1186GrupoVis
Clave=ArtGrupo.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[RM1186GrupoVis.Columnas]
Grupo=304

[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S



[Acciones.Seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
Activo=S
Visible=S

ClaveAccion=Seleccionar/Aceptar


[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.RM1186Grupo,RM1186GrupoVis:ArtGrupo.Grupo)<BR>Informacion(Mavi.RM1186Grupo)

[Acciones.Seleccionar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Seleccionar.Asignar1]
Nombre=Asignar1
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Cerrar1]
Nombre=Cerrar1
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Seleccionar.Seleccionar1]
Nombre=Seleccionar1
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>RM1186GrupoVis<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Asignar2]
Nombre=Asignar2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Seleccionar.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>RM1186GrupoVis<T>)
Activo=S
Visible=S

[Acciones.Seleccionar.Preliminar2]
Nombre=Preliminar2
Boton=0
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.RM1186Grupo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)



[Acciones.Seleccionar.Select]
Nombre=Select
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Seleccionar.Cerr]
Nombre=Cerr
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S



