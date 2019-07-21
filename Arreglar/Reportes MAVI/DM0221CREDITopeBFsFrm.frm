
[Forma]
Clave=DM0221CREDITopeBFsFrm
Icono=0
BarraHerramientas=S
Modulos=(Todos)
Nombre=TOPE BF<T>S POR DIMA
AccionesTamanoBoton=15x5
AccionesDerecha=S







ListaCarpetas=Hoja
CarpetaPrincipal=Hoja
PosicionInicialIzquierda=556
PosicionInicialArriba=92
PosicionInicialAlturaCliente=78
PosicionInicialAncho=263
ListaAcciones=Guarda<BR>Cancelas
[Hoja]
Estilo=Hoja
Clave=Hoja
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0221CREDITopeBFsVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=TablaNumD.Numero
CarpetaVisible=S

HojaTitulosEnBold=S

[Hoja.TablaNumD.Numero]
Carpeta=Hoja
Clave=TablaNumD.Numero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

IgnoraFlujo=N
[Hoja.Columnas]
TablaNum=304
Numero=64

[Acciones.Guarda.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guarda.Actuliza]
Nombre=Actuliza
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Guarda]
Nombre=Guarda
Boton=3
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar<BR>Actuliza
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Cancelas]
Nombre=Cancelas
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cancelar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
