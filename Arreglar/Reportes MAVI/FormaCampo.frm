[Forma]
Clave=FormaCampo
Nombre=Campos de la Forma
Icono=0
Modulos=(Todos)
ListaCarpetas=Lista<BR>Ficha<BR>Fuente<BR>Formulario
CarpetaPrincipal=Ficha
PosicionInicialIzquierda=491
PosicionInicialArriba=322
PosicionInicialAlturaCliente=519
PosicionInicialAncho=947
PosicionCol1=461
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=Aceptar<BR>Nuevo<BR>Eliminar<BR>Ayuda<BR>Despliegue<BR>Validacion<BR>Navegador
VentanaTipoMarco=Diálogo
VentanaPosicionInicial=Centrado
Comentarios=Info.FormaTipo
[Lista]
Estilo=Hoja
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=FormaCampo
Fuente={Tahoma, 8, Negro, []}
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=FormaCampo.Grupo<BR>FormaCampo.Campo<BR>FormaCampo.Orden
CarpetaVisible=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMantenerSeleccion=S
PermiteEditar=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
OtroOrden=S
ListaOrden=FormaGrupo.Orden<TAB>(Acendente)<BR>FormaCampo.Orden<TAB>(Acendente)
FiltroGeneral=FormaCampo.FormaTipo=<T>{Info.FormaTipo}<T>
[Lista.FormaCampo.Campo]
Carpeta=Lista
Clave=FormaCampo.Campo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Ficha]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Datos Generales
Clave=Ficha
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=FormaCampo
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
ListaEnCaptura=FormaCampo.Campo<BR>FormaCampo.Etiqueta<BR>FormaCampo.Grupo<BR>FormaCampo.TipoDato<BR>FormaCampo.AyudaComentario<BR>FormaCampo.LongitudMaxima<BR>FormaCampo.Mascara<BR>FormaCampo.EsContrasena<BR>FormaCampo.EsMayusculas<BR>FormaCampo.AyudaTipo<BR>FormaCampo.DespliegueTipo<BR>FormaCampo.AyudaReferencia<BR>FormaCampo.DespliegueReferencia<BR>FormaCampo.ValidacionTipo<BR>FormaCampo.ValidacionTabla<BR>FormaCampo.ValidacionCampo<BR>FormaCampo.ValidacionReferencia<BR>FormaCampo.FuenteEspecial
CarpetaVisible=S
PermiteEditar=S
[Ficha.FormaCampo.Campo]
Carpeta=Ficha
Clave=FormaCampo.Campo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=62
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.Etiqueta]
Carpeta=Ficha
Clave=FormaCampo.Etiqueta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=62
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.Grupo]
Carpeta=Ficha
Clave=FormaCampo.Grupo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=62
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.TipoDato]
Carpeta=Ficha
Clave=FormaCampo.TipoDato
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Lista.FormaCampo.Orden]
Carpeta=Lista
Clave=FormaCampo.Orden
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Lista.Columnas]
Campo=239
Orden=35
Grupo=153
[Ficha.FormaCampo.FuenteEspecial]
Carpeta=Ficha
Clave=FormaCampo.FuenteEspecial
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Fuente]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Fuente Especial
Clave=Fuente
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=FormaCampo
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
ListaEnCaptura=FormaCampo.FuenteNombre<BR>FormaCampo.FuenteEstilo<BR>FormaCampo.FuenteTamano<BR>FormaCampo.FuenteColor<BR>FormaCampo.FuenteSubrayado<BR>FormaCampo.FondoColor
CondicionVisible=FormaCampo:FormaCampo.FuenteEspecial
[Fuente.FormaCampo.FuenteNombre]
Carpeta=Fuente
Clave=FormaCampo.FuenteNombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=40
ColorFondo=Blanco
ColorFuente=Negro
[Fuente.FormaCampo.FuenteEstilo]
Carpeta=Fuente
Clave=FormaCampo.FuenteEstilo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Fuente.FormaCampo.FuenteTamano]
Carpeta=Fuente
Clave=FormaCampo.FuenteTamano
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Fuente.FormaCampo.FuenteColor]
Carpeta=Fuente
Clave=FormaCampo.FuenteColor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Fuente.FormaCampo.FuenteSubrayado]
Carpeta=Fuente
Clave=FormaCampo.FuenteSubrayado
Editar=S
LineaNueva=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
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
[Lista.FormaCampo.Grupo]
Carpeta=Lista
Clave=FormaCampo.Grupo
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Nuevo]
Nombre=Nuevo
Boton=1
NombreDesplegar=&Nuevo
EnBarraHerramientas=S
EspacioPrevio=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Agregar
Activo=S
Visible=S
NombreEnBoton=S
[Acciones.Eliminar]
Nombre=Eliminar
Boton=5
NombreEnBoton=S
NombreDesplegar=E&liminar
EnBarraHerramientas=S
ConfirmarAntes=S
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Registro Eliminar
Activo=S
Visible=S
[Acciones.Navegador]
Nombre=Navegador
Boton=0
NombreDesplegar=Navegador
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Herramientas Captura
ClaveAccion=Navegador 2 (Registros)
Activo=S
Visible=S
[Ficha.FormaCampo.EsContrasena]
Carpeta=Ficha
Clave=FormaCampo.EsContrasena
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[Ficha.FormaCampo.EsMayusculas]
Carpeta=Ficha
Clave=FormaCampo.EsMayusculas
Editar=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[Ficha.FormaCampo.LongitudMaxima]
Carpeta=Ficha
Clave=FormaCampo.LongitudMaxima
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[Ficha.FormaCampo.Mascara]
Carpeta=Ficha
Clave=FormaCampo.Mascara
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=N
[Ficha.FormaCampo.AyudaTipo]
Carpeta=Ficha
Clave=FormaCampo.AyudaTipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
EspacioPrevio=S
[Ficha.FormaCampo.ValidacionTipo]
Carpeta=Ficha
Clave=FormaCampo.ValidacionTipo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
LineaNueva=S
EspacioPrevio=S
[Ayuda.FormaCampo.AyudaReferencia]
Carpeta=Ayuda
Clave=FormaCampo.AyudaReferencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ayuda.FormaCampo.AyudaRefrescar]
Carpeta=Ayuda
Clave=FormaCampo.AyudaRefrescar
Editar=S
LineaNueva=S
ValidaNombre=N
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=20
[Ficha.FormaCampo.AyudaComentario]
Carpeta=Ficha
Clave=FormaCampo.AyudaComentario
Editar=S
ValidaNombre=S
3D=S
Tamano=41
ColorFondo=Blanco
ColorFuente=Negro
[Fuente.FormaCampo.FondoColor]
Carpeta=Fuente
Clave=FormaCampo.FondoColor
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
EspacioPrevio=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.AyudaReferencia]
Carpeta=Ficha
Clave=FormaCampo.AyudaReferencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.ValidacionTabla]
Carpeta=Ficha
Clave=FormaCampo.ValidacionTabla
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.ValidacionCampo]
Carpeta=Ficha
Clave=FormaCampo.ValidacionCampo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.ValidacionReferencia]
Carpeta=Ficha
Clave=FormaCampo.ValidacionReferencia
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Ayuda]
Nombre=Ayuda
Boton=47
NombreEnBoton=S
NombreDesplegar=&Ayuda
GuardarAntes=S
EnBarraHerramientas=S
EspacioPrevio=S
TipoAccion=Expresion
ConCondicion=S
Antes=S
Visible=S
Expresion=Caso FormaCampo:FormaCampo.AyudaTipo<BR>  Es <T>Lista<T> Entonces Forma(<T>FormaCampoAyudaLista<T>)<BR>  Es <T>Lista Opcional<T> Entonces Forma(<T>FormaCampoAyudaLista<T>)<BR>  Es <T>Expresion<T> Entonces Forma(<T>FormaCampoAyudaExpresion<T>)<BR>  Es <T>Expresion Opcional<T> Entonces Forma(<T>FormaCampoAyudaExpresion<T>)<BR>  Es <T>Forma<T> Entonces Forma(<T>FormaCampoAyudaExpresion<T>)<BR>Fin
ActivoCondicion=ConDatos(FormaCampo:FormaCampo.AyudaTipo)
EjecucionCondicion=ConDatos(FormaCampo:FormaCampo.AyudaTipo)
AntesExpresiones=Asigna(Info.FormaTipo, FormaCampo:FormaCampo.FormaTipo)<BR>Asigna(Info.Campo, FormaCampo:FormaCampo.Campo)<BR>Asigna(Info.Referencia, FormaCampo:FormaCampo.AyudaReferencia)
[Acciones.Despliegue]
Nombre=Despliegue
Boton=47
NombreEnBoton=S
NombreDesplegar=&Despliegue
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Expresion
ConCondicion=S
Antes=S
Visible=S
Expresion=Forma(<T>FormaCampoDespliegueExpresion<T>)
ActivoCondicion=FormaCampo:FormaCampo.DespliegueTipo=<T>Expresion<T>
EjecucionCondicion=FormaCampo:FormaCampo.DespliegueTipo=<T>Expresion<T>
AntesExpresiones=Asigna(Info.FormaTipo, FormaCampo:FormaCampo.FormaTipo)<BR>Asigna(Info.Campo, FormaCampo:FormaCampo.Campo)<BR>Asigna(Info.Referencia, FormaCampo:FormaCampo.DespliegueReferencia)
[Acciones.Validacion]
Nombre=Validacion
Boton=47
NombreEnBoton=S
NombreDesplegar=&Validación
GuardarAntes=S
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=FormaCampoValidacionExpresion
Visible=S
ConCondicion=S
Antes=S
ActivoCondicion=ConDatos(FormaCampo:FormaCampo.ValidacionTipo)
EjecucionCondicion=ConDatos(FormaCampo:FormaCampo.ValidacionTipo)
AntesExpresiones=Asigna(Info.FormaTipo, FormaCampo:FormaCampo.FormaTipo)<BR>Asigna(Info.Campo, FormaCampo:FormaCampo.Campo)<BR>Asigna(Info.Referencia, FormaCampo:FormaCampo.ValidacionReferencia)
[Formulario]
Estilo=Ficha
Pestana=S
PestanaOtroNombre=S
PestanaNombre=Formulario
Clave=Formulario
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=FormaCampo
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
ListaEnCaptura=FormaCampo.PosX<BR>FormaCampo.PosY<BR>FormaCampo.Ancho
PermiteEditar=S
CondicionVisible=Info.Tipo=<T>Formulario<T>
[Formulario.FormaCampo.PosX]
Carpeta=Formulario
Clave=FormaCampo.PosX
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Formulario.FormaCampo.PosY]
Carpeta=Formulario
Clave=FormaCampo.PosY
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Formulario.FormaCampo.Ancho]
Carpeta=Formulario
Clave=FormaCampo.Ancho
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.DespliegueTipo]
Carpeta=Ficha
Clave=FormaCampo.DespliegueTipo
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.FormaCampo.DespliegueReferencia]
Carpeta=Ficha
Clave=FormaCampo.DespliegueReferencia
Editar=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
