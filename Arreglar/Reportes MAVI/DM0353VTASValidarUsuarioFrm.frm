
[Forma]
Clave=DM0353VTASValidarUsuarioFrm
Icono=726
Modulos=(Todos)

ListaCarpetas=validarUsr
CarpetaPrincipal=validarUsr
PosicionInicialAlturaCliente=129
PosicionInicialAncho=301
PosicionInicialIzquierda=464
PosicionInicialArriba=455
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cancelar<BR>cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Nombre=Autenticar Usuario
VentanaSiempreAlFrente=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.RM0353Usuario,<T><T>)<BR>Asigna(Mavi.RM0353Password,<T><T>)<BR>Asigna(Info.Respuesta3,<T><T>)
[validarUsr]
Estilo=Ficha
Clave=validarUsr
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
ListaEnCaptura=Mavi.RM0353Usuario<BR>Mavi.RM0353Password
CarpetaVisible=S

[validarUsr.Mavi.RM0353Password]
Carpeta=validarUsr
Clave=Mavi.RM0353Password
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

EspacioPrevio=S
[validarUsr.Mavi.RM0353Usuario]
Carpeta=validarUsr
Clave=Mavi.RM0353Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

EspacioPrevio=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=Autenticar
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S

Multiple=S
ListaAccionesMultiples=asignar<BR>validar
[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[Acciones.Aceptar.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.validar]
Nombre=validar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S







ConCondicion=S
EjecucionConError=S
Expresion=si Info.Respuesta3 <><T>NoAutenticado<T><BR>entonces<BR>si<BR>    SQL(<T>SELECT COUNT(0) FROM Usuario WITH(NOLOCK) WHERE Usuario = :tUsu AND Contrasena = :tPass<T>,Mavi.RM0353Usuario,MD5(Mavi.RM0353Password,<T>p<T>))=1<BR>    entonces<BR>        Asigna(Info.Respuesta3,<T>NoAutenticado<T>)<BR>        Asigna(Mavi.RM0353Usuario,<T><T>)<BR>        Asigna(Mavi.RM0353Password,<T><T>)<BR>        ActualizarVista<BR>        Informacion(<T>Ingrese usuario y contraseña de destino<T>)<BR>        AbortarOperacion<BR>    sino<BR>        Error(<T>Usuario o contraseña de origen incorrecto<T>,BotonAceptar)<BR>        AbortarOperacion<BR>    Fin<BR>sino<BR>    si<BR>    SQL(<T>SELECT COUNT(0) FROM Usuario WITH(NOLOCK) WHERE Usuario = :tUsu<BR>    AND Contrasena = :tPass AND defCtaDinero = :tCtaDestino AND Estatus=:tEst<T>,Mavi.RM0353Usuario,MD5(Mavi.RM0353Password,<T>p<T>),Info.Respuesta2,<T>alta<T>)=1<BR>    entonces<BR>        Asigna(Info.Respuesta3,<T>Autenticado2<T>)<BR>        Forma.Accion(<T>cerrar<T>)<BR>    sino<BR>        Error(<T>Usuario o contraseña de destino incorrecto<T>,BotonAceptar)<BR>        AbortarOperacion<BR>    fin<BR>Fin
EjecucionCondicion=ConDatos(Mavi.RM0353Usuario) y ConDatos(Mavi.RM0353Password)
EjecucionMensaje=<T>Ingrese datos en los campos Usuario y Password<T>
[Acciones.cerrar]
Nombre=cerrar
Boton=0
NombreDesplegar=cerrar
EnBarraAcciones=S
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S

