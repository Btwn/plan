[Forma]
Clave=RM0949CxcCtrlEnvCobInstFrm
Nombre=RM0949 Control de Envío a Cobros a las Instituciones
Icono=61
Modulos=(Todos)
ListaCarpetas=ExploraVar
CarpetaPrincipal=ExploraVar
PosicionInicialAlturaCliente=197
PosicionInicialAncho=430
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=425
PosicionInicialArriba=396
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
VentanaBloquearAjuste=S
VentanaEscCerrar=S
ListaAcciones=Acepta<BR>Preliminar<BR>Cancela
VentanaExclusiva=S
VentanaRepetir=S
ExpresionesAlMostrar=Si(Info.Ejercicio=0,Asigna(Info.Ejercicio,año(hoy)),)<BR>Si(Info.Periodo=0,Asigna(Info.Periodo,mes(hoy)),)<BR>Asigna(Info.Reemplazar,<T>Si<T>)<BR>Asigna(Info.CategoriaCanal,<T>INSTITUCIONES<T>)<BR>Asigna(Info.CteGrupo,Nulo)
[ExploraVar]
Estilo=Ficha
Clave=ExploraVar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
FichaEspacioEntreLineas=15
FichaEspacioNombres=0
FichaColorFondo=Plata
ListaEnCaptura=Info.Ejercicio<BR>Info.Periodo<BR>Mavi.NumCanalVenta<BR>Mavi.RM0949TipoEnvio<BR>Mavi.RM0949CteInst
PermiteEditar=S
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
[ExploraVar.Info.Periodo]
Carpeta=ExploraVar
Clave=Info.Periodo
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Info.Ejercicio]
Carpeta=ExploraVar
Clave=Info.Ejercicio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.NumCanalVenta]
Carpeta=ExploraVar
Clave=Mavi.NumCanalVenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.Acepta]
Nombre=Acepta
Boton=7
NombreEnBoton=S
NombreDesplegar=&Aceptar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Multiple=S
ListaAccionesMultiples=AsignaV<BR>AceptaV
Visible=S
ActivoCondicion=Info.Bloqueado=Falso
[Acciones.Cancela]
Nombre=Cancela
Boton=36
NombreEnBoton=S
NombreDesplegar=&Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Acepta.AsignaV]
Nombre=AsignaV
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Acepta.AceptaV]
Nombre=AceptaV
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=( ConDatos(Info.Ejercicio) y ConDatos(Info.Periodo) y ConDatos(Mavi.NumCanalVenta) y (Info.Periodo >= 1) y (Info.Periodo <= 12) )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)= 1)y<BR>(Si(ConDatos(Mavi.RM0949CteInst),No Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) ),Verdadero) )
EjecucionMensaje=Si Vacio(Info.Ejercicio) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>Sino Si Vacio(Info.Periodo) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>     Sino Si (Info.Periodo <= 0) o (Info.Periodo >= 13) Entonces <T>El Periodo está fuera del rango<T><BR>          Sino Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)) Entonces <T>El Canal de Venta no es de Instituciones<T><BR>                    Sino Si Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) )<BR>  <CONTINUA>
EjecucionMensaje002=<CONTINUA>                           Entonces <T>El Cliente no es de Instituciones<T><BR>                         Fin<BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Expresion
Multiple=S
ListaAccionesMultiples=AsignaExp<BR>Explorar<BR>CerrarV
ActivoCondicion=Info.Bloqueado
VisibleCondicion=Info.Bloqueado
[Acciones.Preliminar.CerrarV]
Nombre=CerrarV
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=( ConDatos(Info.Ejercicio) y ConDatos(Info.Periodo) y ConDatos(Mavi.NumCanalVenta) y (Info.Periodo >= 1) y (Info.Periodo <= 12) )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)= 1)y<BR>(Si(ConDatos(Mavi.RM0949CteInst),No Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) ),Verdadero) )
EjecucionMensaje=Si Vacio(Info.Ejercicio) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>Sino Si Vacio(Info.Periodo) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>     Sino Si (Info.Periodo <= 0) o (Info.Periodo >= 13) Entonces <T>El Periodo está fuera del rango<T><BR>          Sino Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)) Entonces <T>El Canal de Venta no es de Instituciones<T><BR>                    Sino Si Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) )<BR>  <CONTINUA>
EjecucionMensaje002=<CONTINUA>                           Entonces <T>El Cliente no es de Instituciones<T><BR>                         Fin<BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[Acciones.Preliminar.Explorar]
Nombre=Explorar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Forma(<T>RM0949CxcExpCtrlEnvCobInstFrm<T>)<BR>Asigna(Info.Bloqueado,Falso)
EjecucionCondicion=( ConDatos(Info.Ejercicio) y ConDatos(Info.Periodo) y ConDatos(Mavi.NumCanalVenta) y (Info.Periodo >= 1) y (Info.Periodo <= 12) )y<BR>(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)= 1)y<BR>(Si(ConDatos(Mavi.RM0949CteInst),No Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) ),Verdadero) )
EjecucionMensaje=Si Vacio(Info.Ejercicio) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>Sino Si Vacio(Info.Periodo) Entonces <T>El Ejercicio y Periodo son Requeridos<T><BR>     Sino Si (Info.Periodo <= 0) o (Info.Periodo >= 13) Entonces <T>El Periodo está fuera del rango<T><BR>          Sino Si Vacio(Mavi.NumCanalVenta) Entonces <T>El Canal de Venta es Requerido<T><BR>               Sino Si Vacio(SQL(<T>Select 1 From VentasCanalMavi Where ID = :nID And Categoria = :tCat<T>,Mavi.NumCanalVenta,<T>INSTITUCIONES<T>)) Entonces <T>El Canal de Venta no es de Instituciones<T><BR>                    Sino Si Vacio(SQL(<T>Select Cliente From CteEnviarA Where Cliente = :tCte And Categoria <T>+Si(ConDatos(Info.CategoriaCanal),<T>=<T>+Comillas(Info.CategoriaCanal),<T>IS NOT NULL<T>),Mavi.RM0949CteInst) )<BR>  <CONTINUA>
EjecucionMensaje002=<CONTINUA>                           Entonces <T>El Cliente no es de Instituciones<T><BR>                         Fin<BR>                    Fin<BR>               Fin<BR>          Fin<BR>     Fin<BR>Fin
[Acciones.Preliminar.AsignaExp]
Nombre=AsignaExp
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[ExploraVar.Mavi.RM0949TipoEnvio]
Carpeta=ExploraVar
Clave=Mavi.RM0949TipoEnvio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
[ExploraVar.Mavi.RM0949CteInst]
Carpeta=ExploraVar
Clave=Mavi.RM0949CteInst
Editar=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]


