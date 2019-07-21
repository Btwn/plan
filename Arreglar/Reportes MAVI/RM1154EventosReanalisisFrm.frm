
[Forma]
Clave=RM1154EventosReanalisisFrm
Icono=17
Modulos=(Todos)


ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=175
PosicionInicialAncho=415
Nombre=Configuracion de Eventos de Re Analisis
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Eliminar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=432
PosicionInicialArriba=405
VentanaBloquearAjuste=S
[Vista]
Estilo=Hoja
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM1154EventosReanalisisVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=RM1154EventosReanalisisTbl.Valor<BR>RM1154EventosReanalisisTbl.Nombre
CarpetaVisible=S

PermiteEditar=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General

FiltroGeneral=RM1154EventosReanalisisTbl.TablaSt = <T>EVENTOS REANALISIS<T>
[Vista.RM1154EventosReanalisisTbl.Nombre]
Carpeta=Vista
Clave=RM1154EventosReanalisisTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco


[Vista.Columnas]
TablaSt=193
Nombre=194
Valor=178

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Registro<BR>Guardar<BR>Actualiza
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Guardar.Registro]
Nombre=Registro
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S

[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Vista.RM1154EventosReanalisisTbl.Valor]
Carpeta=Vista
Clave=RM1154EventosReanalisisTbl.Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=250
ColorFondo=Blanco

