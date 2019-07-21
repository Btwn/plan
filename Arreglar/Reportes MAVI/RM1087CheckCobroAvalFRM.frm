[Forma]
Clave=RM1087CheckCobroAvalFRM
Nombre=Cuentas Cobro al Aval
Icono=0
Modulos=(Todos)
ListaCarpetas=ClienteAval
CarpetaPrincipal=ClienteAval
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=cerrar<BR>Mostrar<BR>Refresh
PosicionInicialAlturaCliente=118
PosicionInicialAncho=315
PosicionInicialIzquierda=481
PosicionInicialArriba=189
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(info.cliente,nulo)    <BR>asigna(Mavi.RM1087CategoriaCob,nulo)<BR>asigna(Mavi.RM1087CanalCob,nulo)<BR>asigna(Mavi.RM1087CheckCobAval,<T>Si<T>)
[ClienteAval]
Estilo=Ficha
PestanaNombre=datos de aval
Clave=ClienteAval
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Info.Cliente<BR>Mavi.RM1087CheckCobAval<BR>Mavi.RM1087CategoriaCob<BR>Mavi.RM1087CanalCob
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
AutoRefrescar=S
TiempoRefrescar=00:01
[Acciones.cerrar]
Nombre=cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Mostrar]
Nombre=Mostrar
Boton=35
NombreEnBoton=S
NombreDesplegar=&Mostrar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[ClienteAval.Mavi.RM1087CheckCobAval]
Carpeta=ClienteAval
Clave=Mavi.RM1087CheckCobAval
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[ClienteAval.Mavi.RM1087CategoriaCob]
Carpeta=ClienteAval
Clave=Mavi.RM1087CategoriaCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[ClienteAval.Info.Cliente]
Carpeta=ClienteAval
Clave=Info.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Refresh]
Nombre=Refresh
Boton=0
NombreEnBoton=S
NombreDesplegar=&Refresh
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
ConAutoEjecutar=S
AutoEjecutarExpresion=1
[ClienteAval.Mavi.RM1087CanalCob]
Carpeta=ClienteAval
Clave=Mavi.RM1087CanalCob
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


