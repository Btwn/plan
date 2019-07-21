[Forma]
Clave=DM0255ValidaCorteFrm
Nombre=Valida Corte de Caja    
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
BarraAcciones=S
AccionesTamanoBoton=15x5
PosicionInicialAlturaCliente=141
PosicionInicialAncho=244
ListaCarpetas=CorteCaja
CarpetaPrincipal=CorteCaja
AccionesCentro=S
PosicionInicialIzquierda=87
PosicionInicialArriba=197
ListaAcciones=Aceptar<BR>Cancelar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0255CxcValidaUsuario, <T><T>  )<BR>Asigna( Mavi.DM0255CxcValidaContrasena, <T><T> )
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[CorteCaja]
Estilo=Ficha
Clave=CorteCaja
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0255CxcValidaUsuario<BR>Mavi.DM0255CxcValidaContrasena
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaAlineacion=Centrado
PermiteEditar=S
FichaNombres=Arriba
[Acciones.Aceptar.Valida]
Nombre=Valida
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=EjecutarSQL(<T>EXEC dbo.SP_DM0255CorteCaja :tUsuario,:tUsuarioAutorizo,:tMov,:tMovID<T>,  Usuario, Mavi.DM0255CxcValidaUsuario, Info.Mov, Info.MovID)
EjecucionCondicion=Si<BR>   Vacio(Mavi.DM0255CxcValidaUsuario)<BR>Entonces<BR>  Informacion( <T>El Campo Usuario Esta Vacio<T> )<BR>   //AbortarOperacion<BR>Sino<BR>   Si<BR>       Vacio(Mavi.DM0255CxcValidaContrasena)<BR>    Entonces<BR>       Informacion( <T>El Campo Contraseña Esta Vacio<T> )<BR>      // AbortarOperacion<BR>    Sino<BR>       Si<BR>          SQL(<T>Select dbo.FN_DM0255ValidaUsuarioContraseña (:tUsuario,:tContrasena)<T>, Mavi.DM0255CxcValidaUsuario,  MD5( Mavi.DM0255CxcValidaContrasena,<T>p<T>)) = 1<BR>        Entonces<BR>            SQL(<T>Select dbo.FN_DM055ComprobarPermisos (:tUsuario,:tContrasena)<T>,Mavi.DM0255CxcValidaUsuario,  MD5( Mavi.DM0255CxcValidaContrasena,<T>p<T>)) = 1<BR>       Sino<BR>           Informacion( <T>Usuario y/o contraseña Invalidos<T> )<BR>           //AbortarOperacion<BR>     <CONTINUA>
EjecucionCondicion002=<CONTINUA>  Fin               <BR>    Fin<BR>Fin
EjecucionMensaje=<T>No tienes permiso para cancelar. Llamar a un Gerente o Supervisor de Piso.<T>
[CorteCaja.Mavi.DM0255CxcValidaContrasena]
Carpeta=CorteCaja
Clave=Mavi.DM0255CxcValidaContrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CorteCaja.Mavi.DM0255CxcValidaUsuario]
Carpeta=CorteCaja
Clave=Mavi.DM0255CxcValidaUsuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Dinero.Dinero.Mov]
Carpeta=Dinero
Clave=Dinero.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Dinero.Dinero.MovID]
Carpeta=Dinero
Clave=Dinero.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Dinero.Columnas]
Mov=124
MovID=64
[Money.Dinero.Mov]
Carpeta=Money
Clave=Dinero.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Money.Dinero.MovID]
Carpeta=Money
Clave=Dinero.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Money.Columnas]
Mov=124
MovID=64
[Acciones.Aceptar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
ConCondicion=S
EjecucionConError=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC dbo.SP_DM0255CorteCaja :tUsuario,:tUsuarioAutorizo,:nId<T>,  Usuario, Mavi.DM0255CxcValidaUsuario, Info.ano)
EjecucionCondicion=Si<BR>   Vacio(Mavi.DM0255CxcValidaUsuario)<BR>Entonces<BR>  Informacion( <T>El Campo Usuario Esta Vacio<T> )<BR>   AbortarOperacion<BR>Sino<BR>   Si<BR>       Vacio(Mavi.DM0255CxcValidaContrasena)<BR>    Entonces<BR>       Informacion( <T>El Campo Contraseña Esta Vacio<T> )<BR>      AbortarOperacion<BR>    Sino<BR>       Si<BR>       SQL(<T>Select dbo.FN_DM0255ValidaUsuarioContraseña (:tUsuario,:tContrasena)<T>, Mavi.DM0255CxcValidaUsuario,  MD5( Mavi.DM0255CxcValidaContrasena,<T>p<T>)) = 1<BR>        Entonces<BR>            Si<BR>            SQL(<T>Select dbo.FN_DM0255ComprobarPermisos (:tUsuario,:tContrasena)<T>,Mavi.DM0255CxcValidaUsuario,  MD5( Mavi.DM0255CxcValidaContrasena,<T>p<T>)) = 1<BR>             Entonces<BR>               Asigna(Info.Respuesta1, <T>Si<T>)<BR>            Sino<BR>            E<CONTINUA>
EjecucionCondicion002=<CONTINUA>rror( <T>No tienes permiso para realizar el corte de caja. Llamar a un Gerente o Supervisor de Piso.<T>,  BotonAceptar  )<BR>            AbortarOperacion<BR>            Fin<BR>       Sino<BR>           Informacion( <T>Usuario y/o contraseña Invalidos<T> )<BR>           AbortarOperacion<BR>       Fin<BR>    Fin                                                                 <BR>Fin
EjecucionMensaje=<T>No tienes permiso para realizar el corte de caja. Llamar a un Gerente o Supervisor de Piso.<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Asigna<BR>Expresion<BR>Close
Activo=S
Visible=S
NombreEnBoton=S
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
[Acciones.Aceptar.Close]
Nombre=Close
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


