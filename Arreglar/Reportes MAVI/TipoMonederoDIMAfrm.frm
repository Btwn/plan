[Forma]
Clave=TipoMonederoDIMAfrm
Nombre=Tipo de Monedero
Icono=92
Modulos=(Todos)
ListaCarpetas=Tipo
CarpetaPrincipal=Tipo
PosicionInicialIzquierda=440
PosicionInicialArriba=373
PosicionInicialAlturaCliente=76
PosicionInicialAncho=275
EsConsultaExclusiva=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
AccionesDivision=S
VentanaExclusiva=S
ExpresionesAlMostrar=//Asigna(Info.ID,3143582)<BR>//informacion(SQL(<T>SELECT EnviarA FROM Venta WITH(NOLOCK) WHERE ID = <T>+ Info.ID))<BR>Asigna(Mavi.ServicasaModulo,0)<BR>Si<BR>  (SQL(<T>SELECT EnviarA FROM Venta WITH(NOLOCK) WHERE ID = <T>+ Info.ID)<> 76)<BR>Entonces<BR>  Asigna(Mavi.TipoMoneDima,<T>NORMAL<T>)<BR>Sino<BR>  Asigna(Mavi.TipoMoneDima,<T>VIRTUAL<T>)<BR>Fin
[Tipo]
Estilo=Ficha
Clave=Tipo
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=3
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Derecha
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.TipoMoneDima
CarpetaVisible=S
[Tipo.Mavi.TipoMoneDima]
Carpeta=Tipo
Clave=Mavi.TipoMoneDima
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Expresion
ListaAccionesMultiples=Asignar<BR>Acep<BR>VentanaAceptar
Activo=S
Visible=S
Antes=S
AntesExpresiones=Si<BR>  Mavi.ServicasaModulo <> 0<BR>Entonces<BR>  Abortaroperacion<BR>Fin
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.VentanaAceptar]
Nombre=VentanaAceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.Acep]
Nombre=Acep
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si<BR>  Mavi.TipoMoneDima = <T>NORMAL<T><BR>Entonces<BR>  Forma(<T>TarjetaSerieRedimNormalFrm<T>)<BR>Sino<BR>  Forma(<T>TarjetaSerieMovMAVIRedimirVitual<T>)<BR>Fin

