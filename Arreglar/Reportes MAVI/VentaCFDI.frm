
[Forma]
Clave=VentaCFDI
Icono=0
Modulos=(Todos)
Nombre=Ventas - Imprime CFD-Lote

ListaCarpetas=Lista
CarpetaPrincipal=Lista
PosicionInicialAlturaCliente=549
PosicionInicialAncho=755
PosicionInicialIzquierda=92
PosicionInicialArriba=54
BarraHerramientas=S
AccionesTamanoBoton=15x5
AccionesDerecha=S
EsMovimiento=S
TituloAuto=S
MovEspecificos=Todos
MovModulo=VTAS
ListaAcciones=(Lista)
[Lista]
Estilo=Iconos
Clave=Lista
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=VentaCFDI
Fuente={Tahoma, 8, Negro, []}
CampoColorLetras=Negro
CampoColorFondo=Negro
CarpetaVisible=S
IconosCampo=(sin Icono)
IconosEstilo=Detalles
IconosAlineacion=de Arriba hacia Abajo
IconosConSenales=S
ElementosPorPagina=200
IconosSeleccionMultiple=S

Filtros=S
MenuLocal=S
FiltroPredefinido=S
FiltroNullNombre=(sin clasificar)
FiltroTodoNombre=(Todo)
FiltroAncho=20
FiltroRespetar=S
FiltroTipo=General
BusquedaRapidaControles=S
FiltroFechas=S
FiltroCambiarPeriodo=S
FiltroBuscarEn=S
FiltroFechasCambiar=S
FiltroMonedas=S
FiltroFechasNormal=S
FiltroFechasNombre=&Fecha
FiltroMovs=S
FiltroMovsTodos=S
FiltroFechasCampo=v.FechaEmision
FiltroMovDefault=(Todos)
FiltroMonedasCampo=v.Moneda
FiltroSucursales=S
FiltroEstatusDefault=CONCLUIDO
FiltroUsuarioDefault=(Usuario)
IconosSubTitulo=<T>Movimiento<T>
FiltroListaEstatus=(Lista)
FiltroFechasDefault=(Todo)
BusquedaRapida=S
BusquedaEnLinea=S
BusquedaAncho=20
BusquedaRespetarFiltros=S
BusquedaInicializar=S
BusquedaRespetarControlesNum=S
ListaAcciones=ImprimirCFD


ListaEnCaptura=(Lista)
FiltroFechasCancelacion=v.FechaCancelacion
FiltroEstatus=S
FiltroModificarEstatus=S
IconosNombre=VentaCFDI:v.Mov+<T> <T>+VentaCFDI:v.MovID
FiltroGeneral=c.Sello IS NOT NULL<BR> and v.ContImpCFD IS NULL<BR>and v.ContImpCiego IS NULL<BR>and v.ContImpSimp IS NULL
[Lista.Columnas]
0=172
1=120
2=95

3=93
4=94
5=97



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

[Acciones.SeleccionarTodo]
Nombre=SeleccionarTodo
Boton=55
NombreDesplegar=Seleccionar &Todo
EnBarraHerramientas=S
TipoAccion=Controles Captura
ClaveAccion=Seleccionar Todo
Activo=S
Visible=S
NombreEnBoton=S
EspacioPrevio=S





[Acciones.ImprimirCFD]
Nombre=ImprimirCFD
Boton=0
NombreDesplegar=ImprimirCFD
RefrescarIconos=S
EnLote=S
EnMenu=S
TipoAccion=Expresion
Visible=S

Expresion=Si (VentaCFDI:v.Mov) en(SQL(<T>Select Mov From MovTipo Where CFD=:nuno and Modulo=:tvtas and mov=:tfa <T>,1,<T>VTAS<T>,VentaCFDI:v.Mov))<BR><BR>Entonces<BR> //Validaciones para CFD<BR> si (VentaCFDI:v.Mov) en(SQL(<T>Select Mov From MovTipo Where CFD=:nuno and Modulo=:tvtas and mov=:tfa <T>,1,<T>VTAS<T>,VentaCFDI:v.Mov))<BR> entonces<BR>   Si ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,1))=1)<BR>     entonces<BR>         Si  ((SQL(<T>select dbo.Fn_MaviCFDCanaliza(:nCvta)<T>,VentaCFDI:v.EnviarA))=1)<BR>           entonces<BR>                si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre no<CONTINUA>
Expresion002=<CONTINUA>t like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,1))>=(sql(<T>exec Sp_MaviCFDSaldo :nId<T>,VentaCFDI:v.ID)))<BR>                    entonces<BR>                            si (sql(<T>select isnull(ContImpCFD,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                            ReporteImpresora(<T>FacturaMAVI<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARI<CONTINUA>
Expresion003=<CONTINUA>O WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces                                                    <BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                                ReporteImpresora(<T>FacturaMAVI<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>CFD<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps a<CONTINUA>
Expresion004=<CONTINUA>nd Nombre not like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,2))=1)<BR>                    entonces<BR>                            si (sql(<T>select isnull(ContImpSimp,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                            ReporteImpresora(<T>FacturaMAVISimplificada<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nN<CONTINUA>
Expresion005=<CONTINUA>um)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                                ReporteImpresora(<T>FacturaMAVISimplificada<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre not like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in <CONTINUA>
Expresion006=<CONTINUA>(select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,3))=1)<BR>                    entonces<BR>                            si (sql(<T>select isnull(ContImpCiego,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                            ReporteImpresora(<T>FacturaMAVICiega<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                <CONTINUA>
Expresion007=<CONTINUA>                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                                ReporteImpresora(<T>FacturaMAVICiega<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia Embarque<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>           fin<BR>         Si ((SQL(<T>select dbo.Fn_MaviCFDCanaliza(:nCvta)<T>,VentaCFDI:v.EnviarA))=2)<BR>           entonces<BR>               si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nomb<CONTINUA>
Expresion008=<CONTINUA>re like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,1))>=(sql(<T>exec Sp_MaviCFDSaldo :nId<T>,VentaCFDI:v.ID)))<BR>                   entonces<BR>                            si (sql(<T>select isnull(ContImpCFD,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                            ReporteImpresora(<T>FacturaMAVIMayoreoImp<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO F<CONTINUA>
Expresion009=<CONTINUA>ROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImp<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>CFD<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                   sino <T><T> fin<BR>               si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre  like <T>+comillas(<T>May<CONTINUA>
Expresion010=<CONTINUA>oreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,2))=1)<BR>                   entonces<BR>                            si (sql(<T>select isnull(ContImpSimp,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                            ReporteImpresora(<T>FacturaMAVIMayoreoImpSimp<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T><CONTINUA>
Expresion011=<CONTINUA>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImpSimp<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                   sino <T><T> fin<BR>               si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre  like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi wh<CONTINUA>
Expresion012=<CONTINUA>ere id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,3))=1)<BR>                   entonces<BR>                            si (sql(<T>select isnull(ContImpCiego,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                            ReporteImpresora(<T>FacturaMAVIMayoreoImpCieg<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>     <CONTINUA>
Expresion013=<CONTINUA>                           EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImpCieg<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia Embarque<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                   sino <T><T> fin<BR>           fin<BR>     fin<BR><BR><BR><BR>    Si ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,1))=0)<BR> entonce<CONTINUA>
Expresion014=<CONTINUA>s<BR>         Si  ((SQL(<T>select dbo.Fn_MaviCFDCanaliza(:nCvta)<T>,VentaCFDI:v.EnviarA))=1)<BR>           entonces<BR>                si 1=1<BR>                    entonces<BR>                            si (sql(<T>select isnull(ContImpCFD,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                            ReporteImpresora(<T>FacturaMAVI<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR<CONTINUA>
Expresion015=<CONTINUA>>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                                ReporteImpresora(<T>FacturaMAVI<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>CFD<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre not like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T><CONTINUA>
Expresion016=<CONTINUA>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,2))=1)<BR>                    entonces<BR>                            si (sql(<T>select isnull(ContImpSimp,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                            ReporteImpresora(<T>FacturaMAVISimplificada<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                Eje<CONTINUA>
Expresion017=<CONTINUA>cutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                                ReporteImpresora(<T>FacturaMAVISimplificada<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre not like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,3))=1)<BR>              <CONTINUA>
Expresion018=<CONTINUA>      entonces<BR>                            si (sql(<T>select isnull(ContImpCiego,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                            ReporteImpresora(<T>FacturaMAVICiega<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR<CONTINUA>
Expresion019=<CONTINUA>>                                ReporteImpresora(<T>FacturaMAVICiega<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia Embarque<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                    sino <T><T> fin<BR>           fin<BR>         Si ((SQL(<T>select dbo.Fn_MaviCFDCanaliza(:nCvta)<T>,VentaCFDI:v.EnviarA))=2)<BR>           entonces<BR>               si 1=1<BR>                   entonces<BR>                            si (sql(<T>select isnull(ContImpCFD,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            Ejec<CONTINUA>
Expresion020=<CONTINUA>utarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                            ReporteImpresora(<T>FacturaMAVIMayoreoImp<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 3)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImp<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>CFD<T>)+<T> ya fue impres<CONTINUA>
Expresion021=<CONTINUA>o. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                   sino <T><T> fin<BR>               si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,2))=1)<BR>                   entonces<BR>                          si (sql(<T>select isnull(ContImpSimp,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>          <CONTINUA>
Expresion022=<CONTINUA>                  ReporteImpresora(<T>FacturaMAVIMayoreoImpSimp<T>,VentaCFDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 2)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImpSimp<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una r<CONTINUA>
Expresion023=<CONTINUA>eimpresión del mismo.<T>)<BR>                                fin<BR>                            fin<BR>                   sino <T><T> fin<BR>               si ((SQL(<T>select dbo.Fn_MaviCFDExtrae((Select Valor From TablaStd where TablaSt=:tps and Nombre like <T>+comillas(<T>Mayoreo%<T>)+<T> and Nombre in (select categoria from ventascanalmavi where id=:nCanlVta)),:nNum)<T>,<T>CFD TOLERANCIA<T>,VentaCFDI:v.EnviarA,3))=1)<BR>                   entonces<BR>                        si (sql(<T>select isnull(ContImpCiego,0) from venta where id=:nId<T>,VentaCFDI:v.ID)=0)<BR>                            entonces<BR>                            EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                            ReporteImpresora(<T>FacturaMAVIMayoreoImpCieg<T>,VentaC<CONTINUA>
Expresion024=<CONTINUA>FDI:v.ID)<BR>                            sino<BR>                                si  ((SQL(<T>select dbo.Fn_MaviCFDExtrae( (Select Valor From TablaStd where TablaSt=:tda and Nombre in (SELECT ACCESO FROM USUARIO WHERE Usuario =:tUsu)),:nNum)<T>,<T>CFD PERFILES P/IMPRESION<T>,Usuario,3))=1)<BR>                                entonces<BR>                                EjecutarSQL(<T>spConsecutivoImpresion :nID, :ncom<T>, VentaCFDI:v.ID, 1)<BR>                                ReporteImpresora(<T>FacturaMAVIMayoreoImpCieg<T>,VentaCFDI:v.ID)<BR>                                sino informacion(<T>Este reporte <T>+ COMILLAS(<T>Copia Embarque<T>)+<T> ya fue impreso. Su perfil de usuario no cuenta con privilegios para poder hacer una reimpresión del mismo.<T>)<BR>                                fin<CONTINUA>
Expresion025=<CONTINUA><BR>                            fin<BR>                   sino <T><T> fin<BR>           fin<BR> fin<BR><BR>fin
ActivoCondicion=usuario.imprimirmovs


[Lista.v.ID]
Carpeta=Lista
Clave=v.ID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco

[Lista.v.Empresa]
Carpeta=Lista
Clave=v.Empresa
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=5
ColorFondo=Blanco

[Lista.v.Mov]
Carpeta=Lista
Clave=v.Mov
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.v.MovID]
Carpeta=Lista
Clave=v.MovID
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco

[Lista.v.FechaEmision]
Carpeta=Lista
Clave=v.FechaEmision
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco















[Lista.ListaEnCaptura]
(Inicio)=v.ID
v.ID=v.Empresa
v.Empresa=v.Mov
v.Mov=v.MovID
v.MovID=v.FechaEmision
v.FechaEmision=(Fin)

[Lista.FiltroListaEstatus]
(Inicio)=CONCLUIDO
CONCLUIDO=CANCELADO
CANCELADO=(Fin)

[Forma.ListaAcciones]
(Inicio)=Cerrar
Cerrar=SeleccionarTodo
SeleccionarTodo=(Fin)
[Lista.]
Carpeta=Lista
ColorFondo=Negro
