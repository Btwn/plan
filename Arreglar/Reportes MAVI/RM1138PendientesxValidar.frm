[Forma]
Clave=RM1138PendientesxValidar     
Nombre=Validacion de Telefonos     
Icono=240
Modulos=(Todos)
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialIzquierda=481
PosicionInicialArriba=278
PosicionInicialAlturaCliente=126
PosicionInicialAncho=347
BarraAcciones=S
AccionesTamanoBoton=15x5
ListaAcciones=Aceptar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
AccionesCentro=S
ExpresionesAlMostrar=asigna(Mavi.RM1138FechaAnti,<T>3 meses<T>)
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
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PestanaOtroNombre=S
ListaEnCaptura=Mavi.RM1138FechaAnti
PermiteEditar=S
[Lista.Columnas]
Cuenta=64
NombreCliente=604
IngresadoEn=304
Telefono=604
TipoTelefono=66
Resultado=184
FechaCaptura=94
FechaValidacion=94
Observaciones=604
Usuario=64
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Abrir forma]
Nombre=Abrir forma
Boton=0
TipoAccion=Formas
Activo=S
Visible=S
ClaveAccion=RM1138PantallaBusqueda
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreDesplegar=Aceptar
Multiple=S
EnBarraAcciones=S
TipoAccion=Controles Captura
ListaAccionesMultiples=Asignar<BR>Encabezado<BR>Abrir forma
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.Encabezado]
Nombre=Encabezado
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Caso  Mavi.RM1138FechaAnti<BR>  Es <T>3 meses <T> Entonces Asigna(Info.numero,3)<BR>  Es <T>6 meses<T> Entonces Asigna(Info.numero,6)<BR>  Es <T>12 meses<T> Entonces Asigna(Info.numero,12)<BR>  Es <T>1 mes<T> Entonces Asigna(Info.numero,1)<BR>  Es <T>2 meses<T> Entonces Asigna(Info.numero,2) <BR><BR>Fin
[Lista.Mavi.RM1138FechaAnti]
Carpeta=Lista
Clave=Mavi.RM1138FechaAnti
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


