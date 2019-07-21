[Forma]
Clave=UsuarioIncremento
Nombre=Usuario Incremento
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=UsuarioIncremento
CarpetaPrincipal=UsuarioIncremento
PosicionInicialAlturaCliente=70
PosicionInicialAncho=220
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=300
PosicionInicialArriba=261
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
BarraAcciones=S
AccionesCentro=S
VentanaExclusiva=S
VentanaEscCerrar=S
ExpresionesAlMostrar=Asigna(Info.Importe,0)<BR>Asigna(Mavi.DM0313Bandera, <T>verdadero<T>)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&OK
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EnBarraAcciones=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Aceptar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  Mavi.DM0313Canal = 11<BR>Entonces<BR>  Verdadero<BR>Sino<BR>      Si Mavi.DM0313Bandera = <T>verdadero<T><BR>      Entonces<BR>          Forma(<T>CandadoIncrementoFRM<T>)<BR>          AbortarOperacion<BR>      Fin<BR>Fin
EjecucionMensaje=<T>No cuenta con los permisos adecuados para realizar la operación<T>
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
[UsuarioIncremento]
Estilo=Ficha
Clave=UsuarioIncremento
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Importe
CarpetaVisible=S
[UsuarioIncremento.Info.Importe]
Carpeta=UsuarioIncremento
Clave=Info.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mensaje,<T><T>)<BR>Asigna(Info.Mensaje, SQL(<T>spPropreIncremento :tUsuario, :nID, :tModulo, :nRenglon, :tArticulo, :nImporte<T>,<BR>                          Usuario, Info.ID, Info.Modulo, Info.Renglon, Info.Articulo, Info.Importe))<BR><BR>Informacion(Info.Mensaje)<BR><BR>Si Info.Mensaje = <T>El precio de venta ha sido actualizado<T><BR>   Entonces<BR>    Si Mavi.DM0313Canal <> 11<BR>        Entonces<BR>            EjecutarSQL(<T>SP_DM0313AutorizaIncremento :tUsr, :tMov, :tMovID, :tArt<T>, Mavi.DM0313Usuario, Mavi.DM0313Mov, Mavi.DM0313ID, Mavi.DM0313Art)<BR>        Fin<BR>    Fin
[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

