[Forma]
Clave=DM0277ValidaUsuarioFrm
Nombre=Validación de Usuario
Icono=357
Modulos=(Todos)
PosicionInicialAlturaCliente=107
PosicionInicialAncho=262
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=509
PosicionInicialArriba=439
AccionesTamanoBoton=15x5
ListaAcciones=Validar<BR>Cerrar
BarraAcciones=S
AccionesCentro=S
ExpresionesAlMostrar=Asigna(Mavi.DM0277ValidaUsuario,<T><T>)<BR>Asigna(Mavi.DM0277ValidaContra,<T><T>)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0277ValidaUsuario<BR>Mavi.DM0277ValidaContra
CarpetaVisible=S
FichaEspacioEntreLineas=3
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaNombres=Izquierda
FichaAlineacion=Centrado
FichaEspacioNombresAuto=S
FichaAlineacionDerecha=S
PermiteEditar=S
[Acciones.Validar]
Nombre=Validar
Boton=29
NombreEnBoton=S
NombreDesplegar=&Validar
Activo=S
Visible=S
EnBarraAcciones=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=Asignar<BR>Expresion<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraAcciones=S
[Acciones.Validar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Validar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>   Vacio(Mavi.DM0277ValidaUsuario)<BR>Entonces<BR>    Informacion(<T>EL CAMPO USUARIO ESTA VACIO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Si<BR>        Vacio(Mavi.DM0277ValidaContra)<BR>    Entonces<BR>        Informacion(<T>EL CAMPO CONTRASEÑA ESTA VACIO<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Si<BR>            SQL(<T>SELECT Contrasena FROM Usuario WHERE Usuario=<T>+Comillas(Mavi.DM0277ValidaUsuario)) = MD5(Mavi.DM0277ValidaContra,<T>p<T>)<BR>        Entonces<BR>             Verdadero<BR>             Si<BR>                SQL(<T>SELECT U.Contrasena FROM Usuario U INNER JOIN TablaStD D ON  U.Acceso = D.Nombre WHERE D.Nombre =<T>+Comillas(<T>AUDCC_GERA<T>)<BR>                +<T>AND U.Usuario=<T>+Comillas(Mavi.DM0277ValidaUsuario)) = MD5(Mavi.DM0277ValidaContra,<T>p<T>)<BR>          <CONTINUA>
Expresion002=<CONTINUA>  Entonces<BR>                EjecutarSQLAnimado( <T>EXEC SP_DM0277AccionesFormaPrincipal <T> + Comillas( ASCII( 39 )+ Mavi.DM0277Seleccion + ASCII(39)) + <T>,<T> + 1 +<T><T> )<BR>                Informacion(<T>PROCESO REALIZADO CON EXITO<T>)<BR>                Verdadero<BR>            Sino<BR>                Error(<T>NO TIENE PERMISOS PARA REALIZAR EL QUEBRANTO<T>)<BR>                AbortarOperacion<BR>            Fin<BR>        Sino<BR>             Error(<T>USUARIO O CONTRASEÑA INCORRECTOS<T>)<BR>             AbortarOperacion<BR>        Fin<BR>    Fin<BR>Fin
[Acciones.Validar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.DM0277ValidaUsuario]
Carpeta=(Variables)
Clave=Mavi.DM0277ValidaUsuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[(Variables).Mavi.DM0277ValidaContra]
Carpeta=(Variables)
Clave=Mavi.DM0277ValidaContra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


