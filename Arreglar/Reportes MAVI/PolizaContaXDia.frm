[Forma]
Clave=PolizaContaXDia
Nombre=<T>Poliza x Dia <T> + Info.Titulo
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=(Lista)
PosicionInicialIzquierda=512
PosicionInicialArriba=339
PosicionInicialAlturaCliente=88
PosicionInicialAncho=256
AccionesDivision=S
VentanaBloquearAjuste=S
ExpresionesAlCerrar=Asigna(Info.Titulo, nulo)
[(Variables)]
Estilo=Ficha
Clave=(Variables)
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
ListaEnCaptura=Info.Fecha
CarpetaVisible=S
[(Variables).Info.Fecha]
Carpeta=(Variables)
Clave=Info.Fecha
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Ejecuta]
Nombre=Ejecuta
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=CASO Info.Titulo ES <T>Cobro<T> ENTONCES EjecutarSQLAnimado(<T>xpMaviPolizaCobro :fFecha<T>,Info.Fecha) ES <T>Cobro Inst<T> ENTONCES EjecutarSQLAnimado(<T>xpPolizaCobroInstitucionesSuc :fFecha<T>, Info.Fecha ) ES <T>Cancela Credilana y PP<T> ENTONCES EjecutarSQLAnimado(<T>spContCancelaCredPres :fFecha, :tUsr<T>,Info.Fecha,Usuario) FIN

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
GuardarAntes=S
Multiple=S
EnBarraAcciones=S
ListaAccionesMultiples=(Lista)
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S




[Acciones.Aceptar.ListaAccionesMultiples]
(Inicio)=Guarda
Guarda=Ejecuta
Ejecuta=(Fin)















[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cerrar
Cerrar=(Fin)

