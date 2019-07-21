[Forma]
Clave=RM0430MaviServicasaCredReporteServicasaFrm
Nombre=RM0430 Reporte Servicasa
Icono=48
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=521
PosicionInicialArriba=271
PosicionInicialAlturaCliente=188
PosicionInicialAncho=324
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=GenerarTXT<BR>Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Info.FechaD,nulo)<BR>Asigna(Info.FechaA,nulo)<BR>Asigna(Mavi.RM0430ServicasaGrupoCalificacion,nulo)<BR>Asigna(Info.FechaInicio,nulo)<BR>Asigna(Info.FechaCorte,nulo)<BR>Asigna(Info.Estatus,nulo)
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
ListaEnCaptura=Info.FechaD<BR>Info.FechaA<BR>Mavi.RM0430ServicasaGrupoCalificacion<BR>Info.FechaInicio<BR>Info.FechaCorte<BR>Mavi.RM0430ServicasaEstatus
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
ColorFuente=Negro
[(Variables).Info.FechaA]
Carpeta=(Variables)
Clave=Info.FechaA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaCorte]
Carpeta=(Variables)
Clave=Info.FechaCorte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.FechaInicio]
Carpeta=(Variables)
Clave=Info.FechaInicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
ConCondicion=S
EjecucionConError=S
GuardarAntes=S
EspacioPrevio=S
EjecucionCondicion=(((Info.FechaD) <= (Info.FechaA)) o ((Vacio(Info.FechaD)) y<BR>(Vacio(Info.FechaA))) o ((ConDatos(info.fechaD)) y<BR>(Vacio(info.fechaA)))) y<BR>(((Info.FechaInicio) <= (Info.FechaCorte )) o<BR>((Vacio(Info.FechaInicio)) y (Vacio(Info.FechaCorte))) o<BR>((ConDatos(Info.FechaInicio)) y<BR>(Vacio(Info.FechaCorte))))
EjecucionMensaje=Si  (((Info.FechaA)<(Info.FechaD)) o<BR>((Info.FechaCorte)<(Info.FechaInicio)))<BR>ENTONCES <T>La Fecha Final debe ser Mayor o Igual que la Inicial<T>
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
EspacioPrevio=S
[(Variables).Mavi.RM0430ServicasaGrupoCalificacion]
Carpeta=(Variables)
Clave=Mavi.RM0430ServicasaGrupoCalificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.RM0430ServicasaEstatus]
Carpeta=(Variables)
Clave=Mavi.RM0430ServicasaEstatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.GenerarTXT]
Nombre=GenerarTXT
Boton=54
NombreEnBoton=S
NombreDesplegar=&Generar TXT
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0430MaviServicasaCredReporteServicasaRepTxt
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Variables Asignar<BR>Rep
[Acciones.GenerarTXT.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.GenerarTXT.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0430MaviServicasaCredReporteServicasaRepTxt
Activo=S
Visible=S


