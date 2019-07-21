[Forma]
Clave=MaviContAnalisGtosFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
Nombre=RM768 Analisis de Gastos
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
PosicionInicialIzquierda=356
PosicionInicialArriba=284
PosicionInicialAltura=230
PosicionInicialAncho=311
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Cerrar<BR>Preliminar
PosicionInicialAlturaCliente=165
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.Ejercicio,  EjercicioTrabajo)<BR>Asigna(Info.CtaNivel, TipoMayor)<BR>Asigna(Info.CuentaD,  SQL( <T>SELECT MIN(Cuenta) FROM Cta WHERE Tipo<>:tTipo<T>, TipoEstructura ) )<BR>Asigna(Info.CuentaA,  SQL( <T>SELECT MAX(Cuenta) FROM Cta WHERE Tipo<>:tTipo<T>, TipoEstructura ) )<BR>Asigna(Info.CentroCostos, e(<T>(Todos)<T>))<BR>Asigna(Info.ContMoneda, Config.ContMoneda)

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
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Info.CtaNivel<BR>Info.CuentaD<BR>Info.CuentaA<BR>Info.CentroCostos<BR>Info.ContMoneda
CarpetaVisible=S

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

[(Variables).Info.CtaNivel]
Carpeta=(Variables)
Clave=Info.CtaNivel
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.CuentaD]
Carpeta=(Variables)
Clave=Info.CuentaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.CuentaA]
Carpeta=(Variables)
Clave=Info.CuentaA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.CentroCostos]
Carpeta=(Variables)
Clave=Info.CentroCostos
Editar=S
LineaNueva=S
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

[Acciones.Preliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Variables Asignar<BR>Preeliminar
Activo=S
Visible=S



[(Variables).Info.ContMoneda]
Carpeta=(Variables)
Clave=Info.ContMoneda
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Preeliminar]
Nombre=Preeliminar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
