[Forma]
Clave=DM0307CitarFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista<BR>Detalle
CarpetaPrincipal=Lista
PosicionInicialIzquierda=604
PosicionInicialArriba=405
PosicionInicialAlturaCliente=465
PosicionInicialAncho=417
IniciarAgregando=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cancelar<BR>Pruebas<BR>Usar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
Nombre=<T>DM0307CitasProveedores - Nueva Cita<T>
PosicionSec1=189
VentanaExclusiva=S
VentanaBloquearAjuste=S
ExpresionesAlCerrar=Asigna( Mavi.DM0307Proveedor,<T><T> )<BR> Asigna( Mavi.DM0307Auxiliar,<T><T> )<BR>Asigna( Mavi.DM0307ID, )
ExpresionesAlActivar=Asigna( Mavi.DM0307Proveedor,<T><T> )<BR> Asigna( Mavi.DM0307Auxiliar,<T><T> )<BR>Asigna( Mavi.DM0307ID, )
[Lista]
Estilo=Ficha
Clave=Lista
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0307CitasProveedoresVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0307CitasProveedoresTbl.Proveedor<BR>Prov.NombreCorto<BR>DM0307CitasProveedoresTbl.FechaCita<BR>DM0307CitasProveedoresTbl.Hora<BR>DM0307CitasProveedoresTbl.TipoTransporte<BR>DM0307CitasProveedoresTbl.NumeroUnidad<BR>DM0307CitasProveedoresTbl.OrdenCompra<BR>DM0307CitasProveedoresTbl.Otros
CarpetaVisible=S
IgnorarControlesEdicion=S
[Lista.DM0307CitasProveedoresTbl.Proveedor]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.FechaCita]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.FechaCita
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=11
[Lista.DM0307CitasProveedoresTbl.Hora]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Hora
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.TipoTransporte]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.TipoTransporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.NumeroUnidad]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.NumeroUnidad
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.OrdenCompra]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.OrdenCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.Otros]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Otros
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Prov.NombreCorto]
Carpeta=Lista
Clave=Prov.NombreCorto
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Expresion=OtraForma( <T>DM0307CitasProveedoresFrm<T>, Forma.Accion(<T>Actualizar<T>) )
Activo=S
Visible=S
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Checar<BR>Guardar Cambios<BR>Cancelar Cambios<BR>Cerrar<BR>Actualizar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna( Mavi.DM0307ID,)<BR>AvanzarCaptura
[Acciones.Cancelar.Cancelar]
Nombre=Cancelar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cancelar]
Nombre=Cancelar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cancelar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar<BR>Cerrar
Activo=S
Visible=S
[Detalle]
Estilo=Hoja
Clave=Detalle
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0307CitasDetalleVis
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
ListaEnCaptura=DM0307CitasDetalleTbl.Articulo<BR>Art.Descripcion1<BR>DM0307CitasDetalleTbl.Piezas
CarpetaVisible=S
Detalle=S
VistaMaestra=DM0307CitasProveedoresVis
LlaveLocal=DM0307CitasDetalleTbl.ID
LlaveMaestra=DM0307CitasProveedoresTbl.ID
IgnorarControlesEdicion=S
[Detalle.DM0307CitasDetalleTbl.Articulo]
Carpeta=Detalle
Clave=DM0307CitasDetalleTbl.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0307CitasDetalleTbl.Piezas]
Carpeta=Detalle
Clave=DM0307CitasDetalleTbl.Piezas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Columnas]
Articulo=86
Piezas=64
Descripcion1=207
[Detalle.Art.Descripcion1]
Carpeta=Detalle
Clave=Art.Descripcion1
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Pruebas]
Nombre=Pruebas
Boton=0
NombreEnBoton=S
NombreDesplegar=Prueba
TipoAccion=Controles Captura
ClaveAccion=Ir a la Carpeta
Activo=S
Visible=S
Carpeta=Detalle
[Acciones.Usar]
Nombre=Usar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.OrdenCompra )
[Acciones.Guardar.Checar]
Nombre=Checar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Proveedor)<BR>Si(ConDatos(Mavi.DM0307Auxiliar),, Asigna( Mavi.DM0307ID,0 ) )<BR>Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.FechaCita )<BR>Si(ConDatos(Mavi.DM0307Auxiliar),, Asigna( Mavi.DM0307ID,0 ) )<BR>Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora )<BR>Si(ConDatos(Mavi.DM0307Auxiliar),, Asigna( Mavi.DM0307ID,0 ) )<BR>Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.NumeroUnidad )<BR>Si(ConDatos(Mavi.DM0307Auxiliar),, Asigna( Mavi.DM0307ID,0 ) )<BR>Asigna( Mavi.DM0307Auxiliar,DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.TipoTransporte )<BR>Si(ConDatos(Mavi.DM0307Auxiliar),, Asigna( Mavi.DM0307ID,0 ) )
[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
Activo=S
Visible=S
ClaveAccion=Registro Insertar
ConCondicion=S
Carpeta=(Carpeta principal)
EjecucionCondicion=Si(Vacio(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Proveedor),Informacion(<T>El campo <Proveedor> debe tener un valor<T>) AbortarOperacion,)<BR>Si(Vacio(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora),Informacion(<T>El campo <Hora> debe tener un valor<T>) AbortarOperacion,)<BR>Si(Vacio(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.TipoTransporte),Informacion(<T>El campo <TipoTransporte> debe tener un valor<T>) AbortarOperacion,)<BR>Si(Vacio(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.NumeroUnidad),Informacion(<T>El campo <NumeroUnidad> debe tener un valor<T>) AbortarOperacion,)<BR><BR>Si<BR> Mavi.DM0307ID <> 0<BR>  Entonces<BR>  Si<BR>     ( SQL(<T>SELECT COUNT(*) FROM ( SELECT DISTINCT Proveedor<BR>       FROM DM0307CitasProveedores<BR>       WHERE Estatus = <T> + Comillas(<T>Pendiente<T>) +<BR>       <T> AND Proveedor = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Proveedor) +<BR>       <T> AND FechaCita = <T> + Comillas(FechaEnTexto(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.FechaCita,<T>aaaa/mm/dd<T>,<T>Ingles<T>)) +<BR>       <T> AND Hora = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora)+<T>)Sub<T>)<BR>       ) > 0 )<BR>       o<BR>     ( SQL(<T>SELECT COUNT(*) FROM ( SELECT DISTINCT Proveedor               <BR>     FROM DM0307CitasProveedores<BR>       WHERE Estatus = <T> + Comillas(<T>Pendiente<T>) +<BR>     <T> AND FechaCita = <T> + Comillas(FechaEnTexto(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.FechaCita,<T>aaaa/mm/dd<T>,<T>Ingles<T>)) +<BR>     <T> AND Hora = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora)+<T>)Sub<T>)<BR>     ) <= 2 )<BR>    Entonces<BR>      Verdadero<BR>    Sino<BR>      Informacion(Centrar(<T>Se alcanzó el limite de citas para esta Fecha/Hora en especifico<T>,65)+NuevaLinea+Centrar(<T>Nota: el limite de citas son 3<T>,80)+NuevaLinea)<BR>      AbortarOperacion<BR>    Fin<BR>Sino <BR>  Informacion(<T>Algun valor no es valido<T>+NuevaLinea)<BR>  AbortarOperacion<BR>Fin
EjecucionMensaje=Informacion(<BR>Centrar(<T>Algun valor no es valido<T>,85)<BR>+NuevaLinea+<BR>Centrar(<T>o<T>,95)<BR>+NuevaLinea+<BR>Centrar(<T>Se alcanzó el limite de citas para esta Fecha/Hora en especifico<T>,70)<BR>+NuevaLinea+ NuevaLinea+ NuevaLinea+<BR>Centrar(<T>Nota: el limite de citas son 3<T>,85)<BR>+NuevaLinea<BR>)
[Acciones.Guardar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Lista.Columnas]
Proveedor=64
Nombre=276
Ordenes=64
0=131
1=85

