[Forma]
Clave=RM1167CostoMonederoFrm
Nombre=RM1167CostoMonederoFrm
Icono=0
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=188
PosicionInicialArriba=116
PosicionInicialAlturaCliente=135
PosicionInicialAncho=327
AccionesTamanoBoton=15x5
AccionesDerecha=S
BarraHerramientas=S
ListaAcciones=Preliminar<BR>Desglose Ma<BR>Cancelar
MovModulo=(Todos)
ExpresionesAlMostrar=Asigna(Mavi.RM1167Periodo,  SQL(<T>select MONTH(DATEADD(MONTH, -1, GETDATE()))<T>)  )<BR>Asigna(Info.Ejercicio,   SQL(<T>Select YEAR(GETDATE())<T>) )<BR>Asigna(Mavi.RM1167Meses,  6)
[Principal]
Estilo=Ficha
Clave=Principal
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
ListaEnCaptura=Mavi.RM1167Periodo<BR>Info.Ejercicio<BR>Mavi.RM1167Meses
PermiteEditar=S
[Principal.Info.Ejercicio]
Carpeta=Principal
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Seleccionar/Aceptar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=variablesAsignar<BR>Aceptar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
[Acciones.Preliminar.variablesAsignar]
Nombre=variablesAsignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Principal.Mavi.RM1167Periodo]
Carpeta=Principal
Clave=Mavi.RM1167Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Principal.Mavi.RM1167Meses]
Carpeta=Principal
Clave=Mavi.RM1167Meses
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>    ConDatos(Mavi.RM1167Periodo) y ConDatos(Info.Ejercicio) y ConDatos(Mavi.RM1167Meses)<BR>Entonces<BR>    Si<BR>        ((Mavi.RM1167Periodo >= SQL(<T>Select Month(GETDATE())<T>) y Info.Ejercicio >= SQL(<T>Select YEAR(GETDATE())<T>)) o( Info.Ejercicio > SQL(<T>Select YEAR(GETDATE())<T>)))<BR>    Entonces<BR>        Error(<T>Periodo invalido, debe seleccional un periodo concluido.<T>)<BR>        AbortarOperacion<BR>    Fin<BR>Sino<BR>    Error(<T>Ingrese un periodo concluido<T>)<BR>    AbortarOperacion<BR>Fin

[Acciones.Desglose Ma]
Nombre=Desglose Ma
Boton=65
EnBarraHerramientas=S
TipoAccion=Ventana
Activo=S
Visible=S
EspacioPrevio=S
NombreEnBoton=S

Multiple=S
ListaAccionesMultiples=variables Asignar<BR>Llamada
NombreDesplegar=Desglose MA
[Acciones.Desglose Ma.Llamada]
Nombre=Llamada
Boton=0
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
ClaveAccion=RM1167CostoMonederoDimasPisosRep

ConCondicion=S
EjecucionCondicion=Si<BR>    ConDatos(Mavi.RM1167Periodo) y ConDatos(Info.Ejercicio) y ConDatos(Mavi.RM1167Meses)<BR>Entonces<BR>    Si<BR>        ((Mavi.RM1167Periodo >= SQL(<T>Select Month(GETDATE())<T>) y Info.Ejercicio >= SQL(<T>Select YEAR(GETDATE())<T>)) o( Info.Ejercicio > SQL(<T>Select YEAR(GETDATE())<T>)))<BR>    Entonces<BR>        Error(<T>Periodo invalido, debe seleccional un periodo concluido.<T>)<BR>        AbortarOperacion<BR>    Fin<BR>Sino<BR>    Error(<T>Ingrese un periodo concluido<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Desglose Ma.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S


