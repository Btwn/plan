[Forma]
Clave=RM0202GarantiasAmpliadasComprasFrm
Nombre=RM0202 Garantias Ampliadas Compras
Icono=370
Modulos=(Todos)
PosicionInicialAlturaCliente=75
PosicionInicialAncho=355
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=462
PosicionInicialArriba=457
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,Nulo)<BR>Asigna(Info.FechaA,Nulo)
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
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
PermiteEditar=S
FichaNombres=Arriba
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=asi<BR>cer
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
[Acciones.Preliminar.asi]
Nombre=asi
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.cer]
Nombre=cer
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA)) y (condatos(info.fechad) y condatos(info.fechaa))<BR>//condatos(Info.FechaA) o condatos(Info.FechaD)
EjecucionMensaje=//Si  ((Info.FechaA)<(Info.FechaD)) ENTONCES<BR><T>La Fecha Final debe ser Mayor o Igual que la Inicial<BR>                                    o<BR>         Debe registrar un periodo de tiempo<T>


