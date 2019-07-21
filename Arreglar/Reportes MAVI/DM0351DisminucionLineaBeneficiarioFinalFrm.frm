
[Forma]
Clave=DM0351DisminucionLineaBeneficiarioFinalFrm
Icono=134
Modulos=(Todos)
Nombre=Disminucion de linea de beneficiario final

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=122
PosicionInicialAncho=408
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=479
PosicionInicialArriba=303
BarraHerramientas=S
VentanaBloquearAjuste=S
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Aceptar.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.reporte]
Nombre=reporte
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=SI ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>ENTONCES<BR>    Verdadero<BR>SINO<BR>    Informacion(<T>Los rangos de fecha son obligatorios<T>)<BR>    AbortarOperacion<BR>FIN<BR><BR>SI (info.FechaD > info.FechaA)<BR>ENTONCES<BR>    Error(<T>Seleccione un rango de fechas valido<T>)<BR>    AbortarOperacion<BR>SINO<BR>    Verdadero<BR>FIN
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
ListaAccionesMultiples=asigna<BR>reporte
Activo=S
Visible=S
EnBarraHerramientas=S


[Acciones.cerrar]
Nombre=cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


