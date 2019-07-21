
[Forma]
Clave=DM0321ReporteSegComprasFrm
Icono=375
Modulos=(Todos)
Nombre=Reporte - Venta Seguros (Compras)

ListaCarpetas=Filtros
CarpetaPrincipal=Filtros
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=516
PosicionInicialArriba=324
PosicionInicialAlturaCliente=81
PosicionInicialAncho=334
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar<BR>Cerrar
ExpresionesAlMostrar=Asigna(info.FechaD,NULO)<BR>Asigna(info.FechaA,NULO)
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
FichaAlineacion=Izquierda
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
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Generar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Generar]
Nombre=Generar
Boton=54
NombreEnBoton=S
NombreDesplegar=&Generar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Reporte
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Generar.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0321ReporteSegComprasRepTxt
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Si<BR>    ConDatos(Info.FechaD) y ConDatos(Info.FechaA)<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>Los filtros de fechas son obligatorios<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si<BR>    Info.FechaD > Info.FechaA<BR>Entonces<BR>    Error(<T>Rango de fechas no valido<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Verdadero<BR>Fin

