[Forma]
Clave=DM0125ValidaConclusionEmba
Icono=357
Modulos=(Todos)
ListaCarpetas=variables
CarpetaPrincipal=variables
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=465
PosicionInicialArriba=422
PosicionInicialAlturaCliente=134
PosicionInicialAncho=349
Nombre=DM0125Validaci�n de usuario
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Expresion<BR>Cerrar
AccionesCentro=S
VentanaBloquearAjuste=S
ExpresionesAlMostrar=Asigna(Mavi.DM0125Usuario,<T><T>)<BR>Asigna(Mavi.DM0125Contrasena,<T><T>)
[variables]
Estilo=Ficha
Clave=variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=8
FichaEspacioNombres=100
FichaColorFondo=Plata
ListaEnCaptura=Mavi.DM0125Usuario<BR>Mavi.DM0125Contrasena
FichaNombres=Izquierda
FichaAlineacion=Centrado
PermiteEditar=S
[variables.Mavi.DM0125Usuario]
Carpeta=variables
Clave=Mavi.DM0125Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[variables.Mavi.DM0125Contrasena]
Carpeta=variables
Clave=Mavi.DM0125Contrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Asigna(Mavi.DM0125BanderaEmb,<T>VERDADERO<T>)
[Acciones.Expresion.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Expresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=INFORMACION(<T>Validaci�n correcta, puede continuar...<T>)
EjecucionCondicion=Si<BR>   Vacio(Mavi.DM0125Usuario)<BR>Entonces<BR>    Informacion(<T>El campo usuario esta vacio<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Si<BR>        Vacio(Mavi.DM0125Contrasena)<BR>    Entonces<BR>        Informacion(<T>El campo contrase�a esta vacio<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Si<BR>            SQL(<T>SELECT Contrasena FROM Usuario WHERE Usuario=<T>+Comillas(Mavi.DM0125Usuario)) = MD5(Mavi.DM0125Contrasena,<T>p<T>)<BR>        Entonces                                                        <BR>             Si<BR>                SQL(<T>SELECT U.Contrasena FROM Usuario U INNER JOIN TablaStD D ON U.ACCESO=D.NOMBRE WHERE D.TablaSt =<T>+Comillas(<T>QUITAR ORDEN EMBARQUES<T>)<BR>               +<T>And U.Estatus=<T>+comillas(<T>Alta<T>) +<T>AND U.Usuario=<T>+Comillas(Mavi.<CONTINUA>
EjecucionCondicion002=<CONTINUA>DM0125Usuario)) = MD5(Mavi.DM0125Contrasena,<T>p<T>)<BR>            Entonces<BR>                Verdadero<BR>                Asigna(Mavi.DM0125BanderaEmb,<T>FALSO<T>)<BR>            Sino<BR>                Error(<T>El usuario no tiene permisos para concluir un embarque con transitos pendientes.<T>)<BR>                AbortarOperacion<BR>            Fin<BR>        Sino<BR>             Error(<T>Usuario � Contrase�a Incorrectos<T>)<BR>             AbortarOperacion<BR>        Fin<BR>    Fin<BR>Fin
[Acciones.Expresion.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Expresion]
Nombre=Expresion
Boton=29
NombreEnBoton=S
NombreDesplegar=Validar
Multiple=S
EnBarraAcciones=S
TipoAccion=Expresion
ListaAccionesMultiples=Asigna<BR>Expresion<BR>Cerrar
Activo=S
Visible=S


