[Forma]
Clave=RM1078EnvioCV73RepAsciiFrm
Nombre=RM1078 SSJ
Icono=0
Modulos=(Todos)
ListaCarpetas=Mavi.RM1078Subdependencias
CarpetaPrincipal=Mavi.RM1078Subdependencias
PosicionInicialIzquierda=370
PosicionInicialArriba=146
PosicionInicialAlturaCliente=105
PosicionInicialAncho=258
AccionesTamanoBoton=15x5
BarraAcciones=S
AccionesCentro=S
ListaAcciones=Enviar
[Mavi.RM1078Subdependencias]
Estilo=Ficha
Clave=Mavi.RM1078Subdependencias
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
ListaEnCaptura=Mavi.RM1078Subdependencias
CarpetaVisible=S
[Mavi.RM1078Subdependencias.Mavi.RM1078Subdependencias]
Carpeta=Mavi.RM1078Subdependencias
Clave=Mavi.RM1078Subdependencias
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Enviar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Enviar]
Nombre=Enviar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Enviar
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=Variables Asignar<BR>Enviar
Activo=S
Visible=S
[Acciones.Enviar.Enviar]
Nombre=Enviar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=si<BR> condatos(Mavi.RM1078Subdependencias)<BR> entonces<BR>     si<BR>         Mavi.RM1078Subdependencias =<T>Federal<T><BR>     entonces<BR>          ReporteImpresora( <T>RM1078EnvioCV73FedRep<T> )<BR>     fin<BR>     si<BR>         Mavi.RM1078Subdependencias =<T>Regularizado<T><BR>     entonces<BR>           ReporteImpresora( <T>RM1078EnvioCV73RegRep<T> )<BR>     fin<BR>     si<BR>         Mavi.RM1078Subdependencias =<T>Otros...<T><BR>     entonces<BR>          ReporteImpresora( <T>RM1078EnvioCV73OtroRep<T> )<BR>     fin<BR>     si<BR>         Mavi.RM1078Subdependencias en (<T>Estatal<T>)<BR>     entonces<BR>         ReporteImpresora( <T>RM1078EnvioCV73EstRep<T> )<BR>     fin<BR> fin
