[Forma]
Clave=DM0307CitasReagendarFrm
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=622
PosicionInicialArriba=315
PosicionInicialAlturaCliente=233
PosicionInicialAncho=389
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
Nombre=<T>DM0307CitasProveedores - Reagendar Cita<T>
VentanaExclusiva=S
VentanaBloquearAjuste=S
ExpresionesAlCerrar=Asigna( Mavi.DM0307ID, )
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
ListaEnCaptura=DM0307CitasProveedoresTbl.FechaCita<BR>DM0307CitasProveedoresTbl.Hora<BR>DM0307CitasProveedoresTbl.Proveedor<BR>Prov.NombreCorto<BR>DM0307CitasProveedoresTbl.OrdenCompra<BR>DM0307CitasProveedoresTbl.Otros
CarpetaVisible=S
IgnorarControlesEdicion=S
[Lista.DM0307CitasProveedoresTbl.FechaCita]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.FechaCita
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=15
[Lista.DM0307CitasProveedoresTbl.Hora]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Hora
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.Proveedor]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Proveedor
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
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
[Lista.DM0307CitasProveedoresTbl.OrdenCompra]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.OrdenCompra
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Lista.DM0307CitasProveedoresTbl.Otros]
Carpeta=Lista
Clave=DM0307CitasProveedoresTbl.Otros
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Tabular]
Nombre=Tabular
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Confirmacion(<T>Cita reagendada correctamente<T>, BotonAceptar)
Activo=S
Visible=S
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
Activo=S
Visible=S
Expresion=Asigna( Mavi.DM0307ID,  )<BR>OtraForma( <T>DM0307CitasProveedoresFrm<T>, Forma.Accion(<T>Actualizar<T>) )
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
ListaAccionesMultiples=Tabular<BR>Guardar<BR>Expresion<BR>Cerrar<BR>Actualizar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Si<BR>  ( SQL(<T>SELECT COUNT(*) FROM ( SELECT DISTINCT Proveedor<BR>     FROM DM0307CitasProveedores<BR>     WHERE Estatus = <T> + Comillas(<T>Pendiente<T>) +<BR>     <T> AND Proveedor = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Proveedor) +<BR>     <T> AND FechaCita = <T> + Comillas(FechaEnTexto(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.FechaCita,<T>aaaa/mm/dd<T>,<T>Ingles<T>)) +<BR>     <T> AND Hora = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora)+<T>)Sub<T>)<BR>      ) > 0 )<BR>       o<BR>  ( SQL(<T>SELECT COUNT(*) FROM ( SELECT DISTINCT Proveedor<BR>       FROM DM0307CitasProveedores<BR>       WHERE Estatus = <T> + Comillas(<T>Pendiente<T>) +<BR>       <T> AND FechaCita = <T> + Comillas(FechaEnTexto(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.FechaCita,<T>aaaa/mm/dd<T>,<T>Ingles<T>)) +<BR>       <T> AND Hora = <T> + Comillas(DM0307CitasProveedoresVis:DM0307CitasProveedoresTbl.Hora)+<T>)Sub<T>)<BR>       ) <= 2 )<BR>  Entonces<BR>    Verdadero<BR>  Sino<BR>    Informacion(Centrar(<T>Se alcanzó el limite de citas para esta Fecha/Hora en especifico<T>,65)+NuevaLinea+Centrar(<T>Nota: el limite de citas son 3<T>,80)+NuevaLinea)<BR>    AbortarOperacion<BR>Fin
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
ListaAccionesMultiples=Cancelar<BR>Cerrar<BR>Limpiar
Activo=S
Visible=S
[Acciones.Cancelar.Limpiar]
Nombre=Limpiar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.DM0307ID, )

