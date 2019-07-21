
[Forma]
Clave=RM0188AVtasMayoreoClienteFrm
Icono=124
Modulos=(Todos)
Nombre=Reporte Ventas Mayoreo por Cliente

ListaCarpetas=RM0188AVtasMayoreoCliente
CarpetaPrincipal=RM0188AVtasMayoreoCliente
PosicionInicialIzquierda=360
PosicionInicialArriba=67
PosicionInicialAlturaCliente=98
PosicionInicialAncho=556
CarpetasMultilinea=S
MovModulo=(Todos)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Imprimir<BR>Cerrar



VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=//Asigna(Info.FechaA, NULO)<BR>//Asigna(Info.FechaD, NULO)
[Acciones.Imprimir]
Nombre=Imprimir
Boton=68
NombreEnBoton=S
NombreDesplegar=&Imprimir
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

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

[Acciones.Imprimir.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Imprimir.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0188AVtasMayoreoClienteFrmRepTxt
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(info.FechaA)<BR>ConDatos(info.FechaD)
EjecucionMensaje=<T>Ingrese las fecha para generar el reporte<T>
[RM0188AVtasMayoreoCliente]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Rango de Fechas para Reporte
Clave=RM0188AVtasMayoreoCliente
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.FechaD<BR>Info.FechaA
CarpetaVisible=S

[RM0188AVtasMayoreoCliente.Info.FechaD]
Carpeta=RM0188AVtasMayoreoCliente
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=23
ColorFondo=Blanco
Efectos=[Negritas]

[RM0188AVtasMayoreoCliente.Info.FechaA]
Carpeta=RM0188AVtasMayoreoCliente
Clave=Info.FechaA
Editar=S
ValidaNombre=S
3D=S
Tamano=23
ColorFondo=Blanco
Efectos=[Negritas]




