[Forma]
Clave=Rm0000GerenciaInstVisFrm
Icono=0
Modulos=(Todos)
Nombre=Gerencias
ListaCarpetas=lista
CarpetaPrincipal=lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Seleccionar
PosicionInicialAlturaCliente=140
PosicionInicialAncho=205
PosicionInicialIzquierda=537
PosicionInicialArriba=425
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[lista]
Estilo=Iconos
Clave=lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Rm0000GerenciaInstvis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=Agente
PestanaOtroNombre=S
PestanaNombre=Gerencias
[Acciones.seleccion.Asignas]
Nombre=Asignas
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.seleccion.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Registraseleccion(<T>lista<T>)
[Acciones.seleccion.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)
[lista.Agente]
Carpeta=lista
Clave=Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[lista.Columnas]
0=157
[Acciones.Seleccionar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Seleccionar.Registrar]
Nombre=Registrar
Boton=0
TipoAccion=Expresion
Expresion=RegistrarSeleccion(<T>lista<T>)
Activo=S
Visible=S
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=23
NombreDesplegar=&Seleccionar
Multiple=S
ListaAccionesMultiples=Asignar<BR>Registrar<BR>Seleccion
NombreEnBoton=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
[Acciones.Seleccionar.Seleccion]
Nombre=Seleccion
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=SQL(<T>EXEC SP_MaviCuentaEstacionUen :nSt, 2<T>,EstacionTrabajo)

