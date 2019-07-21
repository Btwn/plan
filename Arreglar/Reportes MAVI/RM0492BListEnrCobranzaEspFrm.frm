[Forma]
Clave=RM0492BListEnrCobranzaEspFrm
Nombre=RM0492 Listado de Enrutamiento de Cobranza
Icono=0
Modulos=(Todos)
ListaCarpetas=(Variables)
CarpetaPrincipal=(Variables)
PosicionInicialAlturaCliente=207
PosicionInicialAncho=334
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Preliminar<BR>Cerrar<BR>Imprimir<BR>Aexcel<BR>atexto
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=473
PosicionInicialArriba=389
VentanaEscCerrar=S
VentanaAvanzaTab=S
ExpresionesAlMostrar=asigna(info.cliente,nulo)<BR>asigna(Mavi.AgentesCob,nulo)<BR>asigna(Mavi.Ejercicio,0)<BR>asigna(Mavi.QuincenaCobranza,nulo)            <BR>asigna(Mavi.RM0492NivelesLista,nulo)<BR>asigna(Info.RM0492Zona,nulo)<BR>asigna(Mavi.RM0492MostrarGestion,<T>No<T>)
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
ListaEnCaptura=Info.Cliente<BR>Mavi.AgentesCob<BR>Mavi.Ejercicio<BR>Mavi.QuincenaCobranza<BR>Mavi.RM0492NivelesLista<BR>Info.RM0492Zona<BR>Mavi.RM0492MostrarGestion
CarpetaVisible=S
FichaEspacioEntreLineas=0
FichaEspacioNombres=0
FichaColorFondo=Plata
PermiteEditar=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreDesplegar=&Preliminar
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
NombreEnBoton=S
GuardarAntes=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[(Variables).Info.Cliente]
Carpeta=(Variables)
Clave=Info.Cliente
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
Efectos=[Negritas]
[(Variables).Mavi.Ejercicio]
Carpeta=(Variables)
Clave=Mavi.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    (ConDatos(Mavi.Ejercicio) y (Mavi.Ejercicio <> 0 ) y ConDatos(Mavi.QuincenaCobranza))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
EjecucionMensaje=<T>Ingrese  Ejercicio y Quincena<T>
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[(Variables).Mavi.AgentesCob]
Carpeta=(Variables)
Clave=Mavi.AgentesCob
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[(Variables).Mavi.QuincenaCobranza]
Carpeta=(Variables)
Clave=Mavi.QuincenaCobranza
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Imprimir]
Nombre=Imprimir
Boton=4
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Asigna<BR>Imp<BR>Cerrar
NombreEnBoton=S
[Acciones.Imprimir.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Imprimir.Imp]
Nombre=Imp
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=ReporteImpresora(<T>RM0492BListEnruCobranzaESPRepImp<T>)
EjecucionCondicion=Si<BR>    (ConDatos(Mavi.Ejercicio) y (Mavi.Ejercicio <> 0 ) y ConDatos(Mavi.QuincenaCobranza))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
EjecucionMensaje=<T>Ingrese  Ejercicio y Quincena<T><BR><T>Ingrese  Ejercicio y Quincena<T>
[Acciones.Imprimir.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[(Variables).Mavi.RM0492NivelesLista]
Carpeta=(Variables)
Clave=Mavi.RM0492NivelesLista
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Acciones.Aexcel]
Nombre=Aexcel
Boton=115
NombreEnBoton=S
NombreDesplegar=&Excel
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asignacampos<BR>excel<BR>cerrarexc
[Acciones.Aexcel.excel]
Nombre=excel
Boton=0
TipoAccion=Reportes Excel
ClaveAccion=RM0492BListEnruCobranzaESPRepXls
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    (ConDatos(Mavi.Ejercicio) y (Mavi.Ejercicio <> 0 ) y ConDatos(Mavi.QuincenaCobranza))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
EjecucionMensaje=<T>Ingrese  Ejercicio y Quincena<T><BR><T>Ingrese  Ejercicio y Quincena<T>
[Acciones.Aexcel.asignacampos]
Nombre=asignacampos
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.atexto]
Nombre=atexto
Boton=54
NombreEnBoton=S
NombreDesplegar=&TXT
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
ListaAccionesMultiples=asiganavar<BR>generaarchivo<BR>cierra
[Acciones.Aexcel.cerrarexc]
Nombre=cerrarexc
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.atexto.asiganavar]
Nombre=asiganavar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.atexto.cierra]
Nombre=cierra
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.atexto.generaarchivo]
Nombre=generaarchivo
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0492BListEnruCobranzaEspRepTXT
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
EjecucionCondicion=Si<BR>    (ConDatos(Mavi.Ejercicio) y (Mavi.Ejercicio <> 0 ) y ConDatos(Mavi.QuincenaCobranza))<BR>entonces<BR>    verdadero<BR>sino<BR>    falso<BR>fin
EjecucionMensaje=<T>Ingrese  Ejercicio y Quincena<T>
[(Variables).Info.RM0492Zona]
Carpeta=(Variables)
Clave=Info.RM0492Zona
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[(Variables).Mavi.RM0492MostrarGestion]
Carpeta=(Variables)
Clave=Mavi.RM0492MostrarGestion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco


