
[Forma]
Clave=DM0221CREDIDVBloqueoBFFrm
Icono=0
Modulos=(Todos)
Nombre=DV Bloqueo BF

ListaCarpetas=HOJA
CarpetaPrincipal=HOJA
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guarda<BR>Cancelar
PosicionInicialAlturaCliente=90
PosicionInicialAncho=258
PosicionInicialIzquierda=405
PosicionInicialArriba=94
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[HOJA]
Estilo=Hoja
Clave=HOJA
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0221CREDIDVBloqueoBFVis
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=TablaNumD.Numero<BR>TablaNumD.Valor
CarpetaVisible=S

PermiteEditar=S


HojaTitulosEnBold=S
[Acciones.Guarda]
Nombre=Guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Guardar<BR>Actualizar
[Acciones.Guarda.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guarda.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[HOJA.Columnas]
PeriodoDV=64
MaxDV=64

Numero=78
Valor=64
[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cancelar Cambios
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cance<BR>aceptar
[Acciones.Cancelar.Cance]
Nombre=Cance
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar.aceptar]
Nombre=aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[HOJA.TablaNumD.Numero]
Carpeta=HOJA
Clave=TablaNumD.Numero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[HOJA.TablaNumD.Valor]
Carpeta=HOJA
Clave=TablaNumD.Valor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

