[Forma]
Clave=RM0071AMaviProgServPrevFrm
Nombre=Programa de Servicios Preventivos
Icono=158
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=473
PosicionInicialArriba=367
PosicionInicialAlturaCliente=195
PosicionInicialAncho=334
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
Comentarios=FechaEnTexto(Hoy,<T>dd-mmm-aaaa<T>)&<T> - <T>&Usuario
ExpresionesAlMostrar=Asigna(Mavi.RM0071AListaActivoFijo, nulo)<BR>Asigna(Mavi.RM0071AFEstatusMAVI, nulo)<BR>Asigna(Info.AFMovMAVI, nulo)<BR>Asigna(Mavi.RM0071AProv, nulo)<BR>Asigna(Info.Articulo, nulo)                <BR>Asigna(Info.AFFechaEnvio, nulo)<BR>Asigna(Info.AFFechaRecepcion, nulo)
[Acciones.Cancelar]
Nombre=Cancelar
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
[(Variables)]
Estilo=Ficha
Clave=(Variables)
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0071AListaActivoFijo<BR>Info.AFMovMAVI<BR>Mavi.RM0071AProv<BR>Mavi.RM0071AFEstatusMAVI<BR>Info.AFFechaEnvio<BR>Info.AFFechaRecepcion
CarpetaVisible=S
[(Variables).Info.AFMovMAVI]
Carpeta=(Variables)
Clave=Info.AFMovMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.AFFechaEnvio]
Carpeta=(Variables)
Clave=Info.AFFechaEnvio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.AFFechaRecepcion]
Carpeta=(Variables)
Clave=Info.AFFechaRecepcion
Editar=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0071AListaActivoFijo]
Carpeta=(Variables)
Clave=Mavi.RM0071AListaActivoFijo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0071AProv]
Carpeta=(Variables)
Clave=Mavi.RM0071AProv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0071AFEstatusMAVI]
Carpeta=(Variables)
Clave=Mavi.RM0071AFEstatusMAVI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro

