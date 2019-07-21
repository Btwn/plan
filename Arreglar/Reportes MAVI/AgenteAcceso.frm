[Forma]
Clave=AgenteAcceso
Icono=0
Modulos=(Todos)
Nombre=Acceso Especifico
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
Comentarios=Lista(Info.Agente, Info.Nombre)
PosicionInicialIzquierda=411
PosicionInicialArriba=202
PosicionInicialAlturaProveedor=361
PosicionInicialAncho=457
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
PosicionInicialAlturaCliente=360

[Lista]
Estilo=Hoja
Clave=Lista
Filtros=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=AgenteAcceso
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
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
CarpetaVisible=S
ListaEnCaptura=AgenteAcceso.Usuario<BR>Usuario.Nombre
FiltroGeneral=AgenteAcceso.Agente=<T>{Info.Agente}<T>



[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[Lista.Columnas]
Usuario=101
Nombre=326
[Lista.AgenteAcceso.Usuario]
Carpeta=Lista
Clave=AgenteAcceso.Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Usuario.Nombre]
Carpeta=Lista
Clave=Usuario.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
