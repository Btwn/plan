[Forma]
Clave=DM0214AgrupaZonasCobranza
Nombre=DM0214AgrupaZonasCobranza
Icono=0
Modulos=(Todos)
ListaCarpetas=Hoja<BR>Ficha<BR>Rutas<BR>totrutas
CarpetaPrincipal=Hoja
PosicionInicialAlturaCliente=706
PosicionInicialAncho=1382
BarraHerramientas=S
AccionesTamanoBoton=27x5
ListaAcciones=Guardar<BR>Exel<BR>nvareg<BR>NvaDiv<BR>NuevaZonas<BR>AdmonRutas<BR>AdmonAgentes<BR>Actualizar Forma<BR>Historial<BR>Fin<BR>Cerrar<BR>CambiaDivision<BR>CambiaRegion<BR>cancelacamb<BR>importarZOnas<BR>Borzonasinr<BR>Prueba<BR>SinZona
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Maximizado
PosicionInicialIzquierda=-8
PosicionInicialArriba=-8
PosicionCol1=746
PosicionSec1=121
PosicionSec2=884
PosicionCol2=978
VentanaRepetir=S
Menus=S
BarraAcciones=S
AccionesCentro=S
AccionesDivision=S
ExpresionesAlMostrar=Asigna( Info.Ruta,<T><T> )<BR>Asigna( Info.Nivel,<T><T> )<BR>Asigna( Info.Agente,<T><T> )<BR>Asigna( Info.Cuenta,<T><T> )<BR>Asigna( Info.Zona,<T><T> )<BR>Asigna( Info.Bloqueo,<T>1<T> )<BR>Asigna(Info.Numero,0)
ExpresionesAlActivar=SI SQL(<T>SELECT COUNT(A.Agente) FROM DM0214ZonasCobranza ZC WITH (NOLOCK) INNER JOIN Agente A ON ZC.Agente = A.Agente WHERE A.Estatus = <T>+ASCII(39)+<T>BAJA<T>+ASCII(39)+<T> OR A.Tipo <> <T>+ASCII(39)+<T>COBRADOR<T>+ASCII(39)+<T> OR A.Categoria <> <T>+ASCII(39)+<T>COBRANZA MENUDEO<T>+ASCII(39)+<T> OR A.Familia <> <T>+ASCII(39)+<T>COB CAMPO<T>+ASCII(39)+<T> OR A.NivelCobranzaMAVI <> ZC.NivelCobranza<T>) > 0<BR>ENTONCES<BR>    Forma( <T>DM0214ConflictosZonasCobranzaFrm<T> )<BR>    ActualizarForma<BR>FIN
MenuPrincipal=&Menú
[Hoja]
Estilo=Hoja
Clave=Hoja
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B1
Vista=DM0214AgrupaZonasRutasCobranzaVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0214ZonasCobranza.Region<BR>DM0214ZonasCobranza.Division<BR>DM0214ZonasCobranza.Categoria<BR>DM0214ZonasCobranza.NivelCobranza<BR>DM0214ZonasCobranza.Equipo<BR>DM0214ZonasCobranza.Zona<BR>DM0214ZonasCobranza.Agente<BR>DM0214ZonasCobranza.Maxcuentas<BR>DM0214ZonasCobranza.MaxAsociados<BR>DM0214ZonasCobranza.MaxCtesFinales
CarpetaVisible=S
MenuLocal=S
ListaAcciones=Localizar
Filtros=S
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaVistaOmision=Automática
FiltroPredefinido=S
FiltroGrupo1=DM0214ZonasCobranza.Categoria
FiltroValida1=DM0214ZonasCobranza.Categoria
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroTipo=Múltiple (por Grupos)
HojaPermiteInsertar=S
HojaPermiteEliminar=S
FiltroGrupo5=DM0214ZonasCobranza.Equipo
FiltroValida5=DM0214ZonasCobranza.Equipo
PermiteLocalizar=S
HojaMantenerSeleccion=S
FiltroGrupo2=DM0214ZonasCobranza.Region
FiltroValida2=DM0214ZonasCobranza.Region
FiltroGrupo3=DM0214ZonasCobranza.Division
FiltroValida3=DM0214ZonasCobranza.Division
FiltroGrupo4=DM0214ZonasCobranza.NivelCobranza
FiltroValida4=DM0214ZonasCobranza.NivelCobranza
FiltroRespetar=S
FiltroTodo=S
OtroOrden=S
ListaOrden=DM0214ZonasCobranza.Categoria<TAB>(Acendente)<BR>DM0214ZonasCobranza.Region<TAB>(Acendente)<BR>DM0214ZonasCobranza.Division<TAB>(Acendente)<BR>DM0214ZonasCobranza.NivelCobranza<TAB>(Acendente)<BR>DM0214ZonasCobranza.Equipo<TAB>(Acendente)<BR>DM0214ZonasCobranza.Zona<TAB>(Acendente)<BR>DM0214ZonasCobranza.Agente<TAB>(Decendente)
FiltroGrupo6=DM0214ZonasCobranza.Zona
FiltroValida6=DM0214ZonasCobranza.Zona
[Hoja.Columnas]
NivelCobranza=146
Zona=73
Ruta=79
Agente=67
MaxCuentas=56
Region=106
Division=130
Equipo=55
Maxcuentas=56
MaxAsociados=80
MaxCtesFinales=79
Categoria=145
[Acciones.Guardar]
Nombre=Guardar
Boton=3
NombreDesplegar=&Guardar
EnBarraHerramientas=S
Activo=S
NombreEnBoton=S
Multiple=S
ListaAccionesMultiples=guardar<BR>actcampo
Visible=S
ConCondicion=S
EjecucionConError=S
EspacioPrevio=S
EjecucionCondicion=1=1
EjecucionMensaje=<T>Ingresa un nivel<T>
[Acciones.Exel]
Nombre=Exel  
Boton=115
NombreEnBoton=S
NombreDesplegar=E&xportar  
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0214exportar
Activo=S
Visible=S
EspacioPrevio=S
Antes=S
AntesExpresiones=asigna(info.modulo,<T>Zonas<T>)
[Acciones.Actualiza.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Ficha]
Estilo=Ficha
Clave=Ficha
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=DM0214AgrupaZonasRutasCobranzaVis
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=84
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
ListaEnCaptura=(Lista)
GuardarPorRegistro=S
[Acciones.Guardar.guardar]
Nombre=guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S
[Rutas]
Estilo=Hoja
Clave=Rutas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=B2
Vista=DM0214AgrupaZonasRutasCobranzaTVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=DM0214ZonaCobranzaMen.Ruta<BR>DM0214ZonaCobranzaMen.Zona
CarpetaVisible=S
MenuLocal=S
ExpAntesRefrescar=Asigna(Info.Cantidad,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonasCobranza.Maxcuentas)<BR>Asigna(Info.AgenteA,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonasCobranza.Agente)<BR>Asigna(Info.Zona,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonaSCobranza.Zona)<BR>Asigna(Info.Nivel,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonaSCobranza.NivelCobranza )
Detalle=S
VistaMaestra=DM0214AgrupaZonasRutasCobranzaVis
LlaveLocal=DM0214ZonaCobranzaMen.Zona
LlaveMaestra=DM0214ZonasCobranza.Zona
Pestana=S
PestanaOtroNombre=S
PestanaNombre=RUTAS
HojaTitulos=S
HojaMostrarColumnas=S
HojaMostrarRenglones=S
HojaColoresPorEstatus=S
HojaPermiteInsertar=S
HojaPermiteEliminar=S
HojaVistaOmision=Automática
PermiteEditar=S
HojaIndicador=S
PermiteLocalizar=S
ListaAcciones=busca<BR>Final
[Rutas.Columnas]
Ruta=68
Zona=84
NivelCobranza=124
Agente=94
MaxCuentas=64
0=-2
1=-2
[Acciones.AdmonZonas.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Expresion=informacion(<T>No sirve todavia<T>)<T>
Activo=S
Visible=S
[Acciones.Rutas.Actualizar Vista]
Nombre=Actualizar Vista
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista(<T>Rutas<T>)
[(Variables).Info.Ruta]
Carpeta=(Variables)
Clave=Info.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.AdmonRutas]
Nombre=AdmonRutas
Boton=42
NombreEnBoton=S
NombreDesplegar=&Rutas
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0214ImportaRutas
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.AdmonAgentes]
Nombre=AdmonAgentes
Boton=60
NombreEnBoton=S
NombreDesplegar=A&gentes
Multiple=S
EnBarraHerramientas=S
Activo=S
Visible=S
ListaAccionesMultiples=datosCteRelacion
EspacioPrevio=S
[Acciones.AdmonAgentes.datosCteRelacion]
Nombre=datosCteRelacion
Boton=0
TipoAccion=Formas
ClaveAccion=DM0214ImportaAgentes
Activo=S
Visible=S
[Acciones.Actualizar Forma]
Nombre=Actualizar Forma
Boton=82
NombreDesplegar=Ac&tualizar
EnBarraHerramientas=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=Expresion<BR>actulizarbol<BR>localiazr
NombreEnBoton=S
Antes=S
EspacioPrevio=S
AntesExpresiones=Asigna(Info.ABC,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonasCobranza.Zona)
[Rutas.DM0214ZonaCobranzaMen.Ruta]
Carpeta=Rutas
Clave=DM0214ZonaCobranzaMen.Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[Rutas.DM0214ZonaCobranzaMen.Zona]
Carpeta=Rutas
Clave=DM0214ZonaCobranzaMen.Zona
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Historial]
Nombre=Historial
Boton=17
NombreEnBoton=S
NombreDesplegar=&Historial.
EnBarraHerramientas=S
TipoAccion=Formas
Activo=S
Visible=S
BtnResaltado=S
EspacioPrevio=S
ClaveAccion=DM0214FiltrosFechaFrm
[Acciones.Cerrar]
Nombre=Cerrar
Boton=23
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraHerramientas=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
EspacioPrevio=S
[Acciones.Localizar]
Nombre=Localizar
Boton=0
NombreDesplegar=Localizar
EnMenu=S
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=busca<BR>actuali
[Hoja.DM0214ZonasCobranza.Region]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Region
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
[Hoja.DM0214ZonasCobranza.Equipo]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Equipo
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
[Hoja.DM0214ZonasCobranza.Division]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Division
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
[Ficha.DM0214ZonasCobranza.Region]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Region
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.DM0214ZonasCobranza.Division]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Division
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.DM0214ZonasCobranza.Equipo]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Equipo
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.nvozn.zno]
Nombre=zno
Boton=0
TipoAccion=Formas
ClaveAccion=DM0214NuevaZonados
Activo=S
Visible=S
[Acciones.CambiaRegion]
Nombre=CambiaRegion
Boton=105
NombreEnBoton=S
NombreDesplegar=Cambio Div-Reg
Activo=S
Visible=S
Menu=&Menú
UsaTeclaRapida=S
TipoAccion=Formas
ClaveAccion=DM0214cambioRegion
EnMenu=S
EnBarraAcciones=S
[Acciones.CambiaDivision]
Nombre=CambiaDivision
Boton=98
NombreEnBoton=S
Menu=&Menú
UsaTeclaRapida=S
NombreDesplegar=Cambio Eq-Div
TipoAccion=Formas
ClaveAccion=DM0214cambioDivision
Activo=S
Visible=S
EnMenu=S
EnBarraAcciones=S
[Acciones.cancelacamb]
Nombre=cancelacamb
Boton=0
NombreDesplegar=Cancelacamb
TipoAccion=Controles Captura
ClaveAccion=Cancelar Cambios
Activo=S
Visible=S
[Acciones.NvaDiv]
Nombre=NvaDiv
Boton=78
Menu=&Menú
Activo=S
Visible=S
NombreDesplegar=Divisiones
TipoAccion=Formas
ClaveAccion=DM0214NuevaDivision
TeclaFuncion=F7
NombreEnBoton=S
EnBarraHerramientas=S
EspacioPrevio=S
[Acciones.nvareg]
Nombre=nvareg
Boton=19
Menu=&Menú
NombreDesplegar=Regi&ones
TipoAccion=Formas
ClaveAccion=DM0214NuevaRegion
Activo=S
Visible=S
Activo=S
Visible=S
Activo=S
Visible=S
TeclaFuncion=F6
NombreEnBoton=S
EnBarraHerramientas=S
EspacioPrevio=S
[Acciones.Localizar.busca]
Nombre=busca
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[Acciones.Localizar.actuali]
Nombre=actuali
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista(<T>Rutas<T>)<BR>Forma.ActualizarVista(<T>totrutas<T>)
[Acciones.Actualizar Forma.localiazr]
Nombre=localiazr
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.LocalizarValor( <T>hoja<T>,<T>zona<T>,Info.ABC )
[Acciones.Modificar.abre]
Nombre=abre
Boton=0
TipoAccion=Formas
ClaveAccion=DM0214NuevaZona
Activo=S
Visible=S
[Acciones.NuevaZonas]
Nombre=NuevaZonas
Boton=87
NombreEnBoton=S
NombreDesplegar=Zo&nas
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0214NuevaZona
Activo=S
Antes=S
Visible=S

Antes=S
Visible=S
EspacioPrevio=S
[Acciones.Guardar.actcampo]
Nombre=actcampo
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Forma.ActualizarVista(<T>totrutas<T>)<BR>Forma.ActualizarVista(<T>Rutas<T>)
[DM0214TOTRUTAS.TotRutas]
Carpeta=DM0214TOTRUTAS
Clave=TotRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[DM0214TOTRUTAS.Columnas]
0=-2
[(Carpeta Totalizadores)]
Clave=(Carpeta Totalizadores)
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=C2
Fuente={Tahoma, 8, Negro, []}
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
Totalizadores1=ruta
Totalizadores=S
TotCarpetaRenglones=Rutas
TotAlCambiar=S
CampoColorLetras=Negro
CampoColorFondo=Plata
CarpetaVisible=S
PestanaNombre=Total de Rutas
Totalizadores2=Conteo
Totalizadores3=0
ListaEnCaptura=Ruta
[(Carpeta Totalizadores).Ruta]
Carpeta=(Carpeta Totalizadores)
Clave=Ruta
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Plata
ColorFuente=Negro
[totrutas]
Estilo=Ficha
Clave=totrutas
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A2
Vista=DM0214TotRutasVis
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
CarpetaVisible=S
Detalle=S
VistaMaestra=DM0214AgrupaZonasRutasCobranzaVis
LlaveLocal=Zona
LlaveMaestra=DM0214ZonasCobranza.Zona
ListaEnCaptura=TotRutas
FichaEspacioEntreLineas=6
FichaEspacioNombres=100
FichaEspacioNombresAuto=S
FichaNombres=Izquierda
FichaAlineacion=Izquierda
FichaColorFondo=Plata
FichaAlineacionDerecha=S
[totrutas.TotRutas]
Carpeta=totrutas
Clave=TotRutas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
[totrutas.Columnas]
TotRutas=74
[Hoja.DM0214ZonasCobranza.Agente]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Agente
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=30
ColorFondo=Blanco
[Hoja.DM0214ZonasCobranza.Maxcuentas]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Maxcuentas
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
[Ficha.DM0214ZonasCobranza.Agente]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Agente
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.DM0214ZonasCobranza.Maxcuentas]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Maxcuentas
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Blanco
ColorFuente=Negro
Tamano=5
[Hoja.DM0214ZonasCobranza.NivelCobranza]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
[Hoja.DM0214ZonasCobranza.Zona]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Zona
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=15
ColorFondo=Blanco
[Ficha.DM0214ZonasCobranza.NivelCobranza]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.NivelCobranza
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro
[Ficha.DM0214ZonasCobranza.Zona]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Zona
Editar=N
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=12
ColorFondo=Blanco
ColorFuente=Negro
[Acciones.Actualizar Forma.actulizarbol]
Nombre=actulizarbol
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S
[Acciones.Final]
Nombre=Final
Boton=0
EsDefault=S
NombreDesplegar=Ir al &Final
EnMenu=S
Carpeta=Rutas
TipoAccion=Controles Captura
ClaveAccion=Registro Ultimo
Activo=S
Visible=S
TeclaFuncion=F4
UsaTeclaRapida=S
[Acciones.busca]
Nombre=busca
Boton=0
NombreDesplegar=Localizar
EnMenu=S
Carpeta=Rutas
TipoAccion=Controles Captura
ClaveAccion=Localizar
Activo=S
Visible=S
[Acciones.Fin]
Nombre=Fin
Boton=29
NombreEnBoton=S
NombreDesplegar=&Fin Rutas
EnBarraHerramientas=S
TipoAccion=Expresion
Activo=S
Visible=S
EspacioPrevio=S
Expresion=Forma.RegistroUltimo(<T>Rutas<T>)
[Acciones.importarZOnas]
Nombre=importarZOnas
Boton=-1
NombreEnBoton=S
NombreDesplegar=Importar Zonas  
EnMenu=S
EnBarraAcciones=S
TipoAccion=Formas
ClaveAccion=DM0214ImportaZonas
Activo=S
Visible=S
Menu=&Menú
[Acciones.Borzonasinr]
Nombre=Borzonasinr
Boton=0
NombreEnBoton=S
NombreDesplegar=Borrar Zonas sin Ruta
Multiple=S
EnMenu=S
EnBarraAcciones=S
Activo=S
Visible=S
Menu=&Menú
EsDefault=S
ListaAccionesMultiples=limpizona<BR>actarb<BR>locali
Antes=S
AntesExpresiones=Asigna(Info.ABC,DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonasCobranza.Zona)
[Acciones.Borzonasinr.limpizona]
Nombre=limpizona
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=EjecutarSQL(<T>EXEC SP_MAVIDM0214ZonasAgente <T>+ASCII(39)+<T>BorZona<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T>BrSinruta<T>+ASCII(39)+<T>,<T>+ASCII(39)+<T><T>+ASCII(39)+<T>,<T>+estaciontrabajo +<T>,<T>+ASCII(39)+Usuario+ASCII(39))
[Acciones.Borzonasinr.actarb]
Nombre=actarb
Boton=0
Carpeta=(Carpeta principal)
TipoAccion=Controles Captura
ClaveAccion=Actualizar Arbol
Activo=S
Visible=S
[Acciones.Borzonasinr.locali]
Nombre=locali
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S



















Expresion=Forma.LocalizarValor( <T>hoja<T>,<T>zona<T>,Info.ABC )
[Ficha.DM0214ZonasCobranza.MaxAsociados]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.MaxAsociados
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro

[Ficha.DM0214ZonasCobranza.MaxCtesFinales]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.MaxCtesFinales
Editar=S
LineaNueva=N
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco
ColorFuente=Negro







[Lista.Columnas]
Ruta=232

























[Hoja.DM0214ZonasCobranza.MaxAsociados]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.MaxAsociados
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Hoja.DM0214ZonasCobranza.MaxCtesFinales]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.MaxCtesFinales
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco







[Acciones.SinZona]
Nombre=SinZona
Boton=18
NombreEnBoton=S
NombreDesplegar=Sin &Zona
EnBarraHerramientas=S
TipoAccion=Formas
ClaveAccion=DM0214RutasSinZonaFRM
Activo=S

























Menu=&Menú




























[Hoja.DM0214ZonasCobranza.Categoria]
Carpeta=Hoja
Clave=DM0214ZonasCobranza.Categoria
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=50
ColorFondo=Blanco


[Ficha.DM0214ZonasCobranza.Categoria]
Carpeta=Ficha
Clave=DM0214ZonasCobranza.Categoria
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=22
ColorFondo=Blanco
ColorFuente=Negro

[Hoja.ListaEnCaptura]
(Inicio)=DM0214ZonasCobranza.Region
DM0214ZonasCobranza.Region=DM0214ZonasCobranza.Division
DM0214ZonasCobranza.Division=DM0214ZonasCobranza.Categoria
DM0214ZonasCobranza.Categoria=DM0214ZonasCobranza.NivelCobranza
DM0214ZonasCobranza.NivelCobranza=DM0214ZonasCobranza.Equipo
DM0214ZonasCobranza.Equipo=DM0214ZonasCobranza.Zona
DM0214ZonasCobranza.Zona=DM0214ZonasCobranza.Agente
DM0214ZonasCobranza.Agente=DM0214ZonasCobranza.Maxcuentas
DM0214ZonasCobranza.Maxcuentas=DM0214ZonasCobranza.MaxAsociados
DM0214ZonasCobranza.MaxAsociados=DM0214ZonasCobranza.MaxCtesFinales
DM0214ZonasCobranza.MaxCtesFinales=(Fin)

[Hoja.ListaOrden]
(Inicio)=DM0214ZonasCobranza.Categoria	(Acendente)
DM0214ZonasCobranza.Categoria	(Acendente)=DM0214ZonasCobranza.Region	(Acendente)
DM0214ZonasCobranza.Region	(Acendente)=DM0214ZonasCobranza.Division	(Acendente)
DM0214ZonasCobranza.Division	(Acendente)=DM0214ZonasCobranza.NivelCobranza	(Acendente)
DM0214ZonasCobranza.NivelCobranza	(Acendente)=DM0214ZonasCobranza.Equipo	(Acendente)
DM0214ZonasCobranza.Equipo	(Acendente)=DM0214ZonasCobranza.Zona	(Acendente)
DM0214ZonasCobranza.Zona	(Acendente)=DM0214ZonasCobranza.Agente	(Decendente)
DM0214ZonasCobranza.Agente	(Decendente)=(Fin)






[Ficha.ListaEnCaptura]
(Inicio)=DM0214ZonasCobranza.Region
DM0214ZonasCobranza.Region=DM0214ZonasCobranza.Equipo
DM0214ZonasCobranza.Equipo=DM0214ZonasCobranza.Maxcuentas
DM0214ZonasCobranza.Maxcuentas=DM0214ZonasCobranza.Division
DM0214ZonasCobranza.Division=DM0214ZonasCobranza.Zona
DM0214ZonasCobranza.Zona=DM0214ZonasCobranza.MaxAsociados
DM0214ZonasCobranza.MaxAsociados=DM0214ZonasCobranza.NivelCobranza
DM0214ZonasCobranza.NivelCobranza=DM0214ZonasCobranza.Agente
DM0214ZonasCobranza.Agente=DM0214ZonasCobranza.MaxCtesFinales
DM0214ZonasCobranza.MaxCtesFinales=DM0214ZonasCobranza.Categoria
DM0214ZonasCobranza.Categoria=(Fin)



[Forma.ListaCarpetas]
(Inicio)=Hoja
Hoja=Ficha
Ficha=Rutas
Rutas=totrutas
totrutas=(Fin)

[Forma.ListaAcciones]
(Inicio)=Guardar
Guardar=Exel
Exel=nvareg
nvareg=NvaDiv
NvaDiv=NuevaZonas
NuevaZonas=AdmonRutas
AdmonRutas=AdmonAgentes
AdmonAgentes=Actualizar Forma
Actualizar Forma=Historial
Historial=Fin
Fin=SinZona
SinZona=Cerrar
Cerrar=CambiaDivision
CambiaDivision=CambiaRegion
CambiaRegion=cancelacamb
cancelacamb=importarZOnas
importarZOnas=Borzonasinr
Borzonasinr=(Fin)

[Agente.Columnas]
Agente=64

[ListaConflictos.Columnas]
Agente=94
Conflicto=184





[Acciones.Actualizar Forma.Expresion]
Nombre=Expresion
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=SI DM0214AgrupaZonasRutasCobranzaVis:DM0214ZonasCobranza.Agente <> DM0214AgrupaZonasRutasCobranzaTVis:DM0214ZonaCobranzaMen.Agente<BR>ENTONCES<BR>    SI ( Confirmacion( <T>¿Guardar cambios?<T> ,    BotonSi   , BotonNo   )=6)<BR>        Entonces<BR>            GuardarCambios<BR>        Fin<BR>FIN

[Acciones.Prueba.Guardar]
Nombre=Guardar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Guardar Cambios
Activo=S
Visible=S

[Acciones.Prueba.Actualizar]
Nombre=Actualizar
Boton=0
TipoAccion=Controles Captura
ClaveAccion=Actualizar Vista
Activo=S
Visible=S

[Acciones.Prueba]
Nombre=Prueba
Boton=0
NombreEnBoton=S
NombreDesplegar=Prueba
Multiple=S
EnBarraHerramientas=S
EnMenu=S
EnBarraAcciones=S
ListaAccionesMultiples=Guardar<BR>Actualizar
Activo=S
ConCondicion=S
ConAutoEjecutar=S
EspacioPrevio=S
EjecucionCondicion=Si<BR>    Info.Numero = 1<BR>Entonces<BR>    Asigna(Info.Numero,0)<BR>    Verdadero<BR>Sino<BR>    Falso<BR>Fin
AutoEjecutarExpresion=1

