[Forma]
Clave=MaviServicasaServicredCredRepsFrm
Nombre=Reporte
Icono=48
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=464
PosicionInicialArriba=383
PosicionInicialAlturaCliente=196
PosicionInicialAncho=318
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=GenerarTXT<BR>Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)<BR>Asigna(Mavi.ServicasaGrupoCalificacion,nulo)<BR>Asigna(Info.FechaInicio,nulo)<BR>Asigna(Info.FechaCorte,nulo)<BR>Asigna(Info.Estatus,nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.ServicasaGrupoCalificacion<BR>Info.FechaInicio<BR>Info.FechaCorte<BR>Mavi.RM0430ServicasaEstatus
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.FechaD]
Carpeta=(Variables)
Clave=Info.FechaD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaCorte]
Carpeta=(Variables)
Clave=Info.FechaCorte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.ServicasaGrupoCalificacion]
Carpeta=(Variables)
Clave=Mavi.ServicasaGrupoCalificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Info.FechaInicio]
Carpeta=(Variables)
Clave=Info.FechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
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
[(Variables).Mavi.RM0430ServicasaEstatus]
Carpeta=(Variables)
Clave=Mavi.RM0430ServicasaEstatus
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
Editar=S

[ListaGrupos.Columnas]
Grupo=179

[Acciones.GenerarTXT]
Nombre=GenerarTXT
Boton=54
NombreEnBoton=S
NombreDesplegar=&GenerarTXT
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Reporte
[Acciones.GenerarTXT.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarTXT.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=MaviServicredCredReporteServicredRepTxt
Activo=S
Visible=S


