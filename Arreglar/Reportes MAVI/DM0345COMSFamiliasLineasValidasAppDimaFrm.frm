
[Forma]
Clave=DM0345COMSFamiliasLineasValidasAppDimaFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=178
PosicionInicialArriba=296
PosicionInicialAlturaCliente=392
PosicionInicialAncho=923
Nombre=<T>Familias-Lineas Validas En App DIMA<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Nuevo<BR>Salir<BR>Actualizar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal

ExpresionesAlMostrar=EjecutarSQL(<T>SET ANSI_NULLS ON SET ANSI_WARNINGS ON<T>)<BR>EjecutarSQL(<T>SpCOMSGestionarFamiliasLineasAppDIMA :nOpcion,:nSpid,:nID,:tDatos<T>,1,SQL(<T>SELECT @@SPID<T>),0,<T><T>)  <BR>Asigna(Mavi.DM0345Bandera,0)
ExpresionesAlCerrar=EjecutarSQL(<T>SpCOMSGestionarFamiliasLineasAppDIMA :nOpcion,:nSpid,:nID,:tDatos<T>,2,SQL(<T>SELECT @@SPID<T>),0,<T><T>)
[Principal.Columnas]
Familia=304
Linea=304
Grupo=45
Descripcion=229





[Acciones.Salir.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Salir]
Nombre=Salir
Boton=36
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Visible=S
EspacioPrevio=S



ActivoCondicion=Si<BR>  Mavi.DM0345Bandera = 0<BR>Entonces<BR>  Verdadero<BR>Sino<BR>  Falso<BR>Fin
[Acciones.Guardar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Eliminar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Eliminar.Actualizar Forma]
Nombre=Actualizar Forma
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Forma
Activo=S
Visible=S

[Acciones.Guardar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Informacion(<T>Datos Guardados<T>)
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Registro Eliminado<T>)
Activo=S
Visible=S






[Vista.Columnas]
Familia=304
Linea=304
Grupo=34
Descripcion=304

[Acciones.Guardar.Limpiar]
Nombre=Limpiar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=ActualizarVista(<T>DM0345COMSFamiliasLineasValidasAppDimaVis<T>)<BR>Asigna(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia,)<BR>Asigna(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea,)<BR>Asigna(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo,)<BR>Asigna(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion,)
[Acciones.Guardar.GuardarRegistro]
Nombre=GuardarRegistro
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S







[Principal.DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia]
Carpeta=Principal
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea]
Carpeta=Principal
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo]
Carpeta=Principal
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[Principal.DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion]
Carpeta=Principal
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Acciones.Guardar Cambios.Expresion2]
Nombre=Expresion2
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S




Expresion=ActualizarForma<BR>ActualizarVista(<T>DM0345COMSFamLinAppDimaVis<T>)
[Acciones.Guardar Cambios.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Guardar Cambios.Avanzar]
Nombre=Avanzar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=AvanzarCaptura





[VistaDatos.Columnas]
Familia=349
Linea=364
Grupo=34
Descripcion=200


[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=DM0345COMSFamiliasLineasValidasAppDimaVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
ElementosPorPaginaEsp=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
CarpetaVisible=S

[(Carpeta Abrir).DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia]
Carpeta=(Carpeta Abrir)
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Abrir).DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea]
Carpeta=(Carpeta Abrir)
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Abrir).DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo]
Carpeta=(Carpeta Abrir)
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[(Carpeta Abrir).DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion]
Carpeta=(Carpeta Abrir)
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[(Carpeta Abrir).Columnas]
0=-2
1=-2
2=-2
3=-2


[Acciones.Modificar]
Nombre=Modificar
Boton=0
NombreDesplegar=Modificar
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Test
[Acciones.Modificar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Modificar.Test]
Nombre=Test
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Info.Numero,DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.IdFamiliasLineasAppDima)     <BR>Forma( <T>DM0345COMSModificarFamiliasLineasFrm<T>)<BR><BR>/*Informacion(<BR><T>Id: <T>+DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.IdFamiliasLineasAppDima+<BR>NuevaLinea+<BR><T>Familia: <T>+DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia+<BR>NuevaLinea+<BR><T>Linea: <T>+DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea+<BR>NuevaLinea+<BR><T>Grupo: <T>+DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo+<BR>NuevaLinea+<BR><T>Descripcion: <T>+DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion)*/

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=ActualizarVista(<T>DM0345COMSFamLinAppDimaVis<T>)<BR>//ActualizarForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>)
[Principal]
Estilo=Hoja
Clave=Principal
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0345COMSFamLinAppDimaVis
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
ListaEnCaptura=DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
ListaAcciones=Modificar<BR>Eliminar
CarpetaVisible=S

[Acciones.Eliminar]
Nombre=Eliminar
Boton=0
NombreDesplegar=Eliminar
EnMenu=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Seleccionar<BR>Eliminar
[Acciones.Eliminar.Seleccionar]
Nombre=Seleccionar
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S

[Acciones.Eliminar.Eliminar]
Nombre=Eliminar
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>SpCOMSGestionarFamiliasLineasAppDIMA :nOpcion,:nSpid,:nID,:tDatos<T>,<BR>             5,<BR>             SQL(<T>SELECT @@SPID<T>),<BR>             DM0345COMSFamLinAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.IdFamiliasLineasAppDima,<BR>             <T><T>)<BR><BR>ActualizarForma
Activo=S
Visible=S

[Acciones.Nuevo]
Nombre=Nuevo
Boton=23
NombreEnBoton=S
NombreDesplegar=Nuevo
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0345COMSNuevoFamiliasLineasFrm
Activo=S
Visible=S

