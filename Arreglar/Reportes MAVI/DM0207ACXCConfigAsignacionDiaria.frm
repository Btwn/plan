
[Forma]
Clave=DM0207ACXCConfigAsignacionDiaria
Icono=0
Modulos=(Todos)
Nombre=DM0207A Configuracion Asignacion Diaria
PosicionInicialAlturaCliente=579
PosicionInicialAncho=856
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S

ListaAcciones=Guardar<BR>Actualizar<BR>Eliminar<BR>Cerrar
PosicionInicialIzquierda=212
PosicionInicialArriba=203
ListaCarpetas=Datos<BR>MostrarDatos<BR>ActualizarDatos
CarpetaPrincipal=MostrarDatos
PosicionSec1=292


VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaEscCerrar=S
PosicionCol1=473
VentanaBloquearAjuste=S
VentanaSinIconosMarco=S
ExpresionesAlCerrar=Asigna(Info.Dialogo,<T><T>)
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Activo=S
Visible=S

TipoAccion=Controles Captura
Carpeta=MostarDatos
ClaveAccion=Registro Eliminar
Multiple=S
ListaAccionesMultiples=Registro Eliminar<BR>Guardar Cambios
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
Visible=S




























Multiple=S
ListaAccionesMultiples=Avanza<BR>GuardarDatos<BR>ActualizarCarpeta
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>  ConDatos( DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente) y<BR>  ConDatos(DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.Canal) y<BR>  ConDatos(DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.Nivel) y<BR>  ConDatos(DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.Division) y<BR>  ConDatos(DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.TopeDia) y<BR>  ConDatos(DM0207ACXCConfigAsignacionDiaria:DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta)<BR>Entonces<BR>  verdadero<BR>Sino<BR>  falso<BR>Fin
EjecucionMensaje=<T>Debe llenar todos los campos<T>
[Datos]
Estilo=Ficha
Clave=Datos
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0207ACXCConfigAsignacionDiaria
Fuente={Tahoma, 8, Negro, []}
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Ingresar Datos
Pestana=S
CampoColorLetras=Negro
CampoColorFondo=Blanco








FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=$00F0F0F0
FichaAlineacionDerecha=S
ListaEnCaptura=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente<BR>DM0207ACXCConfigAsignacionDiariaTBL.Canal<BR>DM0207ACXCConfigAsignacionDiariaTBL.Nivel<BR>DM0207ACXCConfigAsignacionDiariaTBL.Division<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeDia<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta<BR>DM0207ACXCConfigAsignacionDiariaTBL.Usuario<BR>DM0207ACXCConfigAsignacionDiariaTBL.Fecha
[Datos.Columnas]
TipoCliente=64
Canal=304
Nivel=604
Division=184
TopeDias=64
TopeCuentas=68
Fecha=94
Usuario=64
0=-2
1=-2
2=53
3=-2
4=-2
5=-2
6=-2
7=-2

8=-2

[MostarDatos.Columnas]
TipoCliente=64
Canal=100
Nivel=96
Division=184
TopeDias=64
TopeCuentas=68
Fecha=116
Usuario=64

IdAsignacion=0




















[Acciones.Guardar.GuardarDatos]
Nombre=GuardarDatos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S



[Acciones.Guardar.ActualizarCarpeta]
Nombre=ActualizarCarpeta
Boton=0
TipoAccion=expresion
Activo=S
Visible=S










Expresion=Forma.ActualizarVista(<T>Datos<T>) <BR>Forma.ActualizarVista(<T>MostrarDatos<T>)
[Acciones.Actualizar]
Nombre=Actualizar
Boton=38
NombreEnBoton=S
NombreDesplegar=&Actualizar
EnBarraHerramientas=S
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=Expresion<BR>Actualiza
[Acciones.CERRAR.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.CERRAR.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


[Acciones.Eliminar.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=MostrarDatos
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

[Acciones.Elimina.Registro Eliminar]
Nombre=Registro Eliminar
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S

[Acciones.Elimina.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S


[MostrarDatos]
Estilo=Hoja
Clave=MostrarDatos
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0207AMostrarDatosVIST
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
CarpetaVisible=S

Pestana=S
PestanaOtroNombre=S
PestanaNombre=Mostrar Datos
MenuLocal=S
ListaAcciones=Actualizacion








ListaEnCaptura=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente<BR>DM0207ACXCConfigAsignacionDiariaTBL.Canal<BR>DM0207ACXCConfigAsignacionDiariaTBL.Nivel<BR>DM0207ACXCConfigAsignacionDiariaTBL.Division<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeDia<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta<BR>DM0207ACXCConfigAsignacionDiariaTBL.Fecha<BR>DM0207ACXCConfigAsignacionDiariaTBL.Usuario
[MostrarDatos.Columnas]
TipoCliente=109
Canal=37
Nivel=116
Division=184
TopeDias=55
TopeCuentas=68
Fecha=135
Usuario=83
IdAsignacion=65



TopeDia=64
TopeCuenta=64
[Acciones.Modificar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S


Expresion=Asigna(info.Dialogo,DM0207AMostrarDatosVIST:DM0207ACXCConfigAsignacionDiariaTBL.IdAsignacion)


[Acciones.Modificar.ActualizaVis]
Nombre=ActualizaVis
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S






Expresion=Forma.ActualizarVista(<T>ActualizarDatos<T>)

[ActualizarDatos]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Actualizar Datos
Clave=ActualizarDatos
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=DM0207ActualizarDatos
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
PermiteEditar=S








ListaEnCaptura=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente<BR>DM0207ACXCConfigAsignacionDiariaTBL.Canal<BR>DM0207ACXCConfigAsignacionDiariaTBL.Nivel<BR>DM0207ACXCConfigAsignacionDiariaTBL.Division<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeDia<BR>DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta<BR>DM0207ACXCConfigAsignacionDiariaTBL.Fecha<BR>DM0207ACXCConfigAsignacionDiariaTBL.Usuario
[ActualizarDatos.Columnas]
TipoCliente=64
Canal=304
Nivel=604
Division=184
TopeDias=64
TopeCuentas=68
Fecha=94
Usuario=64



[Acciones.Cerrar.Eliminar]
Nombre=Eliminar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.CerrarVentana]
Nombre=CerrarVentana
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar.EliminarRegistro]
Nombre=EliminarRegistro
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S

[Acciones.Cerrar.CerrarVenta]
Nombre=CerrarVenta
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=EliminarRegistro<BR>CerrarVenta
Activo=S
Visible=S
NombreEnBoton=S









[Acciones.Actualizacion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0207AID,DM0207AMostrarDatosVIST:DM0207ACXCConfigAsignacionDiariaTBL.IdConfigAsignacionDiaria)
[Acciones.Actualizacion.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Forma.ActualizarVista(<T>ActualizarDatos<T>)
[Acciones.Actualizacion]
Nombre=Actualizacion
Boton=0
NombreDesplegar=&Actualizacion
Multiple=S
EnMenu=S
ListaAccionesMultiples=Expresion<BR>Actualiza
Activo=S
Visible=S



[Acciones.Actualizar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S

Expresion=Asigna(Mavi.DM0207AID,DM0207ActualizarDatos:DM0207ACXCConfigAsignacionDiariaTBL.IdConfigAsignacionDiaria)
[Acciones.Actualizar.Actualiza]
Nombre=Actualiza
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Forma.ActualizarVista(<T>ActualizarDatos<T>)<BR>Forma.ActualizarVista(<T>MostrarDatos<T>)
[Acciones.Guardar.Avanza]
Nombre=Avanza
Boton=0
Carpeta=Datos
TipoAccion=Controles Captura
ClaveAccion=Registro Siguiente
Activo=S
Visible=S



[Datos.DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Datos.DM0207ACXCConfigAsignacionDiariaTBL.Canal]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=7
ColorFondo=Blanco

[Datos.DM0207ACXCConfigAsignacionDiariaTBL.Nivel]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[Datos.DM0207ACXCConfigAsignacionDiariaTBL.Division]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[Datos.DM0207ACXCConfigAsignacionDiariaTBL.Fecha]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Fecha
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
[Datos.DM0207ACXCConfigAsignacionDiariaTBL.Usuario]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Usuario
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Datos.DM0207ACXCConfigAsignacionDiariaTBL.TopeDia]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeDia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=7
[Datos.DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta]
Carpeta=Datos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=7
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Canal]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Canal
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Nivel]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Nivel
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Division]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Division
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TopeDia]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeDia
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Fecha]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Fecha
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Editar=S
[MostrarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Usuario]
Carpeta=MostrarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Usuario
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

Editar=S
[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TipoCliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Canal]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Canal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=7
ColorFondo=Blanco

[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Nivel]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Nivel
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Division]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco

[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TopeDia]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeDia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=7
[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.TopeCuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=7
[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Fecha]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Fecha
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

Tamano=20
[ActualizarDatos.DM0207ACXCConfigAsignacionDiariaTBL.Usuario]
Carpeta=ActualizarDatos
Clave=DM0207ACXCConfigAsignacionDiariaTBL.Usuario
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

