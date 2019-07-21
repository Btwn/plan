[Forma]
Clave=MaviInvFactXClienteFrm
Nombre=Inventario de Facturas x Cliente
Icono=407
Modulos=(Todos)
ListaCarpetas=variable
CarpetaPrincipal=variable
PosicionInicialIzquierda=484
PosicionInicialArriba=451
PosicionInicialAlturaCliente=92
PosicionInicialAncho=325
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna( Info.Cliente, <T><T> )
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>& Usuario
[variable]
Estilo=Ficha
Clave=variable
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
ListaEnCaptura=Info.Cliente
PermiteEditar=S
FichaNombres=Izquierda
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S
FichaAlineacion=Izquierda
[variable.Info.Cliente]
Carpeta=variable
Clave=Info.Cliente
Editar=S
LineaNueva=S
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
EnBarraHerramientas=S
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Variables Asignar / Ventana Aceptar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
ClaveAccion=Cerrar


