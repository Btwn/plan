[Forma]
Clave=DM0500LDVActualizar
Nombre=DM0500LDVActualizar
Icono=481
Modulos=(Todos)
ListaCarpetas=Actualizar<BR>Detalle<BR>DiasLoc<BR>DetalleLoc<BR>Sanciones
CarpetaPrincipal=Actualizar
PosicionInicialAlturaCliente=749
PosicionInicialAncho=1296
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
AccionesTamanoBoton=15x10
ListaAcciones=Aceptar<BR>Salir
PosicionCol1=452
PosicionSec1=341
PosicionCol2=452
Menus=S
AccionesCentro=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Dise�o
VentanaEstadoInicial=Normal
PosicionSec2=422
PosicionCol3=626
ExpresionesAlMostrar=ASIGNA(Mavi.DV501,SQL(<T>SELECT InicioDv FROM DM0500LDiasVencidos with(nolock) where Id=1<T>) )<BR>ASIGNA(Mavi.DV502,SQL(<T>SELECT FinDV FROM DM0500LDiasVencidos with(nolock) where Id=1<T>) )<BR>ASIGNA(Mavi.DV2,SQL(<T>SELECT FinDv FROM DM0500LDiasVencidos with(nolock) where Id=2<T>) )<BR>ASIGNA(Mavi.DV3,SQL(<T>SELECT FinDv FROM DM0500LDiasVencidos with(nolock) where Id=3<T>) )<BR>ASIGNA(Mavi.DV4,SQL(<T>SELECT FinDv FROM DM0500LDiasVencidos with(nolock) where Id=4<T>) )<BR>ASIGNA(Mavi.DV503,SQL(<T>SELECT Cantidad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>CuotaDiasLocalizacion<T>)))<BR>ASIGNA(Mavi.DM500LDiasInac,SQL(<T>SELECT Cantidad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>CuotaInactividad<T>)))<BR>ASIGNA(Mavi.DM500LPorcenExig,SQL(<T>SELECT Cantid<CONTINUA>
ExpresionesAlMostrar002=<CONTINUA>ad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>PorcentajeExigible<T>)))<BR>ASIGNA(Mavi.DM500LSancionGestor,SQL(<T>SELECT Cantidad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>SancionGestor<T>)))<BR>ASIGNA(Mavi.DM500LSancionJefeGest,SQL(<T>SELECT Cantidad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>SancionJefe<T>)))<BR>ASIGNA(Mavi.DM500LGastosLoc,SQL(<T>SELECT Cantidad FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>GastosLocalizacion<T>)))
[Actualizar]
Estilo=Ficha
Pestana=S
Clave=Actualizar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 10, Negro, []}
FichaEspacioEntreLineas=7
FichaEspacioNombres=89
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Vista=(Variables)
ListaEnCaptura=Mavi.DV501<BR>Mavi.DV502<BR>Mavi.DV2<BR>Mavi.DV3<BR>Mavi.DV4
PestanaOtroNombre=S
PestanaNombre=Actualizacion Dias Vencidos
PermiteEditar=S
FichaEspacioNombresAuto=S
ConFuenteEspecial=S
[Actualizar.Mavi.DV501]
Carpeta=Actualizar
Clave=Mavi.DV501
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Actualizar.Mavi.DV502]
Carpeta=Actualizar
Clave=Mavi.DV502
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Actualizar.Mavi.DV2]
Carpeta=Actualizar
Clave=Mavi.DV2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Actualizar.Mavi.DV3]
Carpeta=Actualizar
Clave=Mavi.DV3
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Actualizar.Mavi.DV4]
Carpeta=Actualizar
Clave=Mavi.DV4
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
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=Guardar
Multiple=S
ListaAccionesMultiples=Asignar<BR>Update<BR>Vista
Activo=S
Visible=S
BtnResaltado=S
EnMenu=S
[Detalle]
Estilo=Hoja
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Fuente={Tahoma, 12, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Vista=DM0500LActualizaDVVis
ListaEnCaptura=Rango<BR>InicioDv<BR>FinDv
PestanaOtroNombre=S
ConFuenteEspecial=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
[Detalle.Rango]
Carpeta=Detalle
Clave=Rango
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
[Detalle.InicioDv]
Carpeta=Detalle
Clave=InicioDv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.FinDv]
Carpeta=Detalle
Clave=FinDv
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Detalle.Columnas]
Rango=124
InicioDv=64
FinDv=64
[Acciones.Aceptar.Update]
Nombre=Update
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC dbo.SP_DM0500LActualizaDV  :nOpc, :nDV0, :nDV1, :nDV2, :nDV3, :nDV4, :nDV5<T>, 1, Mavi.DV501, Mavi.DV502, Mavi.DV2, Mavi.DV3, Mavi.DV4, Mavi.DV503)<BR>Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>EXEC dbo.SP_DM0500LActualizaCant  :nOpc, :nDiasInac, :nPorcenExig, :nSancionGestor, :nSancionJefeGes, :nGastosLoc, :nDiasLoc<T>, 1, Mavi.DM500LDiasInac, Mavi.DM500LPorcenExig, Mavi.DM500LSancionGestor, Mavi.DM500LSancionJefeGest, Mavi.DM500LGastosLoc, Mavi.DV503))<BR>Si<BR>  Info.Dialogo = <T>Guardado<T><BR>Entonces<BR> Informacion(<T>Registro Exitoso<T>)<BR> Verdadero<BR>Sino<BR> AbortarOperacion<BR>Fin
[Acciones.Aceptar.Vista]
Nombre=Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[DiasLoc]
Estilo=Ficha
Pestana=S
Clave=DiasLoc
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 10, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Mavi.DV503<BR>Mavi.DM500LDiasInac<BR>Mavi.DM500LPorcenExig
CarpetaVisible=S
PestanaOtroNombre=S
PestanaNombre=Limite Dias en Localizacion
ConFuenteEspecial=S
[DiasLoc.Mavi.DV503]
Carpeta=DiasLoc
Clave=Mavi.DV503
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DetalleLoc]
Estilo=Hoja
Clave=DetalleLoc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=DM0500LConfigVis
Fuente={Tahoma, 10, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ConFuenteEspecial=S
ListaEnCaptura=Concepto<BR>Cantidad
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Autom�tica
[DetalleLoc.Columnas]
Rango=0
DiasLoc=94
Cantidad=74
Concepto=704
[Acciones.Salir]
Nombre=Salir
Boton=0
NombreDesplegar=Salir
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[CuotaInactividad.Columnas]
InicioDv=64
FinDv=64
[Sanciones]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Sanciones
Clave=Sanciones
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=(Variables)
Fuente={Tahoma, 10, Negro, []}
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
ListaEnCaptura=Mavi.DM500LSancionGestor<BR>Mavi.DM500LSancionJefeGest<BR>Mavi.DM500LGastosLoc
ConFuenteEspecial=S
[CuotaInactividad.Mavi.DM500LDiasInac]
Carpeta=CuotaInactividad
Clave=Mavi.DM500LDiasInac
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CuotaInactividad.Mavi.DM500LPorcenExig]
Carpeta=CuotaInactividad
Clave=Mavi.DM500LPorcenExig
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Sanciones.Mavi.DM500LSancionGestor]
Carpeta=Sanciones
Clave=Mavi.DM500LSancionGestor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Sanciones.Mavi.DM500LSancionJefeGest]
Carpeta=Sanciones
Clave=Mavi.DM500LSancionJefeGest
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Sanciones.Mavi.DM500LGastosLoc]
Carpeta=Sanciones
Clave=Mavi.DM500LGastosLoc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[CuotaInactividad2.Columnas]
Cantidad=95
[SancionesActual.Mavi.DM500LSancionGestorActual]
Carpeta=SancionesActual
Clave=Mavi.DM500LSancionGestorActual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Gris
[SancionesActual.Mavi.DM500LSancionJefeGestActual]
Carpeta=SancionesActual
Clave=Mavi.DM500LSancionJefeGestActual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Gris
[SancionesActual.Mavi.DM500LGastosLocActual]
Carpeta=SancionesActual
Clave=Mavi.DM500LGastosLocActual
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Gris
[DiasLoc.Mavi.DM500LDiasInac]
Carpeta=DiasLoc
Clave=Mavi.DM500LDiasInac
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DiasLoc.Mavi.DM500LPorcenExig]
Carpeta=DiasLoc
Clave=Mavi.DM500LPorcenExig
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[DetalleLoc.Cantidad]
Carpeta=DetalleLoc
Clave=Cantidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DetalleLoc.Concepto]
Carpeta=DetalleLoc
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

