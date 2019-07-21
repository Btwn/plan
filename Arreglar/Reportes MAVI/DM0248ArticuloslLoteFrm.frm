[Forma]
Clave=DM0248ArticuloslLoteFrm
Nombre=Creación de Artículos por Lote
Icono=0
Modulos=(Todos)
ListaCarpetas=dm0248ArticulosloteClave
CarpetaPrincipal=dm0248ArticulosloteClave
PosicionInicialAlturaCliente=404
PosicionInicialAncho=1203
PosicionInicialIzquierda=13
PosicionInicialArriba=169
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=ClaveExcel<BR>Cerrar<BR>Guardar
MovModulo=(Todos)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
VentanaEstadoInicial=Normal
ExpresionesAlCerrar=EjecutarSQL(<T>EXEC SP_DM0248TruncateCerrar<T>)
[dm0248ArticulosloteClave]
Estilo=Hoja
Clave=dm0248ArticulosloteClave
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0248ArticulosloteVis
Fuente={Tahoma, 9, Negro, [Negritas]}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
PestanaNombre=Creación de Artículos por Lote
PermiteEditar=S
ListaEnCaptura=DM0248Articuloslotedlg.Articulo<BR>DM0248Articuloslotedlg.Tipo<BR>DM0248Articuloslotedlg.Descripcion1<BR>DM0248Articuloslotedlg.Unidad<BR>DM0248Articuloslotedlg.Grupo<BR>DM0248Articuloslotedlg.Familia<BR>DM0248Articuloslotedlg.Linea<BR>DM0248Articuloslotedlg.Fabricante<BR>DM0248Articuloslotedlg.ClaveFabricante<BR>DM0248Articuloslotedlg.TipoCompra<BR>DM0248Articuloslotedlg.InvSeguridad<BR>DM0248Articuloslotedlg.TiempoEntrega<BR>DM0248Articuloslotedlg.TipoEmpaque<BR>DM0248Articuloslotedlg.PropiedadColor<BR>DM0248Articuloslotedlg.PropiedadModelo<BR>DM0248Articuloslotedlg.PropiedadSublinea<BR>DM0248Articuloslotedlg.Codigo<BR>DM0248Articuloslotedlg.Proveedor<BR>DM0248Articuloslotedlg.Almacen<BR>DM0248Articuloslotedlg.Almacen2<BR>DM0248Articuloslotedlg.Mini<BR>DM0248Articuloslotedlg.Maxi<BR>DM02<CONTINUA>
ListaEnCaptura002=<CONTINUA>48Articuloslotedlg.PropiedadTalla<BR>DM0248Articuloslotedlg.PropiedadCorrida<BR>DM0248Articuloslotedlg.MarcaE<BR>DM0248Articuloslotedlg.ModeloE<BR>DM0248Articuloslotedlg.LineaE<BR>DM0248Articuloslotedlg.CodigoAlterno<BR>DM0248Articuloslotedlg.Corte<BR>DM0248Articuloslotedlg.Forro<BR>DM0248Articuloslotedlg.Suela<BR>DM0248Articuloslotedlg.Color<BR>DM0248Articuloslotedlg.TipoC<BR>DM0248Articuloslotedlg.TallasDisp<BR>DM0248Articuloslotedlg.Talla
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
[Acciones.Guardar.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Cerrar.Cancelar Cambios]
Nombre=Cancelar Cambios
Boton=0
TipoAccion=controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.Cerrar.Agregar]
Nombre=Agregar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Acciones.Cerrar]
Nombre=Cerrar
Boton=36
NombreDesplegar=&Cerrar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Cancelar Cambios<BR>Agregar
Activo=S
Visible=S
NombreEnBoton=S
[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=dm0248ArticulosloteVis
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
[dm0248ArticulosloteClave.Columnas]
Articulo=81
Tipo=84
Descripcion1=362
Unidad=45
Grupo=120
Familia=96
Linea=124
Fabricante=93
ClaveFabricante=92
TipoCompra=67
InvSeguridad=71
TiempoEntrega=77
TipoEmpaque=72
Almacen=62
Minimo=64
Maximo=64
PropiedadColor=82
PropiedadModelo=88
PropiedadSublinea=93
Codigo=60
Proveedor=58
idArticulo=64
Bandera=604
Min=64
Max=64
Mini=42
Maxi=44
PropiedadTalla=77
PropiedadCorrida=93
Almacen2=62
MarcaE=93
ModeloE=87
LineaE=98
CodigoAlterno=86
0=-2
1=-2
2=-2
3=-2
4=-2
5=-2
6=-2
7=-2
8=-2
9=-2
10=-2
11=-2
12=-2
13=-2
14=-2
15=-2
16=-2
17=-2
18=-2
19=-2
20=-2
21=-2
22=-2
23=-2
24=-2
25=-2
26=-2
27=-2
Corte=97
Forro=106
Suela=101
Color=106
TipoC=106
TallasDisp=111
Talla=68
[Acciones.Guardar.Guarda]
Nombre=Guarda
Boton=0
TipoAccion=controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Guardar.Condicion]
Nombre=Condicion
Boton=0
TipoAccion=expresion
Activo=S
Visible=S
Expresion=Si<BR>      ( SQL(<T>select COUNT(a)  from(<BR>        Select Count(Articulo) a from (<BR>         Select Articulo  From DM0248articuloslotes WITH(NOLOCK)) alias group by Articulo) temp where a>1<T>)=0)<BR>                y<BR>                 ( SQL(<T>select COUNT(a)  from(<BR>                        Select Count(Codigo) a from (<BR>                        Select Codigo  FROM DM0248articuloslotes WITH(NOLOCK)) alias group by Codigo) temp where a>1<T>)=0)<BR>       <BR>      Entonces     <BR><BR>        Asigna(Info.Dialogo,SQL(<T>EXEC SP_MAVIDM0248articuloslote  :tUSr<T>, Usuario))<BR>        Informacion(Info.Dialogo)<BR>                                <BR>    Sino<BR>        Asigna(Info.Dialogo, SQL(<T>EXEC SP_DM0248TruncarImportacion<T>) )<BR>      Si<BR>        Info.Dialogo<><T>NA<T><BR<CONTINUA>
Expresion002=<CONTINUA>>        Entonces<BR>        Error(Info.Dialogo)                                         <BR>      Fin<BR>Fin
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Articulo]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Articulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Tipo]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Tipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Descripcion1]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Unidad]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Unidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Grupo]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Familia]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Linea]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Linea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Fabricante]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Fabricante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.ClaveFabricante]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.ClaveFabricante
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.TipoCompra]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.TipoCompra
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.InvSeguridad]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.InvSeguridad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.TiempoEntrega]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.TiempoEntrega
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.TipoEmpaque]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.TipoEmpaque
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.PropiedadColor]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.PropiedadColor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.PropiedadModelo]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.PropiedadModelo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.PropiedadSublinea]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.PropiedadSublinea
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Codigo]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Codigo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Proveedor]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Proveedor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Almacen]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Almacen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Mini]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Mini
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Maxi]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Maxi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.CERRAR]
Nombre=CERRAR
Boton=0
TipoAccion=ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.PropiedadTalla]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.PropiedadTalla
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.PropiedadCorrida]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.PropiedadCorrida
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Almacen2]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Almacen2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=255
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.MarcaE]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.MarcaE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.ModeloE]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.ModeloE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.LineaE]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.LineaE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.CodigoAlterno]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.CodigoAlterno
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ClaveExcel.Importa]
Nombre=Importa
Boton=0
TipoAccion=Controles Captura
ClaveAccion=dm0248ArticulosloteClave
Activo=S
Visible=S
[Acciones.ClaveExcel.Condicionar]
Nombre=Condicionar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
[Acciones.ClaveExcel.Importar]
Nombre=Importar
Boton=0
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.ClaveExcel.Condicion]
Nombre=Condicion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si (SQL(<T>Select Count(DM.MarcaE)From DM0248articuloslotes DM With(NoLock)<BR>    Where DM.MarcaE en(Select Marca From DM0270CatalogoMarcas)<T>)>=1)<BR>Entonces<BR> Asigna(Info.Mensaje, <T>Si hay<T>)<BR> Informacion(Info.Mensaje)<BR>Sino                                                 <BR> Asigna(Info.Mensaje, <T>No hay<T>)<BR> Informacion(Info.Mensaje)<BR>Fin
[Acciones.Importar.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Importar.guardar Cambios]
Nombre=guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Importar.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_DM0248ValidacionMarcaTipo<T>))<BR>Si<BR>  Info.Dialogo=<T>INCORRECTO<T><BR>Entonces<BR>  Error(<T>Marca o Tipo Incorrectos, Por favor verifique<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Informacion(<T>Importación correcta<T>)<BR>   Verdadero<BR>Fin
[Acciones.Importar.actualizar Vista]
Nombre=actualizar Vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ClaveExcel.Enviar/Recibir]
Nombre=Enviar/Recibir
Boton=0
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.ClaveExcel.Guardar cambios]
Nombre=Guardar cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.ClaveExcel.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.Dialogo,SQL(<T>EXEC SP_DM0248ValidacionMarcaTipo<T>))<BR>Si<BR>  Info.Dialogo=<T>INCORRECTO<T><BR>Entonces<BR> Error(Info.Dialogo)<BR>  AbortarOperacion<BR>Sino<BR>  Si<BR>   Info.Dialogo=<T>CORRECTO<T><BR>  Entonces<BR>   Informacion(<T>Importación correcta<T>)<BR>   Verdadero<BR>  Fin<BR>Fin
[Acciones.ClaveExcel.Actualizar vista]
Nombre=Actualizar vista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Importa.Enviar/Recibir]
Nombre=Enviar/Recibir
Boton=0
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.Importa.guardar Cambios]
Nombre=guardar Cambios
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Importa.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=dm0248ArticulosloteClave<BR><BR><BR>Asigna(Info.Dialogo,SQL(<T>EXEC SP_DM0248ValidacionMarcaTipo<T>))<BR>Si<BR>  Info.Dialogo=<T>INCORRECTO<T><BR>Entonces<BR>  Error(<T>Marca o Tipo Incorrectos, Por favor verifique<T>)<BR>  AbortarOperacion<BR>Sino<BR>  Informacion(<T>Importación correcta<T>)<BR>   Verdadero<BR>Fin<BR>Fin
Activo=S
Visible=S
[Acciones.Importa.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ClaveExcel]
Nombre=ClaveExcel
Boton=115
NombreEnBoton=S
NombreDesplegar=Importar Excel
EnBarraHerramientas=S
Activo=S
Visible=S
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Multiple=S
ListaAccionesMultiples=Enviar/Recibir Excel<BR>Guardar<BR>Actualizar
[Acciones.ClaveExcel.ActualizaVista]
Nombre=ActualizaVista
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
[Acciones.ClaveExcel.Enviar/Recibir Excel]
Nombre=Enviar/Recibir Excel
Boton=0
Carpeta=dm0248ArticulosloteClave
TipoAccion=Controles Captura
ClaveAccion=Enviar/Recibir Excel
Activo=S
Visible=S
[Acciones.ClaveExcel.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.Procesar.Condicion]
Nombre=Condicion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si ( SQL(<T>SELECT COUNT(a)  FROM( SELECT COUNT(Articulo)<BR>      a FROM (<BR>      SELECT Articulo  FROM DM0248articuloslotes WITH(NOLOCK)) alias GROUP BY Articulo) temp WHERE a>1<T>)=0)<BR>                y<BR>                 ( SQL(<T>SELECT COUNT(a)  FROM(<BR>                        SELECT COUNT(Codigo) a FROM (<BR>                        SELECT Codigo  FROM DM0248articuloslotes WITH(NOLOCK)) alias GROUP BY Codigo) temp WHERE a>1<T>)=0)<BR>    Entonces<BR><BR>                Asigna(Info.Dialogo,SQL(<T>EXEC SP_MAVIDM0248articuloslote  :tUSr<T>, Usuario))<BR>                Informacion(Info.Dialogo)<BR>    Sino<BR>                Asigna(Info.Dialogo, SQL(<T>EXEC SP_DM0248TruncarImportacion<T>) )<BR>                    Si<BR>                        Info.Dialogo<><T>NA<T><BR>             <CONTINUA>
Expresion002=<CONTINUA>      Entonces<BR>                   Error(Info.Dialogo)<BR>        Fin<BR> Fin
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Save<BR>Condicion<BR>Limpiar<BR>Actualizar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=Asigna(Mavi.DM0169Dialogo,SQL(<T>EXEC SP_DM0248ValidacionMarcaTipo<T>))<BR>Si Mavi.DM0169Dialogo = <T>CORRECTO<T><BR>Entonces Verdadero<BR>Sino<BR> Informacion(Mavi.DM0169Dialogo)<BR> AbortarOperacion<BR>Fin
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Corte]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Corte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Forro]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Forro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Suela]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Suela
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Color]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Color
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.TipoC]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.TipoC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.TallasDisp]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.TallasDisp
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[dm0248ArticulosloteClave.DM0248Articuloslotedlg.Talla]
Carpeta=dm0248ArticulosloteClave
Clave=DM0248Articuloslotedlg.Talla
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Guardar.Limpiar]
Nombre=Limpiar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EJECUTARSQL(<T>EXEC SP_DM0248TruncateCerrar<T>)
[Acciones.Guardar.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.ClaveExcel.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S
[Acciones.Guardar.Save]
Nombre=Save
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

