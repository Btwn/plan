[Forma]
Clave=PropreListaCaptura
Nombre=Captura de Listas de precios
Icono=23
CarpetaPrincipal=Lista
Modulos=(Todos)
ListaCarpetas=Lista
PosicionInicialAlturaCliente=328
PosicionInicialAncho=961
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=159
PosicionInicialArriba=202
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Detalle<BR>PublicarLista<BR>PublicarAnexo<BR>Preliminar<BR>AbrirMostrar<BR>BorrarAnexosNP<BR>BorrarAnexosP<BR>Homologacion
[Lista]
Estilo=Iconos
Clave=Lista
RefrescarAlEntrar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PropreLista
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=PropreLista.Descripcion<BR>PropreLista.TipoLista<BR>PropreLista.UEN<BR>PropreLista.Estatus<BR>NumeroArticulos<BR>PropreLista.UtilizaM2Contado<BR>PropreListaSucursalTotal.Cantidad<BR>PropreUltimoAnexoPorLista.UltimoAnexo<BR>FechaPublicacion<BR>HoraPublicacion<BR>PropreUltimoAnexoPorLista.Fecha<BR>HoraPubAnexo<BR>PropreLista.FechaOrigen
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosSubTitulo=<T>Lista<T>
ElementosPorPagina=200
MenuLocal=S
ListaAcciones=MenuLocalDetalle<BR>MenuLocalPublicarLista<BR>MenuLocalPublicarAnexo<BR>DespublicarLista<BR>ReporteAnexos
IconosNombre=PropreLista:PropreLista.Lista
[Lista.PropreLista.Descripcion]
Carpeta=Lista
Clave=PropreLista.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreLista.TipoLista]
Carpeta=Lista
Clave=PropreLista.TipoLista
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreLista.UEN]
Carpeta=Lista
Clave=PropreLista.UEN
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreLista.Estatus]
Carpeta=Lista
Clave=PropreLista.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Lista=124
Descripcion=304
TipoLista=184
UEN=64
Estatus=94
0=111
1=170
2=87
3=97
4=56
5=108
6=108
7=-2
8=-2
9=100
10=-2
11=-2
12=-2
13=-2
[Acciones.Detalle]
Nombre=Detalle
Boton=47
NombreEnBoton=S
NombreDesplegar=&Detalle
EnBarraHerramientas=S
TipoAccion=Expresion
Visible=S
Antes=S
Expresion=Asigna(Info.PropreTipoLista,PropreLista:PropreLista.TipoLista)<BR>Asigna(Info.PropreUtilizaM2,PropreLista:PropreLista.UtilizaM2Contado)     <BR>Caso  PropreLista:PropreLista.TipoLista<BR>  Es <T>Credito<T> Entonces Forma(<T>PropreListaD<T>)<BR>  Es <T>Contado<T> Entonces Forma(<T>PropreListaDContado<T>)<BR>  Es <T>Doble<T> Entonces Forma(<T>PropreListaDDoble<T>)<BR>  Es <T>Mayoreo<T> Entonces Forma(<T>PropreListaDMayoreo<T>)<BR>Fin
ActivoCondicion=PropreLista:PropreLista.Estatus <> <T>Baja<T>
AntesExpresiones=Asigna(Info.PropreLista,PropreLista:PropreLista.Lista)
[Acciones.PublicarLista]
Nombre=PublicarLista
Boton=56
NombreDesplegar=Publicar &Lista
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ConCondicion=S
EjecucionConError=S
Expresion=Si<BR>    PropreLista:NumeroArticulos > 0<BR>  Entonces<BR>    Si<BR>      Mayusculas(PropreLista:PropreLista.Estatus) <> <T>BAJA<T><BR>    Entonces<BR>      SI Confirmacion(<T>Desea publicar la lista <T> + PropreLista:PropreLista.Lista + <T>?<T>,BotonSi,BotonNo) = BotonSi Entonces<BR>        ProcesarSQL(<T>spProprePublicarLista :tLista, :nEstacion<T>,PropreLista:PropreLista.Lista, EstacionTrabajo)<BR>        Asigna(Info.Mensaje,Nulo)<BR>      Fin<BR>    Sino<BR>      Informacion(<T>No se puede publicar una lista que esta dada de baja<T>)<BR>    Fin<BR>  Sino<BR>    Informacion(<T>No se pueden Publicar Listas Vacias<T>)<BR>  Fin<BR>ActualizarVista
EjecucionCondicion=(SQL(<T>EXEC SpPropreSucursalesActivas :tLista<T>,PropreLista:PropreLista.Lista)=1) Y (SQL(<T>SELECT dbo.fnPropreCandadoPub(:tLista)<T>,PropreLista:PropreLista.Lista)=0)
EjecucionMensaje=SI<BR> (SQL(<T>EXEC SpPropreSucursalesActivas :tLista<T>,PropreLista:PropreLista.Lista)=0)<BR> Entonces <T>No se pueden Publicar Listas que tienen todas las Sucursales Inactivas.<T><BR>SINO<BR>  Si  (SQL(<T>SELECT dbo.fnPropreCandadoPub(:tLista)<T>,PropreLista:PropreLista.Lista)=1)<BR>    Entonces <T>Debe Borrar los Anexos Publicados y los Anexos no Publicados<T><BR>  Fin<BR>Fin
[Acciones.PublicarAnexo]
Nombre=PublicarAnexo
Boton=75
NombreEnBoton=S
NombreDesplegar=Publicar &Anexo
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Visible=S
Activo=S
ConCondicion=S
EjecucionConError=S
Expresion=SI Confirmacion(<T>Desea publicar un anexo para la lista <T> + PropreLista:PropreLista.Lista + <T>?<T>,BotonSi,BotonNo) = BotonSi Entonces<BR>  Informacion(SQL(<T>spProprePublicarAnexo :tLista<T>,PropreLista:PropreLista.Lista))<BR>  ActualizarVista<BR>Fin
EjecucionCondicion=PropreLista:PropreUltimoAnexoPorLista.UltimoAnexo >= 0
EjecucionMensaje=<T>La Lista no esta Publicadas<T>
[Lista.PropreUltimoAnexoPorLista.UltimoAnexo]
Carpeta=Lista
Clave=PropreUltimoAnexoPorLista.UltimoAnexo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreUltimoAnexoPorLista.Fecha]
Carpeta=Lista
Clave=PropreUltimoAnexoPorLista.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.MenuLocalDetalle]
Nombre=MenuLocalDetalle
Boton=0
NombreDesplegar=Detalle
EnMenu=S
TipoAccion=Expresion
Visible=S
Expresion=Forma.Accion(<T>Detalle<T>)
ActivoCondicion=PropreLista:PropreLista.Estatus <> <T>Baja<T>
[Acciones.MenuLocalPublicarLista]
Nombre=MenuLocalPublicarLista
Boton=0
NombreDesplegar=Publicar Lista
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.Accion(<T>PublicarLista<T>)
[Acciones.MenuLocalPublicarAnexo]
Nombre=MenuLocalPublicarAnexo
Boton=0
NombreDesplegar=Publicar Anexo
EnMenu=S
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Forma.Accion(<T>PublicarAnexo<T>)
EjecucionCondicion=PropreLista:PropreUltimoAnexoPorLista.UltimoAnexo >= 0
EjecucionMensaje=<T>La Lista no esta Publicadas<T>
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=Presentacion Preliminar
EnBarraHerramientas=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S
[Lista.PropreLista.UtilizaM2Contado]
Carpeta=Lista
Clave=PropreLista.UtilizaM2Contado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.NumeroArticulos]
Carpeta=Lista
Clave=NumeroArticulos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreLista.FechaOrigen]
Carpeta=Lista
Clave=PropreLista.FechaOrigen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.AbrirMostrar]
Nombre=AbrirMostrar
Boton=45
NombreEnBoton=S
NombreDesplegar=Personalizar &Vista
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S
[Acciones.DespublicarLista]
Nombre=DespublicarLista
Boton=0
NombreDesplegar=Despublicar Lista
EnMenu=S
TipoAccion=Formas
ClaveAccion=PropreAnexoDBorrados
Activo=S
ConCondicion=S
Visible=S
Antes=S
EjecucionConError=S
EjecucionCondicion=PropreLista:PropreLista.Estatus = <T>Baja<T>
EjecucionMensaje=<T>Esta Lista esta Activa<T>
AntesExpresiones=Asigna(Info.PropreLista,PropreLista:PropreLista.Lista)
[Acciones.BorrarAnexosNP]
Nombre=BorrarAnexosNP
Boton=32
NombreEnBoton=S
NombreDesplegar=&Borrar Anexos No Publicados
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI Confirmacion(<T>Desea borrar los Anexos no publicados? <T>,BotonSi,BotonNo) = BotonSi Entonces<BR>   SQL(<T>SpPropreBorrAnexNoPubli<T>)<BR>  ActualizarVista<BR>Fin
[Acciones.BorrarAnexosP]
Nombre=BorrarAnexosP
Boton=32
NombreEnBoton=S
NombreDesplegar=&Borrar Anexos Publicados
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI Confirmacion(<T>Desea borrar los Anexos publicados? <T>,BotonSi,BotonNo) = BotonSi Entonces<BR>  SQL(<T>SpPropreBorrAnexosPubli<T>)<BR>  ActualizarVista<BR>Fin
[Acciones.Homologacion]
Nombre=Homologacion
Boton=55
NombreEnBoton=S
NombreDesplegar=Homologación de Precios
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=PropreHomPrecios
Activo=S
Visible=S
[Acciones.ReporteAnexos]
Nombre=ReporteAnexos
Boton=0
NombreDesplegar=Reportes de Anexos
EnMenu=S
TipoAccion=Formas
ClaveAccion=PropreAnexoD
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.PropreLista,PropreLista:PropreLista.Lista)
[Lista.FechaPublicacion]
Carpeta=Lista
Clave=FechaPublicacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.HoraPublicacion]
Carpeta=Lista
Clave=HoraPublicacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.HoraPubAnexo]
Carpeta=Lista
Clave=HoraPubAnexo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreListaSucursalTotal.Cantidad]
Carpeta=Lista
Clave=PropreListaSucursalTotal.Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

