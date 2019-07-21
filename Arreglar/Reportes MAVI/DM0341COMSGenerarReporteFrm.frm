
[Forma]
Clave=DM0341COMSGenerarReporteFrm
Icono=134
Modulos=(Todos)
Nombre=<T>Generar Reporte<T>

ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
PosicionInicialAlturaCliente=215
PosicionInicialAncho=277
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preeliminar<BR>Validar
PosicionInicialIzquierda=429
PosicionInicialArriba=314
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0341Periodo1,)<BR>Asigna(Mavi.DM0341Periodo2,)<BR>Asigna(Mavi.DM0341Periodo3,)<BR>Asigna(Mavi.DM0341Periodo4,)<BR>Asigna(Mavi.DM0341Periodo5,)<BR>Asigna(Mavi.DM0341Periodo6,)
[Filtros]
Estilo=Ficha
Clave=Filtros
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
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0341Periodo1<BR>Mavi.DM0341Periodo2<BR>Mavi.DM0341Periodo3<BR>Mavi.DM0341Periodo4<BR>Mavi.DM0341Periodo5<BR>Mavi.DM0341Periodo6
CarpetaVisible=S

[Filtros.Mavi.DM0341Periodo1]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0341Periodo2]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0341Periodo3]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo3
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0341Periodo4]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo4
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0341Periodo5]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo5
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Mavi.DM0341Periodo6]
Carpeta=Filtros
Clave=Mavi.DM0341Periodo6
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preeliminar]
Nombre=Preeliminar
Boton=51
NombreEnBoton=S
NombreDesplegar=Preeliminar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
ListaAccionesMultiples=Variables Asignar<BR>Validar
[Acciones.Preeliminar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S

Expresion=EjecutarSQLAnimado(<T>EXEC SpCOMSReporteUnificadoMacros :nP1, :nP2, :nP3, :nP4, :nP5, :nP6<T>,<BR>Mavi.DM0341Periodo1,<BR>Mavi.DM0341Periodo2,<BR>Mavi.DM0341Periodo3,<BR>Mavi.DM0341Periodo4,<BR>Mavi.DM0341Periodo5,<BR>Mavi.DM0341Periodo6)
EjecucionCondicion=Si(Vacio(Mavi.DM0341Periodo1), Informacion(<T>Asigne un valor para el campo <P1><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(Mavi.DM0341Periodo2), Informacion(<T>Asigne un valor para el campo <P2><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(Mavi.DM0341Periodo3), Informacion(<T>Asigne un valor para el campo <P3><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(Mavi.DM0341Periodo4), Informacion(<T>Asigne un valor para el campo <P4><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(Mavi.DM0341Periodo5), Informacion(<T>Asigne un valor para el campo <P5><T>) AbortarOperacion, Verdadero)<BR>Si(Vacio(Mavi.DM0341Periodo6), Informacion(<T>Asigne un valor para el campo <P6><T>) AbortarOperacion, Verdadero)<BR><BR>Si(Mavi.DM0341Periodo1 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo2 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo3 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo4 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo5 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo6 <=0 , Informacion(<T>No pueden ingresarse valores menores o iguales a cero<T>) AbortarOperacion, Verdadero)<BR><BR>Si(Mavi.DM0341Periodo2 <= Mavi.DM0341Periodo1, Informacion(<T>El valor para <P2> debe ser superior a <P1><T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo3 <= Mavi.DM0341Periodo2, Informacion(<T>El valor para <P3> debe ser superior a <P2><T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo4 <= Mavi.DM0341Periodo3, Informacion(<T>El valor para <P4> debe ser superior a <P3><T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo5 <= Mavi.DM0341Periodo4, Informacion(<T>El valor para <P5> debe ser superior a <P4><T>) AbortarOperacion, Verdadero)<BR>Si(Mavi.DM0341Periodo6 <= Mavi.DM0341Periodo5, Informacion(<T>El valor para <P6> debe ser superior a <P5><T>) AbortarOperacion, Verdadero)
[Acciones.Preeliminar.Validar]
Nombre=Validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.Accion(<T>Validar<T>)

