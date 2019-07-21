
[Forma]
Clave=ReporteFinalBuro
Icono=0
Modulos=(Todos)
Nombre=Reporte Final Buro

ListaCarpetas=Variables
CarpetaPrincipal=Variables
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=(Lista)
AccionesCentro=S
AccionesDivision=S
PosicionInicialIzquierda=527
PosicionInicialArriba=313
PosicionInicialAlturaCliente=140
PosicionInicialAncho=226
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
[Variables]
Estilo=Ficha
Clave=Variables
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
ListaEnCaptura=(Lista)

CarpetaVisible=S

[Variables.Info.Periodo]
Carpeta=Variables
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Variables.Info.Ejercicio]
Carpeta=Variables
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraAcciones=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S






[Acciones.DesactivaEnvio.GuardarVar]
Nombre=GuardarVar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.DesactivaEnvio.EjecDesactiva]
Nombre=EjecDesactiva
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=EjecutarSQL(<T>spFacturasDesactivadasBuro :nejercicio, :nperiodo<T>, info.ejercicio, info.periodo)<BR>EjecutarSQL(<T>spDesactivaEnvioBuroMaviCtaInc :nejercicio, :nperiodo<T>, info.ejercicio, info.periodo)<BR>EjecutarSQL(<T>spDesactivaEnvioBuroMavi :nejercicio, :nperiodo<T>, info.ejercicio, info.periodo)
[Acciones.DesactivaEnvio]
Nombre=DesactivaEnvio
Boton=40
NombreDesplegar=&Desactivar Envio Buro
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S
NombreEnBoton=S




[Acciones.DesactivaEnvio.ListaAccionesMultiples]
(Inicio)=GuardarVar
GuardarVar=EjecDesactiva
EjecDesactiva=(Fin)


[Variables.ListaEnCaptura]
(Inicio)=Info.Ejercicio
Info.Ejercicio=Info.Periodo
Info.Periodo=(Fin)







[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cancelar
Cancelar=DesactivaEnvio
DesactivaEnvio=(Fin)

