[Forma]
Clave=MaviGerAdmRelDoctosCajaChicaFrm
Nombre=RM262 Relación de Documentos de Caja Chica
Icono=700
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=Preliminar<BR>Cerrar
PosicionInicialIzquierda=430
PosicionInicialArriba=440
PosicionInicialAlturaCliente=115
PosicionInicialAncho=424
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)<BR>Asigna(Mavi.ClaveGtoCajaChica,nulo)
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
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
ListaEnCaptura=Mavi.ClaveGtoCajaChica<BR>Info.FechaD<BR>Info.FechaA
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=250
FichaColorFondo=Blanco
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S
[(Variables).Mavi.ClaveGtoCajaChica]
Carpeta=(Variables)
Clave=Mavi.ClaveGtoCajaChica
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
EjecucionCondicion=((Info.FechaD)<=(Info.FechaA))o (Vacio(Info.FechaD) y Vacio(Info.FechaA)) o (ConDatos(Info.FechaD) y Vacio(Info.FechaA))
EjecucionMensaje=<T>Valide Rangos de Fechas<T>
EjecucionConError=S

