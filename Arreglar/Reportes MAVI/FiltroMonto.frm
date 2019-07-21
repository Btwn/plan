[Forma]
Clave=FiltroMonto
Nombre=Filtro Monto
Icono=0
Plantillas=S
Modulos=(Todos)
MovModulo=(Todos)
PermiteCopiarDoc=S
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=101
PosicionInicialAncho=331
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
PosicionInicialIzquierda=517
PosicionInicialArriba=314
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna( Info.Cantidad, 0 )<BR> Asigna( Info.Valor, 0 )
[Lista]
Estilo=Ficha
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Cantidad<BR>Info.Valor
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Lista.Info.Cantidad]
Carpeta=Lista
Clave=Info.Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Info.Valor]
Carpeta=Lista
Clave=Info.Valor
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
OcultaNombre=S
[Acciones.Aceptar.AsignarVaraibles]
Nombre=AsignarVaraibles
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Cadena]
Nombre=Cadena
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Info.Cantidad > 0<BR>Entonces<BR>    Si<BR>      Info.Valor > 0<BR>    Entonces<BR>        Si<BR>            Info.Cantidad > Info.Valor<BR>        Entonces<BR>            Asigna( Info.Filtro, <T> AND 1=1<T> )<BR>        Sino<BR>            Asigna( Info.Filtro, <T> AND CFDValido.Monto >= <T>& {Info.Cantidad} & <T> AND CFDValido.Monto <= <T> & {Info.Valor} )<BR>        Fin<BR>    Sino<BR>      Asigna( Info.Filtro, <T> AND CFDValido.Monto >= <T>& {Info.Cantidad} )                        <BR>    Fin<BR>Sino<BR>    Si<BR>        Info.Valor > 0<BR>    Entonces<BR>        Asigna( Info.Filtro, <T> AND CFDValido.Monto <= <T>& {Info.Valor} )<BR>    Sino<BR>        Asigna( Info.Filtro, <T> <T> )<BR>    Fin<BR>Fin
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
ConCondicion=S
Visible=S
EjecucionConError=S
EjecucionCondicion=Info.Filtro <> <T> AND 1=1<T>
EjecucionMensaje=<T>La cantidad de la izquierda no puede ser mayor a la cantidad de la derecha o alguna de las dos debe ser cero<T>
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignarVaraibles<BR>Cadena<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S


