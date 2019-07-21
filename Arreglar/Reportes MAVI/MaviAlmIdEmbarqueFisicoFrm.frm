[Forma]
Clave=MaviAlmIdEmbarqueFisicoFrm
Nombre=Embarque
Icono=602
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Cerrar
VentanaTipoMarco=Normal
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
PosicionInicialAlturaCliente=74
PosicionInicialAncho=166
PosicionInicialIzquierda=32
PosicionInicialArriba=30
VentanaSinIconosMarco=S
ExpresionesAlMostrar=Asigna(Mavi.AlmacenIdEmbarque,nulo)<BR>Asigna(Info.Mov,nulo)
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
ListaEnCaptura=Mavi.AlmacenIdEmbarque
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[(Variables).Mavi.AlmacenIdEmbarque]
Carpeta=(Variables)
Clave=Mavi.AlmacenIdEmbarque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Forma]
Nombre=Forma
Boton=0
TipoAccion=Formas
ClaveAccion=MaviAlmDetalleFisicoEmbarqueFrm
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=((condatos(Info.Mov)) y ((Info.Situacion=<T>Pasa a Escanear<T>) o ((Info.Situacion=<T>Revision de Escaneo<T>)) o ((Info.Situacion=<T>Completar<T>))))
EjecucionMensaje=<T>Embarque no registrado/Situacion Incorrecta<T>
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreDesplegar=<T>&Aceptar <T>
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=AsignaValores<BR>AsignaMov<BR>Forma<BR>AsignarMas<BR>Cerrar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Aceptar.AsignaMov]
Nombre=AsignaMov
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Mov,(Sql(<T>Select Mov from Embarque Where Id=:nval1<T>,Mavi.AlmacenIdEmbarque)))<BR>Asigna(Info.Situacion,(Sql(<T>Select Situacion from Embarque Where Id=:nval1<T>,Mavi.AlmacenIdEmbarque)))
[Acciones.Aceptar.AsignaValores]
Nombre=AsignaValores
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=<T>Cerrar <T>
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar.AsignarMas]
Nombre=AsignarMas
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
