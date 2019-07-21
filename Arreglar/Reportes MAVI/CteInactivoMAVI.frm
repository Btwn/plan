[Forma]
Clave=CteInactivoMAVI
Nombre=<T>Coincidencia<T>
Icono=4
Modulos=(Todos)
ListaCarpetas=Ficha<BR>Personal<BR>Fiscal<BR>Seguro<BR>Venta<BR>ReglaNegocio<BR>Perfiles<BR>Ford<BR>CRM<BR>Internet<BR>Otros<BR>Comentarios<BR>FormaExtraValor
CarpetaPrincipal=Ficha
;PosicionInicialIzquierda=554
;PosicionInicialArriba=223
;PosicionInicialAltura=593
;PosicionInicialAncho=610
PosicionInicialIzquierda=677
PosicionInicialArriba=66
PosicionInicialAltura=593
PosicionInicialAncho=600
Menus=S
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
;ListaAcciones=Nuevo<BR>Abrir<BR>Guardar<BR>Situacion<BR>PlantillasOffice<BR>Eliminar<BR>MovCte<BR>Cerrar<BR>CteRelacion<BR>CteBonificacion<BR>EspacioAsignacion<BR>CteEvento<BR>CteUEN<BR>EnviarA<BR>CteCto<BR>CamposExtras<BR>Agentes<BR>CtePedidoDef<BR>Conciliar<BR>Tareas<BR>Propiedades<BR>Evaluaciones<BR>Anexos<BR>Doc<BR>Politica<BR>RefCta<BR>AgregarEvento<BR>CteArt<BR>CapacidadPago<BR>CteOtrosDatos<BR>CteTel<BR>CtePension<BR>CteDepto<BR>CteMapeoMov<BR>CteCFD<BR>CteEntregaMercancia<BR>SugerirRFC<BR>OtrosDatosCteRep<BR>OtrosDatosSentinel<BR>CteAcceso<BR>ListaPrecioEsp<BR>Bitacora<BR>Informacion<BR>Cubos<BR>Mapa<BR>Mensajes<BR>Movimientos<BR>ListaNegra<BR>ListaPoliticos<BR>Historico<BR>CteParecidos<BR>Navegador<BR>CteCat<BR>CteGrupo<BR>CteFam<BR>Cobrador<BR>ExpedienteFamiliar<BR>Otros1<BR>Otros2<BR>Otros3<B<CONTINUA>
ListaAcciones=Abrir<BR>Cerrar<BR>CteCto<BR>Navegador
;ListaAcciones=Nuevo<BR>Abrir<BR>Guardar<BR>Situacion<BR>PlantillasOffice<BR>Eliminar<BR>MovCte<BR>Cerrar<BR>CteRelacion<BR>CteBonificacion<BR>EspacioAsignacion<BR>CteEvento<BR>CteUEN<BR>EnviarA<BR>CteCto<BR>CamposExtras<BR>Agentes<BR>CtePedidoDef<BR>Conciliar<BR>Tareas<BR>Propiedades<BR>Evaluaciones<BR>Anexos<BR>Doc<BR>Politica<BR>RefCta<BR>AgregarEvento<BR>CteArt<BR>CapacidadPago<BR>CteOtrosDatos<BR>CteTel<BR>CtePension<BR>CteDepto<BR>CteMapeoMov<BR>CteCFD<BR>CteEntregaMercancia<BR>SugerirRFC<BR>OtrosDatosCteRep<BR>OtrosDatosSentinel<BR>CteAcceso<BR>ListaPrecioEsp<BR>Bitacora<BR>Informacion<BR>Cubos<BR>Mapa<BR>Mensajes<BR>Movimientos<BR>ListaNegra<BR>ListaPoliticos<BR>Historico<BR><CONTINUA>
;ListaAcciones002=<CONTINUA>CteParecidos<BR>Navegador<BR>CteCat<BR>CteGrupo<BR>CteFam<BR>Cobrador<BR>ExpedienteFamiliar<BR>Otros1<BR>Otros2<BR>Otros3<BR>Otros4<BR>Otros5<BR>Otros6<BR>Otros7<BR>Otros8<BR>Otros9<BR>Motivos
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=por Diseño
PosicionSeccion1=7
BarraAyuda=S
VentanaBloquearAjuste=N
DialogoAbrir=S
Plantillas=S
;PermiteCopiarDoc=S
PermiteCopiarDoc=N
PlantillasExcepciones=Cte:Cte.EnviarA<BR>Cte:Cte.Estatus
MovModulo=CXC
;ExpresionesAlMostrar=Asigna(Info.Copiar, Falso)
ExpresionesAlMostrar=Asigna(Info.Copiar, Falso)<BR>Asigna(Info.CategoriaMavi,nulo)<BR>Asigna(Info.CanalVentaMavi,nulo)
PosicionInicialAlturaCliente=640
;PosicionInicialAlturaCliente=680
BarraAyudaBold=S
;ListaAcciones002=<CONTINUA>R>Otros4<BR>Otros5<BR>Otros6<BR>Otros7<BR>Otros8<BR>Otros9
MenuPrincipal=&Archivo<BR>&Edición<BR>&Ver<BR>&Maestros<BR>&Otros

[Lista.Cte.Cliente]
Carpeta=Lista
Clave=Cte.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Cte.Nombre]
Carpeta=Lista
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Columnas]
Cliente=110
Nombre=273

[Ficha]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Datos Generales
Clave=Ficha
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
;ListaEnCaptura=Cte.Cliente<BR>Cte.Tipo<BR>Cte.Rama<BR>Cte.Estatus<BR>Cte.Nombre<BR>Cte.Grado<BR>Cte.Categoria<BR>Cte.NombreCorto<BR>Cte.Grupo<BR>Cte.RFC<BR>Cte.GLN<BR>Cte.Familia<BR>Cte.CURP<BR>Cte.Direccion<BR>Cte.DireccionNumero<BR>Cte.DireccionNumeroInt<BR>Cte.EntreCalles<BR>Cte.Plano<BR>Cte.Observaciones<BR>Cte.Delegacion<BR>Cte.Colonia<BR>Cte.CodigoPostal<BR>Cte.Ruta<BR>Cte.Poblacion<BR>Cte.Estado<BR>Cte.Pais<BR>Cte.Telefonos<BR>Cte.TelefonosLada<BR>Cte.Fax<BR>Cte.PedirTono<BR>Cte.Contacto1<BR>Cte.Extencion1<BR>Cte.Contacto2<BR>Cte.Extencion2<BR>Cte.eMail1<BR>Cte.eMail2<BR>Cte.eMailAuto
ListaEnCaptura=Cte.Cliente<BR>Cte.Tipo<BR>Cte.Rama<BR>Cte.Estatus<BR>Cte.MaviEstatus<BR>Cte.Nombre<BR>Cte.Grado<BR>Cte.NombreCorto<BR>Cte.Grupo<BR>Cte.RFC<BR>Cte.GLN<BR>Cte.Familia<BR>Cte.CURP<BR>Cte.Direccion<BR>Cte.DireccionNumero<BR>Cte.DireccionNumeroInt<BR>Cte.TipoCalle<BR>Cte.EntreCalles<BR>Cte.Plano<BR>Cte.Observaciones<BR>Cte.Delegacion<BR>Cte.Colonia<BR>Cte.CodigoPostal<BR>Cte.Ruta<BR>Cte.Poblacion<BR>Cte.Estado<BR>Cte.Pais<BR>Cte.Telefonos<BR>Cte.TelefonosLada<BR>Cte.Fax<BR>Cte.PedirTono<BR>Cte.Contacto1<BR>Cte.Extencion1<BR>Cte.Contacto2<BR>Cte.Extencion2<BR>Cte.eMail1<BR>Cte.eMail2<BR>Cte.eMailAuto<BR>Cte.ViveEnCalidad<BR>Cte.ImporteRentaMavi<BR>Cte.AntiguedadNegocioMavi
CarpetaVisible=S
PermiteEditar=N

[Ficha.Cte.Cliente]
Carpeta=Ficha
Clave=Cte.Cliente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]

[Ficha.Cte.Categoria]
Carpeta=Ficha
Clave=Cte.Categoria
Editar=S
ValidaNombre=S
3D=S
Tamano=30
LineaNueva=S
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Nombre]
Carpeta=Ficha
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=66
ColorFuente=Negro
Efectos=[Negritas]
EspacioPrevio=S
ColorFondo=Blanco

[Ficha.Cte.RFC]
Carpeta=Ficha
Clave=Cte.RFC
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Direccion]
Carpeta=Ficha
Clave=Cte.Direccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=54
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.CodigoPostal]
Carpeta=Ficha
Clave=Cte.CodigoPostal
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Colonia]
Carpeta=Ficha
Clave=Cte.Colonia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Poblacion]
Carpeta=Ficha
Clave=Cte.Poblacion
;Editar=S
Editar=N
ValidaNombre=S
3D=S
Tamano=20
LineaNueva=N
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Estado]
Carpeta=Ficha
Clave=Cte.Estado
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Pais]
Carpeta=Ficha
Clave=Cte.Pais
;Editar=S
Editar=N
ValidaNombre=S
3D=S
Tamano=20
LineaNueva=N
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Telefonos]
Carpeta=Ficha
Clave=Cte.Telefonos
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Fax]
Carpeta=Ficha
Clave=Cte.Fax
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.PedirTono]
Carpeta=Ficha
Clave=Cte.PedirTono
;Editar=S
Editar=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Contacto1]
Carpeta=Ficha
Clave=Cte.Contacto1
;Editar=S
Editar=N
3D=S
Tamano=24
LineaNueva=S
ValidaNombre=S
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Contacto2]
Carpeta=Ficha
Clave=Cte.Contacto2
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=29
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.eMail1]
Carpeta=Ficha
Clave=Cte.eMail1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Familia]
Carpeta=Ficha
Clave=Cte.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Grupo]
Carpeta=Ficha
Clave=Cte.Grupo
Editar=S
ValidaNombre=S
3D=S
Tamano=30
LineaNueva=S
ColorFondo=Blanco
ColorFuente=Negro

[Notas.Cte.Notas]
Carpeta=Notas
Clave=Cte.Notas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=75x18

[Notas.Cte.DirInternet]
Carpeta=Notas
Clave=Cte.DirInternet
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=75

[RevisiónPagos.Cte.DiaRevision1]
Carpeta=RevisiónPagos
Clave=Cte.DiaRevision1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15

[RevisiónPagos.Cte.DiaRevision2]
Carpeta=RevisiónPagos
Clave=Cte.DiaRevision2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15

[RevisiónPagos.Cte.HorarioRevision]
Carpeta=RevisiónPagos
Clave=Cte.HorarioRevision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[RevisiónPagos.Cte.DiaPago1]
Carpeta=RevisiónPagos
Clave=Cte.DiaPago1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
EspacioPrevio=S

[RevisiónPagos.Cte.DiaPago2]
Carpeta=RevisiónPagos
Clave=Cte.DiaPago2
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15

[RevisiónPagos.Cte.HorarioPago]
Carpeta=RevisiónPagos
Clave=Cte.HorarioPago
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30

[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
Menu=&Archivo
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Nuevo
Visible=S
;Activo=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+N
Activo=
ActivoCondicion=Temp.Numerico1=0

[Acciones.Eliminar]
;Nombre=Eliminar
;Boton=5
;Menu=&Archivo
;NombreDesplegar=E&liminar
;EnMenu=S
;EspacioPrevio=S
;TipoAccion=Controles Captura
;ClaveAccion=Documento Eliminar
;Visible=S
;EnBarraHerramientas=S
;ActivoCondicion=no Cte:Cte.TieneMovimientos
Nombre=Eliminar
Boton=5
Menu=&Archivo
NombreDesplegar=E&liminar
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Documento Eliminar
Visible=S
EnBarraHerramientas=S
ActivoCondicion=no Cte:Cte.TieneMovimientos
Antes=S
AntesExpresiones=EjecutarSQL(<T>EXEC xpCTOCampoExtra_Borra :tCliente<T>, Cte:Cte.Cliente)



[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador (Documentos)
Visible=S
Activo=S

[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Alt+F4
NombreDesplegar=&Cerrar
EnMenu=S
EspacioPrevio=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Visible=S
Activo=S

[Acciones.EnviarA]
Nombre=EnviarA
Boton=16
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=Ctrl+S
;NombreDesplegar=&Sucursales
NombreDesplegar=Canales de Venta
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=CteEnviarA
Visible=S
Antes=S
GuardarAntes=S
ConCondicion=S
DespuesGuardar=S
ActivoCondicion=Cte:Cte.Tipo<><T>Estructura<T>
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[EnviarA.Cte.EnviarA]
Carpeta=EnviarA
Clave=Cte.EnviarA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15

[EnviarA.CteEnviarA.Nombre]
Carpeta=EnviarA
Clave=CteEnviarA.Nombre
Editar=S
3D=S
Tamano=40
ColorFondo=Plata

[EnviarA.CteEnviarA.Direccion]
Carpeta=EnviarA
Clave=CteEnviarA.Direccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=56
ColorFondo=Plata

[Venta]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Datos Ventas
Clave=Venta
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
Fuente={MS Sans Serif, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=130
FichaNombres=Arriba
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
;ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.EnviarA<BR>CteEnviarA.Nombre<BR>Cte.DefMoneda<BR>Cte.Licencias<BR>Cte.LicenciasTipo<BR>Cte.Agente<BR>Agente.Nombre<BR>Cte.AgenteServicio<BR>AgenteServicio.Nombre<BR>Cte.Agente3<BR>Agente3.Nombre<BR>Cte.Agente4<BR>Agente4.Nombre<BR>Cte.PersonalCobrador<BR>PersonalNombre<BR>Cte.SucursalEmpresa<BR>Sucursal.Nombre<BR>Cte.Publico<BR>Cte.DiaRevision1<BR>Cte.DiaRevision2<BR>Cte.HorarioRevision<BR>Cte.DiaPago1<BR>Cte.DiaPago2<BR>Cte.HorarioPago
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.MaviRecomendadoPor<BR>MaviRecomendadoPorNombre<BR>Cte.ParentescoRecomiendaMavi<BR>Cte.DireccionRecomiendaMavi<BR>Cte.EnviarA<BR>CteEnviarA.Nombre<BR>Cte.Licencias<BR>Cte.LicenciasTipo<BR>Cte.Agente<BR>Agente.Nombre<BR>Cte.AgenteServicio<BR>AgenteServicio.Nombre<BR>Cte.Agente3<BR>Agente3.Nombre<BR>Cte.Agente4<BR>Agente4.Nombre<BR>Cte.PersonalCobrador<BR>PersonalNombre<BR>Cte.SucursalEmpresa<BR>Sucursal.Nombre<BR>Cte.Publico<BR>Cte.DiaRevision1<BR>Cte.DiaRevision2<BR>Cte.HorarioRevision<BR>Cte.DiaPago1<BR>Cte.DiaPago2<BR>Cte.HorarioPago
CondicionVisible=(Cte:Cte.Tipo<><T>Estructura<T>) y (no Usuario.CteBloquearOtrosDatos)

[Venta.Cte.EnviarA]
Carpeta=Venta
Clave=Cte.EnviarA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.Agente]
Carpeta=Venta
Clave=Cte.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Venta.Agente.Nombre]
Carpeta=Venta
Clave=Agente.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Venta.Cte.DiaRevision1]
Carpeta=Venta
Clave=Cte.DiaRevision1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.DiaRevision2]
Carpeta=Venta
Clave=Cte.DiaRevision2
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.HorarioRevision]
Carpeta=Venta
Clave=Cte.HorarioRevision
Editar=S
ValidaNombre=S
3D=S
Tamano=39
Pegado=N
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.DiaPago1]
Carpeta=Venta
Clave=Cte.DiaPago1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.DiaPago2]
Carpeta=Venta
Clave=Cte.DiaPago2
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.HorarioPago]
Carpeta=Venta
Clave=Cte.HorarioPago
Editar=S
ValidaNombre=S
3D=S
Tamano=39
Pegado=N
ColorFondo=Blanco
ColorFuente=Negro

[Notas.Cte.Mensaje]
Carpeta=Notas
Clave=Cte.Mensaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=75

[ID.Cte.Cliente]
Carpeta=ID
Clave=Cte.Cliente
Editar=S
LineaNueva=N
3D=N
Tamano=15
ColorFondo=Plata
Efectos=[Negritas]
Pegado=S

[ID.Cte.Nombre]
Carpeta=ID
Clave=Cte.Nombre
Editar=S
3D=N
Tamano=60
ColorFondo=Plata
Efectos=[Negritas]
LineaNueva=S

[Acciones.Propiedades]
Nombre=Propiedades
Boton=35
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=F11
NombreDesplegar=&Propiedades
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=Prop
Activo=S
Antes=S
Visible=S
GuardarAntes=S
ConCondicion=S
DespuesGuardar=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Rama, <T>CXC<T>)<BR>Asigna(Info.Cuenta, Cte:Cte.Cliente)<BR>Asigna(Info.Descripcion, Cte:Cte.Nombre)

[Venta.Cte.Cliente]
Carpeta=Venta
Clave=Cte.Cliente
Editar=N
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
ValidaNombre=S

[Venta.Cte.Nombre]
Carpeta=Venta
Clave=Cte.Nombre
Editar=N
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
ValidaNombre=S

[Acciones.Conciliar]
Nombre=Conciliar
Boton=0
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=F8
NombreDesplegar=&Conciliar Movimientos
EnMenu=S
TipoAccion=Formas
ClaveAccion=Conciliar
Visible=S
GuardarAntes=S
Antes=S
ConCondicion=S
DespuesGuardar=S
ActivoCondicion=Cte:Cte.Conciliar
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Rama, <T>CXC<T>)<BR>Asigna(Info.TituloDialogo, <T>Cliente<T>)<BR>Asigna(Info.Cuenta,Cte:Cte.Cliente)<BR>Asigna(Info.Descripcion,Cte:Cte.Nombre)

[Acciones.Informacion]
Nombre=Informacion
Boton=34
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+I
NombreDesplegar=&Información
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=CteInfo
Antes=S
Visible=S
ConCondicion=S
ActivoCondicion=(Cte:Cte.Tipo<><T>Estructura<T>) y Usuario.CteInfo
EjecucionCondicion=(Cte:Cte.Tipo<><T>Deudor<T>) o Usuario.VerInfoDeudores
AntesExpresiones=Asigna( Info.Cliente,Cte:Cte.Cliente )

[Ficha.Cte.NombreCorto]
Carpeta=Ficha
Clave=Cte.NombreCorto
Editar=S
;LineaNueva=N
ValidaNombre=S
3D=S
;Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=s
Tamano=66


[Ficha.Cte.eMail2]
Carpeta=Ficha
Clave=Cte.eMail2
Editar=S
3D=S
Tamano=35
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Tipo]
Carpeta=Ficha
Clave=Cte.Tipo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
Efectos=[Negritas]
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N


[Ficha.Cte.ViveEnCalidad]
Carpeta=Ficha
Clave=Cte.ViveEnCalidad
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Ficha.Cte.ImporteRentaMavi]
Carpeta=Ficha
Clave=Cte.ImporteRentaMavi
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.AntiguedadNegocioMavi]
Carpeta=Ficha
Clave=Cte.AntiguedadNegocioMavi
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Ficha.Cte.TipoCalle]
Carpeta=Ficha
Clave=Cte.TipoCalle
Editar=S
3D=S
Pegado=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.MaviEstatus]
Carpeta=Ficha
Clave=Cte.MaviEstatus
Editar=S
ValidaNombre=N
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Tareas]
Nombre=Tareas
Boton=70
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=Ctrl+T
NombreDesplegar=&Tareas
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=Tarea
Activo=S
Visible=S
Antes=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.PuedeEditar, Verdadero)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)<BR>Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Proveedor, Nulo)<BR>Asigna(Info.Agente, Nulo)<BR>Asigna(Info.Personal, Nulo)<BR>Asigna(Info.Proyecto, Nulo)<BR>Asigna(Info.UEN, Nulo)<BR>Asigna(Info.Modulo, Nulo)<BR>Asigna(Info.ID, Nulo)<BR>Asigna(Info.Reporte, Nulo)

[Ficha.Cte.EntreCalles]
Carpeta=Ficha
Clave=Cte.EntreCalles
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Plano]
Carpeta=Ficha
Clave=Cte.Plano
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Observaciones]
Carpeta=Ficha
Clave=Cte.Observaciones
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.AgenteServicio]
Carpeta=Venta
Clave=Cte.AgenteServicio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.AgenteServicio.Nombre]
Carpeta=Venta
Clave=AgenteServicio.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Acciones.Anexos]
Nombre=Anexos
Boton=77
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=F4
NombreDesplegar=Ane&xos
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=AnexoCta
Activo=S
ConCondicion=S
Antes=S
DespuesGuardar=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Rama, <T>CXC<T>)<BR>Asigna(Info.AnexoCfg, Verdadero)<BR>Asigna(Info.Cuenta, Cte:Cte.Cliente)<BR>Asigna(Info.Descripcion, Cte:Cte.Nombre)

[Acciones.CteRelacion]
Nombre=CteRelacion
Boton=0
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=Ctrl+R
NombreDesplegar=&Relaciones del Cliente
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteRelacion
Visible=S
Antes=S
ActivoCondicion=Cte:Cte.Tipo<><T>Estructura<T>
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)

[Credito.Cte.Cliente]
Carpeta=Credito
Clave=Cte.Cliente
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
ValidaNombre=S

[Credito.Cte.Nombre]
Carpeta=Credito
Clave=Cte.Nombre
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
ValidaNombre=S

[Credito.Cte.CreditoConLimite]
Carpeta=Credito
Clave=Cte.CreditoConLimite
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=30

[Credito.Cte.CreditoLimite]
Carpeta=Credito
Clave=Cte.CreditoLimite
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Credito.Cte.CreditoMoneda]
Carpeta=Credito
Clave=Cte.CreditoMoneda
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Credito.Cte.CreditoConDias]
Carpeta=Credito
Clave=Cte.CreditoConDias
Editar=S
LineaNueva=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=30

[Credito.Cte.CreditoDias]
Carpeta=Credito
Clave=Cte.CreditoDias
Editar=S
LineaNueva=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Credito.Cte.CreditoConCondiciones]
Carpeta=Credito
Clave=Cte.CreditoConCondiciones
Editar=S
LineaNueva=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Credito.Cte.CreditoCondiciones]
Carpeta=Credito
Clave=Cte.CreditoCondiciones
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.AgregarEvento]
Nombre=AgregarEvento
Boton=56
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=Ctrl+E
NombreDesplegar=Agregar &Evento
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtaBitacoraAgregar
Activo=S
ConCondicion=S
Antes=S
DespuesGuardar=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.Cuenta, Cte:Cte.Cliente)<BR>Asigna(Info.Descripcion, Cte:Cte.Nombre)

[Acciones.Bitacora]
Nombre=Bitacora
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+B
NombreDesplegar=&Bitácora
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtaBitacora
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Modulo, <T>CXC<T>)<BR>Asigna(Info.Tipo, Cte:Cte.Tipo)<BR>Asigna(Info.Cuenta, Cte:Cte.Cliente)<BR>Asigna(Info.Descripcion, Cte:Cte.Nombre)<BR>Asigna(Info.PuedeEditar, Verdadero)

[Ficha.Cte.Rama]
Carpeta=Ficha
Clave=Cte.Rama
Editar=S
ValidaNombre=S
3D=S
Pegado=N
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
Efectos=[Negritas]
LineaNueva=S

[Acciones.Agentes]
Nombre=Agentes
Boton=0
Menu=&Edición
NombreDesplegar=&Agentes del Cliente
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteAgente
Visible=S
ConCondicion=S
Antes=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
ActivoCondicion=Cte:Cte.Tipo<><T>Estructura<T>
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente,Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Acciones.Doc]
Nombre=Doc
Boton=17
Menu=&Edición
NombreDesplegar=&Documentación
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
ConCondicion=S
Visible=S
Expresion=EditarDocumentacion(<T>CXC<T>, Cte:Cte.Cliente, <T>Documentación - <T>+Cte:Cte.Nombre)
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)

[ReglaNegocio]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Regla Negocio
Clave=ReglaNegocio
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
;ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.ListaPreciosEsp<BR>Cte.Descuento<BR>Cte.BonificacionTipo<BR>Cte.Bonificacion<BR>Cte.Condicion<BR>Cte.FormaEnvio<BR>Cte.ZonaImpuesto<BR>Cte.Proyecto<BR>Cte.AlmacenDef<BR>Cte.OperacionLimite<BR>Cte.VtasConsignacion<BR>Cte.AlmacenVtasConsignacion<BR>Cte.BloquearMorosos<BR>Cte.ChecarCredito<BR>Cte.RecorrerVencimiento<BR>Cte.ModificarVencimiento<BR>Cte.CreditoEspecial<BR>Cte.Credito<BR>Cte.OtrosCargos<BR>Cte.CRMovVenta<BR>Cte.CreditoConLimite<BR>Cte.CreditoConLimitePedidos<BR>Cte.CreditoConDias<BR>Cte.CreditoConCondiciones<BR>Cte.CreditoLimite<BR>Cte.CreditoMoneda<BR>Cte.CreditoLimitePedidos<BR>Cte.CreditoDias<BR>Cte.CreditoCondiciones<BR>Cte.PedidosParciales<BR>Cte.DescuentoRecargos<BR>Cte.ExcentoISAN<BR>Cte.Conciliar<BR>Cte.FormasPagoRestringidas<BR>Cte.Precio<CONTINUA>
;ListaEnCaptura002=<CONTINUA>sInferioresMinimo<BR>Cte.PedidoDef<BR>Cte.DocumentacionCompleta
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.BonificacionTipo<BR>Cte.ZonaImpuesto<BR>Cte.BloquearMorosos<BR>Cte.ChecarCredito<BR>Cte.RecorrerVencimiento<BR>Cte.ModificarVencimiento<BR>Cte.CreditoEspecial<BR>Cte.Credito<BR>Cte.OtrosCargos<BR><CONTINUA>
ListaEnCaptura002=<CONTINUA>Cte.CRMovVenta<BR>Cte.CreditoConLimite<BR>Cte.CreditoConLimitePedidos<BR>Cte.CreditoConDias<BR>Cte.CreditoConCondiciones<BR>Cte.CreditoLimite<BR>Cte.CreditoMoneda<BR>Cte.CreditoLimitePedidos<BR>Cte.CreditoDias<BR>Cte.CreditoCondiciones<BR>Cte.PedidosParciales<BR>Cte.Conciliar<BR><CONTINUA>
ListaEnCaptura003=<CONTINUA>Cte.DocumentacionCompleta<BR>Cte.SeEnviaBuroCreditoMAVI<BR>Cte.NivelCobranzaEspecialMAVI<BR>Cte.EnviarCobTelMavi<BR>Cte.MotivoMavi<BR>Cte.PublicidadMAVI<BR>Cte.MotivoMAVIPublicidad
CondicionVisible=(Cte:Cte.Tipo<><T>Estructura<T>) y (no Usuario.CteBloquearOtrosDatos)

[ReglaNegocio.Cte.Cliente]
Carpeta=ReglaNegocio
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[ReglaNegocio.Cte.Nombre]
Carpeta=ReglaNegocio
Clave=Cte.Nombre
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[ReglaNegocio.Cte.ListaPreciosEsp]
Carpeta=ReglaNegocio
Clave=Cte.ListaPreciosEsp
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[ReglaNegocio.Cte.Descuento]
Carpeta=ReglaNegocio
Clave=Cte.Descuento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.Condicion]
Carpeta=ReglaNegocio
Clave=Cte.Condicion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.CreditoEspecial]
Carpeta=ReglaNegocio
Clave=Cte.CreditoEspecial
Editar=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[ReglaNegocio.Cte.FormaEnvio]
Carpeta=ReglaNegocio
Clave=Cte.FormaEnvio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.VtasConsignacion]
Carpeta=ReglaNegocio
Clave=Cte.VtasConsignacion
Editar=S
LineaNueva=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[ReglaNegocio.Cte.AlmacenVtasConsignacion]
Carpeta=ReglaNegocio
Clave=Cte.AlmacenVtasConsignacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.ChecarCredito]
Carpeta=ReglaNegocio
Clave=Cte.ChecarCredito
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.BloquearMorosos]
Carpeta=ReglaNegocio
Clave=Cte.BloquearMorosos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
;EspacioPrevio=N
EspacioPrevio=S

[ReglaNegocio.Cte.ModificarVencimiento]
Carpeta=ReglaNegocio
Clave=Cte.ModificarVencimiento
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.Credito]
Carpeta=ReglaNegocio
Clave=Cte.Credito
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.PedidosParciales]
Carpeta=ReglaNegocio
Clave=Cte.PedidosParciales
Editar=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S

[ReglaNegocio.Cte.Proyecto]
Carpeta=ReglaNegocio
Clave=Cte.Proyecto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro

[Venta.CteEnviarA.Nombre]
Carpeta=Venta
Clave=CteEnviarA.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Venta.Cte.DefMoneda]
Carpeta=Venta
Clave=Cte.DefMoneda
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.CteCat]
Nombre=CteCat
Boton=0
Menu=&Maestros
NombreDesplegar=&Categorías
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteCat
Activo=S
Visible=S

[Acciones.CteGrupo]
Nombre=CteGrupo
Boton=0
Menu=&Maestros
NombreDesplegar=&Grupos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteGrupo
Activo=S
Visible=S

[Acciones.CteFam]
Nombre=CteFam
Boton=0
Menu=&Maestros
NombreDesplegar=&Familias
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteFam
Activo=S
Visible=S

[Acciones.ListaPrecioEsp]
Nombre=ListaPrecioEsp
Boton=0
Menu=&Ver
NombreDesplegar=Lista Precios
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=ListaPreciosInfo
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.ListaPreciosEsp) y (Izquierda(Cte:Cte.ListaPreciosEsp, 1)<><T>(<T>))
AntesExpresiones=Asigna(Info.Lista, Cte:Cte.ListaPreciosEsp)

[ReglaNegocio.Cte.ZonaImpuesto]
Carpeta=ReglaNegocio
Clave=Cte.ZonaImpuesto
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Estatus]
Carpeta=Ficha
Clave=Cte.Estatus
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[(Carpeta Abrir)]
Estilo=Iconos
Clave=(Carpeta Abrir)
Filtros=S
BusquedaRapidaControles=S
MenuLocal=S
PermiteLocalizar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=CteA
Fuente={Tahoma, 8, Negro, []}
IconosCampo=CtaSituacion.Icono
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Cliente<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cte.Nombre
FiltroPredefinido=S
FiltroGrupo1=(Validaciones Memoria)
FiltroValida1=CteCat
FiltroGrupo2=(Validaciones Memoria)
FiltroValida2=CteGrupo
FiltroGrupo3=(Validaciones Memoria)
FiltroValida3=CteFam
FiltroAplicaEn1=Cte.Categoria
FiltroAplicaEn2=Cte.Grupo
FiltroAplicaEn3=Cte.Familia
FiltroNullNombre=(sin clasificar)
FiltroTodo=S
FiltroEnOrden=S
FiltroTodoNombre=Todos
FiltroTodoFinal=S
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
FiltroArbol=Clientes
FiltroArbolAplica=Cte.Rama
FiltroEstatus=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroListaEstatus=(Todos)<BR>ALTA<BR>BLOQ_AVISO<BR>BLOQUEADO<BR>BAJA
FiltroEstatusDefault=ALTA
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
CarpetaVisible=S
FiltroListas=S
FiltroListasRama=CXC
FiltroListasAplicaEn=Cte.Cliente
ListaAcciones=Actualizar<BR>Imprimir<BR>Preliminar<BR>Excel<BR>Campos
PestanaOtroNombre=S
PestanaNombre=Clientes
FiltroSituacion=S
FiltroSituacionTodo=S
FiltroGrupo4=(Validaciones Memoria)
FiltroValida4=CteTipo
FiltroAplicaEn4=Cte.Tipo
FiltroGrupo5=(Validaciones Memoria)
FiltroValida5=Espacio
FiltroAplicaEn5=Cte.Espacio
IconosConPaginas=S
OtroOrden=S
ListaOrden=Cte.Cliente<TAB>(Acendente)
IconosNombre=CteA:Cte.Cliente

[(Carpeta Abrir).Cte.Nombre]
Carpeta=(Carpeta Abrir)
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Abrir]
Nombre=Abrir
Boton=2
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+A
NombreDesplegar=&Abrir...
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Documento Abrir
Activo=S
Visible=S

[Acciones.Guardar]
Nombre=Guardar
Boton=3
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+G
NombreDesplegar=&Guardar Cambios
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
;Activo=S
Visible=S
Activo=
ActivoCondicion=Temp.Numerico1=0

[(Carpeta Abrir).Columnas]
0=106
1=283
2=79
3=80
4=69

[Acciones.Situacion]
Nombre=Situacion
Boton=71
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+F12
NombreDesplegar=&Situación
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Controles Captura
ClaveAccion=Cambiar Situacion
Activo=S
Visible=S

[Acciones.Actualizar]
Nombre=Actualizar
Boton=0
UsaTeclaRapida=S
TeclaRapida=F5
NombreDesplegar=&Actualizar
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S

[Acciones.Imprimir]
Nombre=Imprimir
Boton=0
NombreDesplegar=&Imprimir
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Imprimir
Activo=S
Visible=S

[Acciones.Preliminar]
Nombre=Preliminar
Boton=0
NombreDesplegar=&Presentacion preliminar
EnMenu=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Presentacion preliminar
Activo=S
Visible=S

[Acciones.Excel]
Nombre=Excel
Boton=0
NombreDesplegar=Enviar a E&xcel
EnMenu=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Enviar a Excel
Activo=S
Visible=S

[Acciones.Campos]
Nombre=Campos
Boton=0
NombreDesplegar=Personalizar &Vista
EnMenu=S
EspacioPrevio=S
Carpeta=(Carpeta Abrir)
TipoAccion=Controles Captura
ClaveAccion=Mostrar Campos
Activo=S
Visible=S

[ReglaNegocio.Cte.CreditoConLimite]
Carpeta=ReglaNegocio
Clave=Cte.CreditoConLimite
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Tamano=26

[ReglaNegocio.Cte.CreditoConDias]
Carpeta=ReglaNegocio
Clave=Cte.CreditoConDias
Editar=S
ValidaNombre=N
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.CreditoConCondiciones]
Carpeta=ReglaNegocio
Clave=Cte.CreditoConCondiciones
Editar=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.CreditoLimite]
Carpeta=ReglaNegocio
Clave=Cte.CreditoLimite
Editar=S
LineaNueva=S
3D=S
EspacioPrevio=N
Tamano=16
ColorFondo=Blanco
ColorFuente=Negro
ValidaNombre=N

[ReglaNegocio.Cte.CreditoMoneda]
Carpeta=ReglaNegocio
Clave=Cte.CreditoMoneda
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=9
ColorFondo=Blanco
ColorFuente=Negro
Pegado=N

[ReglaNegocio.Cte.CreditoDias]
Carpeta=ReglaNegocio
Clave=Cte.CreditoDias
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=15

[ReglaNegocio.Cte.CreditoCondiciones]
Carpeta=ReglaNegocio
Clave=Cte.CreditoCondiciones
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.CreditoConLimitePedidos]
Carpeta=ReglaNegocio
Clave=Cte.CreditoConLimitePedidos
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.CreditoLimitePedidos]
Carpeta=ReglaNegocio
Clave=Cte.CreditoLimitePedidos
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.Otros1]
;Nombre=Otros1
;Menu=&Otros
;EnMenu=S
;TipoAccion=Expresion
;Boton=0
Nombre=Otros1
Menu=&Edición
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Boton=78
NombreDesplegar=Supervisar Referencias
EnBarraHerramientas=S
Expresion=ProcesarSQL(<T>spMaviCteGenerarSupervision :tEmpresa, :tCte, :tUsuario, :nSucursal<T>, Empresa, Cte:Cte.Cliente, Usuario, Sucursal)<BR>ActualizarVista
Activo=S
Visible=S



[Acciones.Otros2]
Nombre=Otros2
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros3]
Nombre=Otros3
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros4]
Nombre=Otros4
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros5]
Nombre=Otros5
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros6]
Nombre=Otros6
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros7]
Nombre=Otros7
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros8]
Nombre=Otros8
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[Acciones.Otros9]
Nombre=Otros9
Menu=&Otros
EnMenu=S
TipoAccion=Expresion

[ReglaNegocio.Cte.Conciliar]
Carpeta=ReglaNegocio
Clave=Cte.Conciliar
Editar=S
;LineaNueva=S
LineaNueva=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.SeEnviaBuroCreditoMAVI]
Carpeta=ReglaNegocio
Clave=Cte.SeEnviaBuroCreditoMAVI
Editar=S
LineaNueva=S
EspacioPrevio=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro


[ReglaNegocio.Cte.NivelCobranzaEspecialMAVI]
Carpeta=ReglaNegocio
Clave=Cte.NivelCobranzaEspecialMAVI
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.EnviarCobTelMavi]
Carpeta=ReglaNegocio
Clave=Cte.EnviarCobTelMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5

[ReglaNegocio.Cte.MotivoMavi]
Carpeta=ReglaNegocio
Clave=Cte.MotivoMavi
Editar=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=30


[ReglaNegocio.Cte.PublicidadMAVI]
Carpeta=ReglaNegocio
Clave=Cte.PublicidadMAVI
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.MotivoMAVIPublicidad]
Carpeta=ReglaNegocio
Clave=Cte.MotivoMAVIPublicidad
Editar=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro


[Ficha.Cte.Delegacion]
Carpeta=Ficha
Clave=Cte.Delegacion
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Ruta]
Carpeta=Ficha
Clave=Cte.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.DescuentoRecargos]
Carpeta=ReglaNegocio
Clave=Cte.DescuentoRecargos
Editar=S
LineaNueva=N
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.CURP]
Carpeta=Ficha
Clave=Cte.CURP
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.RecorrerVencimiento]
Carpeta=ReglaNegocio
Clave=Cte.RecorrerVencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.SucursalEmpresa]
Carpeta=Venta
Clave=Cte.SucursalEmpresa
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Venta.Sucursal.Nombre]
Carpeta=Venta
Clave=Sucursal.Nombre
Editar=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
ValidaNombre=S

[Acciones.ListaNegra]
Nombre=ListaNegra
Boton=22
Menu=&Ver
NombreDesplegar=Lista &Negra
EnMenu=S
TipoAccion=Formas
ClaveAccion=ListaNegraLista
Activo=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Mayús+Ctrl+N
EspacioPrevio=S

[Otros]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Otros
Clave=Otros
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
;ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.Espacio<BR>Espacio.Nombre<BR>Cte.Cuenta<BR>Cta.Descripcion<BR>Cte.CuentaRetencion<BR>CtaRetencion.Descripcion<BR>Cte.Mensaje<BR>Cte.DirInternet<BR>Cte.NivelAcceso<BR>Cte.CBDir<BR>Cte.Idioma<BR>Cte.Alta<BR>Cte.UltimoCambio<BR>Cte.Intercompania
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.Espacio<BR>Espacio.Nombre<BR>Cte.Cuenta<BR>Cta.Descripcion<BR>Cte.CuentaRetencion<BR>CtaRetencion.Descripcion<BR>Cte.Mensaje<BR>Cte.DirInternet<BR>Cte.NivelAcceso<BR>Cte.CBDir<BR>Cte.Idioma<BR>Cte.Alta<BR>Cte.UltimoCambio<BR>Cte.Intercompania<BR>Cte.MovimientoUltimoCobro<BR>Cte.FechaUltimoCobro
CondicionVisible=no Usuario.CteBloquearOtrosDatos

[Otros.Cte.Cliente]
Carpeta=Otros
Clave=Cte.Cliente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Otros.Cte.Nombre]
Carpeta=Otros
Clave=Cte.Nombre
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Otros.Cte.Mensaje]
Carpeta=Otros
Clave=Cte.Mensaje
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=81
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Otros.Cte.DirInternet]
Carpeta=Otros
Clave=Cte.DirInternet
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=81
ColorFondo=Blanco
ColorFuente=Negro

[Otros.Cte.NivelAcceso]
Carpeta=Otros
Clave=Cte.NivelAcceso
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Otros.Cte.FechaUltimoCobro]
Carpeta=Otros
Clave=Cte.FechaUltimoCobro
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Plata
ColorFuente=Negro

[Otros.Cte.MovimientoUltimoCobro]
Carpeta=Otros
Clave=Cte.MovimientoUltimoCobro
Editar=N
LineaNueva=S
EspacioPrevio=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro


[Internet]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Internet
Clave=Internet
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.Contrasena<BR>Cte.Contrasena2<BR>Cte.wMovVentas<BR>Cte.wVerDisponible<BR>Cte.wVerArtListaPreciosEsp
CondicionVisible=(Cte:Cte.Tipo<><T>Estructura<T>) y (no Usuario.CteBloquearOtrosDatos)

[Internet.Cte.Cliente]
Carpeta=Internet
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro

[Internet.Cte.Nombre]
Carpeta=Internet
Clave=Cte.Nombre
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Internet.Cte.Contrasena]
Carpeta=Internet
Clave=Cte.Contrasena
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Internet.Cte.wVerDisponible]
Carpeta=Internet
Clave=Cte.wVerDisponible
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Otros.Cte.Idioma]
Carpeta=Otros
Clave=Cte.Idioma
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.Bonificacion]
Carpeta=ReglaNegocio
Clave=Cte.Bonificacion
Editar=S
ValidaNombre=S
3D=S
Tamano=18
ColorFondo=Blanco
ColorFuente=Negro

[CRM]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=CRM
Clave=CRM
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.CRMImporte<BR>Cte.CRMCantidad<BR>Cte.CRMPresupuestoAsignado<BR>Cte.CRMEtapa<BR>Cte.CRMCierreProbabilidad<BR>Cte.CRMCierreFechaAprox<BR>Cte.CRMCompetencia<BR>Cte.CRMInfluencia<BR>Cte.CRMFuente<BR>Cte.Descripcion1<BR>Cte.Descripcion2<BR>Cte.Descripcion3<BR>Cte.Descripcion4<BR>Cte.Descripcion5<BR>Cte.Descripcion6<BR>Cte.Descripcion7<BR>Cte.Descripcion8<BR>Cte.Descripcion9<BR>Cte.Descripcion10<BR>Cte.Descripcion11<BR>Cte.Descripcion12<BR>Cte.Descripcion13<BR>Cte.Descripcion14<BR>Cte.Descripcion15<BR>Cte.Descripcion16<BR>Cte.Descripcion17<BR>Cte.Descripcion18<BR>Cte.Descripcion19<BR>Cte.Descripcion20
CondicionVisible=(Cte:Cte.Tipo<><T>Estructura<T>) y (no Usuario.CteBloquearOtrosDatos)

[CRM.Cte.Cliente]
Carpeta=CRM
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[CRM.Cte.Nombre]
Carpeta=CRM
Clave=Cte.Nombre
ValidaNombre=N
3D=S
Tamano=42
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[CRM.Cte.Descripcion1]
Carpeta=CRM
Clave=Cte.Descripcion1
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion2]
Carpeta=CRM
Clave=Cte.Descripcion2
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion3]
Carpeta=CRM
Clave=Cte.Descripcion3
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion4]
Carpeta=CRM
Clave=Cte.Descripcion4
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion5]
Carpeta=CRM
Clave=Cte.Descripcion5
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.BonificacionTipo]
Carpeta=ReglaNegocio
Clave=Cte.BonificacionTipo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S

[Acciones.CteBonificacion]
Nombre=CteBonificacion
Boton=0
Menu=&Edición
NombreDesplegar=Bonificación Autómatica Multiple
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteBonificacion
Antes=S
Visible=S
ConCondicion=S
GuardarAntes=S
ActivoCondicion=Cte:Cte.BonificacionTipo=<T>Multiple<T>
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)
DespuesGuardar=S

[CRM.Cte.Descripcion6]
Carpeta=CRM
Clave=Cte.Descripcion6
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion7]
Carpeta=CRM
Clave=Cte.Descripcion7
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion8]
Carpeta=CRM
Clave=Cte.Descripcion8
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion9]
Carpeta=CRM
Clave=Cte.Descripcion9
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion10]
Carpeta=CRM
Clave=Cte.Descripcion10
;Editar=S
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.FormasPagoRestringidas]
Carpeta=ReglaNegocio
Clave=Cte.FormasPagoRestringidas
Editar=S
LineaNueva=N
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[ReglaNegocio.Cte.AlmacenDef]
Carpeta=ReglaNegocio
Clave=Cte.AlmacenDef
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Otros.Cte.Alta]
Carpeta=Otros
Clave=Cte.Alta
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFuente=Negro
Editar=S
ColorFondo=Blanco

[Otros.Cte.UltimoCambio]
Carpeta=Otros
Clave=Cte.UltimoCambio
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro

[CRM.Cte.Descripcion11]
Carpeta=CRM
Clave=Cte.Descripcion11
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion12]
Carpeta=CRM
Clave=Cte.Descripcion12
;Editar=S
Editar=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion13]
Carpeta=CRM
Clave=Cte.Descripcion13
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion14]
Carpeta=CRM
Clave=Cte.Descripcion14
;Editar=S
Editar=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion15]
Carpeta=CRM
Clave=Cte.Descripcion15
;Editar=S
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion16]
Carpeta=CRM
Clave=Cte.Descripcion16
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion17]
Carpeta=CRM
Clave=Cte.Descripcion17
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion18]
Carpeta=CRM
Clave=Cte.Descripcion18
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion19]
Carpeta=CRM
Clave=Cte.Descripcion19
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.Descripcion20]
Carpeta=CRM
Clave=Cte.Descripcion20
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Otros.Cte.CBDir]
Carpeta=Otros
Clave=Cte.CBDir
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro

[Personal]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Datos Personales
Clave=Personal
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Plata
PermiteEditar=N
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.PersonalNombres<BR>Cte.PersonalApellidoPaterno<BR>Cte.PersonalApellidoMaterno<BR>Cte.RFC<BR>Cte.Parentesco<BR>Cte.Responsable<BR>Cte.ExpedienteFamiliar<BR>ExpedienteFamiliar.Nombre<BR>Cte.PersonalDireccion<BR>Cte.PersonalEntreCalles<BR>Cte.PersonalPlano<BR>Cte.PersonalDelegacion<BR>Cte.PersonalColonia<BR>Cte.PersonalCodigoPostal<BR>Cte.PersonalPoblacion<BR>Cte.PersonalEstado<BR>Cte.PersonalPais<BR>Cte.PersonalTelefonos<BR>Cte.PersonalTelefonosLada<BR>Cte.PersonalTelefonoMovil<BR>Cte.PersonalSMS<BR>Cte.FechaNacimiento<BR>Edad<BR>Cte.Extranjero<BR>Cte.Sexo<BR>Cte.Religion<BR>Cte.Profesion<BR>Cte.Puesto<BR>Cte.Titulo<BR>Cte.EstadoCivil<BR>Cte.Conyuge<BR>Cte.FechaMatrimonio<BR>Cte.NumeroHijos<BR>Cte.Peso<BR>Cte.Estatura<BR>Cte.GrupoSanguineo<BR>Cte.GrupoSanguin<CONTINUA>
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
ListaEnCaptura002=<CONTINUA>eoRH<BR>Cte.Alergias<BR>Cte.Fuma<BR>Cte.FacturarCte<BR>CteFacturarA.Nombre<BR>Cte.FacturarCteEnviarA<BR>CteEnviarAFacturarA.Nombre
CondicionVisible=General.CteDatosPersonales

[Personal.Cte.Cliente]
Carpeta=Personal
Clave=Cte.Cliente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Personal.Cte.Nombre]
Carpeta=Personal
Clave=Cte.Nombre
Editar=N
LineaNueva=N
ValidaNombre=N
3D=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Personal.Columnas]
Cliente=64
Nombre=244

[MotivoInfo.Columnas]
Motivo=154


[Personal.Cte.PersonalDireccion]
Carpeta=Personal
Clave=Cte.PersonalDireccion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=66
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Personal.Cte.PersonalEntreCalles]
Carpeta=Personal
Clave=Cte.PersonalEntreCalles
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalPlano]
Carpeta=Personal
Clave=Cte.PersonalPlano
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalDelegacion]
Carpeta=Personal
Clave=Cte.PersonalDelegacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalColonia]
Carpeta=Personal
Clave=Cte.PersonalColonia
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalPoblacion]
Carpeta=Personal
Clave=Cte.PersonalPoblacion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalEstado]
Carpeta=Personal
Clave=Cte.PersonalEstado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalPais]
Carpeta=Personal
Clave=Cte.PersonalPais
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalCodigoPostal]
Carpeta=Personal
Clave=Cte.PersonalCodigoPostal
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalTelefonos]
Carpeta=Personal
Clave=Cte.PersonalTelefonos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=19
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Personal.Cte.FechaNacimiento]
Carpeta=Personal
Clave=Cte.FechaNacimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
Tamano=25

[Personal.Cte.FechaMatrimonio]
Carpeta=Personal
Clave=Cte.FechaMatrimonio
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Personal.Cte.Conyuge]
Carpeta=Personal
Clave=Cte.Conyuge
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Personal.Cte.Sexo]
Carpeta=Personal
Clave=Cte.Sexo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.Fuma]
Carpeta=Personal
Clave=Cte.Fuma
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
Tamano=7

[Personal.Cte.Profesion]
Carpeta=Personal
Clave=Cte.Profesion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.Puesto]
Carpeta=Personal
Clave=Cte.Puesto
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.NumeroHijos]
Carpeta=Personal
Clave=Cte.NumeroHijos
Editar=S
LineaNueva=N
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
Pegado=S

[Seguro]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Seguro
Clave=Seguro
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.Aseguradora<BR>CteAseguradora.Nombre<BR>Cte.NombreAsegurado<BR>Cte.PolizaTipo<BR>Cte.PolizaNumero<BR>Cte.PolizaReferencia<BR>Cte.PolizaImporte<BR>Cte.PolizaFechaEmision<BR>Cte.PolizaVencimiento<BR>Cte.Deducible<BR>Cte.DeducibleMoneda<BR>Cte.Coaseguro<BR>Cte.NotificarA<BR>Cte.NoriticarATelefonos
CondicionVisible=(Cte:Cte.Tipo<><T>Estructura<T>) y (no Usuario.CteBloquearOtrosDatos) y General.CteDatosAseguradora

[Seguro.Cte.Cliente]
Carpeta=Seguro
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Seguro.Cte.Nombre]
Carpeta=Seguro
Clave=Cte.Nombre
3D=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Seguro.Cte.Aseguradora]
Carpeta=Seguro
Clave=Cte.Aseguradora
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.PolizaTipo]
Carpeta=Seguro
Clave=Cte.PolizaTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.PolizaNumero]
Carpeta=Seguro
Clave=Cte.PolizaNumero
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.PolizaReferencia]
Carpeta=Seguro
Clave=Cte.PolizaReferencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.Deducible]
Carpeta=Seguro
Clave=Cte.Deducible
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.DeducibleMoneda]
Carpeta=Seguro
Clave=Cte.DeducibleMoneda
Editar=S
3D=S
Pegado=N
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.Cte.Coaseguro]
Carpeta=Seguro
Clave=Cte.Coaseguro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Seguro.CteAseguradora.Nombre]
Carpeta=Seguro
Clave=CteAseguradora.Nombre
Editar=S
3D=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro

[Personal.Cte.Responsable]
Carpeta=Personal
Clave=Cte.Responsable
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N

[Personal.Cte.Parentesco]
Carpeta=Personal
Clave=Cte.Parentesco
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[Personal.Cte.Religion]
Carpeta=Personal
Clave=Cte.Religion
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.Alergias]
Carpeta=Personal
Clave=Cte.Alergias
Editar=S
ValidaNombre=S
3D=S
Tamano=66
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=N

[Seguro.Cte.NombreAsegurado]
Carpeta=Seguro
Clave=Cte.NombreAsegurado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=66
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.EstadoCivil]
Carpeta=Personal
Clave=Cte.EstadoCivil
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Edad]
Carpeta=Personal
Clave=Edad
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Plata
ColorFuente=Negro

[Otros.Cte.Espacio]
Carpeta=Otros
Clave=Cte.Espacio
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Otros.Espacio.Nombre]
Carpeta=Otros
Clave=Espacio.Nombre
Editar=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
ValidaNombre=S

[Acciones.CteParecidos]
Nombre=CteParecidos
Boton=0
Menu=&Ver
UsaTeclaRapida=S
TeclaRapida=Ctrl+P
NombreDesplegar=Clientes Parecidos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteParecidos
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.Nombre, Cte:Cte.Nombre)

[Personal.Cte.FacturarCte]
Carpeta=Personal
Clave=Cte.FacturarCte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Personal.CteFacturarA.Nombre]
Carpeta=Personal
Clave=CteFacturarA.Nombre
Editar=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro

[Personal.Cte.FacturarCteEnviarA]
Carpeta=Personal
Clave=Cte.FacturarCteEnviarA
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=7
Pegado=S

[Personal.CteEnviarAFacturarA.Nombre]
Carpeta=Personal
Clave=CteEnviarAFacturarA.Nombre
Editar=S
3D=S
Tamano=18
ColorFondo=Plata
ColorFuente=Negro

[ReglaNegocio.Cte.OtrosCargos]
Carpeta=ReglaNegocio
Clave=Cte.OtrosCargos
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.PersonalCobrador]
Carpeta=Venta
Clave=Cte.PersonalCobrador
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=N
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.PersonalNombre]
Carpeta=Venta
Clave=PersonalNombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Acciones.Cobrador]
Nombre=Cobrador
Boton=0
Menu=&Maestros
NombreDesplegar=C&obradores
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=Cobrador

[Acciones.EspacioAsignacion]
Nombre=EspacioAsignacion
Boton=0
Menu=&Edición
NombreDesplegar=Asignar Espacio
EnMenu=S
TipoAccion=Formas
ClaveAccion=EspacioAsignacion
ConCondicion=S
Antes=S
GuardarAntes=S
DespuesGuardar=S
ActivoCondicion=Config.EspaciosAsignacion y (Cte:Cte.Tipo<><T>Estructura<T>)
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Proyecto, Nulo)
VisibleCondicion=General.Espacios

[Acciones.Cubos]
Nombre=Cubos
Boton=100
Menu=&Ver
NombreDesplegar=<T>Cubos<T>
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Dialogos
ClaveAccion=CuboCliente
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Acciones.CteArt]
Nombre=CteArt
Boton=0
Menu=&Edición
NombreDesplegar=&Artículos del Cliente
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteArt
ConCondicion=S
Antes=S
Visible=S
ActivoCondicion=Usuario.CteArt
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)<BR>Asigna(Info.Articulo, Nulo)

[Internet.Cte.wVerArtListaPreciosEsp]
Carpeta=Internet
Clave=Cte.wVerArtListaPreciosEsp
Editar=S
LineaNueva=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMImporte]
Carpeta=CRM
Clave=Cte.CRMImporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMCantidad]
Carpeta=CRM
Clave=Cte.CRMCantidad
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMPresupuestoAsignado]
Carpeta=CRM
Clave=Cte.CRMPresupuestoAsignado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMEtapa]
Carpeta=CRM
Clave=Cte.CRMEtapa
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMCierreProbabilidad]
Carpeta=CRM
Clave=Cte.CRMCierreProbabilidad
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMCierreFechaAprox]
Carpeta=CRM
Clave=Cte.CRMCierreFechaAprox
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[CRM.Cte.CRMCompetencia]
Carpeta=CRM
Clave=Cte.CRMCompetencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=68
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[CRM.Cte.CRMInfluencia]
Carpeta=CRM
Clave=Cte.CRMInfluencia
Editar=S
ValidaNombre=S
3D=S
Tamano=68
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S

[CRM.Cte.CRMFuente]
Carpeta=CRM
Clave=Cte.CRMFuente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=68
ColorFondo=Blanco
ColorFuente=Negro

[Internet.Cte.Contrasena2]
Carpeta=Internet
Clave=Cte.Contrasena2
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalTelefonoMovil]
Carpeta=Personal
Clave=Cte.PersonalTelefonoMovil
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.Titulo]
Carpeta=Personal
Clave=Cte.Titulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ford]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Ford
Clave=Ford
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.FordDistribuidor<BR>Cte.FordZona<BR>Cte.Fecha1<BR>Cte.Fecha2<BR>Cte.Fecha3<BR>Cte.Fecha4<BR>Cte.Fecha5<BR>Cte.Flotilla
CondicionVisible=General.Ford

[Ford.Cte.Cliente]
Carpeta=Ford
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Ford.Cte.Nombre]
Carpeta=Ford
Clave=Cte.Nombre
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Ford.Cte.FordDistribuidor]
Carpeta=Ford
Clave=Cte.FordDistribuidor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.Flotilla]
Carpeta=Ford
Clave=Cte.Flotilla
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[ReglaNegocio.Cte.ExcentoISAN]
Carpeta=ReglaNegocio
Clave=Cte.ExcentoISAN
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Extencion1]
Carpeta=Ficha
Clave=Cte.Extencion1
;Editar=S
Editar=N
3D=S
Pegado=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.Extencion2]
Carpeta=Ficha
Clave=Cte.Extencion2
;Editar=S
Editar=N
3D=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S

[Ford.Cte.Fecha1]
Carpeta=Ford
Clave=Cte.Fecha1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.Fecha2]
Carpeta=Ford
Clave=Cte.Fecha2
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.Fecha3]
Carpeta=Ford
Clave=Cte.Fecha3
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.Fecha4]
Carpeta=Ford
Clave=Cte.Fecha4
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.Fecha5]
Carpeta=Ford
Clave=Cte.Fecha5
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalNombres]
Carpeta=Personal
Clave=Cte.PersonalNombres
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalApellidoPaterno]
Carpeta=Personal
Clave=Cte.PersonalApellidoPaterno
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Personal.Cte.PersonalApellidoMaterno]
Carpeta=Personal
Clave=Cte.PersonalApellidoMaterno
Editar=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S

[Perfiles]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Perfiles
Clave=Perfiles
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.EsProveedor<BR>Cte.EsPersonal<BR>Cte.EsAgente<BR>Cte.EsAlmacen<BR>Cte.EsCentroCostos<BR>Cte.EsProyecto<BR>Cte.EsCentroTrabajo<BR>Cte.EsEstacionTrabajo<BR>Cte.EsEspacio
CarpetaVisible=S

[Perfiles.Cte.EsProveedor]
Carpeta=Perfiles
Clave=Cte.EsProveedor
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsPersonal]
Carpeta=Perfiles
Clave=Cte.EsPersonal
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsAgente]
Carpeta=Perfiles
Clave=Cte.EsAgente
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsAlmacen]
Carpeta=Perfiles
Clave=Cte.EsAlmacen
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsEspacio]
Carpeta=Perfiles
Clave=Cte.EsEspacio
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsCentroCostos]
Carpeta=Perfiles
Clave=Cte.EsCentroCostos
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsProyecto]
Carpeta=Perfiles
Clave=Cte.EsProyecto
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsCentroTrabajo]
Carpeta=Perfiles
Clave=Cte.EsCentroTrabajo
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.EsEstacionTrabajo]
Carpeta=Perfiles
Clave=Cte.EsEstacionTrabajo
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20

[Perfiles.Cte.Cliente]
Carpeta=Perfiles
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Perfiles.Cte.Nombre]
Carpeta=Perfiles
Clave=Cte.Nombre
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Acciones.Historico]
Nombre=Historico
Boton=0
Menu=&Ver
NombreDesplegar=Histórico de Cambios
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteHist
Activo=S
ConCondicion=S
Antes=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+H
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)


[Acciones.Evaluaciones]
Nombre=Evaluaciones
Boton=103
Menu=&Edición
NombreDesplegar=E&valuaciones
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=EvaluacionCalificacion
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Modulo, Nulo)<BR>Asigna(Info.Mov, Nulo)<BR>Asigna(Info.Clave, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)<BR>Asigna(Info.Aplica, <T>Clientes<T>)<BR>Asigna(Info.Nombre2, Cte:Agente.Nombre)

[Seguro.Cte.PolizaImporte]
Carpeta=Seguro
Clave=Cte.PolizaImporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.Licencias]
Carpeta=Venta
Clave=Cte.Licencias
Editar=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
LineaNueva=S

[Venta.Cte.LicenciasTipo]
Carpeta=Venta
Clave=Cte.LicenciasTipo
Editar=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Venta.Cte.MaviRecomendadoPor]
Carpeta=Venta
Clave=Cte.MaviRecomendadoPor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro


[Venta.MaviRecomendadoPorNombre]
Carpeta=Venta
Clave=MaviRecomendadoPorNombre
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Venta.Cte.ParentescoRecomiendaMavi]
Carpeta=Venta
Clave=Cte.ParentescoRecomiendaMavi
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.DireccionRecomiendaMavi]
Carpeta=Venta
Clave=Cte.DireccionRecomiendaMavi
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Blanco
ColorFuente=Negro


[Acciones.Movimientos]
Nombre=Movimientos
Boton=50
Menu=&Ver
UsaTeclaRapida=S
NombreDesplegar=&Movimientos del Cliente
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteMov
Activo=S
Visible=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
Antes=S
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Otros.Cte.Cuenta]
Carpeta=Otros
Clave=Cte.Cuenta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S

[Otros.Cta.Descripcion]
Carpeta=Otros
Clave=Cta.Descripcion
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Acciones.MovCte]
Nombre=MovCte
Boton=25
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=F12
NombreDesplegar=Generar &Movimientos...
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ConCondicion=S
Antes=S
DespuesGuardar=S
Visible=S
ClaveAccion=MovCte
ActivoCondicion=Usuario.CteMov
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Aseguradora, Cte:Cte.Aseguradora)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Acciones.CteAcceso]
Nombre=CteAcceso
Boton=0
Menu=&Edición
NombreDesplegar=Acceso Especifico...
EnMenu=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=CteAcceso
Activo=S
ConCondicion=S
Antes=S
GuardarAntes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
VisibleCondicion=General.NivelAccesoEsp y (Cte:Cte.NivelAcceso=<T>(Especifico)<T>)

[Acciones.CteOtrosDatos]
Nombre=CteOtrosDatos
Boton=58
Menu=&Edición
NombreDesplegar=&Otros Datos...
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteOtrosDatos
Activo=S
ConCondicion=S
Antes=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Ctrl+O
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Otros.Cte.CuentaRetencion]
Carpeta=Otros
Clave=Cte.CuentaRetencion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Otros.CtaRetencion.Descripcion]
Carpeta=Otros
Clave=CtaRetencion.Descripcion
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[ReglaNegocio.Cte.PreciosInferioresMinimo]
Carpeta=ReglaNegocio
Clave=Cte.PreciosInferioresMinimo
Editar=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Fiscal]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Fiscal
Clave=Fiscal
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Cliente<BR>Cte.Nombre<BR>Cte.FiscalRegimen<BR>Cte.RFC<BR>Cte.CURP<BR>Cte.IFE<BR>Cte.Pasaporte<BR>Cte.IEPS<BR>Cte.PITEX<BR>Cte.RPU<BR>Cte.SIRAC<BR>Cte.ImportadorRegimen<BR>Cte.ImportadorRegistro
CarpetaVisible=S

[Fiscal.Cte.Cliente]
Carpeta=Fiscal
Clave=Cte.Cliente
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Fiscal.Cte.Nombre]
Carpeta=Fiscal
Clave=Cte.Nombre
3D=S
Tamano=39
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[Fiscal.Cte.FiscalRegimen]
Carpeta=Fiscal
Clave=Cte.FiscalRegimen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Fiscal.Cte.RFC]
Carpeta=Fiscal
Clave=Cte.RFC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Fiscal.Cte.CURP]
Carpeta=Fiscal
Clave=Cte.CURP
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Ford.Cte.FordZona]
Carpeta=Ford
Clave=Cte.FordZona
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.CtePedidoDef]
Nombre=CtePedidoDef
Boton=0
Menu=&Edición
NombreDesplegar=Pedido por O&misión...
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtePedidoDef
ConCondicion=S
Antes=S
DespuesGuardar=S
Visible=S
GuardarAntes=S
ActivoCondicion=Cte:Cte.PedidoDef
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[ReglaNegocio.Cte.PedidoDef]
Carpeta=ReglaNegocio
Clave=Cte.PedidoDef
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.eMailAuto]
Carpeta=Ficha
Clave=Cte.eMailAuto
Editar=S
LineaNueva=S
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.CteEvento]
Nombre=CteEvento
Boton=0
Menu=&Edición
NombreDesplegar=Participación en Eventos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteEvento
Activo=S
Antes=S
GuardarAntes=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
DespuesGuardar=S
VisibleCondicion=General.Espacios

[Ficha.Cte.DireccionNumero]
Carpeta=Ficha
Clave=Cte.DireccionNumero
Editar=S
3D=S
Pegado=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.Cte.TelefonosLada]
Carpeta=Ficha
Clave=Cte.TelefonosLada
;Editar=S
Editar=N
3D=S
Pegado=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
ValidaNombre=N

[Personal.Cte.PersonalTelefonosLada]
Carpeta=Personal
Clave=Cte.PersonalTelefonosLada
Editar=S
3D=S
Pegado=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.CteTel]
Nombre=CteTel
Boton=0
Menu=&Edición
NombreDesplegar=Otros &Teléfonos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteTel
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)

[Acciones.CtePension]
Nombre=CtePension
Boton=0
Menu=&Edición
NombreDesplegar=&Pensiones Alimenticias
EnMenu=S
TipoAccion=Formas
ClaveAccion=CtePension
Activo=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
VisibleCondicion=General.Autotransportes

[Fiscal.Cte.IEPS]
Carpeta=Fiscal
Clave=Cte.IEPS
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Internet.Cte.wMovVentas]
Carpeta=Internet
Clave=Cte.wMovVentas
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Fiscal.Cte.PITEX]
Carpeta=Fiscal
Clave=Cte.PITEX
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro

[Acciones.CteUEN]
Nombre=CteUEN
Boton=0
Menu=&Edición
NombreDesplegar=Límite de Crédito a Nivel UEN
GuardarAntes=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteUEN
Antes=S
Activo=S
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
VisibleCondicion=Config.VentaLimiteCreditoNivelUEN

[Acciones.Mapa]
Nombre=Mapa
Boton=105
Menu=&Ver
NombreDesplegar=&Mapa
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=PlugIn(<T>InteliMap<T>, <T>Consulta<T>, <T>Clientes<T>, Cte:Cte.Cliente, Cte:Cte.Colonia, Cte:Cte.Direccion, Cte:Cte.EntreCalles, Cte:Cte.Poblacion)

[Acciones.Politica]
Nombre=Politica
Boton=22
Menu=&Edición
NombreDesplegar=Política
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=Politica
Activo=S
ConCondicion=S
Antes=S
Visible=S
UsaTeclaRapida=S
TeclaRapida=Mayús+Ctrl+O
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Rama, <T>CTE<T>)<BR>Asigna(Info.Clave, Cte:Cte.Cliente)

[AC.Cte.Cliente]
Carpeta=AC
Clave=Cte.Cliente
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[AC.Cte.Nombre]
Carpeta=AC
Clave=Cte.Nombre
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]

[AC.Cte.CapacidadPago]
Carpeta=AC
Clave=Cte.CapacidadPago
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFuente=Negro
ColorFondo=Plata

[Acciones.CapacidadPago]
Nombre=CapacidadPago
Boton=0
Menu=&Edición
NombreDesplegar=Capacidad Pago...
EnMenu=S
TipoAccion=Formas
Activo=S
ConCondicion=S
Antes=S
GuardarAntes=S
RefrescarDespues=S
ClaveAccion=CteCapacidadPago
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)
VisibleCondicion=General.AC

[Otros.Cte.Intercompania]
Carpeta=Otros
Clave=Cte.Intercompania
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Cte.Agente3]
Carpeta=Venta
Clave=Cte.Agente3
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Agente3.Nombre]
Carpeta=Venta
Clave=Agente3.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Venta.Cte.Agente4]
Carpeta=Venta
Clave=Cte.Agente4
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Venta.Agente4.Nombre]
Carpeta=Venta
Clave=Agente4.Nombre
Editar=S
ValidaNombre=S
3D=S
Tamano=60
ColorFondo=Plata
ColorFuente=Negro

[Venta.Cte.Publico]
Carpeta=Venta
Clave=Cte.Publico
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.OtrosDatosCteRep]
Nombre=OtrosDatosCteRep
Boton=0
Menu=&Edición
NombreDesplegar=Otros Datos - &Reportes
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteRep
Activo=S
ConCondicion=S
Antes=S
Visible=S
EspacioPrevio=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
[Acciones.OtrosDatosSentinel]
Nombre=OtrosDatosSentinel
Boton=0
Menu=&Edición
NombreDesplegar=Otros Datos - Sentinel
GuardarAntes=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=Sentinel
Antes=S
DespuesGuardar=S
ActivoCondicion=General.Intelisis
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)<BR>Asigna(Info.Cantidad, Cte:Cte.Licencias)<BR>Asigna(Info.Tipo, Cte:Cte.LicenciasTipo)
VisibleCondicion=General.Intelisis
[Personal.Cte.Extranjero]
Carpeta=Personal
Clave=Cte.Extranjero
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[ReglaNegocio.Cte.DocumentacionCompleta]
Carpeta=ReglaNegocio
Clave=Cte.DocumentacionCompleta
Editar=S
LineaNueva=N
3D=S
Tamano=30
ColorFondo=Blanco
ColorFuente=Negro
[ReglaNegocio.Cte.OperacionLimite]
Carpeta=ReglaNegocio
Clave=Cte.OperacionLimite
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[ReglaNegocio.Cte.CRMovVenta]
Carpeta=ReglaNegocio
Clave=Cte.CRMovVenta
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.RefCta]
Nombre=RefCta
Boton=110
Menu=&Edición
NombreDesplegar=&Referencias
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=RefCta
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Rama, <T>CXC<T>)<BR>Asigna(Info.Cuenta, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
[Acciones.PlantillasOffice]
Nombre=PlantillasOffice
Boton=0
Menu=&Archivo
UsaTeclaRapida=S
TeclaRapida=Ctrl+F11
NombreDesplegar=Plantillas &Office
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Asigna(Info.Forma, <T>Cte<T>)<BR>Asigna(Info.Nombre, <T>Clientes<T>)<BR>Asigna(Info.Modulo, Nulo)<BR>Asigna(Info.Mov, Nulo)<BR>Si<BR>  Forma(<T>PlantillasOffice<T>)<BR>Entonces<BR>   PlantillaOffice( Info.PlantillaID ) <BR>Fin
[Acciones.Mensajes]
Nombre=Mensajes
Boton=112
Menu=&Ver
NombreDesplegar=Mensajes
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=OutlookCte
Activo=S
ConCondicion=S
Antes=S
Visible=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)
[Fiscal.Cte.ImportadorRegimen]
Carpeta=Fiscal
Clave=Cte.ImportadorRegimen
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Fiscal.Cte.ImportadorRegistro]
Carpeta=Fiscal
Clave=Cte.ImportadorRegistro
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Cte.Grado]
Carpeta=Ficha
Clave=Cte.Grado
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.ListaPoliticos]
Nombre=ListaPoliticos
Boton=0
Menu=&Ver
NombreDesplegar=Lista &Poíiticos
EnMenu=S
TipoAccion=Formas
ClaveAccion=ListaPoliticosLista
Activo=S
Visible=S
[Ficha.Cte.GLN]
Carpeta=Ficha
Clave=Cte.GLN
Editar=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Personal.Cte.PersonalSMS]
Carpeta=Personal
Clave=Cte.PersonalSMS
Editar=S
3D=S
Tamano=13
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.Cte.DireccionNumeroInt]
Carpeta=Ficha
Clave=Cte.DireccionNumeroInt
Editar=S
3D=S
Pegado=S
Tamano=6
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.CteDepto]
Nombre=CteDepto
Boton=0
Menu=&Edición
NombreDesplegar=&Departamentos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteDepto
Activo=S
Visible=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
[Acciones.CteCFD]
Nombre=CteCFD
Boton=0
Menu=&Edición
NombreDesplegar=Datos CFD
GuardarAntes=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteCFD
Activo=S
ConCondicion=S
Antes=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
VisibleCondicion=Empresa.CFD
[Fiscal.Cte.RPU]
Carpeta=Fiscal
Clave=Cte.RPU
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Fiscal.Cte.SIRAC]
Carpeta=Fiscal
Clave=Cte.SIRAC
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Valores.Columnas]
0=278
1=234
VerCampo=340
VerValor=318
[FormaExtraValor]
Estilo=Hoja
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Características
Clave=FormaExtraValor
Filtros=S
OtroOrden=S
RefrescarAlEntrar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=FormaExtraValor
Fuente={Tahoma, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Plata
ListaEnCaptura=VerCampo<BR>VerValor
ListaOrden=GrupoOrden<TAB>(Acendente)<BR>FormaExtraCampo.Orden<TAB>(Acendente)
FiltroAplicaEn=FormaExtraCampo.Grupo
FiltroPredefinido=S
FiltroAutoCampo=FormaExtraCampo.Grupo
FiltroAutoValidar=FormaExtraCampo.Grupo
FiltroAutoOrden=FormaExtraCampo.Orden
FiltroGrupo1=FormaExtraCampo.Grupo
FiltroValida1=FormaExtraCampo.Grupo
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroTodoFinal=S
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
HojaFondoGris=S
HojaSinBorde=S
PermiteEditar=N
FiltroGeneral=FormaExtraValor.FormaTipo IN (SELECT FormaTipo FROM dbo.fnFormaExtraVisibleCliente(<T>{Cte:Cte.Categoria}<T>, <T>{Cte:Cte.Grupo}<T>, <T>{Cte:Cte.Familia}<T>)) AND FormaExtraValor.Aplica=<T>Cliente<T> AND FormaExtraValor.AplicaClave=<T>{Cte:Cte.Cliente}<T>
CondicionVisible=General.CamposExtras<><T>Campos Extras<T>
[FormaExtraValor.VerCampo]
Carpeta=FormaExtraValor
Clave=VerCampo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFuente=Negro
ColorFondo=Plata
IgnoraFlujo=N
[FormaExtraValor.VerValor]
Carpeta=FormaExtraValor
Clave=VerValor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFuente=Negro
ColorFondo=Blanco
Efectos=[Negritas]
[FormaExtraValor.Columnas]
VerCampo=346
VerValor=364
[Acciones.CteMapeoMov]
Nombre=CteMapeoMov
Boton=0
Menu=&Edición
NombreDesplegar=Mapeo Movimientos
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteMapeoMov
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
Antes=S
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)
Visible=S
[Comentarios]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Comentarios
Clave=Comentarios
PermiteEditar=N
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=Cte
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
ListaEnCaptura=Cte.Comentarios
CarpetaVisible=S
AlinearTodaCarpeta=S
[Comentarios.Cte.Comentarios]
Carpeta=Comentarios
Clave=Cte.Comentarios
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100x10
ColorFondo=Blanco
ColorFuente=Negro
[Fiscal.Cte.IFE]
Carpeta=Fiscal
Clave=Cte.IFE
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Fiscal.Cte.Pasaporte]
Carpeta=Fiscal
Clave=Cte.Pasaporte
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
[Seguro.Cte.PolizaFechaEmision]
Carpeta=Seguro
Clave=Cte.PolizaFechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=25
[Seguro.Cte.PolizaVencimiento]
Carpeta=Seguro
Clave=Cte.PolizaVencimiento
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=25
[Seguro.Cte.NotificarA]
Carpeta=Seguro
Clave=Cte.NotificarA
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=66
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Seguro.Cte.NoriticarATelefonos]
Carpeta=Seguro
Clave=Cte.NoriticarATelefonos
Editar=S
ValidaNombre=S
3D=S
Tamano=66
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Foto.Cte.Foto]
Carpeta=Foto
Clave=Cte.Foto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100x100
ColorFondo=Blanco
ColorFuente=Negro
[Personal.Cte.Peso]
Carpeta=Personal
Clave=Cte.Peso
Editar=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S
[Personal.Cte.Estatura]
Carpeta=Personal
Clave=Cte.Estatura
Editar=S
ValidaNombre=S
3D=S
Tamano=8
ColorFondo=Blanco
ColorFuente=Negro
Pegado=S
[Personal.Cte.GrupoSanguineo]
Carpeta=Personal
Clave=Cte.GrupoSanguineo
Editar=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Personal.Cte.GrupoSanguineoRH]
Carpeta=Personal
Clave=Cte.GrupoSanguineoRH
Editar=S
ValidaNombre=N
3D=S
Pegado=N
Tamano=14
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.SugerirRFC]
Nombre=SugerirRFC
Boton=0
Menu=&Edición
NombreDesplegar=Sugerir &RFC (Personas Fisicas)
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Cte:Cte.RFC, SQL(<T>SELECT dbo.fnCalculaRFC(:tNombre, :tPaterno, :tMaterno, :fNacimiento, :tRegimen)<T>, Cte:Cte.PersonalNombres, Cte:Cte.PersonalApellidoPaterno, Cte:Cte.PersonalApellidoMaterno, Cte:Cte.FechaNacimiento, Cte:Cte.FiscalRegimen))
[Personal.Cte.RFC]
Carpeta=Personal
Clave=Cte.RFC
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
Efectos=[Negritas]
[Acciones.ExpedienteFamiliar]
Nombre=ExpedienteFamiliar
Boton=0
Menu=&Maestros
NombreDesplegar=E&xpedientes Familiares
EnMenu=S
TipoAccion=Formas
ClaveAccion=ExpedienteFamiliar
Activo=S
Visible=S
EspacioPrevio=S
[Personal.Cte.ExpedienteFamiliar]
Carpeta=Personal
Clave=Cte.ExpedienteFamiliar
Editar=S
ValidaNombre=S
3D=S
Tamano=25
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
[Personal.ExpedienteFamiliar.Nombre]
Carpeta=Personal
Clave=ExpedienteFamiliar.Nombre
Editar=S
3D=S
Tamano=40
ColorFondo=Plata
ColorFuente=Negro
[Acciones.CteEntregaMercancia]
Nombre=CteEntregaMercancia
Boton=0
Menu=&Edición
NombreDesplegar=Datos Entrega Mercancia
GuardarAntes=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteEntregaMercancia
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
Antes=S
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)
Visible=S
[Acciones.CteCto]
Nombre=CteCto
Boton=60
Menu=&Edición
NombreDesplegar=&Contactos del Cliente
GuardarAntes=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Formas
ClaveAccion=CteCto
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
Antes=S
AntesExpresiones=Asigna(Info.Cliente, Cte:Cte.Cliente)<BR>Asigna(Info.Nombre, Cte:Cte.Nombre)
Visible=S
[Acciones.CamposExtras]
Nombre=CamposExtras
Boton=104
Menu=&Edición
UsaTeclaRapida=S
TeclaRapida=Ctrl+1
NombreDesplegar=General.CamposExtras+<T>...<T>
GuardarAntes=S
RefrescarDespues=S
EnBarraHerramientas=S
EnMenu=S
TipoAccion=Expresion
Expresion=Si<BR>  General.CamposExtras=<T>Campos Extras<T><BR>Entonces<BR>  CamposExtrasContacto(<T>Cliente<T>, Cte:Cte.Tipo, Cte:Cte.Cliente)<BR>Sino<BR>  Asigna(Info.Aplica, <T>Cliente<T>)<BR>  Asigna(Info.Clave, Cte:Cte.Cliente)<BR>  Asigna(Info.Nombre, Cte:Cte.Nombre)<BR>  Asigna(Info.Modulo, Nulo)<BR>  Asigna(Info.Mov, Nulo)<BR>  Asigna(Info.Categoria, Cte:Cte.Categoria)<BR>  Asigna(Info.Grupo, Cte:Cte.Grupo)<BR>  Asigna(Info.Familia, Cte:Cte.Familia)<BR>  Asigna(Info.Departamento, Nulo)<BR>  Asigna(Info.Puesto, Nulo)<BR>  Asigna(Info.SIC, Nulo)<BR><BR>  Asigna(Temp.Reg, SQL(<T>spFormaExtraVisible :tAplica, :tModulo, :tMov, :tCat, :tGrupo, :tFam, :tDepto, :tPuesto, :tSIC<T>, Info.Aplica, Info.Modulo, Info.Mov, Info.Categoria, Info.Grupo, Info.Familia, Info.Departamento, Info.Puesto, Info.SIC))<BR>  <CONTINUA>
Expresion002=<CONTINUA>Si(Temp.Reg[1]>1, Si(no Forma(<T>EspecificarFormaTipo<T>), AbortarOperacion), Asigna(Info.FormaTipo, Temp.Reg[2]))<BR>  Si(ConDatos(Info.FormaTipo), iForma(Info.FormaTipo, Info.Aplica, Info.Clave, Info.Nombre), Informacion(<T>No Tiene Definida Ninguna Forma<T>))<BR>Fin
Activo=S
ConCondicion=S
EjecucionCondicion=ConDatos(Cte:Cte.Cliente)
Visible=S

[Acciones.Motivos]
Nombre=Motivos
Boton=0
NombreEnBoton=S
Menu=&Maestros
NombreDesplegar=Catalgo de &Motivos
EnMenu=S
TipoAccion=Formas
ClaveAccion=MotivoMAVIPublicidad
Activo=S
Visible=S
