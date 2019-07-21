[Forma]
Clave=MaviMovEmbarquesSoporteVisFrm
Nombre=Movimientos de Embarque y Soporte
Icono=0
Modulos=(Todos)
ListaCarpetas=Vista
CarpetaPrincipal=Vista
PosicionInicialAlturaCliente=158
PosicionInicialAncho=333
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Sel2
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaAvanzaTab=S
VentanaEstadoInicial=Normal
PosicionInicialIzquierda=473
PosicionInicialArriba=416
[Vista]
Estilo=Iconos
Clave=Vista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=MaviMovEmbarquesSoporteVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Movimiento<T>
ElementosPorPagina=200
IconosSeleccionMultiple=S
ListaAcciones=Sel<BR>Quit
IconosNombre=MaviMovEmbarquesSoporteVis:mov
[Acciones.Sel.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel.Reg]
Nombre=Reg
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Vista)
Activo=S
Visible=S
[Acciones.Sel.Sele]
Nombre=Sele
Boton=0
TipoAccion=ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
[Acciones.Sel]
Nombre=Sel
Boton=0
NombreDesplegar=Seleccionar & Todo
EnMenu=S
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
[Vista.Columnas]
0=315
[Acciones.Sel.Asigna2]
Nombre=Asigna2
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel.Reg2]
Nombre=Reg2
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Sel.Sel2]
Nombre=Sel2
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=<T>WWW<T>
[Acciones.Sel2]
Nombre=Sel2
Boton=23
NombreEnBoton=S
NombreDesplegar=&Seleccionar
Multiple=S
EnBarraHerramientas=S
EspacioPrevio=S
ListaAccionesMultiples=Asigna2<BR>Reg2<BR>sEL3
Activo=S
Visible=S
[Acciones.Sel2.sEL3]
Nombre=sEL3
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Mavi.DeptoRHDSuc,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,2<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)
[Acciones.Quit]
Nombre=Quit
Boton=0
NombreDesplegar=&Quitar Selección
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Sel2.Asigna2]
Nombre=Asigna2
Boton=0
TipoAccion=controles Captura
ClaveAccion=Variables Asignar
[Acciones.Sel2.Reg2]
Nombre=Reg2
Boton=0
TipoAccion=expresion
Expresion=RegistrarSeleccion(<T>Vista<T>)

