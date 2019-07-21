
[Forma]
Clave=DM0169MonederoVirtualClonFrm
Icono=67
Modulos=(Todos)
Nombre=Ingrese importe a redimir
VentanaTipoMarco=Sencillo
VentanaPosicionInicial=Centrado
VentanaExclusiva=S
VentanaEstadoInicial=Normal
BarraAcciones=S
AccionesTamanoBoton=15x5

ListaCarpetas=Virtual
CarpetaPrincipal=Virtual
PosicionInicialIzquierda=419
PosicionInicialArriba=308
PosicionInicialAlturaCliente=114
PosicionInicialAncho=527
ListaAcciones=Aceptar<BR>Cerrar
AccionesCentro=S
VentanaSinIconosMarco=S
PosicionSec1=68

VentanaExclusivaOpcion=0
ExpresionesAlMostrar=//Asigna(Mavi.SaldoVirtual,0)<BR>Asigna(Mavi.ImporteVirtual,0)<BR><BR>Asigna(Info.ClienteNombre,SQL(<T>SELECT Cliente FROM Venta WITH(NOLOCK) WHERE ID = :nId<T>,Info.ID)) //ya no pregunto si tiene virtual lo se desde la forma de venta<BR>  <BR>Asigna(Mavi.SerieMoneVirtual,SQL(<T>SELECT Serie FROM TarjetaMonederoMAVI WITH(NOLOCK) WHERE estatus = :tEst AND TipoMonedero = :tTip AND Cliente = :tCte <T>,<T>ACTIVA<T>,<T>VIRTUAL<T>,Info.ClienteNombre))<BR><BR>//informacion(Info.Cliente+<T>,<T>+Mavi.SerieMoneVirtual)<BR>SI (SQL(<T>SELECT dbo.fnMonederoDV(:tSerie,0)<T>,Mavi.SerieMoneVirtual))=<T>1<T><BR>ENTONCES                                                                              <BR>    Asigna(Mavi.SaldoVirtual,SQL(<T>SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoP WHERE Empresa = :tEmp AND Rama = :tRama AND Moneda = :tMon AND Grupo = :tGrupo AND Cuenta = :tCuenta AND UEN = ISNULL(NULLIF(:tUEN,:tVac),:tOmi)<T>, Empresa,<T>MONEL<T>, <T>Pesos<T>, <T>ME<T>, Izquierda(Mavi.SerieMoneVirtual,8), Info.UEN, <T><T>, <T>0<T> ))<BR>SINO<BR>    Asigna(Mavi.SaldoVirtual,SQL(<T>SELECT SUM(ISNULL(Saldo,0.0)) FROM SaldoP WHERE Empresa = :tEmp AND Rama = :tRama AND Moneda = :tMon AND Grupo = :tGrupo AND Cuenta = :tCuenta AND UEN = ISNULL(NULLIF(:tUEN,:tVac),:tOmi)<T>, Empresa,<T>MONEL<T>, <T>Pesos<T>, <T>ME<T>, Mavi.SerieMoneVirtual, Info.UEN, <T><T>, <T>0<T> ))<BR>FIN<BR><BR>  //Asigna(Mavi.SerieMoneVirtual,<T>01<T>)
[Lista.TarjetaSerieMovMavi.Serie]
Carpeta=Lista
Clave=TarjetaSerieMovMavi.Serie
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro

[Lista.Saldo]
Carpeta=Lista
Clave=Saldo
LineaNueva=N
ValidaNombre=S
3D=S
ColorFondo=Plata

Tamano=20
Efectos=[Negritas]
ColorFuente=Negro
[Lista.TarjetaSerieMovMavi.Importe]
Carpeta=Lista
Clave=TarjetaSerieMovMavi.Importe
Editar=S
LineaNueva=S
ValidaNombre=S
3D=S
ColorFondo=Blanco
Tamano=20
ColorFuente=Negro

[Lista.Columnas]
0=430

[Acciones.Aceptar]
Nombre=Aceptar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Aceptar
Multiple=S
EnBarraAcciones=S
Activo=S
Visible=S

ListaAccionesMultiples=Asignar<BR>Aceptar<BR>Cerrar
Antes=S
AntesExpresiones=Asigna(Mavi.NSerie,Izquierda(Mavi.SerieMoneVirtual,8))
[Acciones.Cerrar]
Nombre=Cerrar
Boton=0
NombreEnBoton=S
NombreDesplegar=&Cerrar
EnBarraAcciones=S
TipoAccion=Ventana
ClaveAccion=Cerrar
Visible=S
Multiple=S
ListaAccionesMultiples=Cerrar
ActivoCondicion=SQL(<T>SELECT COUNT(1)<BR>FROM dbo.Venta V WITH(NOLOCK)<BR>JOIN dbo.VentasCanalMAVI VC WITH(NOLOCK) ON VC.ID=V.EnviarA<BR>JOIN dbo.TablaRangoStD MV WITH(NOLOCK) ON Mv.TablaRangoSt=<T>+Comillas(<T>MODALIDAD MONEDERO VIRTUAL<T>)+<T><BR>    AND (CASE ISNULL(MV.NumeroD,0) WHEN 0 THEN V.UEN ELSE MV.NumeroD END) = V.UEN<BR>    AND (CASE ISNULL(MV.NumeroA,0) WHEN 0 THEN V.Sucursal ELSE MV.NumeroA END) = V.Sucursal<BR>    AND (CASE ISNULL(MV.Nombre,<T>+Comillas(<T><T>)+<T>) WHEN <T>+Comillas(<T><T>)+<T> THEN VC.Categoria ELSE MV.Nombre END) = VC.Categoria<BR>    AND V.ID=:nId<T>,Info.ID)=0

[Acciones.Aceptar.Aceptar]
Nombre=Aceptar
Boton=0
TipoAccion=Expresion
Activo=S
Visible=S
ConCondicion=S
EjecucionConError=S
Expresion=Asigna(Mavi.NSerie,Izquierda(Mavi.SerieMoneVirtual,8))<BR>Si<BR>  (SQL(<T>SELECT EnviarA FROM Venta WITH(NOLOCK) WHERE ID = :nId<T>,Info.ID) = 76)<BR>Entonces<BR> Asigna(Mavi.ServicasaModulo,1)<BR>         SI (SQL(<T>SELECT COUNT(Numero) FROM dbo.TablaNumD WHERE TablaNum=:tTab AND CAST(Numero AS INT)=:nSuc<T>, <T>SUCURSALES RDP<T>, Sucursal)=1)<BR>         Entonces<BR>             Ejecutar(<T>PlugIns\RutaTicket.exe <T>+<T>SHM7<T>+<T> <T>+<T>VALIDADIMA<T> +<T> <T>+ Info.ClienteNombre +<T> <T>+ <T>DIMA<T>+<T> <T>+Info.ID+<T>_<T>+Empresa+<T>_<T>+Mavi.NSerie+<T>_<T>+Mavi.ImporteVirtual+<T>_<T>+Sucursal+<T>_<T>+<T>VTAS<T>+<T> <T>+Sucursal)<BR>         Sino<BR>            Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe<T> +<T> <T>+ <T>VALIDADIMA<T> +<T> <T>+ Info.ClienteNombre +<T> <T>+ <T>DIMA<T>+<T> <T>+Info.ID+<T> <T>+Em<CONTINUA>
Expresion002=<CONTINUA>presa+<T> <T>+Mavi.NSerie+<T> <T>+Mavi.ImporteVirtual+<T> <T>+Sucursal+<T> <T>+<T>VTAS<T>)<BR>         Fin<BR> //Ejecutar(<T>C:\AppsMavi\SHM\SHM.exe<T> +<T> <T>+ <T>VALIDADIMA<T> +<T> <T>+ Info.ClienteNombre +<T> <T>+ <T>DIMA<T>+<T> <T>+Info.ID+<T> <T>+Empresa+<T> <T>+Mavi.NSerie+<T> <T>+Mavi.ImporteVirtual+<T> <T>+Sucursal+<T> <T>+<T>VTAS<T>)<BR> AbortarOperacion<BR>Sino<BR> Asigna(Mavi.ServicasaModulo,1)<BR> EjecutarSQLAnimado( <T>EXEC SP_InsertaTarjetaMonVirtual :tEmp,:tMod,:nId,:tSer,:nImp,:nSuc<T>,Empresa,<T>VTAS<T>,Info.ID,Mavi.NSerie,Mavi.ImporteVirtual,Sucursal)<BR> EjecutarSQL(<T>EXEC spRedimirMovMonederoMAVI :nid<T>, Info.ID)<BR><BR>Fin
EjecucionCondicion=Si Mavi.ImporteVirtual <= Mavi.SaldoVirtual<BR>Entonces<BR>    SI (SQL(<T>SELECT N=COUNT(ID) FROM DM0173UsrValidoMonedero WHERE ID=:tN<T>,Info.ID)>0) o (SQL(<T>Select Count(*) From  Venta where EnviarA=76 and ID=:nID<T>,Info.ID) > 0)<BR>    ENTONCES<BR><BR>            Verdadero<BR>    SINO<BR>          SI SQL(<T>Select Count(*) From Venta With(NoLock) Where EnviarA=76 and ID=:nID<T>,Info.ID)=0<BR>           Entonces<BR>             Forma(<T>DM0173ValidaUsrMone<T>)<BR>             Falso<BR>           Sino<BR>            Falso<BR>          Fin<BR>    FIN<BR>sino<BR>    informacion(<T>El importe no puede exceder el saldo<T>)<BR>    abortaroperacion<BR>fin
EjecucionMensaje=SI (SQL(<T>SELECT N=COUNT(ID) FROM DM0173UsrValidoMonedero WHERE ID=:tN<T>,Info.ID)>0) o (SQL(<T>Select Count(*) From Venta With(Nolock) Where EnviarA=76 and ID=:nId<T>,Info.ID)> 0)<BR>ENTONCES<BR>    SI (SQL(<T>SELECT COUNT(m.UEN) FROM MonederoMAVID md INNER JOIN MonederoMAVI m on m.ID = md.ID and m.Mov=:tMov AND m.UEN=:nUen AND Serie=:tSerie<T>,<T>Activacion Tarjeta<T>,Usuario.UEN,Izquierda(Mavi.SerieMoneVirtual,8)))=<T>0<T><BR>    ENTONCES<BR>        <T>Monedero no Aplica en esta Unidad de Negocio<T><BR>    SINO<BR>        <T>Monedero Incorrecto<T><BR>    FIN<BR>SINO<BR>    <T>Validar Monedero...<T><BR>FIN

[Acciones.Aceptar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Aceptar
Activo=S
Visible=S
[Acciones.Cerrar.Cerrar]
Nombre=Cerrar
Boton=0
TipoAccion=Ventana
ClaveAccion=Cerrar
Activo=S
Visible=S
[Virtual]
Estilo=Ficha
Clave=Virtual
PermiteEditar=S
AlineacionAutomatica=S
AcomodarTexto=S
MostrarConteoRegistros=S
Zona=A1
Vista=(Variables)
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
CarpetaVisible=S
ListaEnCaptura=Mavi.SerieMoneVirtual<BR>Mavi.SaldoVirtual<BR>Mavi.ImporteVirtual
[Virtual.Mavi.SerieMoneVirtual]
Carpeta=Virtual
Clave=Mavi.SerieMoneVirtual
Editar=N
LineaNueva=S
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Blanco
ColorFuente=Negro
[Virtual.Mavi.SaldoVirtual]
Carpeta=Virtual
Clave=Mavi.SaldoVirtual
Editar=N
ValidaNombre=S
3D=S
Tamano=20
ColorFondo=Plata
ColorFuente=Negro
[Virtual.Mavi.ImporteVirtual]
Carpeta=Virtual
Clave=Mavi.ImporteVirtual
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

