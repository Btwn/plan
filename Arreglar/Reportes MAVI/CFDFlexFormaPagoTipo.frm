[Forma]
Clave=CFDFlexFormaPagoTipo
Nombre=Tipos Formas Pagos
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>FormasPago
PosicionInicialIzquierda=585
PosicionInicialArriba=207
PosicionInicialAlturaCliente=448
PosicionInicialAncho=429
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=CFDFlexFormaPagoTipo
Fuente={Tahoma, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CFDFlexFormaPagoTipo.Tipo<BR>CFDFlexFormaPagoTipo.SobrePrecio
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S

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
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Asigna(Temp.Texto, ListaBuscarDuplicados(CampoEnLista(FormaPagoTipo:FormaPagoTipo.Tipo)))<BR>Vacio(Temp.Texto)
EjecucionMensaje=Comillas(Temp.Texto)+<T> Duplicado<T>
[Lista.Columnas]
Tipo=312
SobrePrecio=78
[Acciones.FormasPago]
Nombre=FormasPago
Boton=47
NombreEnBoton=S
NombreDesplegar=&Formas Pago
GuardarAntes=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=FormaPagoTipoD
Activo=S
ConCondicion=S
Antes=S
Visible=S


EjecucionCondicion=ConDatos(CFDFlexFormaPagoTipo:CFDFlexFormaPagoTipo.Tipo)
AntesExpresiones=Asigna(Info.Tipo, CFDFlexFormaPagoTipo:CFDFlexFormaPagoTipo.Tipo)
[Lista.CFDFlexFormaPagoTipo.Tipo]
Carpeta=Lista
Clave=CFDFlexFormaPagoTipo.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Lista.CFDFlexFormaPagoTipo.SobrePrecio]
Carpeta=Lista
Clave=CFDFlexFormaPagoTipo.SobrePrecio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
