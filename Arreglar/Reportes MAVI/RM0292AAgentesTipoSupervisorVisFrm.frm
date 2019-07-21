[Forma]
Clave=RM0292AAgentesTipoSupervisorVisFrm
Nombre=Agentes Tipo Supervisor
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=544
PosicionInicialArriba=434
PosicionInicialAlturaCliente=203
PosicionInicialAncho=431
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
BarraHerramientas=S
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0292AAgentesTipoSupervisorVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ColorFuente=Negro
ListaEnCaptura=NombreSupervisor
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Clave
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
IconosNombre=RM0292AAgentesTipoSupervisorVis:CveSupervisor
ListaAcciones=Selectodo<BR>quitaasele
[Lista.Columnas]
CveSupervisor=74
NombreSupervisor=604
0=-2
1=-2
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EnMenu=S
EnBarraHerramientas=S
Multiple=S
ListaAccionesMultiples=asigna<BR>registrar<BR>sel
[Lista.NombreSupervisor]
Carpeta=Lista
Clave=NombreSupervisor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.registrar]
Nombre=registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Seleccionar.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.RM0292ACveTipoSuperv,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)
[Acciones.Selectodo]
Nombre=Selectodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitaasele]
Nombre=quitaasele
Boton=0
NombreDesplegar=Quitar seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
