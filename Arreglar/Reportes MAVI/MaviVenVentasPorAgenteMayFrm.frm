[Forma]
Clave=MaviVenVentasPorAgenteMayFrm
Nombre=RM322 Ventas por Agente de Mayoreo
Icono=406
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=125
PosicionInicialAncho=356
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=462
PosicionInicialArriba=435
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
ExpresionesAlMostrar=asigna(Info.FechaD,Nulo)<BR>asigna(Info.FechaA,Nulo)<BR>asigna(Mavi.AgenteSucu98D2,Nulo)<BR>asigna(Mavi.AgenteSucu98A2,Nulo)
[Lista]
Estilo=Ficha
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.AgenteSucu98D2<BR>Mavi.AgenteSucu98A2<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
PermiteEditar=S
[Lista.Info.FechaD]
Carpeta=Lista
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Info.FechaA]
Carpeta=Lista
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=(((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))) y<BR>(((Mavi.AgenteSucu98D2)<=(Mavi.AgenteSucu98A2))o (vacio(Mavi.AgenteSucu98D2)y vacio(Mavi.AgenteSucu98A2)) o (condatos(Mavi.AgenteSucu98D2) y vacio(Mavi.AgenteSucu98A2)))
EjecucionMensaje=Si  ((condatos(Info.FechaD) y condatos(Info.FechaA))y ((Info.FechaA)<(Info.FechaD))) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>SINO<BR>Si  ((condatos(Mavi.AgenteSucu98D2) y condatos(Mavi.AgenteSucu98A2))y ((Mavi.AgenteSucu98A2)<(Mavi.AgenteSucu98D2))) ENTONCES <T>El No. de Agente Final debe ser Mayor o Igual que el Inicial<T>
[Lista.Mavi.AgenteSucu98D2]
Carpeta=Lista
Clave=Mavi.AgenteSucu98D2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Mavi.AgenteSucu98A2]
Carpeta=Lista
Clave=Mavi.AgenteSucu98A2
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


