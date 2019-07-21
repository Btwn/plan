[Forma]
Clave=RM1084CtasenviadasMavicob
Icono=0
Modulos=(Todos)
ListaCarpetas=RM1084CtasenviadasMavicob
CarpetaPrincipal=RM1084CtasenviadasMavicob
PosicionInicialIzquierda=269
PosicionInicialArriba=216
PosicionInicialAlturaCliente=235
PosicionInicialAncho=253
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)
Nombre=RM1084 Cuentas enviadas a Mavicob
[Acciones.Preliminar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=55
NombreEnBoton=S
NombreDesplegar=Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=asignar<BR>Reporte
EspacioPrevio=S
[Acciones.Preliminar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SI vacio(Info.cliente)<BR>Entonces<BR>condatos(info.fechad) y  condatos(info.fechaa)<BR>FIN
EjecucionMensaje=<T>Debe especificar al menos un cliente<BR>o un rango de fechas<T>
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[RM1084CtasenviadasMavicob]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Cuentas enviadas a Mavicob
Clave=RM1084CtasenviadasMavicob
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Cliente<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
[RM1084CtasenviadasMavicob.Info.Cliente]
Carpeta=RM1084CtasenviadasMavicob
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1084CtasenviadasMavicob.Info.FechaD]
Carpeta=RM1084CtasenviadasMavicob
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[RM1084CtasenviadasMavicob.Info.FechaA]
Carpeta=RM1084CtasenviadasMavicob
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


