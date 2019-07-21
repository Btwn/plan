[Forma]
Clave=TiposCoberturaMAVI
Nombre=Tipos de Cobertura
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=273
PosicionInicialAncho=396
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar Cambios<BR>Cobertura<BR>Ordenar
PosicionInicialIzquierda=435
PosicionInicialArriba=242
[tablaAmortizacion.Columnas]
Cobertura=304
[Lista]
Estilo=Hoja
Clave=Lista
OtroOrden=S
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=TiposCoberturaMAVI
Fuente={Tahoma, 8, Negro, []}
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=TiposCoberturaMAVI.Orden<BR>TiposCoberturaMAVI.Cobertura
ListaOrden=TiposCoberturaMAVI.Orden<TAB>(Acendente)<BR>TiposCoberturaMAVI.Cobertura<TAB>(Acendente)
CarpetaVisible=S
[Lista.TiposCoberturaMAVI.Cobertura]
Carpeta=Lista
Clave=TiposCoberturaMAVI.Cobertura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Cobertura=304
Orden=64
[Acciones.Guardar Cambios]
Nombre=Guardar Cambios
Boton=3
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Ordenar]
Nombre=Ordenar
Boton=54
NombreDesplegar=&Ordenar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S
Antes=S
GuardarAntes=S
DespuesGuardar=S
AntesExpresiones=Forma(<T>OrdenarTiposCoberturaMAVI<T>)
[Lista.TiposCoberturaMAVI.Orden]
Carpeta=Lista
Clave=TiposCoberturaMAVI.Orden
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Plata
ColorFuente=Negro
[Acciones.Cobertura]
Nombre=Cobertura
Boton=17
NombreDesplegar=&Cobertura
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=CoberturaMAVI
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
AntesExpresiones=Asigna(Info.Concepto, TiposCoberturaMAVI:TiposCoberturaMAVI.Cobertura)
