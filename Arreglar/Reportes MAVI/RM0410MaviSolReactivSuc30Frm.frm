[Forma]
Clave=RM0410MaviSolReactivSuc30Frm
Nombre=RM0410 Solicitudes Reactivadas. Sucursal 30
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=450
PosicionInicialArriba=459
PosicionInicialAlturaCliente=71
PosicionInicialAncho=380
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Cerrar
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Mavi.FechaEmision,Hoy)<BR>Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)
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
FichaEspacioEntreLineas=14
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaColorFondo=Plata
FichaNombres=Arriba
FichaAlineacion=Centrado
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
FichaAlineacionDerecha=S
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
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
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
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
Visible=S
ConCondicion=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (vacio(Info.FechaD)y vacio(Info.FechaA)) o (condatos(info.fechad) y vacio(info.fechaa))   
EjecucionMensaje=Si  ((Info.FechaA)<(Info.FechaD)) ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>     
EjecucionConError=S


