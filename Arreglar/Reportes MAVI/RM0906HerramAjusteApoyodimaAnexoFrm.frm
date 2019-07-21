
[Forma]
Clave=RM0906HerramAjusteApoyodimaAnexoFrm
Icono=36
BarraHerramientas=S
Modulos=(Todos)
Nombre=AJUSTE DE APOYO
AccionesTamanoBoton=15x5
AccionesDerecha=S



ListaAcciones=Asignar<BR>Guardar<BR>Reporte
ListaCarpetas=Filtro<BR>Vista
CarpetaPrincipal=Filtro
PosicionInicialIzquierda=68
PosicionInicialArriba=265
PosicionInicialAlturaCliente=496
PosicionInicialAncho=1082
PosicionSec1=39
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[Acciones.Asignar]
Nombre=Asignar
Boton=82
NombreEnBoton=S
NombreDesplegar=&Cargar Datos
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Cargar
Activo=S
Visible=S

[Filtro]
Estilo=Ficha
Clave=Filtro
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=3
FichaEspacioNombres=53
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=MAVI.RM0906Cliente
CarpetaVisible=S

PermiteEditar=S
[Filtro.MAVI.RM0906Cliente]
Carpeta=Filtro
Clave=MAVI.RM0906Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=RM0906HerramAjusteApoyodimaAnexoVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=CteFinal<BR>NomCteFinal<BR>Documento<BR>Factura<BR>Estatus<BR>Saldo<BR>Cliente
CarpetaVisible=S

IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPaginaEsp=200
IconosSeleccionMultiple=S
IconosNombre=RM0906HerramAjusteApoyodimaAnexoVis:ID
[Vista.CteFinal]
Carpeta=Vista
Clave=CteFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Vista.NomCteFinal]
Carpeta=Vista
Clave=NomCteFinal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco

[Vista.Documento]
Carpeta=Vista
Clave=Documento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Factura]
Carpeta=Vista
Clave=Factura
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Vista.Estatus]
Carpeta=Vista
Clave=Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Saldo]
Carpeta=Vista
Clave=Saldo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Vista.Cliente]
Carpeta=Vista
Clave=Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco

[Vista.Columnas]
0=19
1=-2
2=-2
3=-2
4=-2
5=-2
6=117

7=-2
CteFinal=108
NomCteFinal=304
Documento=124
Factura=124
Estatus=64
Saldo=64
Cliente=64
[Acciones.Asignar.Cargar]
Nombre=Cargar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
EjecucionCondicion=si(Vacio(MAVI.RM0906Cliente),Falso)
EjecucionMensaje=<T>No Selecciono CLIENTE<T>
[Acciones.Asignar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar


[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Registra<BR>Procesar<BR>Actualizar
Activo=S
Visible=S

NombreEnBoton=S
[Acciones.Guardar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Guardar.Registra]
Nombre=Registra
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=RegistrarSeleccion( <T>Vista<T> )
[Acciones.Guardar.Procesar]
Nombre=Procesar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.RM0906NoCorregidos,<BR>        SQL(<BR>              <T>EXEC SPCXCRM0906AjusteApoyoDima <T>+EstacionTrabajo +<T>, <T>+comillas(Usuario)<BR>         )<BR>       )<BR>Fin<BR>//informacion(Mavi.RM0906NoCorregidos)<BR>Si Mavi.RM0906NoCorregidos=7<BR>Entonces<BR>    Error(<T>No se selecciono ningun DOCUMENTO<T>)<BR>Sino<BR>    Si Condatos(Mavi.RM0906NoCorregidos)<BR>       Entonces<BR>           Error(<T>El(Los) registro(s) no puede(n) ser corregido(s) por que esta(n) saldado(s)<T>)<BR>       Fin<BR><BR>Fin
EjecucionCondicion=si(Vacio(MAVI.RM0906Cliente),Falso)
EjecucionMensaje=<T>No Selecciono CLIENTE<T>
[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S


[Acciones.Reporte.Reporte]
Nombre=Reporte
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0906HerramAjusteApoyodimaAnexoRep
Activo=S
Visible=S

[Acciones.Reporte]
Nombre=Reporte
Boton=48
NombreEnBoton=S
NombreDesplegar=Cambios Realizados
Multiple=S
EnBarraHerramientas=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0906HerramientaAjusteApoyoCobranzadimaAnexoRep
ListaAccionesMultiples=Reporte
Activo=S
Visible=S

