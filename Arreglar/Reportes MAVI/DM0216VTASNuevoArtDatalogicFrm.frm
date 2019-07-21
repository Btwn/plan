
[Forma]
Clave=DM0216VTASNuevoArtDatalogicFrm
Icono=0
CarpetaPrincipal=Principal
Modulos=(Todos)
Nombre=<T>Alta De Articulo DataLogic<T>

ListaCarpetas=Principal
PosicionInicialAlturaCliente=212
PosicionInicialAncho=430
IniciarAgregando=S
PosicionInicialIzquierda=425
PosicionInicialArriba=386
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesCentro=S
ListaAcciones=Aceptar<BR>Cancelar
AccionesDivision=S
VentanaSinIconosMarco=S
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0216VTASCatalogoDatalogicVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=11
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
Visible=S

ConCondicion=S
ListaAccionesMultiples=Guardar Cambios<BR>Actualizar<BR>Cerrar
EjecucionCondicion=AvanzarCaptura<BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Codigo),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Codigo DataLogic><T>) AbortarOperacion)<BR>                                                                                                                                          <BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Nombre),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Nombre DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Tipo),<BR>            verdadero,                                                                                <BR>            informacion(<T>Debe llenar el campo <Tipo DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si(ConDatos(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Prov),<BR>            verdadero,<BR>            informacion(<T>Debe llenar el campo <Proveedor DataLogic><T>) AbortarOperacion)<BR><BR><BR>Si<BR>  DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Tipo = <T>PS<T><BR>Entonces<BR>  Asigna(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Monto,)<BR>  verdadero<BR>Sino<BR>  Si<BR>    Vacio(DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Monto)<BR>  Entonces<BR>    Informacion(<T>Debe llenar el campo <Monto><T>)<BR>    AbortarOperacion<BR>  Fin<BR>Fin<BR><BR><BR>Si<BR>  SQL(<T>SELECT COUNT(*) FROM DM0216PagoExternoArt WITH(NOLOCK) WHERE Codigo = :tCodigo<T>,<BR>  DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Codigo) = 0<BR>Entonces<BR>  Verdadero<BR>Sino                                                                                                  <BR>  Informacion(<T>Ya existe el codigo: <T>+DM0216VTASCatalogoDatalogicVis:DM0216VTASArtDatalogicTbl.Codigo+<BR>              <T> en el catalogo DataLogic<T>+NuevaLinea+<T>Ingrese un codigo diferente<T>)<BR>  AbortarOperacion<BR>Fin
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=Cancelar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S

ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
[Acciones.Cancelar.Cancelar Cambios]
Nombre=Cancelar Cambios
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

Expresion=OtraForma(<T>DM0216VTASArtDatalogicPralFrm<T>, Forma.Accion(<T>Actualizar<T>))<BR>Informacion(<T>Datos Almacenados<T>)
[Acciones.Aceptar.Cerrar]
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

