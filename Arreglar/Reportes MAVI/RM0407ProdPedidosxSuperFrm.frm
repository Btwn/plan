[Forma]
Clave=RM0407ProdPedidosxSuperFrm
Nombre=RM0407 Productividad de Pedidos por Supervisor
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=439
PosicionInicialArriba=440
PosicionInicialAlturaCliente=110
PosicionInicialAncho=402
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Info.AgenteA ,Nulo)<BR>Asigna(Info.AgenteD,Nulo)<BR>Asigna(Info.FechaA,Nulo)<BR>Asigna(Info.FechaD,Nulo)
ListaAcciones=Preliminar<BR>Cerrar
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
FichaEspacioNombres=34
FichaColorFondo=Plata
ListaEnCaptura=Info.AgenteD<BR>Info.AgenteA<BR>Info.FechaD<BR>Info.FechaA
FichaNombres=Arriba
FichaEspacioNombresAuto=S
PermiteEditar=S
PestanaNombre=Hola
[(Variables).Info.AgenteA]
Carpeta=(Variables)
Clave=Info.AgenteA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Info.AgenteD]
Carpeta=(Variables)
Clave=Info.AgenteD
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
Efectos=[Negritas]
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
Efectos=[Negritas]
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Info.AgenteD) y ConDatos(Info.AgenteA) y ConDatos(Info.FechaD) y ConDatos(Info.FechaA)
EjecucionMensaje=<T>Hace Falta capturar un campo<T>
EjecucionConError=S
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
Visible=S
EjecucionConError=S
EjecucionCondicion=/*ConDatos(Info.AgenteD) y ConDatos(Info.AgenteA) y ConDatos(Info.FechaD) y ConDatos(Info.FechaA)*/<BR>(((Info.AgenteD)<=(Info.AgenteA))o (vacio(Info.AgenteD)y vacio(Info.AgenteA)) o (condatos(info.AgenteD) y vacio(info.AgenteA)))y<BR>(((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa)))
EjecucionMensaje=/*<T>Hace Falta Capturar un Campo<T>*/<BR><BR>Si  ((condatos(Info.AgenteD) y condatos(Info.AgenteA))y ((Info.AgenteA)<(Info.AgenteD))) ENTONCES <T>El No. de Agente Final debe ser Mayor o Igual que el Inicial<T> sino<BR>Si  ((condatos(Info.FechaD) y condatos(Info.FechaA))y ((Info.FechaA)<(Info.FechaD))) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>


