[Forma]
Clave=MaviEspecificarAlmacenFrm
Nombre=RM255A Resurtido a Sucursales con Artículos Nuevos
Icono=551
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
PosicionInicialIzquierda=418
PosicionInicialArriba=452
PosicionInicialAltura=108
PosicionInicialAncho=444
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
PosicionInicialAlturaCliente=90
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesCentro=S
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
VentanaAvanzaTab=S
ExpresionesAlMostrar=Asigna(Mavi.Almacen,nulo)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=62
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.Almacen
CarpetaVisible=S


[Acciones.Aceptar]
Nombre=Aceptar
Boton=6
NombreDesplegar=&Preliminar
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Cerrar
NombreEnBoton=S
EnBarraHerramientas=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=23
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S
[(Variables).Mavi.Almacen]
Carpeta=(Variables)
Clave=Mavi.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
EjecucionCondicion=condatos(Mavi.Almacen)
EjecucionMensaje=Si (Vacio(Mavi.Almacen)) Entonces <T>Selecciona un Almacen de Venta...<T>

