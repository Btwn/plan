[Forma]
Clave=RM1142NumSmsFrm
Nombre=Configuracion de No Sms
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=83
PosicionInicialAncho=185
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Guardar
AccionesCentro=S
PosicionInicialIzquierda=547
PosicionInicialArriba=451
ExpresionesAlMostrar=Asigna(Mavi.RM1142NumSms,SQL(<T>SELECT numero FROM TablaNumD WITH(NOLOCK) WHERE TablaNum = :tnumero <T>, <T>#Smsxmes<T>))
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
ListaEnCaptura=Mavi.RM1142NumSms
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaAlineacion=Centrado
PermiteEditar=S
[(Variables).Mavi.RM1142NumSms]
Carpeta=(Variables)
Clave=Mavi.RM1142NumSms
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Asigna(Info.Numero, SQL(<T>SELECT COUNT(*) FROM TablaNumD WHERE TablaNum = <T>+Comillas(<T>#Smsxmes<T>)))<BR>Si Info.Numero = 0<BR>Entonces<BR>    EjecutarSQL(<T>EXEC SP_RM1142ConfigMaxSms :n, <T>+Comillas(<T>INSERTAR<T>), Mavi.RM1142NumSms)<BR>Sino<BR>    EjecutarSQL(<T>EXEC SP_RM1142ConfigMaxSms :n, <T>+Comillas(<T>ACTUALIZA<T>), Mavi.RM1142NumSms)<BR>Fin
EjecucionCondicion=Si Mavi.RM1142NumSms > 0<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>Ingrese un número mayor a 0.<T>)<BR>    AbortarOperacion<BR>Fin<BR><BR>Si Mavi.RM1142NumSms < 100<BR>Entonces<BR>    Verdadero<BR>Sino<BR>    Error(<T>Ingrese una cantidad menor para mensajes a enviar por mes.<T>)<BR>    AbortarOperacion<BR>Fin
[Acciones.Guardar]
Nombre=Guardar
Boton=0
NombreDesplegar=Guardar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Asignar<BR>Guarda<BR>Cerrar
Activo=S
Visible=S
[Acciones.Guardar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


