
[Forma]
Clave=DM0500LCXCConfCuotasLocBFFrm
Icono=481
Modulos=(Todos)

ListaCarpetas=Actualizar<BR>Detalle<BR>DiasLoc<BR>DetalleLoc<BR>Sanciones
CarpetaPrincipal=Actualizar
Nombre=Dm0500L Configuración CuotasLocBF
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
Menus=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Salir
PosicionInicialAlturaCliente=628
PosicionInicialAncho=1159
PosicionSec1=276
PosicionCol1=358
PosicionCol2=358
PosicionInicialIzquierda=110
PosicionInicialArriba=23
ExpresionesAlMostrar=ASIGNA(Mavi.DV501,SQL(<T>SELECT InicioDvBF FROM DM0500LDiasVencidos with(nolock) where Id=1<T>) )<BR>ASIGNA(Mavi.DV502,SQL(<T>SELECT FinDVBF FROM DM0500LDiasVencidos with(nolock) where Id=1<T>) )<BR>ASIGNA(Mavi.DV2,SQL(<T>SELECT FinDvBF FROM DM0500LDiasVencidos with(nolock) where Id=2<T>) )<BR>ASIGNA(Mavi.DV3,SQL(<T>SELECT FinDvBF FROM DM0500LDiasVencidos with(nolock) where Id=3<T>) )<BR>ASIGNA(Mavi.DV4,SQL(<T>SELECT FinDvBF FROM DM0500LDiasVencidos with(nolock) where Id=4<T>) )<BR>ASIGNA(Mavi.DV503,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>CuotaDiasLocalizacion<T>)))<BR>ASIGNA(Mavi.DM500LDiasInac,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>CuotaInactividad<T>)))<BR>ASIGNA(Mavi.DM500LPorcenExig,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>PorcentajeExigible<T>)))<BR>ASIGNA(Mavi.DM500LSancionGestor,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>SancionGestor<T>)))<BR>ASIGNA(Mavi.DM500LSancionJefeGest,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>SancionJefe<T>)))<BR>ASIGNA(Mavi.DM500LGastosLoc,SQL(<T>SELECT CantidadBF FROM ConfigDM0500L WITH(NOLOCK) WHERE Concepto=<T>+COMILLAS(<T>GastosLocalizacion<T>)))
[Actualizar]
Estilo=Ficha
Pestana=S
Clave=Actualizar
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Fuente={Tahoma, 10, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Actualizacion Dias Vencidos Beneficiarios Finales
Vista=(Variables)
FichaEspacioEntreLineas=7
FichaEspacioNombres=89
FichaColorFondo=Plata
PermiteEditar=S
ConFuenteEspecial=S
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S
ListaEnCaptura=Mavi.DV501<BR>Mavi.DV502<BR>Mavi.DV2<BR>Mavi.DV3<BR>Mavi.DV4
[Detalle]
Estilo=Hoja
Clave=Detalle
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Fuente={Tahoma, 12, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

Vista=DM0500LActualizaDVVis
ConFuenteEspecial=S
ListaEnCaptura=Rango<BR>InicioDvBF<BR>FinDvBF
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
PestanaOtroNombre=S
[DiasLoc]
Estilo=Ficha
Pestana=S
Clave=DiasLoc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 10, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Limite Dias en Localizacion
PermiteEditar=S
Vista=(Variables)
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaColorFondo=Plata
ConFuenteEspecial=S
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S
ListaEnCaptura=Mavi.DV503<BR>Mavi.DM500LDiasInac<BR>Mavi.DM500LPorcenExig
[DetalleLoc]
Estilo=Hoja
Clave=DetalleLoc
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Fuente={Tahoma, 10, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

Vista=DM0500LConfigVis
ConFuenteEspecial=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
ListaEnCaptura=Concepto<BR>CantidadBF
[Sanciones]
Estilo=Ficha
Pestana=S
Clave=Sanciones
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 10, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S

PestanaOtroNombre=S
PestanaNombre=Sanciones
Vista=(Variables)
ConFuenteEspecial=S
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaColorFondo=Plata
PermiteEditar=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaAlineacionDerecha=S
ListaEnCaptura=Mavi.DM500LSancionGestor<BR>Mavi.DM500LSancionJefeGest<BR>Mavi.DM500LGastosLoc
FichaEspacioNombresAuto=S
[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
EnMenu=S
Activo=S
Visible=S
NombreDesplegar=Guardar
Multiple=S

ListaAccionesMultiples=Asignar<BR>Update<BR>Vista
[Acciones.Salir]
Nombre=Salir
Boton=0
NombreDesplegar=Salir
EnMenu=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Acciones.Aceptar.Asignar]
Nombre=Asignar
Boton=0
Activo=S
Visible=S

TipoAccion=Controles Captura
ClaveAccion=Variables Asignar
[Acciones.Aceptar.Update]
Nombre=Update
Boton=0
Activo=S
Visible=S

TipoAccion=Expresion
Expresion=EjecutarSQL(<T>EXEC dbo.SP_DM0500LActualizaDV  :nOpc, :nDV0, :nDV1, :nDV2, :nDV3, :nDV4, :nDV5<T>, 2, Mavi.DV501, Mavi.DV502, Mavi.DV2, Mavi.DV3, Mavi.DV4, Mavi.DV503)<BR>Asigna(Info.Dialogo,<T><T>)<BR>Asigna(Info.Dialogo,SQL(<T>EXEC dbo.SP_DM0500LActualizaCant  :nOpc, :nDiasInac, :nPorcenExig, :nSancionGestor, :nSancionJefeGes, :nGastosLoc, :nDiasLoc<T>, 2,  Mavi.DM500LDiasInac, Mavi.DM500LPorcenExig, Mavi.DM500LSancionGestor, Mavi.DM500LSancionJefeGest, Mavi.DM500LGastosLoc, Mavi.DV503))<BR>Si<BR>  Info.Dialogo = <T>Guardado<T><BR>Entonces<BR> Informacion(<T>Registro Exitoso<T>)<BR> Verdadero<BR>Sino<BR> AbortarOperacion<BR>Fin
[Acciones.Aceptar.Vista]
Nombre=Vista
Boton=0
Activo=S
Visible=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista

[Actualizar.Mavi.DV501]
Carpeta=Actualizar
Clave=Mavi.DV501
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Actualizar.Mavi.DV502]
Carpeta=Actualizar
Clave=Mavi.DV502
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Actualizar.Mavi.DV2]
Carpeta=Actualizar
Clave=Mavi.DV2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Actualizar.Mavi.DV3]
Carpeta=Actualizar
Clave=Mavi.DV3
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Actualizar.Mavi.DV4]
Carpeta=Actualizar
Clave=Mavi.DV4
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.Rango]
Carpeta=Detalle
Clave=Rango
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

Efectos=[Negritas]


[DiasLoc.Mavi.DV503]
Carpeta=DiasLoc
Clave=Mavi.DV503
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DiasLoc.Mavi.DM500LDiasInac]
Carpeta=DiasLoc
Clave=Mavi.DM500LDiasInac
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[DiasLoc.Mavi.DM500LPorcenExig]
Carpeta=DiasLoc
Clave=Mavi.DM500LPorcenExig
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Sanciones.Mavi.DM500LSancionGestor]
Carpeta=Sanciones
Clave=Mavi.DM500LSancionGestor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Sanciones.Mavi.DM500LSancionJefeGest]
Carpeta=Sanciones
Clave=Mavi.DM500LSancionJefeGest
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Sanciones.Mavi.DM500LGastosLoc]
Carpeta=Sanciones
Clave=Mavi.DM500LGastosLoc
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Detalle.Columnas]
Rango=204
InicioDv=94
FinDv=94

InicioDvBF=94
FinDvBF=94
[DetalleLoc.Concepto]
Carpeta=DetalleLoc
Clave=Concepto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco


[DetalleLoc.Columnas]
Concepto=381
Cantidad=100

CantidadBF=74
[Detalle.InicioDvBF]
Carpeta=Detalle
Clave=InicioDvBF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Detalle.FinDvBF]
Carpeta=Detalle
Clave=FinDvBF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[DetalleLoc.CantidadBF]
Carpeta=DetalleLoc
Clave=CantidadBF
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco




