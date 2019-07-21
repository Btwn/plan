[Forma]
Clave=PropreArt
Nombre=Configuracion de artículos Propre
Icono=34
BarraHerramientas=S
Modulos=(Todos)
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=718
PosicionInicialAncho=1279
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
ListaAcciones=Aceptar<BR>Buscar<BR>CopiarCosto<BR>CopiarCostoGlobal<BR>FiltroCero<BR>FiltroTodo<BR>EnviarTodosALista<BR>PropreArtUEN<BR>Garantias<BR>RecorreAtras<BR>RecorreAdelante<BR>Eliminar
PosicionInicialIzquierda=0
PosicionInicialArriba=7
Totalizadores=S
PosicionSec1=632
Comentarios=Si(Info.Filtro = 1, <T>C = 0<T>)
AutoGuardar=S
VentanaAvanzaTab=S
BarraAyuda=S
BarraAyudaBold=S
ExpresionesAlMostrar=EJECUTARSQL(<T>EXEC spActualizaPropreArt :tEmpresa<T>, Empresa)<BR>Asigna(Info.PropreCostoMin, 0.01)<BR>Asigna(Info.PropreCostoMax,SQL(<T>SELECT ISNULL(MAX(Costo),0) FROM PropreArt<T>))<BR>Asigna(Info.Filtro, 0)<BR>Asigna(Info.PropreSeccionPorcentaje,<T>Articulos<T>)<BR>Asigna(Info.PropreFamiliaGarantias,SQL(<T>SELECT FamiliaGarantias FROM PropreEmpresaCfg WHERE Empresa = :tEmpresa<T>,Empresa))<BR>Asigna(Info.PropreArtLista,<T>0<T>)<BR>ActualizarVista(<T>PropreArt<T>)
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=PropreArt
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=PropreArt.Art<BR>Art.Descripcion1<BR>PropreArtExistencia.Existencia<BR>PropreArt.Costo<BR>PropreArt.NuevoCosto<BR>ArtCostoEmpresa.CostoPromedio<BR>PropreArt.PorcentajeBonificacion<BR>PropreArt.ApoyoActivo<BR>PropreArt.ApoyoFuturo<BR>CostoReal<BR>PropreArt.TipoArticulo<BR>PropreArt.ArticuloTitular<BR>PropreArt.GarantiaAmpliada<BR>Art.UltimoMov<BR>Art.FechaUltimoMov<BR>Art.Linea<BR>PropreArt.SubFamilia
CarpetaVisible=S
MenuLocal=S
ListaAcciones=EnviarALista<BR>EnviarCategoriaALista<BR>ArtInfo
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaVistaOmision=Automática
PestanaOtroNombre=S
PestanaNombre=Productos
PermiteEditar=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=Múltiple (por Grupos)
HojaIndicador=S
FiltroGrupo1=Art.Categoria
FiltroGrupo2=Art.Grupo
FiltroGrupo3=Art.Familia
FiltroAutoCampo=Art.Familia
FiltroPredefinido1=Famila
FiltroPredefinido2=Art.Familia
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
FiltroTodo=S
FiltroTodoFinal=S
OtroOrden=S
ListaOrden=Art.Categoria<TAB>(Acendente)<BR>Art.Grupo<TAB>(Acendente)<BR>Art.Familia<TAB>(Acendente)<BR>Art.Linea<TAB>(Acendente)<BR>PropreArt.Art<TAB>(Acendente)
FiltroGrupo4=Art.Linea
FiltroGrupo5=Art.Fabricante
GuardarPorRegistro=S
HojaMantenerSeleccion=S
RefrescarAlEntrar=S
FiltroGeneral=((PropreArt.Costo BETWEEN {Info.PropreCostoMin} AND {Info.PropreCostoMax}) OR (Costo IS NULL))
[Lista.PropreArt.Art]
Carpeta=Lista
Clave=PropreArt.Art
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Art.Descripcion1]
Carpeta=Lista
Clave=Art.Descripcion1
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreArt.Costo]
Carpeta=Lista
Clave=PropreArt.Costo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.PorcentajeBonificacion]
Carpeta=Lista
Clave=PropreArt.PorcentajeBonificacion
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.ApoyoActivo]
Carpeta=Lista
Clave=PropreArt.ApoyoActivo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.ApoyoFuturo]
Carpeta=Lista
Clave=PropreArt.ApoyoFuturo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.GarantiaAmpliada]
Carpeta=Lista
Clave=PropreArt.GarantiaAmpliada
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.Columnas]
Art=81
Descripcion1=190
Costo=70
PorcentajeBonificacion=74
ApoyoActivo=77
ApoyoFuturo=79
America=64
Viu=64
GarantiaAmpliada=93
CostoReal=85
NuevoCosto=91
SubFamilia=57
TipoArticulo=64
ArticuloTitular=77
Existencia=54
UEN=64
Linea=187
CostoPromedio=79
UltimoMov=161
FechaUltimoMov=94
[Acciones.Aceptar]
Nombre=Aceptar
Boton=3
NombreEnBoton=S
NombreDesplegar=&Guardar y cerrar
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Lista.CostoReal]
Carpeta=Lista
Clave=CostoReal
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.PropreArt.NuevoCosto]
Carpeta=Lista
Clave=PropreArt.NuevoCosto
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
IgnoraFlujo=N
[Lista.PropreArt.SubFamilia]
Carpeta=Lista
Clave=PropreArt.SubFamilia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.TipoArticulo]
Carpeta=Lista
Clave=PropreArt.TipoArticulo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=1
ColorFondo=Blanco
ColorFuente=Rojo
[Lista.PropreArt.ArticuloTitular]
Carpeta=Lista
Clave=PropreArt.ArticuloTitular
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Rojo
[Acciones.EnviarALista]
Nombre=EnviarALista
Boton=0
NombreDesplegar=Enviar a:
GuardarAntes=S
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Asigna(Info.PropreLista,<T><T>)<BR>Asigna(Info.Mensaje,<T><T>)<BR>Forma(<T>ProprePreguntaLista<T>),<BR>SI ConDatos(Info.ProPreLista) ENTONCES<BR>  Forma(<T>ProprePreguntaMargen<T>),<BR>  Asigna(Info.Mensaje, SQL(<T>EXEC SpEnviarArticuloAPropreLista :tLista, :tArticulo, :nMargen<T>,Info.PropreLista,PropreArt:PropreArt.Art,Info.PropreMargen1))<BR>  Si Info.Mensaje = <T>0<T> Entonces<BR>    Informacion(<T>El Articulo: <T> + Comillas(PropreArt:PropreArt.Art) + <T>, fué enviado exitosamente a la lista: <T> + Comillas(Info.PropreLista) + <T> <T> + <T>,con su Margen de Protección<T>)<BR>  Sino<BR>    Error(Info.Mensaje)<BR>  Fin<BR>FIN
[Acciones.Buscar]
Nombre=Buscar
Boton=73
NombreEnBoton=S
NombreDesplegar=&Buscar
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
EspacioPrevio=S
EnBarraHerramientas=S
[Acciones.CopiarCosto]
Nombre=CopiarCosto
Boton=65
NombreDesplegar=&Nuevo Costo ->  Costo
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
Antes=S
Expresion=GuardarCambios<BR>Si Confirmacion(<T>Esta seguro que desea copiar el Nuevo Costo al Costo para el producto <T> + Info.Articulo,BotonSi,BotonNo) = BotonSi Entonces<BR>  EJECUTARSQL(<T>SpCopiarCostoNuevoACostoVigente :tArticulo<T>,Info.Articulo)   <BR>Asigna(Info.PropreCostoMin, 0.01)<BR>Asigna(Info.PropreCostoMax,SQL(<T>SELECT ISNULL(MAX(Costo),0) FROM PropreArt<T>))                     <BR>  ActualizarVista(<T>PropreArt<T>)   <BR>Fin
AntesExpresiones=Asigna(Info.Articulo,PropreArt:PropreArt.Art)
[Acciones.CopiarCostoGlobal]
Nombre=CopiarCostoGlobal
Boton=55
NombreEnBoton=S
NombreDesplegar=Nuveo Costo -> Costo (&Global)
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=GuardarCambios<BR>Si Confirmacion(<T>Esta seguro que desea copiar el Nuevo Costo al Costo para todos los productos <T>,BotonSi,BotonNo) = BotonSi Entonces<BR>  EJECUTARSQL(<T>SpCopiarCostoNuevoACostoVigenteGlobal<T>)      <BR>Asigna(Info.PropreCostoMin, 0.01)<BR>Asigna(Info.PropreCostoMax,SQL(<T>SELECT ISNULL(MAX(Costo),0) FROM PropreArt<T>))                     <BR>  ActualizarVista(<T>PropreArt<T>)   <BR>Fin
[Acciones.FiltroCero]
Nombre=FiltroCero
Boton=12
NombreDesplegar=C = 0
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S
Expresion=Asigna(Info.PropreCostoMin,0)<BR>Asigna(Info.PropreCostoMax,0)<BR>Asigna(Info.Filtro, 1)<BR>ActualizarVista(<T>PropreArt<T>)
[Acciones.FiltroTodo]
Nombre=FiltroTodo
Boton=11
NombreEnBoton=S
NombreDesplegar=Costo = Todos
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Asigna(Info.PropreCostoMin,SQL(<T>SELECT MIN(Costo) FROM PropreArt<T>))<BR>Asigna(Info.PropreCostoMax,SQL(<T>SELECT MAX(Costo) FROM PropreArt<T>))<BR>Asigna(Info.Filtro, 0)<BR>ActualizarVista(<T>PropreArt<T>)
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=113
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
Totalizadores1=Costo Total<BR>Existencias<BR>Articulos
Totalizadores2=Suma(PropreArt:PropreArt.Costo*PropreArt:PropreArtExistencia.Existencia)<BR>Suma(PropreArt:PropreArtExistencia.Existencia)<BR>Conteo(PropreArt:PropreArt.Art)
Totalizadores3=(Monetario)<BR>(Cantidades)<BR>(Cantidades)
TotCarpetaRenglones=Lista
ListaEnCaptura=Articulos<BR>Existencias<BR>Costo Total
[(Carpeta Totalizadores).Costo Total]
Carpeta=(Carpeta Totalizadores)
Clave=Costo Total
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Lista.PropreArtExistencia.Existencia]
Carpeta=Lista
Clave=PropreArtExistencia.Existencia
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Totalizadores).Existencias]
Carpeta=(Carpeta Totalizadores)
Clave=Existencias
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Acciones.EnviarTodosALista]
Nombre=EnviarTodosALista
Boton=78
NombreEnBoton=S
NombreDesplegar=&Enviar Todos
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Asigna(Info.PropreLista, Nulo)<BR>Forma(<T>ProprePreguntaLista<T>)<BR>Si ConDatos(Info.ProPreLista) Entonces<BR>  Informacion(SQL(<T>EXEC SpEnviarTodosAPropreLista :tLista<T>,Info.PropreLista))<BR>Fin
[Acciones.PropreArtUEN]
Nombre=PropreArtUEN
Boton=45
NombreEnBoton=S
NombreDesplegar=Configuración &UEN
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Formas
ClaveAccion=PropreArtUEN
Activo=S
Antes=S
AntesExpresiones=Asigna(Info.PropreArt,PropreArt:PropreArt.Art)
Visible=S
[Acciones.Garantias]
Nombre=Garantias
Boton=38
NombreEnBoton=S
NombreDesplegar=Articulos Con &Garantia
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=PropreArtGarantia
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.EnviarCategoriaALista]
Nombre=EnviarCategoriaALista
Boton=0
NombreDesplegar=Enviar por &Categoria
EnMenu=S
TipoAccion=Expresion
Expresion=Asigna(Info.PropreLista,<T><T>)<BR>Forma(<T>ProprePreguntaLista<T>)<BR>SI ConDatos(Info.ProPreLista) ENTONCES<BR>  Forma(<T>ProprePreguntaMargen<T>),<BR>  EJECUTARSQL(<T>EXEC SpEnviarPorCategoriaAPropreLista :tLista, :nClase, :nMargen<T>,Info.PropreLista,PropreArt:PropreArt.SubFamilia,Info.PropreMargen1)<BR>FIN
[(Carpeta Abrir)]
Estilo=Iconos
Pestana=S
Clave=(Carpeta Abrir)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Vista=PropreArt
Fuente={Tahoma, 8, Negro, []}
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Articulo<T>
ElementosPorPagina=200
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Art.Familia<BR>Art2.Descripcion1<BR>PropreArtExistencia.Existencia
CarpetaVisible=S
IconosConPaginas=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaRespetarControles=S
BusquedaAncho=20
BusquedaEnLinea=S
IconosSeleccionMultiple=S
IconosNombre=PropreArt:PropreArt.Art
[(Carpeta Abrir).Art.Familia]
Carpeta=(Carpeta Abrir)
Clave=Art.Familia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Art2.Descripcion1]
Carpeta=(Carpeta Abrir)
Clave=Art2.Descripcion1
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).PropreArtExistencia.Existencia]
Carpeta=(Carpeta Abrir)
Clave=PropreArtExistencia.Existencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[(Carpeta Abrir).Columnas]
0=-2
1=-2
2=-2
3=-2
[(Carpeta Totalizadores).]
Carpeta=(Carpeta Totalizadores)
ColorFondo=Negro
[Acciones.RecorreAtras]
Nombre=RecorreAtras
Boton=40
NombreDesplegar=Retroceder Registros 
EspacioPrevio=S
TipoAccion=Expresion
Activo=S
Visible=S
NombreEnBoton=S
Expresion=Si((Reexpresa(Info.PropreArtLista) - 20) < 0, Asigna(Info.PropreArtLista, <T>0<T>),Asigna(Info.PropreArtLista, Reexpresa(Info.PropreArtLista) - 20))<BR>ActualizarVista
[Acciones.RecorreAdelante]
Nombre=RecorreAdelante
Boton=7
NombreDesplegar=Avanzar Registros
TipoAccion=expresion
Activo=S
Visible=S
NombreEnBoton=S
Expresion=//Informacion(Reexpresa(SQL(<T>SELECT COUNT(*) FROM PropreArt<T>)))<BR>Si((Reexpresa(Info.PropreArtLista) + 20) <= Reexpresa(SQL(<T>SELECT COUNT(*) FROM PropreArt<T>)), Asigna(Info.PropreArtLista, Reexpresa(Info.PropreArtLista) + 20))<BR>//Informacion(Info.PropreArtLista)<BR>ActualizarVista
[(Carpeta Totalizadores).Articulos]
Carpeta=(Carpeta Totalizadores)
Clave=Articulos
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[Lista.Art.Linea]
Carpeta=Lista
Clave=Art.Linea
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Eliminar]
Nombre=Eliminar
Boton=33
NombreEnBoton=S
NombreDesplegar=Eliminar Articulos
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Antes=S
DespuesGuardar=S
AntesExpresiones=Si<BR>  Precaucion(<T>El Proceso Eliminara los articulos Sin movimientos recientes y que no se encuentran en ninguna lista.<BR>  ¿Desea Continuar?<T>, BotonSi, BotonNo) = BotonSi<BR>Entonces<BR>  ProcesarSQL(<T>EXEC spEmilinarArtLista<T>)         <BR>Fin
[Lista.ArtCostoEmpresa.CostoPromedio]
Carpeta=Lista
Clave=ArtCostoEmpresa.CostoPromedio
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Art.UltimoMov]
Carpeta=Lista
Clave=Art.UltimoMov
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Plata
ColorFuente=Negro
[Lista.Art.FechaUltimoMov]
Carpeta=Lista
Clave=Art.FechaUltimoMov
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Plata
ColorFuente=Negro
[Acciones.ArtInfo]
Nombre=ArtInfo
Boton=0
NombreDesplegar=<T>Informacion del Articulo<T>
EnMenu=S
TipoAccion=Formas
ClaveAccion=PropreArtInfo
Activo=S
Antes=S
Visible=S
AntesExpresiones=Asigna(Info.Articulo, PropreArt:PropreArt.Art)

