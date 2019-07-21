
[Forma]
Clave=DM0239ContraSegFrm
Icono=639
Modulos=(Todos)
Nombre=Autorizacion

ListaCarpetas=rama
CarpetaPrincipal=rama
PosicionInicialIzquierda=467
PosicionInicialArriba=436
PosicionInicialAlturaCliente=113
PosicionInicialAncho=346
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Validar<BR>Cancelar
AccionesIzq=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaSiempreAlFrente=S
VentanaBloquearAjuste=S
VentanaExclusiva=S
VentanaExclusivaOpcion=2
[rama]
Estilo=Ficha
Clave=rama
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
CarpetaVisible=S
ListaEnCaptura=Mavi.DM0239Usuario<BR>Mavi.DM0239Contra

InicializarVariables=S
[rama.Mavi.DM0239Usuario]
Carpeta=rama
Clave=Mavi.DM0239Usuario
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[rama.Mavi.DM0239Contra]
Carpeta=rama
Clave=Mavi.DM0239Contra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


[Acciones.Cancelar]
Nombre=Cancelar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Validar]
Nombre=Validar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Validar
Multiple=S
EnBarraAcciones=S
EspacioPrevio=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Expresion<BR>cerrar
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

Expresion=Si<BR>   Vacio(Mavi.DM0239Usuario)<BR>Entonces<BR>    Informacion(<T>EL CAMPO USUARIO ESTA VACIO<T>)<BR>    AbortarOperacion<BR>Sino<BR>    Si<BR>        Vacio(Mavi.DM0239Contra)<BR>    Entonces<BR>        Informacion(<T>EL CAMPO CONTRASEÑA ESTA VACIO<T>)<BR>        AbortarOperacion<BR>    Sino<BR>        Asigna(Info.Dato,<T>NO<T>)<BR>        Si<BR>            (SQL(<T>SELECT COUNT(*) FROM Usuario U<BR>                WHERE U.Usuario = :tUsuario AND U.Contrasena=:tContrasena<T>,Mavi.DM0239Usuario, MD5(Mavi.DM0239Contra,<T>p<T>))= 1)<BR>        Entonces<BR>          Caso Info.Numero<BR>            Es 1 Entonces//Agregar segmento<BR>                Si<BR>                SQL(<T>SELECT COUNT(P.PerfilAcceso) FROM INVCPerfilesUsuario P JOIN Usuario U ON P.PerfilAcceso = U.Acceso<BR>                WHERE P.PermSegmento = 1 AND U.Usuario = :tUsu<T>,Mavi.DM0239Usuario) > 0<BR>                Entonces<BR>                    EjecutarSQL(<T>EXEC SpINVConfDistribucion :tSeg, :nOpcion, :tLin<T>,Mavi.DM0239CrearSeg,Info.Numero,Nulo)<BR>                    Informacion(<T>SE AGREGO EL SEGMENTO CON EXITO<T>)<BR>                    Forma(<T>DM0239CrearSegmentosFrm<T>)<BR>                    Asigna(Info.Dato,<T>SI<T>)<BR>                Sino<BR>                    Error(<T>NO TIENE PERMISOS PARA CREAR SEGMENTOS<T>)<BR><BR>                Fin<BR>            Es 2 Entonces//Asignar linea<BR>                Si<BR>                SQL(<T>SELECT COUNT(P.PerfilAcceso) FROM INVCPerfilesUsuario P JOIN Usuario U ON P.PerfilAcceso = U.Acceso<BR>                WHERE P.PermLineas = 1 AND U.Usuario = :tUsu<T>,Mavi.DM0239Usuario) > 0<BR>                Entonces<BR>                    EjecutarSQL(<T>EXEC SpINVConfDistribucion <T>+COMILLAS(Mavi.DM0239Segmentos)+<T>,<T>+Info.Numero+<T>,<T>+Reemplaza(Comillas(<T>,<T>), <T>,<T>, Mavi.DM0239Linea)))<BR>                    Informacion(<T>SE ASIGNO LA(S) LINEA(S) CON EXITO<T>)<BR>                    Asigna(Info.Dato,<T>SI<T>)<BR>                Sino<BR>                    Error(<T>NO TIENE PERMISOS PARA ASIGNAR LINEAS<T>)<BR>                Fin<BR>           )<BR>            Es 3 Entonces//Desasignar linea<BR>                Si<BR>                SQL(<T>SELECT COUNT(P.PerfilAcceso) FROM INVCPerfilesUsuario P JOIN Usuario U ON P.PerfilAcceso = U.Acceso<BR>                WHERE P.PermLineas = 1 AND U.Usuario = :tUsu<T>,Mavi.DM0239Usuario) > 0<BR>                Entonces<BR>                    EjecutarSQL(<T>EXEC SpINVConfDistribucion <T>+COMILLAS(Mavi.DM0239Segmentos)+<T>,<T>+Info.Numero+<T>,<T>+Reemplaza(Comillas(<T>,<T>), <T>,<T>, Mavi.DM0239Linea)))<BR>                    Informacion(<T>SE DESASIGNO LA(S) LINEA(S) CON EXITO<T>)<BR>                    Asigna(Info.Dato,<T>SI<T>)<BR>                Sino<BR>                    Error(<T>NO TIENE PERMISOS PARA DESASIGNAR LINEAS<T>)<BR>                Fin<BR><BR>            Es 4 Entonces //Eliminar segmento<BR>              Si<BR>                SQL(<T>SELECT COUNT(P.PerfilAcceso) FROM INVCPerfilesUsuario P JOIN Usuario U ON P.PerfilAcceso = U.Acceso<BR>                WHERE P.PermSegmento = 1 AND U.Usuario = :tUsu<T>,Mavi.DM0239Usuario) > 0<BR>                Entonces<BR>                    EjecutarSQL(<T>EXEC SpINVConfDistribucion :tSeg, :nOpcion, :tLin<T>,Mavi.DM0239Segmentos,Info.Numero,Nulo)<BR>                    Informacion(<T>SE ELIMINO EL SEGMENTO CON EXITO<T>)<BR>                    Asigna(Info.Dato,<T>SI<T>)<BR>                Sino<BR>                    Error(<T>NO TIENE PERMISOS PARA ELIMINAR SEGMENTOS<T>)<BR><BR>                Fin<BR>            Fin<BR>        Sino<BR>        Error(<T>USUARIO O CONTRASEÑA INCORRECTA<T>)<BR>        Fin<BR>    Fin<BR>Fin
[Acciones.Validar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




ConCondicion=S
EjecucionCondicion=Si<BR>  Info.Dato = <T>SI<T><BR>Entonces<BR>  verdadero<BR>Sino<BR>  falso<BR>Fin



