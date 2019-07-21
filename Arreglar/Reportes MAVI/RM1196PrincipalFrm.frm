
[Forma]
Clave=RM1196PrincipalFrm
Icono=0
Modulos=(Todos)
Nombre=Ventana Principal para CFDI´s

ListaCarpetas=consultar
CarpetaPrincipal=consultar
PosicionInicialAlturaCliente=97
PosicionInicialAncho=282
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=500
PosicionInicialArriba=319
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
ExpresionesAlMostrar=Asigna( Mavi.RM1196Consultar, nulo )
[consultar]
Estilo=Ficha
Clave=consultar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.RM1196Consultar
CarpetaVisible=S

PermiteEditar=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
[consultar.Mavi.RM1196Consultar]
Carpeta=consultar
Clave=Mavi.RM1196Consultar
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Aceptar.Forma]
Nombre=Forma
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S

Expresion=Si<BR>  Condatos(Mavi.RM1196Consultar)<BR>Entonces<BR>      Si<BR>           (Mavi.RM1196Consultar)= <T>Auditoria a los CFDIs<T><BR>        Entonces<BR>           Forma( <T>RM1196ReporteAuditoriaCFDIFrm<T> )<BR>        Sino<BR>             Forma(<T>RM1196FiltrosCFDIGlobalesFrm<T>)<BR>        Fin<BR>Sino<BR>  Informacion(<T>Favor de Especificar Tipo de Consulta<T>)<BR>Fin
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Asignar<BR>Forma<BR>Aceptar
Activo=S
Visible=S

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S


