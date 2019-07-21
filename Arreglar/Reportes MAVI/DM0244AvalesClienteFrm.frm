[Forma]
Clave=DM0244AvalesClienteFrm
Nombre=Avales asignados al Cliente
Icono=126
Modulos=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialIzquierda=494
PosicionInicialArriba=445
PosicionInicialAlturaCliente=95
PosicionInicialAncho=292
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar
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
ListaEnCaptura=Mavi.DM0244ListaAvales
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
PermiteEditar=S
[(Variables).Mavi.DM0244ListaAvales]
Carpeta=(Variables)
Clave=Mavi.DM0244ListaAvales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
EspacioPrevio=S
ListaAccionesMultiples=control<BR>expresion<BR>cerrar
[Acciones.Aceptar.control]
Nombre=control
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Mavi.DM0244IndicaAccion,nulo)<BR><BR>      Si<BR>         ConDatos(Info.Respuesta2)<BR>        Entonces<BR>      Asigna(Info.Respuesta4,<T>Aval<T>)<BR>         Asigna(Mavi.DM0244IndicaAccion,<T>Cerrar<T>)<BR>          Forma(<T>NegociaMoratoriosMavi<T>)<BR>        Sino<BR>           Error(<T>Seleccione un Aval<T>)<BR>           Fin
[Acciones.Aceptar.cerrar]
Nombre=cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=Mavi.DM0244IndicaAccion  = <T>Cerrar<T>


