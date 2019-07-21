
[Forma]
Clave=DM0345COMSModificarFamiliasLineasFrm
Icono=0
Modulos=(Todos)

ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialAlturaCliente=152
PosicionInicialAncho=446
PosicionInicialIzquierda=417
PosicionInicialArriba=416
Nombre=<T>Modificar Familias-Lineas Validas En App Dima<T>
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Guardar<BR>Salir<BR>CargarInfo<BR>Capturar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaSinIconosMarco=S
VentanaEstadoInicial=Normal
PosicionSec1=125
VentanaSiempreAlFrente=S
ExpresionesAlMostrar=Asigna(Mavi.DM0345Bandera,Mavi.DM0345Bandera+1)<BR>OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))
ExpresionesAlCerrar=Asigna(Mavi.DM0345Bandera,Mavi.DM0345Bandera-1)<BR>OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))
ExpresionesAlActivar=Forma.Accion(<T>CargarInfo<T>)
[Principal]
Estilo=Ficha
Clave=Principal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0345Familia<BR>Mavi.DM0345Linea<BR>Mavi.DM0345Grupo<BR>Mavi.DM0345Descripcion
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S



PermiteEditar=S
[Principal.Columnas]
Familia=304
Linea=304
Grupo=34
Descripcion=304


[Acciones.Salir]
Nombre=Salir
Boton=23
NombreEnBoton=S
NombreDesplegar=Salir
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Cerrar

ConCondicion=S
EjecucionCondicion=AvanzarCaptura<BR><BR>Si Mavi.DM0345Grupo <> Info.Categoria<BR>Entonces<BR>    Si Confirmacion( <T>¿Salir sin guardar cambios?<T>, botonaceptar, botoncancelar) = botonAceptar<BR>    Entonces<BR>      verdadero<BR>    Sino<BR>      AbortarOperacion<BR>Fin
[Acciones.Salir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.CargarInfo]
Nombre=CargarInfo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(Mavi.DM0345Familia,<BR>SQL(<T>SELECT Familia<BR>     FROM COMSCFamiliasLineasAppDima WITH(NOLOCK)<BR>     WHERE IdFamiliasLineasAppDima = :nID<BR>     AND Spid = :nSpid<T>,Info.Numero,SQL(<T>SELECT @@SPID<T>))<BR>)<BR><BR>Asigna(Mavi.DM0345Linea,<BR>SQL(<T>SELECT Linea<BR>     FROM COMSCFamiliasLineasAppDima WITH(NOLOCK)<BR>     WHERE IdFamiliasLineasAppDima = :nID<BR>     AND Spid = :nSpid<T>,Info.Numero,SQL(<T>SELECT @@SPID<T>))<BR>)<BR><BR>Asigna(Mavi.DM0345Grupo,<BR>SQL(<T>SELECT Grupo<BR>     FROM COMSCFamiliasLineasAppDima WITH(NOLOCK)<BR>     WHERE IdFamiliasLineasAppDima = :nID<BR>     AND Spid = :nSpid<T>,Info.Numero,SQL(<T>SELECT @@SPID<T>))<BR>)<BR><BR>Asigna(Mavi.DM0345Descripcion,<BR>SQL(<T>SELECT Descripcion<BR>     FROM COMSCFamiliasLineasAppDima WITH(NOLOCK)<BR>     WHERE IdFamiliasLineasAppDima = :nID<BR>     AND Spid = :nSpid<T>,Info.Numero,SQL(<T>SELECT @@SPID<T>))<BR>)<BR><BR>Asigna(Info.Categoria,<BR>SQL(<T>SELECT Grupo<BR>     FROM COMSCFamiliasLineasAppDima WITH(NOLOCK)<BR>     WHERE IdFamiliasLineasAppDima = :nID<BR>     AND Spid = :nSpid<T>,Info.Numero,SQL(<T>SELECT @@SPID<T>))<BR>)
[Informacion.Info.Mensaje]
Carpeta=Informacion
Clave=Info.Mensaje
Editar=S
LineaNueva=S
ValidaNombre=N
3D=N
Tamano=50
ColorFondo=Blanco



[Acciones.Guardar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
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

Expresion=//OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))
[Acciones.Guardar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Principal.Mavi.DM0345Familia]
Carpeta=Principal
Clave=Mavi.DM0345Familia
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

Editar=N
AccionAlEnter=
AccionAlEnterBloquearAvance=N
[Principal.Mavi.DM0345Linea]
Carpeta=Principal
Clave=Mavi.DM0345Linea
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

Editar=N
[Principal.Mavi.DM0345Grupo]
Carpeta=Principal
Clave=Mavi.DM0345Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco

AccionAlEnter=Capturar
AccionAlEnterBloquearAvance=N

[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=AvanzarCaptura<BR><BR>EjecutarSQL(<T>EXEC SpCOMSGestionarFamiliasLineasAppDIMA :nOpcion, :nSpid, :nId, :tDatos<T>,<BR>             4,<BR>             SQL(<T>SELECT @@SPID<T>),<BR>             Info.Numero,<BR>             Mavi.DM0345Grupo<BR>             )<BR><BR>OtraForma(<T>DM0345COMSFamiliasLineasValidasAppDimaFrm<T>, Forma.Accion(<T>Actualizar<T>))<BR><BR>Informacion(<T>SE ACTUALIZARON LOS SIGUIENTES DATOS:<T>+NuevaLinea+NuevaLinea+<BR>             <T>- FAMILIA: <T>+ Mavi.DM0345Familia + NuevaLinea +<BR>             <T>- LINEA: <T> + Mavi.DM0345Linea + NuevaLinea +<BR>             <T>- GRUPO: <T> + Mavi.DM0345Grupo + NuevaLinea +<BR>             <T>- DESCRIPCION: <T>+ Mavi.DM0345Descripcion)
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Guardar<BR>Close
Activo=S
Visible=S

[Acciones.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Capturar<BR>AsignaDescripcion
[Acciones.Capturar.Capturar]
Nombre=Capturar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Capturar.AsignaDescripcion]
Nombre=AsignaDescripcion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso Mavi.DM0345Grupo<BR>  Es <T>A<T> Entonces Asigna(Mavi.DM0345Descripcion,<T>POR TALLA<T>)<BR>  Es <T>B<T> Entonces Asigna(Mavi.DM0345Descripcion,<T>SIN PROPIEDADES<T>)<BR>  Es <T>C<T> Entonces Asigna(Mavi.DM0345Descripcion,<T>CON GARANTÍA<T>)<BR>  Es <T>D<T> Entonces Asigna(Mavi.DM0345Descripcion,<T>GENERICOS<T>)<BR>Fin

[Principal.Mavi.DM0345Descripcion]
Carpeta=Principal
Clave=Mavi.DM0345Descripcion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Guardar.Close]
Nombre=Close
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

