
[Forma]
Clave=RM0195ClasificacionPlazosFrm
Icono=729
Modulos=(Todos)

ListaCarpetas=Vista
CarpetaPrincipal=Vista
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=552
PosicionInicialArriba=267
PosicionInicialAlturaCliente=196
PosicionInicialAncho=262
Nombre=Clasificación de Plazos
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetasMultilinea=S
ListaAcciones=Guardar<BR>Salir
VentanaSinIconosMarco=S
ExpresionesAlMostrar=EjecutarSQL(<T>EXEC SPCOMSAutoConfiguracionPlazos<T>)
[Vista]
Estilo=Hoja
Clave=Vista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0195ClasificacionPlazosVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM0195ClasificacionPlazosTbl.Plazos<BR>RM0195ClasificacionPlazosTbl.Clasificacion
CarpetaVisible=S

[Vista.RM0195ClasificacionPlazosTbl.Plazos]
Carpeta=Vista
Clave=RM0195ClasificacionPlazosTbl.Plazos
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Vista.RM0195ClasificacionPlazosTbl.Clasificacion]
Carpeta=Vista
Clave=RM0195ClasificacionPlazosTbl.Clasificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Vista.Columnas]
Plazos=131
Clasificacion=92

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Guardar Cambios
[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=&Salir
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si<BR>    SQL(<T>SELECT COUNT(*) FROM COMSCClasificacionPlazos WHERE Clasificacion IS NULL OR Clasificacion = :tvacio<T>,<T><T>) > 0  <BR>Entonces<BR>    Error(<T>No se pueden dejar campos vacios<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Informacion(<T>Guardado correctamente<T>)<BR>    Verdadero<BR>Fin
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S



