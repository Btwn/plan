
[Forma]
Clave=RM1195AyudaBenefFrm
Icono=407
Modulos=(Todos)
Nombre=RM1195 - Cuenta Final
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado

ListaCarpetas=Vista
CarpetaPrincipal=Vista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna(Mavi.RM1195Beneficiario,NULO)
[Acciones.Seleccionar]
Nombre=Seleccionar
Boton=0
NombreDesplegar=&Seleccionar
EnMenu=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Vista]
Estilo=Iconos
Clave=Vista
BusquedaRapidaControles=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=RM1195AyudaBenefVis
ConFuenteEspecial=S
Fuente={Microsoft Sans Serif, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Cuenta Final<T>
IconosSeleccionMultiple=S
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=NombreFinal<BR>Domicilio
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

IconosNombre=RM1195AyudaBenefVis:ClienteF
[Vista.NombreFinal]
Carpeta=Vista
Clave=NombreFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=500
ColorFondo=Blanco

[Vista.Domicilio]
Carpeta=Vista
Clave=Domicilio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1000
ColorFondo=Blanco

[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Mavi.RM1195Beneficiario
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
Expresion=RegistrarSeleccion(<T>Vista<T>)<BR>Asigna(Info.Dialogo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>Si<BR>  ConDatos(Mavi.RM1195Beneficiario)<BR>Entonces<BR>  Asigna(Mavi.RM1195Beneficiario,Mavi.RM1195Cliente+<T>,<T>+Info.Dialogo)<BR>Sino<BR>  Asigna(Mavi.RM1195Beneficiario,Info.Dialogo)<BR>Fin<BR>Asigna(Info.Dialogo,NULO)<BR>Forma.ActualizarVista

