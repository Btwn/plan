[Forma]
Clave=RM1108RephuellasSIDxcobroSucFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=145
PosicionInicialAncho=415
ListaAcciones=Preli<BR>PreliAnt<BR>PreliAct<BR>cerrar
Nombre=RM1108 Reporte Huellas SID Cobro X Sucursal
PosicionInicialIzquierda=545
PosicionInicialArriba=211
VentanaExclusiva=S
VentanaExclusivaOpcion=3
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
ListaEnCaptura=Info.Ejercicio<BR>Mavi.Quincena<BR>Mavi.RM1108Sucursales<BR>Mavi.RM1108TipoReporte
PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
CondicionVisible=SQL(<T>Select Acceso From Usuario Where Usuario=:tUsr<T>, Usuario ) noen (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>,<T>VENTP_LIMA<T>,<T>VENTP_USRA<T>)
[(Variables).Mavi.Quincena]
Carpeta=(Variables)
Clave=Mavi.Quincena
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[(Variables).Mavi.RM1108Sucursales]
Carpeta=(Variables)
Clave=Mavi.RM1108Sucursales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preli]
Nombre=Preli
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
Visible=S
Multiple=S
ListaAccionesMultiples=asign<BR>rep
ActivoCondicion=SQL(<T>Select Acceso From Usuario Where Usuario=:tUsr<T>, Usuario ) noen (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>,<T>VENTP_LIMA<T>,<T>VENTP_USRA<T>)
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.RM1108TipoReporte]
Carpeta=(Variables)
Clave=Mavi.RM1108TipoReporte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preli.asign]
Nombre=asign
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preli.rep]
Nombre=rep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dato,<T>NO<T>)<BR>Si<BR>  (ConDatos(Info.Ejercicio)) y (ConDatos(Mavi.Quincena)) y (ConDatos(Mavi.RM1108TipoReporte))<BR>Entonces<BR>    Caso  Mavi.RM1108TipoReporte<BR>  Es <T>DETALLE<T> Entonces  ReportePantalla(<T>RM1108RepHuellasSIDXCobSucDRep<T>)<BR>  Es <T>RESUMEN<T> Entonces  ReportePantalla(<T>RM1108RepHuellasSIDXCobSucRRep<T>)<BR>Fin<BR>Sino<BR>  Error(<T>Debe Seleccionar Ejercicio, Periodo y Tipo de Reporte<T>)<BR>Fin
[Acciones.PreliAnt.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dato,<T>ANT<T>)<BR>Asigna(Mavi.RM1108Sucursales, Sucursal)<BR>Asigna(Info.Ejercicio,  Año(Ahora ))<BR>Asigna(Mavi.Quincena,0)<BR>ReportePantalla(<T>RM1108RepHuellasSIDXCobSucRRep<T>)
[Acciones.PreliAnt]
Nombre=PreliAnt
Boton=6
NombreEnBoton=S
NombreDesplegar=Periodo Anterior
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=exp
Visible=S
ActivoCondicion=SQL(<T>Select Acceso From Usuario Where Usuario=:tUsr<T>, Usuario ) en (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>,<T>VENTP_LIMA<T>,<T>VENTP_USRA<T>)
[Acciones.PreliAct]
Nombre=PreliAct
Boton=6
NombreEnBoton=S
NombreDesplegar=Periodo Actual
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
Expresion=Asigna(Info.Dato,<T>ACT<T>)<BR>Asigna(Mavi.RM1108Sucursales, Sucursal)<BR>Asigna(Info.Ejercicio,  Año(Ahora ))<BR>Asigna(Mavi.Quincena,0)<BR>ReportePantalla(<T>RM1108RepHuellasSIDXCobSucRRep<T>)
ActivoCondicion=SQL(<T>Select Acceso From Usuario Where Usuario=:tUsr<T>, Usuario ) en (<T>VENTP_GERA<T>,<T>VENTP_USRB<T>,<T>VENTP_LIMA<T>,<T>VENTP_USRA<T>)

