[Forma]
Clave=DM0175JefesDeGrupoDimaVisFrm
Nombre=DM0175 Jefes De Grupo Dima
Icono=0
Modulos=(Todos)
ListaCarpetas=Agentes
CarpetaPrincipal=Agentes
PosicionInicialIzquierda=533
PosicionInicialArriba=203
PosicionInicialAlturaCliente=323
PosicionInicialAncho=299
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
[Agentes]
Estilo=Iconos
Clave=Agentes
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0175JefesDeGrupoDimaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
ListaEnCaptura=Agente<BR>Nombre
MenuLocal=S
ListaAcciones=Seleccionar Todo
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
IconosNombre=DM0175JefesDeGrupoDimaVis:Nombre
[Agentes.Columnas]
0=20
1=78
Agente=64
Nombre=604
2=144
[Acciones.seleccion.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.seleccion.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Agentes<T>)
[Acciones.seleccion.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.DM0175AgentesDima,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
Activo=S
Visible=S
[Acciones.seleccionar.Agregar]
Nombre=Agregar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>Agentes<T>)
[Acciones.seleccionar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.DM0175AgentesDima, SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
EnBarraHerramientas=S
EspacioPrevio=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Registra<BR>Selecciona
Activo=S
Visible=S
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Seleccionar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Vista<T>)
[Acciones.Seleccionar.Selecciona]
Nombre=Selecciona
Boton=0
Activo=S
Visible=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(MAVI.DM0175AgentesDima,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Agentes.Agente]
Carpeta=Agentes
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Agentes.Nombre]
Carpeta=Agentes
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Seleccionar Todo]
Nombre=Seleccionar Todo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+E

