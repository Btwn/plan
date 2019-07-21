
[Forma]
Clave=RM1182VtasTelemarketingFrm
Icono=22
Modulos=(Todos)

ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=392
PosicionInicialArriba=282
PosicionInicialAlturaCliente=124
PosicionInicialAncho=668
Nombre=Telemarketing
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Mavi.RM1182DiasVencidosD<BR>Mavi.RM1182DiasVencidosA<BR>Mavi.RM1182DiasInactivoD<BR>Mavi.RM1182DiasInactivoA<BR>Mavi.RM1182CanalTelemarketing
CarpetaVisible=S

PermiteEditar=S
InicializarVariables=S
[(Variables).Mavi.RM1182CanalTelemarketing]
Carpeta=(Variables)
Clave=Mavi.RM1182CanalTelemarketing
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[RM1182VtasCanalVentaPrin.Columnas]
0=-2

1=-2
[(Variables).Mavi.RM1182DiasVencidosD]
Carpeta=(Variables)
Clave=Mavi.RM1182DiasVencidosD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1182DiasVencidosA]
Carpeta=(Variables)
Clave=Mavi.RM1182DiasVencidosA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Acciones.Preliminar]
Nombre=Preliminar
Boton=68
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Activo=S
Visible=S

NombreEnBoton=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Asignar<BR>Aceptar
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=ConDatos(Mavi.RM1182CanalTelemarketing)
EjecucionMensaje=informacion(<T>El campo de canal es obligatorio<T>)
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S

[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Preliminar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

[(Variables).Mavi.RM1182DiasInactivoD]
Carpeta=(Variables)
Clave=Mavi.RM1182DiasInactivoD
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM1182DiasInactivoA]
Carpeta=(Variables)
Clave=Mavi.RM1182DiasInactivoA
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


