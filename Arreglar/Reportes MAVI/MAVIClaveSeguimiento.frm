;Ultima Modificacion 12 Nov 09 ALQG. Se agrego la accion de localizar.

;Ultima Modificacion 28/07/08 - Leticia Quezada
;Se agrego el campo de grupo

[Forma]
Clave=MAVIClaveSeguimiento
Nombre=MAVIClaveSeguimiento
Icono=0
Modulos=(Todos)
ListaCarpetas=MAVIClaveSeguimiento
CarpetaPrincipal=MAVIClaveSeguimiento
PosicionInicialIzquierda=116
PosicionInicialArriba=133
PosicionInicialAlturaCliente=366
PosicionInicialAncho=1039
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Localizar

[MAVIClaveSeguimiento]
Estilo=Hoja
Clave=MAVIClaveSeguimiento
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MAVIClaveSeguimiento
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVIClaveSeguimiento.Clave<BR>MAVIClaveSeguimiento.Descripcion<BR>MAVIClaveSeguimiento.Modulo<BR>MAVIClaveSeguimiento.Grupo<BR>MAVIClaveSeguimiento.Tipo<BR>MAVIClaveSeguimiento.Situacion<BR>MAVIClaveSeguimiento.Rescate
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Clave]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Clave
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Descripcion]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Modulo]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Modulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Grupo]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[MAVIClaveSeguimiento.Columnas]
Clave=64
Descripcion=463
Modulo=57
Grupo=85
Tipo=49
Situacion=212

Rescate=64
[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Tipo]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco

[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y Cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Acciones.Localizar]
Nombre=Localizar
Boton=73
NombreEnBoton=S
NombreDesplegar=&Localizar
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Situacion]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Situacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[MAVIClaveSeguimiento.MAVIClaveSeguimiento.Rescate]
Carpeta=MAVIClaveSeguimiento
Clave=MAVIClaveSeguimiento.Rescate
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
