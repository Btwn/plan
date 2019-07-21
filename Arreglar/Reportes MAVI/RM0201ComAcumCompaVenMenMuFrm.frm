[Forma]
Clave=RM0201ComAcumCompaVenMenMuFrm
Nombre=RM201 Acumulado Comparativo Venta Mensual Muebles
Icono=117
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=136
PosicionInicialAncho=444
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=418
PosicionInicialArriba=427
VentanaBloquearAjuste=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna( Info.Ejercicio, Nulo)<BR>Asigna(Info.Periodo, Nulo)<BR>Asigna(Mavi.RM0201FamiliasVentaRutas, Nulo)
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
PermiteEditar=S
FichaEspacioEntreLineas=21
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaEspacioNombresAuto=S
ListaEnCaptura=Info.Ejercicio<BR>Info.Periodo<BR>Mavi.RM0201FamiliasVentaRutas
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
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=ventana
Activo=S
Visible=S
ClaveAccion=Cerrar
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=16
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=controles Captura
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
EjecucionCondicion=ConDatos(Info.Ejercicio) y ConDatos(Info.Periodo) y ConDatos(Mavi.RM0201FamiliasVentaRutas)
EjecucionMensaje=Si (Vacio(Info.Ejercicio)) Entonces <T>Seleccione un Ejercicio<T> SiNo<BR>Si (Vacio(Info.Periodo)) Entonces <T>Seleccione un Periodo<T> SiNo<BR>Si (Vacio(Mavi.RM0201FamiliasVentaRutas)) Entonces <T>Seleccione una Familia<T>
[(Variables).Mavi.RM0201FamiliasVentaRutas]
Carpeta=(Variables)
Clave=Mavi.RM0201FamiliasVentaRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=16
ColorFondo=Blanco
ColorFuente=Negro


