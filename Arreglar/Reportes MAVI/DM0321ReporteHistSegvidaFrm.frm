
[Forma]
Clave=DM0321ReporteHistSegvidaFrm
Icono=0
CarpetaPrincipal=Filtros
Modulos=(Todos)
Nombre=Reporte Histórico Seguros de Vida
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Generar<BR>Cerrar
ListaCarpetas=Filtros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaBloquearAjuste=S
PosicionInicialIzquierda=494
PosicionInicialArriba=250
PosicionInicialAlturaCliente=134
PosicionInicialAncho=368
ExpresionesAlMostrar=Asigna(info.FechaD,NULO)Asigna(info.FechaA,NULO)
[Acciones.Generar]
Nombre=Generar
Boton=55
NombreEnBoton=S
NombreDesplegar=&Generar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Asignar<BR>Reporte
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[Acciones.Generar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Generar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
Activo=S
Visible=S

ClaveAccion=DM0321RepHisSegvidaRepTxt
ConCondicion=S
EjecucionCondicion=Si<BR>  vacio(Info.FechaD) o  vacio(Info.FechaA)<BR>Entonces<BR>  Informacion(<T>Favor de Ingresar Filtros<T>)<BR>  AbortarOperacion<BR>Sino<BR>    Si<BR>      Condatos(Info.FechaA) y Condatos(Info.FechaD) y  Info.FechaA<Info.FechaD<BR>    Entonces<BR>       Informacion(<T>Rango Invalido<T>)<BR>       AbortarOperacion<BR>    Sino<BR>      Verdadero<BR>    Fin<BR>Fin
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
FichaNombres=Arriba
FichaAlineacion=Centrado
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[Filtros.Info.FechaD]
Carpeta=Filtros
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Filtros.Info.FechaA]
Carpeta=Filtros
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Ejemplo Reporte.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Ejemplo Reporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=Ejemplo0321
Activo=S
Visible=S

[Acciones.Ejemplo Reporte.impresion]
Nombre=impresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(Info.FechaD <T><T>Info.FechaA)
Activo=S
Visible=S


[Acciones.Prueba.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Prueba.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Info.FechaD=nulo<BR>Entonces<BR>  Informacion(<T>Esta madre va vacia<T>)<BR>Sino<BR> Informacion( Info.FechaD)<BR>Fin



