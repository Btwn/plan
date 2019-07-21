
[Forma]
Clave=DM0345COMSNuevoFamiliasLineasFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=164
PosicionInicialAncho=450
IniciarAgregando=S
PosicionInicialIzquierda=329
PosicionInicialArriba=321
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir<BR>Avanzar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
Nombre=<T>Agregar Nueva Familia-Linea En App DIMA<T>
VentanaSiempreAlFrente=S
ExpresionesAlMostrar=Asigna(Mavi.DM0345Bandera,Mavi.DM0345Bandera+1)<BR>OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))
ExpresionesAlCerrar=Asigna(Mavi.DM0345Bandera,Mavi.DM0345Bandera-1)<BR>OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))
[Principal]
Estilo=Ficha
Clave=Principal
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0345COMSFamiliasLineasValidasAppDimaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo<BR>DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
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
Tamano=50
ColorFondo=Blanco

[Principal.DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion]
Carpeta=Principal
Clave=DM0345COMSFamiliasLineasValidasAppDimaTbl.Descripcion
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

[Principal.Columnas]
Familia=304
Linea=304
Grupo=34
Descripcion=304

[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S

ConCondicion=S
ListaAccionesMultiples=Guardar Cambios<BR>Almacena<BR>Actualizar<BR>Mensaje<BR>Cerrar
EjecucionCondicion=Forma.Accion(<T>Avanzar<T>)<BR><BR>Si(ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia),<BR>   verdadero,<BR>   Informacion(<T>Debe llenar el campo <Familia><T>) AbortarOperacion)<BR><BR>Si(ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea),<BR>   verdadero,<BR>   Informacion(<T>Debe llenar el campo <Linea><T>) AbortarOperacion)<BR><BR>Si(ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo),<BR>   verdadero,<BR>   Informacion(<T>Debe llenar el campo <Grupo><T>) AbortarOperacion)
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
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Cancelar Cambios<BR>Cerrar
Activo=S
Visible=S

ConCondicion=S
EjecucionCondicion=Si ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Familia)<BR>   o<BR>   ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Linea)<BR>   o<BR>   ConDatos(DM0345COMSFamiliasLineasValidasAppDimaVis:DM0345COMSFamiliasLineasValidasAppDimaTbl.Grupo)<BR>Entonces<BR>    Si Confirmacion( <T>¿Salir sin guardar cambios?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>    Entonces<BR>      verdadero<BR>    Sino<BR>      AbortarOperacion<BR>Fin
[Acciones.Avanzar]
Nombre=Avanzar
Boton=0
TipoAccion=Expresion
Expresion=AvanzarCaptura
Activo=S
Visible=S

[Acciones.Guardar.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))

[Acciones.Guardar.Almacena]
Nombre=Almacena
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>SpCOMSGestionarFamiliasLineasAppDIMA :nOpcion,:nSpid,:nID,:tDatos<T>,3,SQL(<T>SELECT @@SPID<T>),0,<T><T>)



[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Guardar.Mensaje]
Nombre=Mensaje
Boton=0
TipoAccion=Expresion
Expresion=Informacion(<T>Datos Guardados<T>)
Activo=S
Visible=S

