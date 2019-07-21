[Forma]
Clave=ComisionesForaneosMayMavi
Nombre=Comisiones Foraneas Mayoreo
Icono=125
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Acep<BR>Cance
PosicionInicialIzquierda=496
PosicionInicialArriba=414
PosicionInicialAlturaCliente=161
PosicionInicialAncho=287
AccionesDivision=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
AccionesCentro=S
ExpresionesAlMostrar=/*Variables Locales*/<BR>Asigna(Info.Periodo,Nulo)<BR>Asigna(Mavi.ComiForaneaMayoreo,<T>Comisiones Foraneas Mayoreo<T>)
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
ListaEnCaptura=Mavi.ComiForaneaMayoreo<BR>Info.Periodo<BR>Info.Ano
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Info.Ano]
Carpeta=(Variables)
Clave=Info.Ano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Acep]
Nombre=Acep
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Reportes Pantalla
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Guarda<BR>Exec<BR>Rep<BR>Cerrar
[Acciones.Cance]
Nombre=Cance
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.ComiForaneaMayoreo]
Carpeta=(Variables)
Clave=Mavi.ComiForaneaMayoreo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Info.Periodo]
Carpeta=(Variables)
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Acep.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Acep.Exec]
Nombre=Exec
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSqlAnimado(<T>Exec SP_ComisionesForaneosMayMavi <T>&Info.Periodo&<T>,<T>&Info.Ano&<T>,<T>& EstacionTrabajo)
EjecucionCondicion=ConDatos(Mavi.ComiForaneaMayoreo) y ConDatos(Info.Periodo) y ConDatos(Info.Ano)
EjecucionMensaje=<T>Favor de llenar todas las variables<T>
[Acciones.Acep.Rep]
Nombre=Rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=ComisionesForaneasMayMavi
[Acciones.Acep.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


