[Forma]
Clave=DM0175GerentesDeGrupoDimaFrm
Nombre=DM0175 Gerentes De Grupo Dima
Icono=0
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=516
PosicionInicialArriba=303
PosicionInicialAlturaCliente=124
PosicionInicialAncho=334
ListaCarpetas=Variables
CarpetaPrincipal=Variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(MAVI.DM0175AgentesDima,<T><T>)
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
NombreDesplegar=&Preliminar
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
RefrescarDespues=S
Multiple=S
ListaAccionesMultiples=Variables Asig<BR>llama<BR>Cerra
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaAlineacion=Izquierda
PermiteEditar=S
ListaEnCaptura=MAVI.DM0175GerentesDima<BR>mavi.DM0175Quincena<BR>MAVI.DM0175Ejercicio
[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
ConCondicion=S
EjecucionCondicion=ConDatos(MAVI.DM0175Quincena)<BR>ConDatos(Info.Ejercicio)
EjecucionMensaje=<T>Error<T>
EjecucionConError=S
[Variables.MAVI.DM0175Ejercicio]
Carpeta=Variables
Clave=MAVI.DM0175Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.mavi.DM0175Quincena]
Carpeta=Variables
Clave=mavi.DM0175Quincena
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Expresion
Expresion=ReportePantalla(<T>DM0175JefesDeGrupoDimaGerenteRep<T>)
[Variables.MAVI.DM0175GerentesDima]
Carpeta=Variables
Clave=MAVI.DM0175GerentesDima
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Variables Asig]
Nombre=Variables Asig
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.llama]
Nombre=llama
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ReportePantalla(<T>DM0175JefesDeGrupoDimaGerenteRep<T>)
[Acciones.Preliminar.Cerra]
Nombre=Cerra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


