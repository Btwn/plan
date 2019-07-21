[Forma]
Clave=RM0845ServiciosMantosVehiculosFrm
Nombre=RM845 Servicios de Mantenimientos
Icono=631
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=456
PosicionInicialArriba=418
PosicionInicialAlturaCliente=150
PosicionInicialAncho=368
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
PosicionSec1=180
PosicionCol1=192
ExpresionesAlMostrar=Asigna(Mavi.RM0845MantoVehiculoLigSevRepara,Nulo)<BR>Asigna(Mavi.RM0845TipoManto,Nulo)<BR>Asigna(Mavi.RM0845AfinacionMotor,Nulo)
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
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Combustible.Conbustible]
Carpeta=Combustible
Clave=Conbustible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=19
ColorFondo=Blanco
ColorFuente=Negro
[Combustible.Columnas]
0=131
[Acciones.Seleccion]
Nombre=Seleccion
Boton=0
NombreDesplegar=&Seleccion
EnMenu=S
TipoAccion=Reportes Pantalla
ClaveAccion=Seleccionar Todo
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
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM0845MantoVehiculoLigSevRepara<BR>Mavi.RM0845TipoManto<BR>Mavi.RM0845AfinacionMotor
CarpetaVisible=S
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
EjecucionCondicion=condatos(Mavi.RM0845MantoVehiculoLigSevRepara)<BR><BR>//((ConDatos(Mavi.MantoVehiculoLigSevRepara)) y (Mavi.TipoManto<><T>Mantenimiento Severo<T>) y (Vacio(Mavi.AfinacionMotor))) o<BR>//((ConDatos(Mavi.MantoVehiculoLigSevRepara)) y (Mavi.TipoManto=<T>Mantenimiento Severo<T>) y (ConDatos(Mavi.AfinacionMotor)))
EjecucionMensaje=<T>Debe Proporcionar el Número de Servicio,<BR>para Poder Realizar la Consulta<T>
[(Variables).Mavi.RM0845MantoVehiculoLigSevRepara]
Carpeta=(Variables)
Clave=Mavi.RM0845MantoVehiculoLigSevRepara
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0845TipoManto]
Carpeta=(Variables)
Clave=Mavi.RM0845TipoManto
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[(Variables).Mavi.RM0845AfinacionMotor]
Carpeta=(Variables)
Clave=Mavi.RM0845AfinacionMotor
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


