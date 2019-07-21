[Forma]
Clave=CreacionLayoutINTF
Nombre=Layout INTF
Icono=0
Modulos=(Todos)
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=CreacionLayoutINTF
CarpetaPrincipal=CreacionLayoutINTF
PosicionInicialIzquierda=512
PosicionInicialArriba=329
PosicionInicialAlturaCliente=108
PosicionInicialAncho=256
ListaAcciones=(Lista)
Totalizadores=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=7
NombreDesplegar=&Generar
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
ListaAccionesMultiples=Variables Asignar<BR>Expresion
[Acciones.Aceptar.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Aceptar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
;Expresion=GuardarLista(SQLEnLista(<T>sp_FormatoINTFMAVI :nejercicio, :nperiodo <T>, Info.Ejercicio, Info.Periodo), <T><T>,<T>INTF001.txt<T>, <T>txt<T>, <T>Todos los Archivos<T>, <T>Todos los Archivos<T>)<BR>Informacion(<T>Archivo .txt creado<T> )
;Expresion=EjecutarSQL(<T> sp_FormatoINTFMAVI :nejercicio, :nperiodo, :tempresa <T>, Info.Ejercicio, Info.Periodo, Empresa)) <BR> Informacion('Proceso Concluido')
Expresion=/*EjecutarSQL(<T> spFacturasAValidarBuro :ffecha<T>, UltimoDiaMes(TextoEnFecha(<T>01/<T>+ Si(Longitud(NumEnTexto(info.periodo ))=1, <BR>                        <T>0<T> & NumEnTexto(info.periodo ), NumEnTexto(info.periodo )) + <T>/<T> + NumEnTexto(info.ejercicio ) ))))*/ <BR> EjecutarSQL(<T> sp_FormatoINTFMAVI :nejercicio, :nperiodo, :tempresa <T>, Info.Ejercicio, Info.Periodo, Empresa)) <BR> Informacion('Proceso Concluido')
[CreacionLayoutINTF]
Estilo=Ficha
Clave=CreacionLayoutINTF
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=5
FichaEspacioNombres=0
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Info.Ejercicio<BR>Info.Periodo
CarpetaVisible=S
[CreacionLayoutINTF.Info.Ejercicio]
Carpeta=CreacionLayoutINTF
Clave=Info.Ejercicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CreacionLayoutINTF.Info.Periodo]
Carpeta=CreacionLayoutINTF
Clave=Info.Periodo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro




[Acciones.SaldosFactura.AsignaVar]
Nombre=AsignaVar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S

[Acciones.SaldosFactura.Saldos]
Nombre=Saldos
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T> spFacturasAValidarBuro :ffecha<T>, UltimoDiaMes(TextoEnFecha(<T>01/<T>+ Si(Longitud(NumEnTexto(info.periodo ))=1, <BR>                        <T>0<T> & NumEnTexto(info.periodo ), NumEnTexto(info.periodo )) + <T>/<T> + NumEnTexto(info.ejercicio ) )))) <BR>Informacion(<T>Proceso Concluido<T>)
Activo=S
Visible=S

[Acciones.SaldosFactura]
Nombre=SaldosFactura
Boton=75
NombreDesplegar=&Saldos de Factura
Multiple=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ListaAccionesMultiples=(Lista)

Activo=S
Visible=S
NombreEnBoton=S


EspacioPrevio=S


[Acciones.SaldosFactura.ListaAccionesMultiples]
(Inicio)=AsignaVar
AsignaVar=Saldos
Saldos=(Fin)



[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=Aceptar
Aceptar=SaldosFactura
SaldosFactura=(Fin)


