[Forma]
Clave=MaviCobTelA
Nombre=Selecciona el Cliente a Cobrar
Icono=0
Modulos=(Todos)<BR>CXC
MovModulo=CXC
ListaCarpetas=Principal
CarpetaPrincipal=Principal
PosicionInicialIzquierda=432
PosicionInicialArriba=129
PosicionInicialAlturaCliente=668
PosicionInicialAncho=416
BarraAcciones=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
ListaAcciones=AbrirA<BR>Cerrar
AccionesDivision=S
AutoGuardar=S
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaEstadoInicial=Normal
VentanaAjustarZonas=S
VentanaBloquearAjuste=S
[Acciones.Abrir]
Nombre=Abrir
Boton=0
NombreDesplegar=Abrir
EnMenu=S
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
Expresion=Si SQL(<T>Select Max(FechaPromesa) From MaviCobTelFechasPromesa<BR>                    Where ID = :nid And IDAsignacion = :nidasignacion<BR>                    And Cliente = :tcliente<T>,CobTelMaviA:CobTelMavi.ID<BR>                    ,CobTelMaviA:CobTelMavi.IDAsignacion,CobTelMaviA:CobTelMavi.Cliente) < SQL(<T>Select Getdate()<T>)<BR>Entonces<BR><BR>Asigna(Info.ID,CobTelMaviA:CobTelMavi.ID)<BR>Asigna(Info.IDR, SQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,1<T>))<BR>Asigna(Temp.Numerico1, SQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,3<T>))<BR>Asigna(Temp.Numerico2,0)<BR><BR>Si (Vacio(Sql(<T>Select Usuario1 from CobTelMavi where ID=:nid<T>,Info.ID)))  o (Vacio(Sql(<T>Select Usuario2 from CobTelMavi where ID=:nid<T>,Info.ID)))<BR>Entonces<BR><BR> Asigna(Temp.Numerico3,1)<<CONTINUA>
Expresion002=<CONTINUA>BR> Si (no Vacio(Sql(<T>Select FechaPromesa from CobTelMavi where ID=:nid<T>,Info.ID)))  y (Vacio(Sql(<T>Select Usuario2 from CobTelMavi where ID=:nid<T>,Info.ID))) y (Vacio(CobTelMaviA:CobTelMavi.Resultado))<BR> Entonces<BR>    Si Precaucion(<T>Ya se capturó la Primer respuesta de la Gestión, Desea Registrar la Segunda?<T>, BotonSi, BotonNo )= 7<BR>    Entonces<BR>         Asigna(Temp.Numerico3,0)<BR>         Asigna(Temp.Numerico2,1)<BR>    Fin<BR> Fin<BR>   Si Temp.Numerico3=1<BR>   Entonces<BR>     Si Info.IDR = 1<BR>     Entonces<BR>       Si Temp.Numerico1=0<BR>       Entonces<BR>           Si FormaModal(<T>CobTelMavi<T>)<BR>           Entonces<BR>               Asigna(Temp.Numerico2,1)<BR>               EjecutarSQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,2<T>)<BR>         <CONTINUA>
Expresion003=<CONTINUA>  Fin<BR>       Fin<BR>     Sino<BR>          Si Info.IDR = 2 Entonces<BR>             Precaucion(<T>La Gestión no esta activada para Seguimiento<T>)<BR>             Asigna(Temp.Numerico2,1)<BR>          Sino<BR>             Precaucion(<T>No puede brincar el cliente, o el mismo ya esta en uso.<T>)<BR>             Asigna(Temp.Numerico2,1)<BR>          Fin<BR>     Fin<BR>   Fin<BR>Fin<BR><BR> Si Temp.Numerico2=1<BR>  Entonces<BR>  EjecutarSQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,4<T>)<BR> Fin<BR><BR><BR>  Si Temp.Numerico1=1<BR>   Entonces<BR>   Precaucion(<T>El Cliente ya está siendo gestionado por otro usuario!<T>)<BR>  Fin<BR>SiNo<BR>    Informacion(<T>Aun no se cumple la ultima fecha promesa<T>)<BR>                     Informacion(<T>La ultima fecha promesa es: <T>+SQL(<T>S<CONTINUA>
Expresion004=<CONTINUA>elect Max(FechaPromesa) From MaviCobTelFechasPromesa<BR>                                 Where ID = :nid And IDAsignacion = :nidasignacion<BR>                                 And Cliente = :tcliente<T>,CobTelMaviA:CobTelMavi.ID<BR>                                ,CobTelMaviA:CobTelMavi.IDAsignacion,CobTelMaviA:CobTelMavi.Cliente))<BR>Fin<BR>ActualizarVista
EjecucionCondicion=ConDatos(CobTelMaviA:CobTelMavi.Cliente)
[Principal]
Estilo=Iconos
Clave=Principal
OtroOrden=S
MenuLocal=S
AlineacionAutomatica=S
AcomodarTexto=S
Zona=A1
Vista=CobTelMaviA
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Blanco
ListaEnCaptura=Cte.Nombre<BR>CobTelMavi.Resultado
ListaOrden=CobTelMavi.Cliente<TAB>(Acendente)
ListaAcciones=Abrir
CarpetaVisible=S
BusquedaRapidaControles=S
FiltroModificarEstatus=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
BusquedaRapida=S
BusquedaInicializar=S
BusquedaAncho=20
BusquedaEnLinea=S
Filtros=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroEnOrden=S
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
IconosSubTitulo=<T>Cliente<T>
ElementosPorPagina=200
IconosConRejilla=S
IconosNombre=CobTelMaviA:CobTelMavi.Cliente
FiltroGeneral=CobTelMavi.IDAsignacion In (Select ID From CobTelAsignacionMavi Where Estatus = <T>Concluido<T> And Vigente = 1) And<BR>CobTelMavi.Equipo = (SELECT E.Equipo<BR>FROM dbo.EquipoAgente E<BR>INNER JOIN dbo.Prop P ON e.Agente = P.Propiedad<BR>WHERE P.Cuenta = {Comillas(USUARIO)})<BR>AND (CobTelMavi.FechaPromesa IS NULL OR CobTelMavi.FechaPromesa2 IS NULL)
[Principal.Cte.Nombre]
Carpeta=Principal
Clave=Cte.Nombre
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=100
ColorFondo=Blanco
ColorFuente=Negro
[Principal.CobTelMavi.Resultado]
Carpeta=Principal
Clave=CobTelMavi.Resultado
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=10
ColorFondo=Blanco
ColorFuente=Negro
[Principal.Columnas]
Cliente=64
Nombre=236
Resultado=64
ID=64
0=78
1=252
2=-2
[Acciones.AbrirA]
Nombre=AbrirA
Boton=0
NombreEnBoton=S
NombreDesplegar=Abrir
EnBarraAcciones=S
TipoAccion=Expresion
Activo=S
Visible=S
Multiple=S
ListaAccionesMultiples=EXpre
ConCondicion=S
EjecucionCondicion=ConDatos(CobTelMaviA:CobTelMavi.Cliente)
[Acciones.AbrirA.EXpre]
Nombre=EXpre
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
Expresion=Si SQL(<T>Select Max(FechaPromesa) From MaviCobTelFechasPromesa<BR>                    Where ID = :nid And IDAsignacion = :nidasignacion<BR>                    And Cliente = :tcliente<T>,CobTelMaviA:CobTelMavi.ID<BR>                    ,CobTelMaviA:CobTelMavi.IDAsignacion,CobTelMaviA:CobTelMavi.Cliente) < SQL(<T>Select Getdate()<T>)<BR>Entonces<BR><BR>Asigna(Info.ID,CobTelMaviA:CobTelMavi.ID)<BR>Asigna(Info.IDR, SQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,1<T>))<BR>Asigna(Temp.Numerico1, SQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,3<T>))<BR>Asigna(Temp.Numerico2,0)<BR><BR>Si (Vacio(Sql(<T>Select Usuario1 from CobTelMavi where ID=:nid<T>,Info.ID)))  o (Vacio(Sql(<T>Select Usuario2 from CobTelMavi where ID=:nid<T>,Info.ID)))<BR>Entonces<BR><BR> Asigna(Temp.Numerico3,1)<<CONTINUA>
Expresion002=<CONTINUA>BR> Si (no Vacio(Sql(<T>Select FechaPromesa from CobTelMavi where ID=:nid<T>,Info.ID)))  y (Vacio(Sql(<T>Select Usuario2 from CobTelMavi where ID=:nid<T>,Info.ID))) y (Vacio(CobTelMaviA:CobTelMavi.Resultado))<BR> Entonces<BR>    Si Precaucion(<T>Ya se capturó la Primer respuesta de la Gestión, Desea Registrar la Segunda?<T>, BotonSi, BotonNo )= 7<BR>    Entonces<BR>         Asigna(Temp.Numerico3,0)<BR>         Asigna(Temp.Numerico2,1)<BR>    Fin<BR> Fin<BR>   Si Temp.Numerico3=1<BR>   Entonces<BR>     Si Info.IDR = 1<BR>     Entonces<BR>       Si Temp.Numerico1=0<BR>       Entonces<BR>           Si FormaModal(<T>CobTelMavi<T>)<BR>           Entonces<BR>               Asigna(Temp.Numerico2,1)<BR>               EjecutarSQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,2<T>)<BR>         <CONTINUA>
Expresion003=<CONTINUA>  Fin<BR>       Fin<BR>     Sino<BR>          Si Info.IDR = 2 Entonces<BR>             Precaucion(<T>La Gestión no esta activada para Seguimiento<T>)<BR>             Asigna(Temp.Numerico2,1)<BR>          Sino<BR>             Precaucion(<T>No puede brincar el cliente, o el mismo ya esta en uso.<T>)<BR>             Asigna(Temp.Numerico2,1)<BR>          Fin<BR>     Fin<BR>   Fin<BR>Fin<BR><BR> Si Temp.Numerico2=1<BR>  Entonces<BR>  EjecutarSQL(<T>Exec SP_ValidaClienteCobTelMavi <T>+Info.ID+<T>,4<T>)<BR> Fin<BR><BR><BR>  Si Temp.Numerico1=1<BR>   Entonces<BR>   Precaucion(<T>El Cliente ya está siendo gestionado por otro usuario!<T>)<BR>  Fin<BR>SiNo<BR>    Informacion(<T>Aun no se cumple la ultima fecha promesa<T>)<BR>                     Informacion(<T>La ultima fecha promesa es: <T>+SQL(<T>S<CONTINUA>
Expresion004=<CONTINUA>elect Max(FechaPromesa) From MaviCobTelFechasPromesa<BR>                                 Where ID = :nid And IDAsignacion = :nidasignacion<BR>                                 And Cliente = :tcliente<T>,CobTelMaviA:CobTelMavi.ID<BR>                                ,CobTelMaviA:CobTelMavi.IDAsignacion,CobTelMaviA:CobTelMavi.Cliente))<BR>Fin<BR>ActualizarVista
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreDesplegar=Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S

