[Forma]
Clave=DM0224DistribuccionenloteFrm
Nombre=DM0224 Distribuccion En Lote
Icono=0
BarraHerramientas=S
Modulos=(Todos)
MovModulo=COMS
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Variables<BR>Detalle
CarpetaPrincipal=Detalle
PosicionInicialAlturaCliente=526
PosicionInicialAncho=1201
PosicionInicialIzquierda=71
PosicionInicialArriba=52
PosicionSec1=78
ListaAcciones=Txt<BR>guarda<BR>Eliminar<BR>cerrar<BR>Filtro
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlMostrar=Asigna(Mavi.DM0224FamiliaFiltro,<T><T>)<BR> Asigna(Mavi.DM0224GrupoFiltro,<T><T>)<BR> Asigna(Mavi.DM0224LineaFiltro,<T><T>)<BR> Asigna(Mavi.DM0224EstatusFiltro,<T><T>)<BR> Asigna(Mavi.DM0224SucursalFiltro,<T><T>)<BR> EjecutarSQL(<T>EXEC SP_DM0224EliminaPteDM0224<T>)
[Variables]
Estilo=Ficha
Clave=Variables
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DM0224GrupoFiltro<BR>Mavi.DM0224FamiliaFiltro<BR>Mavi.DM0224LineaFiltro<BR>Mavi.DM0224EstatusFiltro<BR>Mavi.DM0224SucursalFiltro
CarpetaVisible=S
PermiteEditar=S
[Variables.Mavi.DM0224GrupoFiltro]
Carpeta=Variables
Clave=Mavi.DM0224GrupoFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.DM0224FamiliaFiltro]
Carpeta=Variables
Clave=Mavi.DM0224FamiliaFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.DM0224LineaFiltro]
Carpeta=Variables
Clave=Mavi.DM0224LineaFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Detalle]
Estilo=Hoja
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0224DistribuccionenLoteVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0224DistribucionesLoteTBL.Articulo<BR>DM0224DistribucionesLoteTBL.Almacen<BR>DM0224DistribucionesLoteTBL.Minimo<BR>DM0224DistribucionesLoteTBL.Maximo<BR>DM0224DistribucionesLoteTBL.UltimoMovimiento<BR>DM0224DistribucionesLoteTBL.Familia<BR>DM0224DistribucionesLoteTBL.Linea<BR>DM0224DistribucionesLoteTBL.Estatus
CarpetaVisible=S
PermiteEditar=S
MenuLocal=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Detalle.Columnas]
Articulo=104
Almacen=99
Minimo=62
Maximo=64
UltimoMovimiento=287
Grupo=304
Categoria=304
Familia=240
Linea=199
Empresa=45
SubCuenta=124
0=43
1=78
2=74
3=64
4=60
5=167
6=73
7=115
8=-2
Estatus=94
[Acciones.guarda]
Nombre=guarda
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
EnBarraHerramientas=S
EspacioPrevio=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=inser<BR>exp
[Acciones.Txt.nonulos]
Nombre=nonulos
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0224DistribucionlotenoNulosRep
Activo=S
Visible=S
[Acciones.Txt]
Nombre=Txt
Boton=9
NombreEnBoton=S
NombreDesplegar=&Generar TXT
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=asigna<BR>nonulos
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.cerrar]
Nombre=cerrar
Boton=36
NombreEnBoton=S
NombreDesplegar=&cerrar
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Txt.asigna]
Nombre=asigna
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=&Eliminar
EnBarraHerramientas=S
Activo=S
Visible=S
EspacioPrevio=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>actu
[Detalle.DM0224DistribucionesLoteTBL.Almacen]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0224DistribucionesLoteTBL.Minimo]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Minimo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0224DistribucionesLoteTBL.Maximo]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Maximo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0224DistribucionesLoteTBL.UltimoMovimiento]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.UltimoMovimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.guarda.inser]
Nombre=inser
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.guarda.exp]
Nombre=exp
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=EjecutarSQLAnimado(<T>EXEC SP_DM0224DistribucionLote<T>)
EjecucionCondicion=Si<BR> ( SQL(<T>Select ISNULL(Sum(Conta),0) As Cont From (<BR><BR>select Conta=COUNT(Articulo) from DM0224DistribucionesLoteTBL<BR>Group By Articulo,Almacen having COUNT(Articulo) > 1<BR>) A <BR>Where Conta > 1<T>) > 1)<BR>Entonces<BR>  Error(<T>Tiene Articulos Duplicados con Almacen para Continuar elimine la duplicidad<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Verdadero<BR>Fin
[Acciones.Filtro]
Nombre=Filtro
Boton=67
NombreEnBoton=S
NombreDesplegar=Importar de E&xcel
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=excel<BR>Guardar Cambios<BR>expresion<BR>Actualizar Vista
[Detalle.DM0224DistribucionesLoteTBL.Familia]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0224DistribucionesLoteTBL.Linea]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.DM0224DistribucionesLoteTBL.Estatus]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Estatus
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.prueba.Variables Asignar]
Nombre=Variables Asignar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.prueba.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=RegistrarSeleccion(<T>Detalle<T>)
[Acciones.prueba.Seleccionar/Resultado]
Nombre=Seleccionar/Resultado
Boton=0
TipoAccion=Ventana
ClaveAccion=Seleccionar/Resultado
Expresion=Asigna(Info.Dialogo,SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>))<BR>SQL(<T>Exec SP_MaviCuentaEstacionUEN <T>+EstacionTrabajo+<T>,1<T>)<BR>informacion(Info.Dialogo)
Activo=S
Visible=S
[Detalle.DM0224DistribucionesLoteTBL.Articulo]
Carpeta=Detalle
Clave=DM0224DistribucionesLoteTBL.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.prueba.Expresion3]
Nombre=Expresion3
Boton=0
TipoAccion=Expresion
Expresion=EjecutarSQL(<T>EXEC SP_DM0224EliminaArtAlm <T>+Info.Dialogo)
Activo=S
Visible=S
[Acciones.prueba.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Variables.Mavi.DM0224EstatusFiltro]
Carpeta=Variables
Clave=Mavi.DM0224EstatusFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Variables.Mavi.DM0224SucursalFiltro]
Carpeta=Variables
Clave=Mavi.DM0224SucursalFiltro
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Filtro.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EJECUTARSQL(<T>EXEC SP_DM0224AsignaCampos<T>)
[Acciones.Filtro.Guardar Cambios]
Nombre=Guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Filtro.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Eliminar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=GuardarCambios<BR>SI<BR>    Precaucion(<T>Esta Seguro que desea eliminar los registros <T>, BotonAceptar , BotonCancelar )=  BotonAceptar<BR>      Entonces<BR>          EjecutarSQLAnimado(<T>SP_DM0224EliminaArtAlm<T>)<BR>      sino<BR>       verdadero<BR>Fin
[Acciones.PRUEBA.VIS]
Nombre=VIS
Boton=0
TipoAccion=Reportes Impresora
ClaveAccion=DM0224DistribucionlotenoNulosRep
Activo=S
Visible=S
[Acciones.PRUEBA.ASI]
Nombre=ASI
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
Activo=S
Visible=S
[Acciones.Filtro.excel]
Nombre=excel
Boton=0
Carpeta=Detalle
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Eliminar.actu]
Nombre=actu
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

