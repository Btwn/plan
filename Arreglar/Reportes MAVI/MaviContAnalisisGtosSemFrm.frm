[Forma]
Clave=MaviContAnalisisGtosSemFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=449
PosicionInicialArriba=408
PosicionInicialAltura=409
PosicionInicialAncho=381
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
AccionesTamanoBoton=25x5
AccionesCentro=S
ListaAcciones=RepPan<BR>Cerrar
AccionesDivision=S
Nombre=RM768 Análisis de Gastos
BarraHerramientas=S
VentanaEscCerrar=S
PosicionInicialAlturaCliente=174
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.Ejercicio, EjercicioTrabajo)<BR>si (Mavi.Semestre=<T>1 SEMESTRE<T>)<BR>entonces<BR>    Asigna(Info.PeriodoD, 1);<BR>    Asigna(Info.PeriodoA, 6)<BR>sino<BR>    Asigna(Info.PeriodoD, 7);<BR>    Asigna(Info.PeriodoA, 12)<BR>fin<BR>Asigna(Info.ConMovimientos, <T>No<T>)<BR>Asigna(Info.CtaNivel, TipoMayor)<BR>Asigna(Info.CuentaD, SQL(<T>SELECT MIN(Cuenta) FROM Cta WHERE Tipo<>:tTipo<T>, TipoEstructura))<BR>Asigna(Info.CuentaA, SQL(<T>SELECT MAX(Cuenta) FROM Cta WHERE Tipo<>:tTipo<T>, TipoEstructura))<BR>Asigna(Info.CentroCostos,e(<T>(Todos)<T>))<BR>Asigna(Info.CtaCat, e(<T>(Todos)<T>))<BR>Asigna(Info.CtaGrupo, e(<T>(Todos)<T>))<BR>Asigna(Info.CtaFam, e(<T>(Todos)<T>))<BR>Asigna(Rep.Sucursal, Nulo)<BR>Asigna(Info.ContMoneda, Config.ContMoneda)<BR>Asigna(Info.Controladora, Nulo)

[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={MS Sans Serif, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=8
FichaEspacioNombres=75
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaColorFondo=Plata
FichaAlineacion=Izquierda
ListaEnCaptura=Info.Ejercicio<BR>Mavi.Semestre<BR>Info.CtaNivel<BR>Info.CuentaD<BR>Info.CuentaA<BR>Info.CentroCostos<BR>Info.ContMoneda
PermiteEditar=S

[(Variables).Info.Ejercicio]
Carpeta=(Variables)
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.RepPan]
Nombre=RepPan
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Asignar<BR>MaviContAnalisisGtosSem
Activo=S
Visible=S
NombreEnBoton=S
EnBarraHerramientas=S




[Acciones.Imprimir.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Imprimir.ContBalanza]
Nombre=ContBalanza
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=ContBalanza
Activo=S
Visible=S


[Acciones.RepPan.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[(Variables).Info.CtaNivel]
Carpeta=(Variables)
Clave=Info.CtaNivel
Editar=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EspacioPrevio=S

[(Variables).Info.CuentaD]
Carpeta=(Variables)
Clave=Info.CuentaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[(Variables).Info.CuentaA]
Carpeta=(Variables)
Clave=Info.CuentaA
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[(Variables).Info.CentroCostos]
Carpeta=(Variables)
Clave=Info.CentroCostos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro





[Acciones.RepPan.MaviContAnalisisGtosSem]
Nombre=MaviContAnalisisGtosSem
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=(((Info.CuentaD)<=(Info.CuentaA))o (vacio(Info.CuentaD)y vacio(Info.CuentaA)) o (condatos(info.CuentaD) y vacio(info.CuentaA)))<BR>y ((condatos(info.ejercicio))  y (condatos(mavi.semestre)) /*y (condatos(mavi.ctanivel)))
EjecucionMensaje=Si  ((condatos(Info.CuentaD) y condatos(Info.CuentaA))y ((Info.CuentaA)<(Info.CuentaD))) ENTONCES <T>El No. de Cuenta Final debe ser Mayor o Igual que la Inicial<T> sino<BR>si (vacio(info.ejercicio)) entonces <T>Seleccionar el Año del Ejercicio<T> sino<BR>si (vacio(mavi.semestre)) entonces <T>Seleccionar el Semestre del Ejercicio<T> sino<BR>si (vacio(info.ctanivel)) entonces <T>Seleccionar el Nivel del Ejercicio<T>
[(Variables).Mavi.Semestre]
Carpeta=(Variables)
Clave=Mavi.Semestre
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.ContMoneda]
Carpeta=(Variables)
Clave=Info.ContMoneda
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
