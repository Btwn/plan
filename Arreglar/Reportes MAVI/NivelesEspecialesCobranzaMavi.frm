[Forma]
Clave=NivelesEspecialesCobranzaMavi
Nombre=Niveles Especiales de Cobranza Menudeo
Icono=0
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Prelimianar<BR>Excel<BR>Eliminar
ListaCarpetas=Lista
CarpetaPrincipal=Lista
AutoGuardar=S
PosicionInicialIzquierda=426
PosicionInicialArriba=355
PosicionInicialAlturaCliente=276
PosicionInicialAncho=427
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaExclusiva=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y Cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Lista]
Estilo=Hoja
Clave=Lista
PermiteEditar=S
GuardarPorRegistro=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=NivelesEspecialesCobranzaMavi
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
ListaEnCaptura=NivelesEspecialesCobranzaMavi.Nombre<BR>NivelesEspecialesCobranzaMavi.NivelOrigen<BR>NivelesEspecialesCobranzaMavi.Orden
CarpetaVisible=S
[Lista.NivelesEspecialesCobranzaMavi.Nombre]
Carpeta=Lista
Clave=NivelesEspecialesCobranzaMavi.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Nombre=170
NivelOrigen=160
Orden=64
[Acciones.Prelimianar]
Nombre=Prelimianar
Boton=6
NombreDesplegar=Vista Preliminar
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S
GuardarAntes=S
[Acciones.Excel]
Nombre=Excel
Boton=115
NombreDesplegar=Excel
GuardarAntes=S
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreDesplegar=Eliminar
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=SQL(<T>Select Count(*) From (Select TOP 1 Cliente FROM Cte WHERE NivelCobranzaEspecialMAVI =:tNiv)B<T>, NivelesEspecialesCobranzaMavi:NivelesEspecialesCobranzaMavi.Nombre) = 0
EjecucionMensaje=<T>El nivel de cobranza ya fue asignado a un cliente, no se puede eliminar!!.<T>
[Lista.NivelesEspecialesCobranzaMavi.NivelOrigen]
Carpeta=Lista
Clave=NivelesEspecialesCobranzaMavi.NivelOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.NivelesEspecialesCobranzaMavi.Orden]
Carpeta=Lista
Clave=NivelesEspecialesCobranzaMavi.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

