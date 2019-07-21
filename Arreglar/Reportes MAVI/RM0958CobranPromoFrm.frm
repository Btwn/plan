[Forma]
Clave=RM0958CobranPromoFrm
Nombre=RM0958 Cobranza Promotores
Icono=145
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=492
PosicionInicialArriba=433
PosicionInicialAlturaCliente=123
PosicionInicialAncho=295
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Espacio
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM0958AgenteCobCampo,Nulo)<BR>Asigna(Info.Ejercicio,Nulo)<BR>Asigna(Mavi.RM0958QuincenaCobranza,Nulo)
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
FichaEspacioEntreLineas=7
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.Ejercicio<BR>Mavi.RM0958QuincenaCobranza<BR>Mavi.RM0958AgenteCobCampo
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
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
EjecucionCondicion=Condatos(Mavi.RM0958QuincenaCobranza) y Condatos(Info.Ejercicio)
EjecucionMensaje=<T>Los Campos  Ejercicio y Quincena Cobranza son Obligatorios<T>
[Acciones.Espacio]
Nombre=Espacio
Boton=0
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
[(Variables).Mavi.RM0958QuincenaCobranza]
Carpeta=(Variables)
Clave=Mavi.RM0958QuincenaCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0958AgenteCobCampo]
Carpeta=(Variables)
Clave=Mavi.RM0958AgenteCobCampo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


