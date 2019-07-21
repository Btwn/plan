[Forma]
Clave=ClienteExpressMavi
Nombre=Cliente Express
Icono=67
Modulos=(Todos)
ListaCarpetas=(Lista)
CarpetaPrincipal=Datos
PosicionInicialAlturaCliente=746
PosicionInicialAncho=587
PosicionInicialIzquierda=346
PosicionInicialArriba=120
Menus=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=(Lista)
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaExclusiva=S
VentanaBloquearAjuste=S

ExpresionesAlMostrar=Asigna(Info.Respuesta1,Nulo)<BR>Asigna(Info.Respuesta2,Nulo)<BR>Asigna(Info.Actualizar,nulo)<BR>Asigna(temp.Numerico1,0)<BR>Asigna(temp.Numerico2,0)<BR>Asigna(temp.Numerico3,0)<BR>Asigna(temp.Numerico4,0)<BR>Asigna(Info.Copiar, Falso)<BR>Asigna(Info.ABC,nulo)<BR>Asigna(Info.Cliente,SQL(<T>SP_GeneraConsecutivoCteMavi :tEmpresa<T>,Empresa))<BR>EjecutarSQL(<T>EXEC SP_EliminaRegistrosMavi<T>)                                                                                                   <BR>EjecutarSQL(<T>Sp_AccionCancelarMavi :ta<T>,Info.Cliente)<BR>EjecutarSQL(<T>SPInsertaCanalVentaMavi :ta,:tb<T>,Info.Cliente,Info.CanalVentaMavi)<BR>EjecutarSQL(<T>SP_InicioCteExpressMavi :tCliente,:tEmpresa,:nEstacion,:nSucursal,:tCategoria<T>,Info.Cliente,Empresa,EstacionTrabajo,Sucursal,Info.CategoriaMavi)<BR>Asigna(Mavi.ClienteExpressFecha, nulo)<BR>Asigna(Mavi.DM0138Nomina, nulo)<BR>Asigna(Mavi.DM0138NominaAux, nulo)<BR>Asigna(Mavi.DM0138Puesto, nulo)<BR>Asigna(Mavi.DM0138RFC, nulo)<BR>Asigna(Mavi.DM0138ClaveINST, nulo)<BR>Asigna(Mavi.DM0138Cargo, nulo)<BR>Asigna(Mavi.DM0138Municipio, nulo)
ExpresionesAlCerrar=EjecutarSQL(<T>Sp_AboOpeCteExpressMavi :tcliente<T>,info.cliente)
[Datos]
Estilo=Ficha
PestanaNombre=&Datos Generales
Clave=Datos
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ClienteExpressMavi
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=2
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Esp1<BR>EspacioLey<BR>ClienteExpressMavi.FiscalRegimenCte<BR>ClienteExpressMavi.CanalVentaCte<BR>ClienteExpressMavi.ApaternoCte<BR>ClienteExpressMavi.AmaternoCte<BR>ClienteExpressMavi.NombresCte<BR>ClienteExpressMavi.SexoCte<BR>ClienteExpressMavi.FechaNacimiento<BR>ClienteExpressMavi.RFCCte<BR>ClienteExpressMavi.EstadoCivilCte<BR>ClienteExpressMavi.AntiguaedadNegocioCte<BR>ClienteExpressMavi.ImporteRentaCte<BR>ClienteExpressMavi.TipoCalleCte1<BR>ClienteExpressMavi.AntiguedadAniosMAVI<BR>ClienteExpressMavi.AntiguedadMesesMAVI<BR>ClienteExpressMavi.DireccionCte<BR>ClienteExpressMavi.NumeroExteriorCte<BR>ClienteExpressMavi.NumeroInteriorCte<BR>ClienteExpressMavi.EntreCallesCte<BR>ClienteExpressMavi.ColoniaCte<BR>ClienteExpressMavi.CodigoPostalCte<BR>ClienteExpressMavi.DelegacionCte<BR>Cliente<CONTINUA>
CarpetaVisible=S
ListaEnCaptura002=<CONTINUA>ExpressMavi.Poblacion<BR>ClienteExpressMavi.EstadoCte<BR>ClienteExpressMavi.PaisCte<BR>ClienteExpressMavi.ViveEnCalidadCte<BR>ClienteExpressMavi.ViveConH<BR>ClienteExpressMavi.ViveEnCalidadH<BR>ClienteExpressMavi.ATipoCalleCte1<BR>ClienteExpressMavi.ADireccionCte<BR>ClienteExpressMavi.ANumeroExteriorCte<BR>ClienteExpressMavi.ANumeroInteriorCte<BR>ClienteExpressMavi.AEntreCallesCte<BR>ClienteExpressMavi.AColoniaCte<BR>ClienteExpressMavi.ACodigoPostalCte<BR>ClienteExpressMavi.ADelegacionCte<BR>ClienteExpressMavi.APoblacion<BR>ClienteExpressMavi.AEstadoCte<BR>ClienteExpressMavi.APaisCte
PestanaOtroNombre=S
Pestana=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=ClienteExpressMavi.Cliente =<T>{info.cliente}<T> AND ID=ClienteExpressMavi.ID

[Datos.ClienteExpressMavi.FiscalRegimenCte]
Carpeta=Datos
Clave=ClienteExpressMavi.FiscalRegimenCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=$FFFFFFFF

[Datos.ClienteExpressMavi.ApaternoCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ApaternoCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.AmaternoCte]
Carpeta=Datos
Clave=ClienteExpressMavi.AmaternoCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.NombresCte]
Carpeta=Datos
Clave=ClienteExpressMavi.NombresCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=32
ColorFondo=Blanco
ColorFuente=Negro


[Datos.ClienteExpressMavi.DireccionCte]
Carpeta=Datos
Clave=ClienteExpressMavi.DireccionCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Datos.ClienteExpressMavi.NumeroExteriorCte]
Carpeta=Datos
Clave=ClienteExpressMavi.NumeroExteriorCte
Editar=S
ValidaNombre=S
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.NumeroInteriorCte]
Carpeta=Datos
Clave=ClienteExpressMavi.NumeroInteriorCte
Editar=S
ValidaNombre=S
3D=S
Tamano=6
ColorFuente=Negro
ColorFondo=Blanco

[Datos.ClienteExpressMavi.EntreCallesCte]
Carpeta=Datos
Clave=ClienteExpressMavi.EntreCallesCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=48
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Datos.ClienteExpressMavi.TipoCalleCte1]
Carpeta=Datos
Clave=ClienteExpressMavi.TipoCalleCte1
Editar=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S

[Datos.ClienteExpressMavi.ColoniaCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ColoniaCte
Editar=S
ValidaNombre=S
3D=S
Tamano=48
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Datos.ClienteExpressMavi.DelegacionCte]
Carpeta=Datos
Clave=ClienteExpressMavi.DelegacionCte
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.EstadoCte]
Carpeta=Datos
Clave=ClienteExpressMavi.EstadoCte
Editar=N
ValidaNombre=S
3D=S
Tamano=37
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=N

[Datos.ClienteExpressMavi.PaisCte]
Carpeta=Datos
Clave=ClienteExpressMavi.PaisCte
Editar=N
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=N

[Datos.ClienteExpressMavi.CodigoPostalCte]
Carpeta=Datos
Clave=ClienteExpressMavi.CodigoPostalCte
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.ViveEnCalidadCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ViveEnCalidadCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=23
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.RFCCte]
Carpeta=Datos
Clave=ClienteExpressMavi.RFCCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=27
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.SexoCte]
Carpeta=Datos
Clave=ClienteExpressMavi.SexoCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Datos.ClienteExpressMavi.EstadoCivilCte]
Carpeta=Datos
Clave=ClienteExpressMavi.EstadoCivilCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Personales.ClienteExpressMavi.FechaNacimiento]
Carpeta=Personales
Clave=ClienteExpressMavi.FechaNacimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Aceptar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=ProcesarSQL(<T>SP_CargaClientesMavi :tCliente,:tAccion,:nEstacion,:nID,:tUsuario,:tRegFis<T>, Info.cliente,<T>Agregar<T>,EstacionTrabajo,ClienteExpressMavi:ClienteExpressMavi.ID, Usuario, ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte)
;Expresion=ProcesarSQL(<T>SP_CargaClientesMavi :tCliente,:tAccion,:nEstacion,:nID<T>, Info.cliente,<T>Agregar<T>,EstacionTrabajo,ClienteExpressMavi:ClienteExpressMavi.ID)




[Acciones.Cancelar]
Nombre=Cancelar
Boton=36
NombreEnBoton=S
NombreDesplegar=Cancelar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=expresion<BR>cancelar

[Acciones.Telefonos]
Nombre=Telefonos
Boton=43
NombreEnBoton=S
NombreDesplegar=&Teléfonos
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=CteTel
Activo=S
Visible=S

[Acciones.CanalVenta]
Nombre=CanalVenta
Boton=57
NombreDesplegar=&Datos Nominales
EnBarraHerramientas=S
Activo=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=CteExpressCVMavi
Multiple=S
ListaAccionesMultiples=(Lista)
ConCondicion=S
EjecucionConError=S
Antes=S

EjecucionCondicion=Condatos(ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte) y<BR>Condatos(ClienteExpressMavi:ClienteExpressMavi.DireccionCte)     y<BR>condatos(ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte)y<BR>condatos(ClienteExpressMavi:ClienteExpressMavi.ColoniaCte)       y<BR>condatos(ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte)  y<BR>condatos(ClienteExpressMavi:ClienteExpressMavi.DelegacionCte)    y<BR>condatos(ClienteExpressMavi:ClienteExpressMavi.EstadoCte)
EjecucionMensaje=<T>Es necesario capturar todos los campos requeridos<T>
AntesExpresiones=Asigna(Info.cantidad2,ClienteExpressMavi:ClienteExpressMavi.ID)
VisibleCondicion=Info.CategoriaMavi en(<T>INSTITUCIONES<T>)
[Datos.ClienteExpressMavi.Poblacion]
Carpeta=Datos
Clave=ClienteExpressMavi.Poblacion
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.FechaNacimiento]
Carpeta=Datos
Clave=ClienteExpressMavi.FechaNacimiento
Nombre=Fecha Nacimiento (dd/mm/aaaa)
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=25

[Acciones.CanalVenta.CteExpressCVMavi]
Nombre=CteExpressCVMavi
Boton=0
TipoAccion=Formas
ClaveAccion=CteExpressCVMavi
Activo=S
Visible=S

[Acciones.CanalVenta.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=guardarcambios

[Acciones.Cancelar.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL( <T>Sp_AccionCancelarMavi  :ta<T>,info.cliente)

[Acciones.Cancelar.cancelar]
Nombre=cancelar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cancelar
Activo=S
Visible=S

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

[Datos.ClienteExpressMavi.CanalVentaCte]
Carpeta=Datos
Clave=ClienteExpressMavi.CanalVentaCte
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=43
ColorFuente=Negro
ColorFondo=$00C8D0D4

[Acciones.ConExpress]
Nombre=ConExpress
Boton=60
NombreEnBoton=S
NombreDesplegar=Contactos
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=CteCtoExpess
Activo=S
Antes=S
ConCondicion=S
EjecucionConError=S
EspacioPrevio=S
EjecucionCondicion=CONDATOS(ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte)
EjecucionMensaje=<T>En necesario capturar el Regimen Fiscal<T>
AntesExpresiones=Asigna(Info.Clase,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1)<BR>Asigna(Info.clase1,ClienteExpressMavi:ClienteExpressMavi.ColoniaCte)<BR>Asigna(Info.Clase2,ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte)<BR>Asigna(Info.Clase3,ClienteExpressMavi:ClienteExpressMavi.DelegacionCte)<BR>Asigna(Info.Clase4,ClienteExpressMavi:ClienteExpressMavi.EstadoCte)<BR>Asigna(Info.Clase5,ClienteExpressMavi:ClienteExpressMavi.PaisCte)<BR>Asigna(Info.Actividad,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1)<BR>Asigna(Info.Observaciones,ClienteExpressMavi:ClienteExpressMavi.DireccionCte)<BR>Asigna(Info.Articulo,ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte)<BR>Asigna(Info.ArticuloA,ClienteExpressMavi:ClienteExpressMavi.NumeroInteriorCte)<BR>Asigna(Info.Desde1,ClienteExpressMavi:Cl<CONTINUA>
AntesExpresiones002=<CONTINUA>ienteExpressMavi.AntiguedadAniosMAVI)<BR>Asigna(Info.Desde2,ClienteExpressMavi:ClienteExpressMavi.AntiguedadMesesMAVI)<BR>Asigna(Info.Respuesta1,<T>P<T>)<BR>Asigna(Info.ABC,ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte)
VisibleCondicion=Info.CategoriaMavi en(<T>CREDITO MENUDEO<T>,<T>ASOCIADOS<T>,<T>INSTITUCIONES<T>,<T>MAYOREO<T>)

[Datos.ClienteExpressMavi.ViveConH]
Carpeta=Datos
Clave=ClienteExpressMavi.ViveConH
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.ViveEnCalidadH]
Carpeta=Datos
Clave=ClienteExpressMavi.ViveEnCalidadH
Editar=S
ValidaNombre=S
3D=S
Tamano=23
ColorFondo=Blanco
ColorFuente=Negro

;CAMBIOS AGR, SE AGREGO ACCION PARA ABRIR UNA U OTRA FORMA DEPENDIENDO DEL CANAL, 24112009
[Acciones.OtrosDatos]
Nombre=OtrosDatos
Boton=38
NombreDesplegar=Otros Datos...
EnBarraHerramientas=S
;TipoAccion=expresion
;Expresion=Si Info.CategoriaMavi=<T>CREDITO MENUDEO<T><BR>   Entonces  forma(<T>EnviarAOtrosDatosMenMavi<T>)<BR>Sino<BR>    Si Info.DescTipo=<T>MAYOREO<T><BR>       Entonces forma(<T>EnviarAOtrosDatosMayMavi<T>)<BR>    Sino forma(<T>CteEnviarAOtrosDatos<T>)<BR>    Fin<BR>Fin
TipoAccion=Formas
ClaveAccion=EnviarAOtrosDatosMayMavi
Visible=S
ActivoCondicion=Info.CategoriaMavi en(<T>MAYOREO<T>)
;Cambio 130809 Guizer
Antes=S
AntesExpresiones=Asigna(Info.ID, ClienteExpressMavi:ClienteExpressMavi.CanalVentaCte)





[Refer]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=&Referencias
Clave=Refer
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ClienteExpressMavi
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
ListaEnCaptura=ClienteExpressMavi.Recomendado<BR>ClienteExpressMavi.PuestoCte<BR>ClienteExpressMavi.Parentesco<BR>ClienteExpressMavi.DireccionP<BR>ClienteExpressMavi.Observaciones<BR>ClienteExpressMavi.Emisor1C<BR>ClienteExpressMavi.NTarjeta1C<BR>ClienteExpressMavi.Emisor2C<BR>ClienteExpressMavi.NTarjeta2C<BR>ClienteExpressMavi.Emisor1B<BR>ClienteExpressMavi.NTarjeta1B<BR>ClienteExpressMavi.Emisor2B<BR>ClienteExpressMavi.NTarjeta2B<BR>ClienteExpressMavi.Emisor3B<BR>ClienteExpressMavi.NTarjeta3B
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
FiltroGeneral=ClienteExpressMavi.Cliente =<T>{info.cliente}<T> AND ID=ClienteExpressMavi.ID
;CondicionVisible=(Info.CategoriaMavi en(<T>CREDITO MENUDEO<T>))

[Refer.ClienteExpressMavi.Observaciones]
Carpeta=Refer
Clave=ClienteExpressMavi.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=74x4
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
ConScroll=S

[Refer.ClienteExpressMavi.Emisor1C]
Carpeta=Refer
Clave=ClienteExpressMavi.Emisor1C
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.NTarjeta1C]
Carpeta=Refer
Clave=ClienteExpressMavi.NTarjeta1C
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.Emisor2C]
Carpeta=Refer
Clave=ClienteExpressMavi.Emisor2C
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.NTarjeta2C]
Carpeta=Refer
Clave=ClienteExpressMavi.NTarjeta2C
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.Emisor1B]
Carpeta=Refer
Clave=ClienteExpressMavi.Emisor1B
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.NTarjeta1B]
Carpeta=Refer
Clave=ClienteExpressMavi.NTarjeta1B
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.Emisor2B]
Carpeta=Refer
Clave=ClienteExpressMavi.Emisor2B
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.NTarjeta2B]
Carpeta=Refer
Clave=ClienteExpressMavi.NTarjeta2B
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.Emisor3B]
Carpeta=Refer
Clave=ClienteExpressMavi.Emisor3B
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.NTarjeta3B]
Carpeta=Refer
Clave=ClienteExpressMavi.NTarjeta3B
Editar=S
ValidaNombre=S
3D=S
Tamano=28
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.ATipoCalleCte1]
Carpeta=Datos
Clave=ClienteExpressMavi.ATipoCalleCte1
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S

[Datos.ClienteExpressMavi.ADireccionCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ADireccionCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=58
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Datos.ClienteExpressMavi.ANumeroExteriorCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ANumeroExteriorCte
Editar=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.ANumeroInteriorCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ANumeroInteriorCte
Editar=S
ValidaNombre=S
3D=S
Tamano=6
ColorFuente=Negro
ColorFondo=Blanco

[Datos.ClienteExpressMavi.AEntreCallesCte]
Carpeta=Datos
Clave=ClienteExpressMavi.AEntreCallesCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=48
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Datos.ClienteExpressMavi.AColoniaCte]
Carpeta=Datos
Clave=ClienteExpressMavi.AColoniaCte
Editar=S
ValidaNombre=S
3D=S
Tamano=48
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Datos.ClienteExpressMavi.ACodigoPostalCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ACodigoPostalCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.ADelegacionCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ADelegacionCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=43
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.APoblacion]
Carpeta=Datos
Clave=ClienteExpressMavi.APoblacion
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.AEstadoCte]
Carpeta=Datos
Clave=ClienteExpressMavi.AEstadoCte
Editar=S
ValidaNombre=S
3D=S
Tamano=37
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=N

[Datos.ClienteExpressMavi.APaisCte]
Carpeta=Datos
Clave=ClienteExpressMavi.APaisCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.Recomendado]
Carpeta=Refer
Clave=ClienteExpressMavi.Recomendado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=14
ColorFuente=Negro
ColorFondo=Blanco

[Refer.ClienteExpressMavi.PuestoCte]
Carpeta=Refer
Clave=ClienteExpressMavi.PuestoCte
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Plata
ColorFuente=Negro

[Refer.ClienteExpressMavi.Parentesco]
Carpeta=Refer
Clave=ClienteExpressMavi.Parentesco
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=13
ColorFondo=Blanco
ColorFuente=Negro

[Refer.ClienteExpressMavi.DireccionP]
Carpeta=Refer
Clave=ClienteExpressMavi.DireccionP
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.AntiguaedadNegocioCte]
Carpeta=Datos
Clave=ClienteExpressMavi.AntiguaedadNegocioCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Datos.ClienteExpressMavi.ImporteRentaCte]
Carpeta=Datos
Clave=ClienteExpressMavi.ImporteRentaCte
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Tamano=20




[Datos.ClienteExpressMavi.AntiguedadMesesMAVI]
Carpeta=Datos
Clave=ClienteExpressMavi.AntiguedadMesesMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=16
ColorFondo=Blanco
ColorFuente=Negro

[Datos.ClienteExpressMavi.AntiguedadAniosMAVI]
Carpeta=Datos
Clave=ClienteExpressMavi.AntiguedadAniosMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=16
ColorFondo=Blanco
ColorFuente=Negro

[Empleo]
Estilo=Ficha
Clave=Empleo
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=ClienteExpressMavi
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
ListaEnCaptura=ClienteExpressMavi.EEmpresa<BR>ClienteExpressMavi.EFunciones<BR>ClienteExpressMavi.EDepartamento<BR>ClienteExpressMavi.EAntiguedadAniosMAVI<BR>ClienteExpressMavi.EAntiguedadMesesMAVI<BR>ClienteExpressMavi.EJefeInmediato<BR>ClienteExpressMavi.EPuestoJefeInmediato<BR>ClienteExpressMavi.EIngresos<BR>ClienteExpressMavi.EPeriodoIngresos<BR>ClienteExpressMavi.EComprobables<BR>ClienteExpressMavi.ETipoCalle<BR>ClienteExpressMavi.EDireccion<BR>ClienteExpressMavi.ENumeroExterior<BR>ClienteExpressMavi.ENumeroInterior<BR>ClienteExpressMavi.ECruces<BR>ClienteExpressMavi.EColonia<BR>ClienteExpressMavi.ECodigoPostal<BR>ClienteExpressMavi.EDelegacion<BR>ClienteExpressMavi.EEstado<BR>ClienteExpressMavi.EPais<BR>ClienteExpressMavi.ETrabajoAnterior<BR>ClienteExpressMavi.ETATipoCalle<BR>ClienteExpressMavi.ETA<CONTINUA>
ListaEnCaptura002=<CONTINUA>Direccion<BR>ClienteExpressMavi.ETANumeroExterior<BR>ClienteExpressMavi.ETANumeroInterior<BR>ClienteExpressMavi.ETAEntreCalles<BR>ClienteExpressMavi.ETAColonia<BR>ClienteExpressMavi.ETACodigoPostal<BR>ClienteExpressMavi.ETADelegacion<BR>ClienteExpressMavi.ETAEstado<BR>ClienteExpressMavi.ETAPais
PestanaOtroNombre=S
PestanaNombre=&Empleo
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
Pestana=S
FiltroGeneral=ClienteExpressMavi.Cliente =<T>{info.cliente}<T> AND ID=ClienteExpressMavi.ID
CondicionVisible=(ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte<><T>Persona Moral<T>) y (Info.CategoriaMavi en(<T>CREDITO MENUDEO<T>,<T>ASOCIADOS<T>,<T>INSTITUCIONES<T>))


[Empleo.ClienteExpressMavi.EEmpresa]
Carpeta=Empleo
Clave=ClienteExpressMavi.EEmpresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=74
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EFunciones]
Carpeta=Empleo
Clave=ClienteExpressMavi.EFunciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=74x4
ConScroll=S

[Empleo.ClienteExpressMavi.EDepartamento]
Carpeta=Empleo
Clave=ClienteExpressMavi.EDepartamento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=34
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EAntiguedadMesesMAVI]
Carpeta=Empleo
Clave=ClienteExpressMavi.EAntiguedadMesesMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=19
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EAntiguedadAniosMAVI]
Carpeta=Empleo
Clave=ClienteExpressMavi.EAntiguedadAniosMAVI
Editar=S
ValidaNombre=S
3D=S
Tamano=19
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EJefeInmediato]
Carpeta=Empleo
Clave=ClienteExpressMavi.EJefeInmediato
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=44
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EPuestoJefeInmediato]
Carpeta=Empleo
Clave=ClienteExpressMavi.EPuestoJefeInmediato
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=29
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EIngresos]
Carpeta=Empleo
Clave=ClienteExpressMavi.EIngresos
Editar=S
ValidaNombre=S
3D=S
Tamano=24
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Empleo.ClienteExpressMavi.EPeriodoIngresos]
Carpeta=Empleo
Clave=ClienteExpressMavi.EPeriodoIngresos
Editar=S
ValidaNombre=S
3D=S
Tamano=24
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EComprobables]
Carpeta=Empleo
Clave=ClienteExpressMavi.EComprobables
Editar=S
ValidaNombre=N
3D=S
Tamano=24
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETipoCalle]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETipoCalle
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Empleo.ClienteExpressMavi.EDireccion]
Carpeta=Empleo
Clave=ClienteExpressMavi.EDireccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=74
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ENumeroExterior]
Carpeta=Empleo
Clave=ClienteExpressMavi.ENumeroExterior
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ENumeroInterior]
Carpeta=Empleo
Clave=ClienteExpressMavi.ENumeroInterior
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ECruces]
Carpeta=Empleo
Clave=ClienteExpressMavi.ECruces
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=32
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EColonia]
Carpeta=Empleo
Clave=ClienteExpressMavi.EColonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ECodigoPostal]
Carpeta=Empleo
Clave=ClienteExpressMavi.ECodigoPostal
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EDelegacion]
Carpeta=Empleo
Clave=ClienteExpressMavi.EDelegacion
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.EEstado]
Carpeta=Empleo
Clave=ClienteExpressMavi.EEstado
Editar=N
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Empleo.ClienteExpressMavi.EPais]
Carpeta=Empleo
Clave=ClienteExpressMavi.EPais
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=37
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETrabajoAnterior]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETrabajoAnterior
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=74
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETATipoCalle]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETATipoCalle
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETADireccion]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETADireccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=74
ColorFondo=Blanco
ColorFuente=Negro


[Empleo.ClienteExpressMavi.ETANumeroExterior]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETANumeroExterior
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETANumeroInterior]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETANumeroInterior
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETAEntreCalles]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETAEntreCalles
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=32
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETAColonia]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETAColonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETACodigoPostal]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETACodigoPostal
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Empleo.ClienteExpressMavi.ETADelegacion]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETADelegacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=26
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETAEstado]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETAEstado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=36
ColorFondo=Blanco
ColorFuente=Negro

[Empleo.ClienteExpressMavi.ETAPais]
Carpeta=Empleo
Clave=ClienteExpressMavi.ETAPais
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=37
ColorFondo=Blanco
ColorFuente=Negro



[Datos.Esp1]
Carpeta=Datos
Clave=Esp1
OcultaNombre=S
Tamano=37
ColorFondo=$00E6E6E6
ColorFuente=Negro
[Datos.EspacioLey]
Carpeta=Datos
Clave=EspacioLey
Editar=S
ValidaNombre=N
OcultaNombre=S
Tamano=34
ColorFondo=$00E6E6E6
ColorFuente=Azul
[Acciones.ImprSol]
Nombre=ImprSol
Boton=4
NombreEnBoton=S
NombreDesplegar=&Imprimir Solicitud
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Reportes Pantalla
ClaveAccion=RM0855AVTASImprSolCredRep
Activo=S
ConCondicion=S
Visible=S
Antes=S
Multiple=S
ListaAccionesMultiples=gua<BR>rep
EjecucionCondicion=SQL(<T>Sp_ValidadCamposTotalMavi :tCte,:tCat,:tRF,:tSex,:tFec,:tNoms,:tAp,:tAm,:tNom,:tTC,:tDir,:tNExt,:tEnCales,:tCol,:tCP,:tDel,:tEdo,:tPais,:tViEnCal,:tViConH,:tViEnCalH,:tImpRenta,:tAntNegocio,:tRFC,:tEdoCivil,:nID,:tCInst,:tRecomendado,:tParentesco,:tDireccionP,:tATipoCalle,:tADireccion,:tANumeroExterior,:tAEntreCalles,:tAColonia,:tACodigoPostal,:tADelegacion,:tAEstado,:tAPais,:tEmpresa,:nAntiguedadAniosMAVI,:nAntiguedadMesesMAVI, :nRenta<T>,Info.cliente,Info.CategoriaMavi,ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte,ClienteExpressMavi:ClienteExpressMavi.SexoCte,ClienteExpressMavi:ClienteExpressMavi.FechaNacimiento,ClienteExpressMavi:ClienteExpressMavi.NombresCte,ClienteExpressMavi:ClienteExpressMavi.ApaternoCte,ClienteExpressMavi:ClienteExpressMavi.AmaternoCte,ClienteExpres<CONTINUA>
EjecucionCondicion002=<CONTINUA>sMavi:ClienteExpressMavi.Nombre,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.DireccionCte,ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.EntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.ColoniaCte,ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.DelegacionCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCte,ClienteExpressMavi:ClienteExpressMavi.PaisCte,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadCte,ClienteExpressMavi:ClienteExpressMavi.ViveConH,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadH,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte,ClienteExpressMavi:ClienteExpressMavi.AntiguaedadNegocioCte,ClienteExpressMavi:ClienteExpressMavi.<CONTINUA>
EjecucionCondicion003=<CONTINUA>RFCCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCivilCte,ClienteExpressMavi:ClienteExpressMavi.ID,ClienteExpressMavi:ClienteExpressMavi.ClaveINST,ClienteExpressMavi:ClienteExpressMavi.Recomendado,ClienteExpressMavi:ClienteExpressMavi.Parentesco,ClienteExpressMavi:ClienteExpressMavi.DireccionP,ClienteExpressMavi:ClienteExpressMavi.ATipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.ADireccionCte,ClienteExpressMavi:ClienteExpressMavi.ANumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.AEntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.AColoniaCte,ClienteExpressMavi:ClienteExpressMavi.ACodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.ADelegacionCte,ClienteExpressMavi:ClienteExpressMavi.AEstadoCte,ClienteExpressMavi:ClienteExpressMavi.APaisCte,ClienteExpressMavi:ClienteExpress<CONTINUA>
EjecucionCondicion004=<CONTINUA>Mavi.EEmpresa,ClienteExpressMavi:ClienteExpressMavi.AntiguedadAniosMAVI,ClienteExpressMavi:ClienteExpressMavi.AntiguedadMesesMAVI,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte)<BR>SI SQL(<T>Sp_ValidadCamposTotalMavi :tCte,:tCat,:tRF,:tSex,:tFec,:tNoms,:tAp,:tAm,:tNom,:tTC,:tDir,:tNExt,:tEnCales,:tCol,:tCP,:tDel,:tEdo,:tPais,:tViEnCal,:tViConH,:tViEnCalH,:tImpRenta,:tAntNegocio,:tRFC,:tEdoCivil,:nID,:tCInst,:tRecomendado,:tParentesco,:tDireccionP,:tATipoCalle,:tADireccion,:tANumeroExterior,:tAEntreCalles,:tAColonia,:tACodigoPostal,:tADelegacion,:tAEstado,:tAPais,:tEmpresa,:nAntiguedadAniosMAVI,:nAntiguedadMesesMAVI, :nRenta<T>,Info.cliente,Info.CategoriaMavi,ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte,ClienteExpressMavi:ClienteExpressMavi.SexoCte,ClienteExpressMavi:Client<CONTINUA>
EjecucionCondicion005=<CONTINUA>eExpressMavi.FechaNacimiento,ClienteExpressMavi:ClienteExpressMavi.NombresCte,ClienteExpressMavi:ClienteExpressMavi.ApaternoCte,ClienteExpressMavi:ClienteExpressMavi.AmaternoCte,ClienteExpressMavi:ClienteExpressMavi.Nombre,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.DireccionCte,ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.EntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.ColoniaCte,ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.DelegacionCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCte,ClienteExpressMavi:ClienteExpressMavi.PaisCte,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadCte,ClienteExpressMavi:ClienteExpressMavi.ViveConH,ClienteExpress<CONTINUA>
EjecucionCondicion006=<CONTINUA>Mavi:ClienteExpressMavi.ViveEnCalidadH,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte,ClienteExpressMavi:ClienteExpressMavi.AntiguaedadNegocioCte,ClienteExpressMavi:ClienteExpressMavi.RFCCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCivilCte,ClienteExpressMavi:ClienteExpressMavi.ID,ClienteExpressMavi:ClienteExpressMavi.ClaveINST,ClienteExpressMavi:ClienteExpressMavi.Recomendado,ClienteExpressMavi:ClienteExpressMavi.Parentesco,ClienteExpressMavi:ClienteExpressMavi.DireccionP,ClienteExpressMavi:ClienteExpressMavi.ATipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.ADireccionCte,ClienteExpressMavi:ClienteExpressMavi.ANumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.AEntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.AColoniaCte,ClienteExpressMavi:ClienteExpressMavi.ACodigoP<CONTINUA>
EjecucionCondicion007=<CONTINUA>ostalCte,ClienteExpressMavi:ClienteExpressMavi.ADelegacionCte,ClienteExpressMavi:ClienteExpressMavi.AEstadoCte,ClienteExpressMavi:ClienteExpressMavi.APaisCte,ClienteExpressMavi:ClienteExpressMavi.EEmpresa,ClienteExpressMavi:ClienteExpressMavi.AntiguedadAniosMAVI,ClienteExpressMavi:ClienteExpressMavi.AntiguedadMesesMAVI,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte)<> verdadero<BR> entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> ERROR(Info.Dialogo)<BR> fin
AntesExpresiones=Asigna(Info.ClienteD,ClienteExpressMavi:ClienteExpressMavi.Cliente)
[Acciones.ImprSol.gua]
Nombre=gua
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Acciones.ImprSol.rep]
Nombre=rep
Boton=0
TipoAccion=Reportes Pantalla
ClaveAccion=RM0855AVTASImprSolCredRep
Activo=S
Visible=S
[Acciones.ref]
Nombre=ref
Boton=0
Boton=0
NombreDesplegar=refrescaFNac
TipoAccion=Expresion
Activo=S
Visible=S
ConAutoEjecutar=S
EnBarraHerramientas=S
Expresion=Asigna(ClienteExpressMavi:ClienteExpressMavi.FechaNacimiento,Mavi.ClienteExpressFecha)<BR>si(condatos(ClienteExpressMavi:ClienteExpressMavi.FechaNacimiento),Asigna(Mavi.ClienteExpressFecha,nulo),<T><T>)
ConCondicion=S
EjecucionCondicion=condatos(Mavi.ClienteExpressFecha)
AutoEjecutarExpresion=1
[Acciones.Aceptar1.expresion]
Nombre=expresion
Boton=0
TipoAccion=Expresion
Expresion=SQL(<T>SP_CargaClientesMavi :tCliente,:tAccion,:nEstacion,:nID,:tUsuario,:tRegFisc<T>, Info.cliente,<T>Agregar<T>,EstacionTrabajo,ClienteExpressMavi:ClienteExpressMavi.ID, Usuario, ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte)
[Acciones.Aceptar]
Nombre=Aceptar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraHerramientas=S
ListaAccionesMultiples=Aceptar<BR>expresion<BR>Cerrar
Activo=S
ConCondicion=S
Visible=S
EjecucionCondicion=ActualizarForma<BR>SQL(<T>Sp_ValidadCamposTotalMavi :tCte,:tCat,:tRF,:tSex,:tFec,:tNoms,:tAp,:tAm,:tNom,:tTC,:tDir,:tNExt,:tEnCales,:tCol,:tCP,:tDel,:tEdo,:tPais,:tViEnCal,:tViConH,:tViEnCalH,:tImpRenta,:tAntNegocio,:tRFC,:tEdoCivil,:nID,:tCInst,:tRecomendado,:tParentesco,:tDireccionP,:tATipoCalle,:tADireccion,:tANumeroExterior,:tAEntreCalles,:tAColonia,:tACodigoPostal,:tADelegacion,:tAEstado,:tAPais,:tEmpresa,:nAntiguedadAniosMAVI,:nAntiguedadMesesMAVI, :nRenta<T>,Info.cliente,Info.CategoriaMavi,ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte,ClienteExpressMavi:ClienteExpressMavi.SexoCte,ClienteExpressMavi:ClienteExpressMavi.FechaNacimiento,ClienteExpressMavi:ClienteExpressMavi.NombresCte,ClienteExpressMavi:ClienteExpressMavi.ApaternoCte,ClienteExpressMavi:ClienteExpressMavi.Amater<CONTINUA>
EjecucionCondicion002=<CONTINUA>noCte,ClienteExpressMavi:ClienteExpressMavi.Nombre,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.DireccionCte,ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.EntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.ColoniaCte,ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.DelegacionCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCte,ClienteExpressMavi:ClienteExpressMavi.PaisCte,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadCte,ClienteExpressMavi:ClienteExpressMavi.ViveConH,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadH,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte,ClienteExpressMavi:ClienteExpressMavi.AntiguaedadNegocioCte,ClienteExpressMavi:<CONTINUA>
EjecucionCondicion003=<CONTINUA>ClienteExpressMavi.RFCCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCivilCte,ClienteExpressMavi:ClienteExpressMavi.ID,ClienteExpressMavi:ClienteExpressMavi.ClaveINST,ClienteExpressMavi:ClienteExpressMavi.Recomendado,ClienteExpressMavi:ClienteExpressMavi.Parentesco,ClienteExpressMavi:ClienteExpressMavi.DireccionP,ClienteExpressMavi:ClienteExpressMavi.ATipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.ADireccionCte,ClienteExpressMavi:ClienteExpressMavi.ANumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.AEntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.AColoniaCte,ClienteExpressMavi:ClienteExpressMavi.ACodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.ADelegacionCte,ClienteExpressMavi:ClienteExpressMavi.AEstadoCte,ClienteExpressMavi:ClienteExpressMavi.APaisCte,ClienteExpress<CONTINUA>
EjecucionCondicion004=<CONTINUA>Mavi:ClienteExpressMavi.EEmpresa,ClienteExpressMavi:ClienteExpressMavi.AntiguedadAniosMAVI,ClienteExpressMavi:ClienteExpressMavi.AntiguedadMesesMAVI,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte)<BR>SI SQL(<T>Sp_ValidadCamposTotalMavi :tCte,:tCat,:tRF,:tSex,:tFec,:tNoms,:tAp,:tAm,:tNom,:tTC,:tDir,:tNExt,:tEnCales,:tCol,:tCP,:tDel,:tEdo,:tPais,:tViEnCal,:tViConH,:tViEnCalH,:tImpRenta,:tAntNegocio,:tRFC,:tEdoCivil,:nID,:tCInst,:tRecomendado,:tParentesco,:tDireccionP,:tATipoCalle,:tADireccion,:tANumeroExterior,:tAEntreCalles,:tAColonia,:tACodigoPostal,:tADelegacion,:tAEstado,:tAPais,:tEmpresa,:nAntiguedadAniosMAVI,:nAntiguedadMesesMAVI, :nRenta<T>,Info.cliente,Info.CategoriaMavi,ClienteExpressMavi:ClienteExpressMavi.FiscalRegimenCte,ClienteExpressMavi:ClienteExpressMavi.SexoCte,Client<CONTINUA>
EjecucionCondicion005=<CONTINUA>eExpressMavi:ClienteExpressMavi.FechaNacimiento,ClienteExpressMavi:ClienteExpressMavi.NombresCte,ClienteExpressMavi:ClienteExpressMavi.ApaternoCte,ClienteExpressMavi:ClienteExpressMavi.AmaternoCte,ClienteExpressMavi:ClienteExpressMavi.Nombre,ClienteExpressMavi:ClienteExpressMavi.TipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.DireccionCte,ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.EntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.ColoniaCte,ClienteExpressMavi:ClienteExpressMavi.CodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.DelegacionCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCte,ClienteExpressMavi:ClienteExpressMavi.PaisCte,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadCte,ClienteExpressMavi:ClienteExpressMavi.Vive<CONTINUA>
EjecucionCondicion006=<CONTINUA>ConH,ClienteExpressMavi:ClienteExpressMavi.ViveEnCalidadH,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte,ClienteExpressMavi:ClienteExpressMavi.AntiguaedadNegocioCte,ClienteExpressMavi:ClienteExpressMavi.RFCCte,ClienteExpressMavi:ClienteExpressMavi.EstadoCivilCte,ClienteExpressMavi:ClienteExpressMavi.ID,ClienteExpressMavi:ClienteExpressMavi.ClaveINST,ClienteExpressMavi:ClienteExpressMavi.Recomendado,ClienteExpressMavi:ClienteExpressMavi.Parentesco,ClienteExpressMavi:ClienteExpressMavi.DireccionP,ClienteExpressMavi:ClienteExpressMavi.ATipoCalleCte1,ClienteExpressMavi:ClienteExpressMavi.ADireccionCte,ClienteExpressMavi:ClienteExpressMavi.ANumeroExteriorCte,ClienteExpressMavi:ClienteExpressMavi.AEntreCallesCte,ClienteExpressMavi:ClienteExpressMavi.AColoniaCte,ClienteExpressMavi:ClienteE<CONTINUA>
EjecucionCondicion007=<CONTINUA>xpressMavi.ACodigoPostalCte,ClienteExpressMavi:ClienteExpressMavi.ADelegacionCte,ClienteExpressMavi:ClienteExpressMavi.AEstadoCte,ClienteExpressMavi:ClienteExpressMavi.APaisCte,ClienteExpressMavi:ClienteExpressMavi.EEmpresa,ClienteExpressMavi:ClienteExpressMavi.AntiguedadAniosMAVI,ClienteExpressMavi:ClienteExpressMavi.AntiguedadMesesMAVI,ClienteExpressMavi:ClienteExpressMavi.ImporteRentaCte)<> verdadero<BR> entonces<BR> Asigna(Info.Dialogo,SQL(<T>SELECT Mensaje FROM MensajeErrorMavi<T>))<BR> ERROR(Info.Dialogo)<BR> fin
[Acciones.GoogleMaps]
Nombre=GoogleMaps
Boton=106
NombreEnBoton=S
NombreDesplegar=&GoogleMaps
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
ConCondicion=S
EjecucionConError=S
Expresion=asigna(Info.ClienteNombre,<T>Cliente<T>)<BR>ejecutar(<T>PlugIns\MAPAS.exe <T>+<BR>ClienteExpressMavi:ClienteExpressMavi.Cliente+<BR><T> <T>+ Info.ClienteNombre +<BR><T> <T>+ Reemplaza( <T> <T>, <T>%20<T>, ClienteExpressMavi:ClienteExpressMavi.DireccionCte+ <T> <T> +ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte)+<BR><T> <T>+ Reemplaza( <T> <T>, <T>%20<T>, ClienteExpressMavi:ClienteExpressMavi.ColoniaCte)+<BR><T> <T>+ Reemplaza( <T> <T>, <T>%20<T>, ClienteExpressMavi:ClienteExpressMavi.DelegacionCte)+<BR><T> <T>+ Reemplaza( <T> <T>, <T>%20<T>, ClienteExpressMavi:ClienteExpressMavi.EstadoCte)+<BR><T> <T>+ 0 +<BR><T> <T>+ NumEnTexto(sql(<T>SELECT Uen FROM ventascanalmavi WHERE id=:tCliente<T>,ClienteExpressMavi:ClienteExpressMavi.CanalVentaCte)))<BR><BR>/* CLIENTE/PROSPECTO,<BR>TIPO <CONTINUA>
Expresion002=<CONTINUA>DE CLIENTE/PROSPECTO,<BR>DOMICILIO,<BR>COLONIA,<BR>POBLACION,<BR>ESTADO,<BR>ID CONTACTO,<BR>UEN */
EjecucionCondicion=condatos(ClienteExpressMavi:ClienteExpressMavi.DireccionCte) y condatos(ClienteExpressMavi:ClienteExpressMavi.NumeroExteriorCte)<BR>y condatos(ClienteExpressMavi:ClienteExpressMavi.DelegacionCte) y condatos(ClienteExpressMavi:ClienteExpressMavi.EstadoCte)<BR>y condatos(ClienteExpressMavi:ClienteExpressMavi.ColoniaCte)
EjecucionMensaje=<T>Los campos Direccion,NumeroExteriror,Colonia,Delegacion y Estado<T>



[Acciones.CanalVenta.Asigna]
Nombre=Asigna
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna( Mavi.DM0138RFC, ClienteExpressMavi:ClienteExpressMavi.RFCCte )




[Acciones.CanalVenta.ListaAccionesMultiples]
(Inicio)=Asigna
Asigna=CteExpressCVMavi
CteExpressCVMavi=Guardar
Guardar=(Fin)









[Forma.ListaCarpetas]
(Inicio)=Datos
Datos=Empleo
Empleo=Refer
Refer=(Fin)

[Forma.ListaAcciones]
(Inicio)=Aceptar
Aceptar=Cancelar
Cancelar=Telefonos
Telefonos=ConExpress
ConExpress=CanalVenta
CanalVenta=OtrosDatos
OtrosDatos=ImprSol
ImprSol=ref
ref=GoogleMaps
GoogleMaps=(Fin)

