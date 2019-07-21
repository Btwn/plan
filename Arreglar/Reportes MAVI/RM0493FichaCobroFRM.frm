[Forma]
Clave=RM0493FichaCobroFRM
Nombre=Ficha de Cobro
Icono=0
Modulos=(Todos)
ListaCarpetas=Ficha de cobro
CarpetaPrincipal=Ficha de cobro
PosicionInicialIzquierda=431
PosicionInicialArriba=345
PosicionInicialAlturaCliente=236
PosicionInicialAncho=418
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Generar Impresion<BR>Prelimina<BR>Impresion<BR>Cerra
BarraHerramientas=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=asigna(Info.Ejercicio,Año(Hoy))<BR>asigna(Mavi.QuincenaCobranza,0)<BR>asigna(Mavi.RM0493NivelCob,nulo)  <BR>asigna(Info.Agente,nulo)<BR>asigna(Mavi.RM0493ID,nulo)<BR>asigna(Mavi.RM0493ID2,nulo)
[Ficha de cobro]
Estilo=Ficha
clave=Ficha de cobro
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
CarpetaVisible=S
ListaEnCaptura=Info.Ejercicio<BR>Mavi.QuincenaCobranza<BR>Mavi.RM0493NivelCob<BR>Info.Agente<BR>Mavi.RM0493ID<BR>Mavi.RM0493ID2
PermiteEditar=S
[Ficha de cobro.Info.Agente]
Carpeta=Ficha de cobro
Clave=Info.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Acciones.Preliminar]
Nombre=Preliminar
Boton=6
NombreEnBoton=S
NombreDesplegar=Preliminar
Multiple=S
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asigna<BR>Cerrar
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EnBarraHerramientas=S
EspacioPrevio=S
[Acciones.Preliminar.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S
[Ficha de cobro.Info.Ejercicio]
Carpeta=Ficha de cobro
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha de cobro.]
Carpeta=Ficha de cobro
ColorFondo=Negro
[Ficha de cobro.Mavi.QuincenaCobranza]
Carpeta=Ficha de cobro
Clave=Mavi.QuincenaCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Ficha de cobro.ListaEnCaptura]
(Inicio)=Info.Ejercicio
Info.Ejercicio=Mavi.QuincenaCobranza
Mavi.QuincenaCobranza=Info.Agente
Info.Agente=Mavi.RM0493ID
Mavi.RM0493ID=Mavi.RM0493ID2
Mavi.RM0493ID2=(Fin)

[Ficha de cobro.Mavi.RM0493ID]
Carpeta=Ficha de cobro
Clave=Mavi.RM0493ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha de cobro.Mavi.RM0493ID2]
Carpeta=Ficha de cobro
Clave=Mavi.RM0493ID2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro



[Forma.ListaAcciones]
(Inicio)=Preliminar
Preliminar=Cerrar
Cerrar=(Fin)
[Acciones.Preliminar.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Preliminar.Cerra]
Nombre=Cerra
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
Activo=S
Visible=S

[Acciones.Prelimina]
Nombre=Prelimina
Boton=6
NombreDesplegar=&Preliminar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Asignar<BR>Cerra
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
[Acciones.Cerra]
Nombre=Cerra
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
[Acciones.Prelimina.Asignar]
Nombre=Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Prelimina.Cerra]
Nombre=Cerra
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar / Ventana Aceptar
[Ficha de cobro.Mavi.RM0493NivelCob]
Carpeta=Ficha de cobro
Clave=Mavi.RM0493NivelCob
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Impresion]
Nombre=Impresion
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir
EnBarraHerramientas=S
TipoAccion=Reportes Impresora
ClaveAccion=RM0493FichaCobroREPIMP
ListaParametros=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asignar<BR>Imprimir

[Acciones.Impresion.asignar]
Nombre=asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.Impresion.Imprimir]
Nombre=Imprimir
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=RM0493FichaCobroREPIMP
Activo=S
Visible=S
[Acciones.Generar Impresion]
Nombre=Generar Impresion
Boton=55
NombreEnBoton=S
NombreDesplegar=&Generar Impresion
multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=variables Asignar<BR>Expresion<BR>Aceptar
[Acciones.Generar Impresion.variables Asignar]
Nombre=variables Asignar
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Generar Impresion.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR>  Confirmacion(<T>Esta Seguro que desea Generar Nuevas Fichas de Cobro? <T> + NuevaLinea + NuevaLinea, BotonSi, BotonNo)=BotonSi<BR>Entonces<BR>  EjecutarSQLAnimado(<T>EXEC SP_MAVIRM0493FichaCobroImpresion :nEjerc, :nQna, :tAgte, :nDesde, :nHasta<T>, Info.Ejercicio, Mavi.QuincenaCobranza, Info.Agente, Mavi.RM0493id, Mavi.RM0493id2)<BR>Fin
[Acciones.Generar Impresion.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=ventana
ClaveAccion=Aceptar
Activo=S
Visible=S

