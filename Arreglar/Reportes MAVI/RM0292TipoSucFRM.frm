[Forma]
Clave=RM0292TipoSucFRM
Nombre=Tipos de Sucursales
Icono=154
Modulos=(Todos)
ListaCarpetas=TipoSuc
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
CarpetaPrincipal=TipoSuc
ListaAcciones=Sel
PosicionInicialIzquierda=518
PosicionInicialArriba=419
PosicionInicialAlturaCliente=151
PosicionInicialAncho=244
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEscCerrar=S
VentanaBloquearAjuste=S
VentanaEstadoInicial=Normal
[TipoSuc]
Estilo=Iconos
Clave=TipoSuc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=RM0292TipoSucVIS
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
MenuLocal=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=Tipo
ElementosPorPagina=200
IconosConRejilla=S
IconosSeleccionMultiple=S
ListaAcciones=selecionatodo<BR>quitatodo
IconosNombre=RM0292TipoSucVIS:Tipo
[Acciones.Sel]
Nombre=Sel
Boton=23
NombreEnBoton=S
NombreDesplegar=Seleccionar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Seleccionar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=asignar<BR>registrar<BR>sel
[TipoSuc.Columnas]
Sucursal=46
Tipo=180
Nombre=143
0=-2
1=-2
[Acciones.selecionatodo]
Nombre=selecionatodo
Boton=0
NombreDesplegar=Seleccionar Todo
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
[Acciones.quitatodo]
Nombre=quitatodo
Boton=0
NombreDesplegar=Quitar Seleccion
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Quitar Seleccion
Activo=S
Visible=S
[Acciones.Sel.asignar]
Nombre=asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Sel.registrar]
Nombre=registrar
Boton=0
TipoAccion=Expresion
Expresion= RegistrarSeleccion(<T>Vista<T>)
Activo=S
Visible=S
[Acciones.Sel.sel]
Nombre=sel
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Activo=S
Visible=S
Expresion=asigna(Mavi.TipoSuc292,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>     SQL(<T>EXEC dbo.SP_MaviCuentaEstacionUEN :nEst, 1<T>,EstacionTrabajo)

