
[Forma]
Clave=RM1195AyudaClienteFrm
Icono=575
Modulos=(Todos)

ListaCarpetas=Vista
CarpetaPrincipal=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
PosicionInicialAlturaCliente=706
PosicionInicialAncho=1382
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar

Nombre=RM1195 - Clientes DIMA
ExpresionesAlMostrar=Asigna(Mavi.RM1195Cliente,NULO)
[Vista]
Estilo=Iconos
Clave=Vista
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM1195AyudaClienteVis
Fuente={Microsoft Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Cliente<T>
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Nombre<BR>Domicilio
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
ListaAcciones=Seleccionar
CarpetaVisible=S

ConFuenteEspecial=S
IconosNombre=RM1195AyudaClienteVis:Cliente
[Vista.Nombre]
Carpeta=Vista
Clave=Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


[Vista.Columnas]
0=94
1=420
2=828

[Acciones.Prueba.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Prueba.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion(<T>Vista<T>)<BR>Asigna(Info.Dialogo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>Asigna(Mavi.RM1195Cliente,Mavi.RM1195Cliente+Info.Dialogo)<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)


[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=Aceptar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S





Expresion=Mavi.RM1195Cliente
[Acciones.Seleccionar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Seleccionar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=RegistrarSeleccion(<T>Vista<T>)<BR>Asigna(Info.Dialogo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>Si<BR>  ConDatos(Mavi.RM1195Cliente)<BR>Entonces<BR>  Asigna(Mavi.RM1195Cliente,Mavi.RM1195Cliente+<T>,<T>+Info.Dialogo)<BR>Sino<BR>  Asigna(Mavi.RM1195Cliente,Info.Dialogo)<BR>Fin<BR>Asigna(Info.Dialogo,NULO)<BR>Forma.ActualizarVista
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=Seleccionar
Multiple=S
EnMenu=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
Activo=S
Visible=S



[Vista.Domicilio]
Carpeta=Vista
Clave=Domicilio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1000
ColorFondo=Blanco

