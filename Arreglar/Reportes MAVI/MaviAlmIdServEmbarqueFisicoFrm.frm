[Forma]
Clave=MaviAlmIdServEmbarqueFisicoFrm
Nombre=Recepcion Servicio
Icono=631
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=89
PosicionInicialAncho=169
PosicionInicialIzquierda=22
PosicionInicialArriba=14
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.AlmIdServiciosAlmacen,nulo)<BR>Asigna(Info.Mov,nulo)
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
ListaEnCaptura=Mavi.AlmIdServiciosAlmacen
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Acciones.Aceptar.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=MaviAlmDetalleFisicoServEmbarqueFrm
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(Info.Mov=<T>Reporte Servicio<T>)
EjecucionMensaje=<T>Orden no registrada<T>
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>&Aceptar <T>
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>AsignarMov<BR>Forma<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.AsignarMov]
Nombre=AsignarMov
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mov,(Sql(<T>Select Mov from Soporte Where Id=:nval1 and Mov=:tval2<T>,Mavi.AlmIdServiciosAlmacen,<T>Reporte Servicio<T>)))
[(Variables).Mavi.AlmIdServiciosAlmacen]
Carpeta=(Variables)
Clave=Mavi.AlmIdServiciosAlmacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>Cerrar <T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


