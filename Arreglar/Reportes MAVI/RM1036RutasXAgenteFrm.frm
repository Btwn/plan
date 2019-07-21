[Forma]
Clave=RM1036RutasXAgenteFrm
Nombre=Rutas de Cobro por Agente
Icono=0
Modulos=(Todos)
PosicionInicialAlturaCliente=156
PosicionInicialAncho=331
ListaCarpetas=Variables
CarpetaPrincipal=Variables
PosicionInicialIzquierda=202
PosicionInicialArriba=138
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.RM1036Agente, nulo)<BR>Asigna(Mavi.RM1036Ruta, nulo)<BR>Asigna(Mavi.RM1036Colonia, nulo)<BR>Asigna(Mavi.RM1036Delegacion, nulo)<BR>Asigna(Mavi.RM1036Estado, nulo)<BR>Asigna(Mavi.RM1036Nivel, nulo)
Menus=S
[Variables]
Estilo=Ficha
Clave=Variables
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
ListaEnCaptura=Mavi.RM1036Agente<BR>Mavi.RM1036Ruta<BR>Mavi.RM1036Colonia<BR>Mavi.RM1036Delegacion<BR>Mavi.RM1036Estado<BR>Mavi.RM1036Nivel
PermiteEditar=S
[Variables.Mavi.RM1036Agente]
Carpeta=Variables
Clave=Mavi.RM1036Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1036Ruta]
Carpeta=Variables
Clave=Mavi.RM1036Ruta
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1036Colonia]
Carpeta=Variables
Clave=Mavi.RM1036Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1036Delegacion]
Carpeta=Variables
Clave=Mavi.RM1036Delegacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1036Estado]
Carpeta=Variables
Clave=Mavi.RM1036Estado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.RM1036Nivel]
Carpeta=Variables
Clave=Mavi.RM1036Nivel
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
RefrescarDespues=S
EnMenu=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Verifica]
Nombre=Verifica
Boton=0
TipoAccion=Expresion
Expresion=INFORMACION(Mavi.RM1036Agente)<BR>INFORMACION(Mavi.RM1036Colonia)<BR>INFORMACION(Mavi.RM1036Delegacion)<BR>INFORMACION(Mavi.RM1036Estado)<BR>INFORMACION(Mavi.RM1036Ruta)<BR>INFORMACION(Mavi.RM1036Nivel)
Activo=S
Visible=S
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Verifica.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Verifica.Verifica]
Nombre=Verifica
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=INFORMACION(Mavi.RM1036Agente)<BR>INFORMACION(Mavi.RM1036Colonia)<BR>INFORMACION(Mavi.RM1036Delegacion)<BR>INFORMACION(Mavi.RM1036Estado)<BR>INFORMACION(Mavi.RM1036Ruta)<BR>INFORMACION(Mavi.RM1036Nivel)
[Acciones.Preliminar.Preliminar]
Nombre=Preliminar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S


