[Forma]
Clave=RM0401MaviComCrediNuevosFrm
Nombre=RM401 Comparativo de Créditos Nuevos
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=466
PosicionInicialArriba=439
PosicionInicialAlturaCliente=112
PosicionInicialAncho=347
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaEscCerrar=S
VentanaAvanzaTab=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.Fecha, Hoy ),<BR>Asigna(Mavi.Fonacot, Nulo )
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Azul
CampoColorFondo=Blanco
ListaEnCaptura=Info.Fecha<BR>Mavi.Fonacot
CarpetaVisible=S
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[(Variables).Info.Fecha]
Carpeta=(Variables)
Clave=Info.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Azul
EspacioPrevio=N
Efectos=[Negritas]
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EnMenu=S
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
EjecucionCondicion=ConDatos(Info.Fecha)  y ConDatos(Mavi.Fonacot)
EjecucionMensaje=Si  ((Vacio(Info.Fecha)) y (Vacio(Mavi.Fonacot))) ENTONCES <T>No se ha Colocado una Fecha Y un Tipo de Consulta<T> sino<BR>Si  (Vacio(Info.Fecha)) y (ConDATOS(Mavi.Fonacot)) ENTONCES <T>No se ha Colocado una Fecha<T>  Sino<BR>Si  (Condatos(Info.Fecha)) y (Vacio(Mavi.Fonacot)) ENTONCES <T>No se ha Seleccionado un Tipo de Consulta<T>
[(Variables).Mavi.Fonacot]
Carpeta=(Variables)
Clave=Mavi.Fonacot
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Azul
Efectos=[Negritas]


