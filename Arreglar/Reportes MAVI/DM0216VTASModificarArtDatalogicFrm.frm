
[Forma]
Clave=DM0216VTASModificarArtDatalogicFrm
Icono=0
Modulos=(Todos)
Nombre=<T>Modificar Articulo Del Catalogo DataLogic<T>

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=217
PosicionInicialAncho=500
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cancelar
AccionesCentro=S
AccionesDivision=S
VentanaSinIconosMarco=S
PosicionInicialIzquierda=390
PosicionInicialArriba=384
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0216VTASCatalogoDatalogicVis
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
ListaEnCaptura=DM0216VTASArtDatalogicTbl.Codigo<BR>DM0216VTASArtDatalogicTbl.Nombre<BR>DM0216VTASArtDatalogicTbl.Tipo<BR>DM0216VTASArtDatalogicTbl.Prov<BR>DM0216VTASArtDatalogicTbl.Monto
CarpetaVisible=S

PermiteEditar=S





[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Aceptar
Multiple=S
EnBarraAcciones=S
Activo=S
ConCondicion=S
Visible=S

ListaAccionesMultiples=Guardar Cambios<BR>Actualizar<BR>Cerrar
EjecucionCondicion=AvanzarCaptura<BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Codigo),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Codigo DataLogic><T>) AbortarOperacion)<BR>                                                                                                                                          <BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Nombre),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Nombre DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Tipo),<BR>            verdadero,                                                                                <BR>            informacion(<T>Debe llenar el campo <Tipo DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Prov),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Proveedor DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si<BR>  DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Tipo = <T>PS<T><BR>Entonces<BR>  Asigna(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Monto,)<BR>  verdadero<BR>Sino<BR>  Si<BR>    Vacio(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Monto)<BR>  Entonces<BR>    Informacion(<T>Debe llenar el campo <Monto><T>)<BR>    AbortarOperacion<BR>  Fin<BR>Fin
[Acciones.Aceptar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Aceptar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Mensaje,)<BR>OtraForma(<T>DM0216VTASArtDatalogicPralFrm<T>, Forma.Accion(<T>Actualizar<T>))<BR>Informacion(<T>Datos Actualizados<T>)
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cancelar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cancelar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Info.Mensaje,)<BR>OtraForma(<T>DM0216COMSArtDatalogicPralFrm<T>, Forma.Accion(<T>Actualizar<T>))
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cancelar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Cancelar Cambios<BR>Actualizar<BR>Cerrar
Activo=S
Visible=S

[Acciones.Cancelar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Principal.DM0216VTASArtDatalogicTbl.Codigo]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Nombre]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Tipo]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Prov]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Prov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

[Principal.DM0216VTASArtDatalogicTbl.Monto]
Carpeta=Principal
Clave=DM0216VTASArtDatalogicTbl.Monto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco

