SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE  [dbo].[spAspelImportarTablasCargaPropReg]
(
@ServidorOrigen		varchar(20),
@ServidorDestino		varchar(20),
@BaseDatosOrigen		varchar(20),
@BaseDatosDestino		varchar(20),
@ImportarCOI			bit
)

AS BEGIN
SET LOCK_TIMEOUT -1
DECLARE @Link				nvarchar(50),
@Sql				nvarchar(max),
@Cuenta				varchar(50),
@Modulo				varchar(15),
@Agrupador			varchar(15),
@CuentaParam		varchar(50),
@Saldo				money,
@Parametros			nvarchar(max),
@CuentaParametro	varchar(50),
@ConfS				int,
@ConfE				varchar(30),
@ConfU				varchar(30),
@CuentaV			varchar(30),
@CuentaD			varchar(30),
@Cte				varchar(30),
@Prov				varchar(30),
@Refer				varchar(30),
@Importe			varchar(30),
@alm				varchar(30),
@art				varchar(30),
@cant				float(30),
@cost				float(30),
@Obsrv				varchar(30),
@Tipo				varchar(30),
@Estatus			varchar(15),
@Moneda				varchar(30),
@GID				uniqueidentifier,
@Factura			varchar(10),
@Mon				varchar(20),
@Descr				varchar(50),
@TipoCambio			varchar(10),
@FechaAplicacion	datetime,
@FechaVencimiento	datetime,
@TipoMov			varchar(5),
@Documento			varchar(30),
@ImporteCargo		float(15),
@ImporteAbono		float(15),
@SaldoCx			float(15),
@Debe				money,
@Haber				money,
@CadenaAgrupacion	varchar(255),
@MovDebe			varchar(20),
@MovHaber			varchar(20),
@ImporteCxc			money,
@CampoImpuesto1		varchar(30),
@CampoImpuesto2		varchar(30),
@CampoImpuesto3		varchar(30),
@Costo				float(15),
@NumConcep		smallint
SET DATEFIRST 7
SET @Sql = ''
SET @Link = ''
SET @ConfE	= ''
SET @ConfU	= ''
SET @Parametros = ''
SET @Parametros = '@ConfS int OUTPUT'
SET @Sql = 'SELECT @ConfS = Valor FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Sucursal' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @ConfS = @ConfS OUTPUT
SET @Parametros = '@ConfE varchar(30) OUTPUT'
SET @Sql = 'SELECT @ConfE = Valor FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Empresa' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @ConfE = @ConfE OUTPUT
SET @Parametros = '@ConfU varchar(30) OUTPUT'
SET @Sql = 'SELECT @ConfU = Valor FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Usuario' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @ConfU = @ConfU OUTPUT
SET @Parametros = '@Obsrv varchar(30) OUTPUT'
SET @Sql = 'SELECT @Obsrv = Valor FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Observaciones' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @Obsrv = @Obsrv OUTPUT
SET @Parametros = '@Tipo varchar(30) OUTPUT'
SET @Sql = 'SELECT @Tipo = Valor FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Tipo' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @Tipo = @Tipo OUTPUT
SET @Parametros = '@Estatus varchar(30) OUTPUT'
SET @Sql = 'SELECT @Estatus = Valor FROM ' + @ServidorDestino + '.' + @BaseDatosDestino +
'.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Estatus' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @Estatus = @Estatus OUTPUT
SET @Parametros = '@Moneda varchar(30) OUTPUT'
SET @Sql = 'SELECT @Moneda = Valor FROM ' + @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfg WHERE Descripcion = ' + CHAR(39) + 'Moneda' + CHAR(39)
EXEC sp_executesql @Sql, @Parametros, @Moneda = @Moneda OUTPUT
SET @Parametros = '@GID uniqueidentifier OUTPUT'
SELECT @Sql = 'Select @GID = NEWID()'
EXEC sp_executesql @Sql, @Parametros, @GID = @GID OUTPUT
SET @Sql = ''
+ 'INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelMcCarga (GID, Empresa, Sucursal, Usuario, FechaEmision, Observaciones, Tipo, Estatus) '
+ 'VALUES (@GID, @ConfE, @ConfS, @ConfU, Getdate(), @Obsrv, @Tipo, @Estatus)'
EXEC sp_executeSql @Sql,
N'@GID uniqueidentifier, @ConfE varchar(30), @ConfS varchar(30), @ConfU varchar(30), @Obsrv varchar(30), @Tipo varchar(30), @Estatus varchar(30)',
@GID = @GID,
@ConfE = @ConfE,
@ConfS = @ConfS,
@ConfU = @ConfU,
@Obsrv = @Obsrv,
@Tipo = @Tipo,
@Estatus = @Estatus
SET @Sql = 'USE ' + @BaseDatosDestino
EXEC sp_executesql @Sql
IF NOT EXISTS (SELECT NAME FROM sys.servers WHERE NAME = @ServidorOrigen)
BEGIN
SET @Link = 'sp_addlinkedserver ' + char(39) + @ServidorOrigen + char(39) + ', N' + char(39) + 'SQL Server' + char(39)
EXEC sp_ExecuteSql @Link
END
/*********** Carga de Ventas y Devoluciones de Venta ***********/
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Ventas' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #VTAS
( 	 Mayor		varchar(30)	NULL,
Empresa	varchar(10)	NULL,
Sucursal	int			NULL,
Moneda		varchar(10) NULL,
TipoCambio float(15)	NULL,
Cliente	varchar (6)	NULL,
Almacen	varchar(30)	NULL,
Fecha		datetime	NULL,
Articulo	varchar(20)	NULL,
Cantidad	float(15)	NULL,
Precio		float(15)	NULL,
Impuesto1	float(15)	NULL,
Impuesto2	float(15)	NULL,
Impuesto3	float(15)	NULL,
Descuento1	float(15)	NULL,
DEBE		float(15)	NULL,
HABER		float(15)	NULL,
Mov		varchar(20)	NULL,
MovID		varchar(20)	NULL,
Agente		varchar(10) NULL,
DescGlobal	float(15)	NULL,
Costo float(15) NULL,
Estatus varchar(15) NULL,
CLIENTEORIG VARCHAR(5) NULL,
AGENTEORIG VARCHAR(5)  NULL
)
SELECT @CadenaAgrupacion = CASE @Agrupador
WHEN 'Movimiento' THEN 'FACT.FECHA_DOC, FACT.CVE_DOC, '
WHEN 'Dia'		THEN 'FACT.FECHA_DOC, '
WHEN 'Semana'		THEN 'DATEADD(DD, - DATEPART(DW,FACT.FECHA_DOC),DATEADD(WW,1,FACT.FECHA_DOC)), '
WHEN 'Mes'		THEN 'DATEADD(DD, - DAY(FACT.FECHA_DOC),DATEADD(MM,1,FACT.FECHA_DOC)), '
WHEN 'A�o'		THEN 'DATEADD(DD, - DATEPART(DY,FACT.FECHA_DOC),DATEADD(YY,1,FACT.FECHA_DOC)), '
ELSE 'FACT.FECHA_DOC, '
END
SELECT @CampoImpuesto1 = LTRIM(RTRIM(Valor)) FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'IVA Articulo'
SELECT @CampoImpuesto2 = LTRIM(RTRIM(Valor)) FROM AspelCfgOpcion WITH (NOLOCK)  WHERE Descripcion = 'IEPS Articulo'
SELECT @CampoImpuesto3 = LTRIM(RTRIM(Valor)) FROM AspelCfgOpcion WITH (NOLOCK)  WHERE Descripcion = 'Impuesto 3 Articulo'
SET @CampoImpuesto3 = CASE @CampoImpuesto3
WHEN 'IMPU2+IMPU3' THEN 'PART.TOTIMP2+PART.TOTIMP3'
WHEN 'IMPU1+IMPU2' THEN 'PART.TOTIMP1+PART.TOTIMP2'
WHEN 'IMPU3+IMPU4' THEN 'PART.TOTIMP3+PART.TOTIMP4'
WHEN 'IMPU3+IMPU2' THEN 'PART.TOTIMP3+PART.TOTIMP2'
END
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN 'INSERT #VTAS (MovID, TipoCambio,Cliente,Agente,Almacen,Fecha,Articulo,Cantidad,Precio,Impuesto1,Impuesto2,Impuesto3,Descuento1,DEBE,HABER, Mov, Moneda, DescGlobal, Costo, Estatus, clienteorig, agenteorig) '
ELSE 'INSERT #VTAS  (TipoCambio,Cliente,Agente,Almacen,Fecha,Articulo,Cantidad,Precio,Impuesto1,Impuesto2,Impuesto3,Descuento1,DEBE,HABER, Mov, Moneda, DescGlobal, Costo) ' END
+ 'SELECT  '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'MovID = dbo.fnAspelJustificadocto(LTRIM(RTRIM(FACT.CVE_DOC))), ' ELSE '' END
+ 'TipoCambio	=	ROUND(FACT.TIPCAMB,5), '
+ 'Cliente		=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(FACT.CVE_CLPV))),  '
+ 'Agente		=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(FACT.CVE_VEND))),  '
+ 'Almacen		=	FACT.NUM_ALMA, '
+ 'Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'FACT.FECHA_DOC, ' ELSE @CadenaAgrupacion END
+ 'Articulo		=   PART.CVE_ART, '
+ 'Cantidad		=	SUM(CANT), '
+ 'Precio		=	PREC / PART.TIP_CAM, '
+ 'Impuesto1	= ' + @CampoImpuesto1 + ', '
+ 'Impuesto2	= ' + @CampoImpuesto2 + ', '
+ 'Impuesto3	= ' + @CampoImpuesto3 + ', '	
+ 'Descuento1	= dbo.fn_AspelDescuentoEnCascada(PART.DESC1, PART.DESC2, PART.DESC3), '
+ 'DEBE			=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'D' + CHAR(39) + ' THEN (SUM((PART.PREC-(PART.PREC*(PART.DESC1/100)))*PART.CANT)) / PART.TIP_CAM ELSE 0 END, '
+ 'HABER		=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'F' + CHAR(39) + ' THEN (SUM((PART.PREC-(PART.PREC*(PART.DESC1/100)))*PART.CANT)) / PART.TIP_CAM ELSE 0 END, '
+ 'Mov			=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'D' + CHAR(39) + ' THEN ' + CHAR(39) + @MovDebe + CHAR(39) + ' ELSE ' + CHAR(39) + @MovHaber + CHAR(39) + ' END, '
+ 'Moneda		=	LEFT(MONED.DESCR,10), '
+ 'DescGlobal = CASE WHEN FACT.DES_FIN <> 0 THEN (FACT.DES_FIN * 100 / FACT.CAN_TOT) ELSE 0 END,  '	
+ 'Costo		=	PART.COST, '
+ 'Estatus		= FACT.STATUS, '
+ 'CLIENTEORIG  = LTRIM(RTRIM(FACT.CVE_CLPV)), '
+ 'AGENTEORIG   = LTRIM(RTRIM(FACT.CVE_VEND)) '
+ 'FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.FACT01 FACT  ' 
+ 'LEFT JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.CLIE01 CLIE ON CLIE.CCLIE = FACT.CVE_CLPV ' 
+ 'INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.FA0TY1 PART ON FACT.CVE_DOC = PART.CVE_DOC AND FACT.TIP_DOC = PART.TIP_DOC AND PART.TIPO_PROD <> ' + char(39) + 'K' + char(39) + ' ' 
+ 'INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.MONED01 MONED ON FACT.NUM_MONED = MONED.NUM_MONED ' 
+ 'WHERE FACT.TIP_DOC IN (' + CHAR(39) + 'F' + CHAR(39) + ',' + CHAR(39) + 'D' + CHAR(39) + ') ' 
+ 'AND PART.TIPO_PRODT IN (' + CHAR(39) + 'I' + CHAR(39) + ',' + CHAR(39) + ' ' + CHAR(39) + ')'
+ 'GROUP BY FACT.CVE_CLPV, FACT.NUM_ALMA, ' + @CadenaAgrupacion + ' PART.CVE_ART, PREC, DESC1, DESC2, DESC3, ' + @CampoImpuesto1 + ',' + @CampoImpuesto2 + ',' + @CampoImpuesto3 + ', TIPCAMB, PART.TIP_CAM, FACT.NUM_MONED, FACT.TIP_DOC, FACT.CVE_VEND, MONED.DESCR, FACT.DES_FIN, FACT.CAN_TOT, FACT.STATUS,TOTIMP3,PART.COST,FACT.STATUS ' 
EXEC Sp_ExecuteSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de ventas',16,1)
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN 'INSERT #VTAS (MovID, TipoCambio,Cliente,Agente,Almacen,Fecha,Articulo,Cantidad,Precio,Impuesto1,Impuesto3,Descuento1,DEBE,HABER, Mov, Moneda, DescGlobal, Costo, Estatus, clienteorig, agenteorig) '
ELSE 'INSERT #VTAS (TipoCambio,Cliente,Agente,Almacen,Fecha,Articulo,Cantidad,Precio,Impuesto1,Impuesto3,Descuento1,DEBE,HABER, Mov, Moneda, DescGlobal) ' END
+ 'SELECT  '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'MovID = dbo.fnAspelJustificadocto(LTRIM(RTRIM(FACT.CVE_DOC))), ' ELSE '' END
+ 'TipoCambio	=	ROUND(FACT.TIPCAMB,5), '
+ 'Cliente		=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(FACT.CVE_CLPV))),  '
+ 'Agente		=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(FACT.CVE_VEND))),  '
+ 'Almacen		=	FACT.NUM_ALMA, '
+ 'Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'FACT.FECHA_DOC, ' ELSE @CadenaAgrupacion END
+ 'Articulo		= ' + char(39) + 'FLETE' + char(39) + ', '
+ 'Cantidad		=	1, '
+ 'Precio		=	FACT.COSTOFLET / FACT.TIPCAMB, '
+ 'Impuesto1	=	FACT.IMPUEFLET, '
+ 'Impuesto3	=	-(FACT.COSTOFLET*(FACT.RETENFLET/100)), '
+ 'Descuento1	=	0, '
+ 'DEBE		=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'D' + CHAR(39) + ' THEN SUM(FACT.COSTOFLET*1) ELSE 0 END, '
+ 'HABER		=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'F' + CHAR(39) + ' THEN SUM(FACT.COSTOFLET*1) ELSE 0 END, '
+ 'Mov			=	CASE WHEN FACT.TIP_DOC = ' + CHAR(39) + 'D' + CHAR(39) + ' THEN ' + CHAR(39) + @MovDebe + CHAR(39) + ' ELSE ' + CHAR(39) + @MovHaber + CHAR(39) + ' END, '
+ 'Moneda		=	LEFT(MONED.DESCR,10), '
+ 'DescGlobal = CASE WHEN FACT.DES_FIN <> 0 THEN (FACT.DES_FIN * 100 / FACT.CAN_TOT) ELSE 0 END,  '
+ 'Costo		=	0, '
+ 'Estatus		= FACT.STATUS, '
+ 'CLIENTEORIG  = LTRIM(RTRIM(FACT.CVE_CLPV)), '
+ 'AGENTEORIG   = LTRIM(RTRIM(FACT.CVE_VEND)) '
+ 'FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.FACT01 FACT  ' 
+ 'LEFT JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.CLIE01 CLIE ON CLIE.CCLIE = FACT.CVE_CLPV ' 
+ 'INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.MONED01 MONED ON FACT.NUM_MONED = MONED.NUM_MONED ' 
+ 'WHERE FACT.TIP_DOC IN (' + CHAR(39) + 'F' + CHAR(39) + ',' + CHAR(39) + 'D' + CHAR(39) + ') AND FACT.COSTOFLET <> 0 '
+ 'GROUP BY FACT.CVE_CLPV, FACT.NUM_ALMA, ' + @CadenaAgrupacion + ' FACT.COSTOFLET, FACT.IMPUEFLET, FACT.RETENFLET, FACT.TIPCAMB, FACT.NUM_MONED, FACT.TIP_DOC, FACT.CVE_VEND, MONED.DESCR, FACT.DES_FIN, FACT.CAN_TOT, FACT.STATUS'
EXEC Sp_ExecuteSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de ventas (FLETES)',16,1)
SET @Sql =  ''
+ ' INSERT '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg(GID, CargaGID, Modulo, Mayor,Empresa,Sucursal,Moneda, Mov, Estatus, TipoCambio, Cliente, Agente, Almacen, FechaEmision, Articulo, Cantidad, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1, Debe, Haber,MovID, Gastos, costo, proveedor, personal) '
+ ' SELECT '
+ '  GID			=	NewId() '
+ ' ,CargaGID		=	@GID '
+ ' ,Modulo		=	@Modulo '
+ ' ,Mayor		=	@Cuenta '
+	' ,Empresa		=	@ConfE '
+	' ,Sucursal 	=	@ConfS '
+ ' ,Moneda		=	Moneda '
+ ' ,Mov			=	Mov '
+ ' ,Estatus		=	CASE WHEN Estatus = ' + CHAR(39) +'C' + CHAR(39) + 'THEN ' + CHAR(39) + 'CANCELADO' + CHAR(39) + ' ELSE '+ CHAR(39) + @Estatus + char(39) + ' END  '
+ ' ,TipoCambio	=	TipoCambio '
+ ' ,Cliente		=	Cliente '
+ ' ,Agente		=	Agente '
+ ' ,Almacen		=	Almacen '
+ ' ,Fecha		=	Fecha '
+ ' ,Articulo		=	Articulo '
+ ' ,Cantidad		=	Cantidad '
+ ' ,Precio		=	Precio '
+ ' ,Impuesto1	=	Impuesto1 '
+ ' ,Impuesto2	=	Impuesto2 '
+ ' ,Impuesto3	=	Impuesto3 '
+ ' ,Descuento1	=	Descuento1 '
+ ' ,Debe			=	sum(Debe) '
+ ' ,Haber		=	sum(Haber) '
+ ' ,MovID		=	MovID '
+ ' ,DescGlobal '
+ ' ,Costo '
+ ' ,Clienteorig '
+ ' ,Agenteorig  '
+ ' FROM #VTAS '
+ ' GROUP BY Mayor, Empresa, Sucursal, Moneda, Mov, MovID, TipoCambio, Cliente, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1, Agente, DescGlobal, Costo, Estatus, Clienteorig, Agenteorig '
EXEC sp_ExecuteSql @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @ConfS int, @Moneda varchar(30), @Estatus varchar(15)',
@GID = @GID,
@Modulo = @Modulo,
@Cuenta = @Cuenta,
@ConfE = @ConfE,
@ConfS = @ConfS,
@Moneda = @Moneda,
@Estatus = @Estatus
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla  permanente de ventas',16,1)
Update ASPELCARGAREG
SET MOVID = ltrim(rtrim(MOVID)) + 'min'
WHERE MODULO = 'VTAS' AND  ascii(left(RTRIM(LTRIM(MOVID)),1)) between 97 and 122
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Compras' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #Coms
(
Mayor		varchar(30) NULL,
Empresa		varchar(30) NULL,
Sucursal	int			NULL,
Moneda		varchar(30) NULL,
TipoCambio	float(15)	NULL,
Proveedor	varchar(30) NULL,
Almacen		varchar(30)	NULL,
Fecha		datetime	NULL,
Articulo	varchar(30)	NULL,
Cantidad	float(15)	NULL,
Precio		float(15)	NULL,
Impuesto1	float(15)	NULL,
Impuesto2	float(15)	NULL,
Impuesto3	float(15)	NULL,
Descuento1  float(15)	NULL,
DEBE		float(15)	NULL,
HABER		float(15)	NULL,
Mov			varchar(20) NULL,
MovID		varchar(20)	NULL,
Factura		varchar(30)	NULL,
DescGlobal	float(15)	NULL,
Provorig	varchar(30)	NULL
)
SELECT @CadenaAgrupacion = CASE @Agrupador
WHEN 'Movimiento' THEN 'COM.FECHA_DOC, COM.CVE_DOC, '
WHEN 'Dia'		THEN 'COM.FECHA_DOC, '
WHEN 'Semana'		THEN 'DATEADD(DD, - DATEPART(DW,COM.FECHA_DOC),DATEADD(WW,1,COM.FECHA_DOC)), '
WHEN 'Mes'		THEN 'DATEADD(DD, - DAY(COM.FECHA_DOC),DATEADD(MM,1,COM.FECHA_DOC)), '
WHEN 'A�o'		THEN 'DATEADD(DD, - DATEPART(DY,COM.FECHA_DOC),DATEADD(YY,1,COM.FECHA_DOC)), '
ELSE 'COM.FECHA_DOC, '
END
SELECT @CampoImpuesto1 = ltrim(rtrim(Valor)) FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'IVA Articulo'
SELECT @CampoImpuesto2 = ltrim(rtrim(Valor)) FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'IEPS Articulo'
SELECT @CampoImpuesto3 = ltrim(rtrim(Valor)) FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'Impuesto 3 Articulo'
SET @CampoImpuesto3 = CASE @CampoImpuesto3
WHEN 'IMPU2+IMPU3' THEN 'PART.TOTIMP2+PART.TOTIMP3'
WHEN 'IMPU1+IMPU2' THEN 'PART.TOTIMP1+PART.TOTIMP2'
WHEN 'IMPU3+IMPU4' THEN 'PART.TOTIMP3+PART.TOTIMP4'
END
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN '	INSERT #Coms (MovID, TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1, DEBE, HABER, Mov, Moneda, Factura,DescGlobal,Provorig) '
ELSE '	INSERT #Coms (TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1, DEBE, HABER, Mov, Moneda, Factura) ' END
+ '	SELECT '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'MovID = dbo.fnAspelJustificadocto(LTRIM(RTRIM(COM.CVE_DOC))), ' ELSE '' END
+ '	  TipoCambio	=	ROUND(COM.TIPCAMB,5), '
+ '	  Proveedor	=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(COM.CVE_CLPV))), '
+ '	  Almacen		=	COM.NUM_ALMA, '
+ '	  Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'COM.FECHA_DOC, ' ELSE @CadenaAgrupacion END
+ '	  Articulo	=   PART.CVE_ART, '
+ '	  Cantidad	=	SUM(CANT), '
+ '	  Precio	=	COST/COM.TIPCAMB , '
+ '	  Impuesto1	= ' + @CampoImpuesto1 +', '
+ '	  Impuesto2	= ' + @CampoImpuesto2 +', '
+ '	  Impuesto3	= ' + @CampoImpuesto3 +', '
+ '	  Descuento1  =	DESCU, '
+ '	  DEBE		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN SUM((PART.COST * PART.CANT)-((PART.COST * PART.CANT)*(PART.DESCU/100))) ELSE 0 END, ' 
+ '	  HABER		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'd' + CHAR(39) + ' THEN SUM((PART.COST * PART.CANT)-((PART.COST * PART.CANT)*(PART.DESCU/100))) ELSE 0 END, '  
+ '   Mov		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN ' + CHAR(39) + @MovDebe + CHAR(39) + ' ELSE ' + CHAR(39) + @MovHaber + CHAR(39) + ' END, '
+ '	  Moneda		=	LEFT(MONED.DESCR,10), '
+ '   Factura      = COM.SU_REFER, '
+ '   DescGlobal = CASE WHEN COM.DES_FIN <> 0 THEN (COM.DES_FIN * 100 / COM.CAN_TOT) ELSE 0 END,  '
+ '	  PROVORIG  = LTRIM(RTRIM(COM.CVE_CLPV)) '
+ '   FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.COMP01 COM '
+ '	  LEFT JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.PROV01 PROV ON COM.CVE_CLPV = PROV.CPROV '
+ '	  INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.COM0Y1 PART ON COM.CVE_DOC = PART.CVE_DOC AND COM.TIP_DOC = PART.TIP_DOC '
+ '   INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.MONED01 MONED ON COM.NUM_MONED = MONED.NUM_MONED ' 
+ '	 WHERE COM.TIP_DOC IN (' + CHAR(39) + 'C' + CHAR(39) + ',' + CHAR(39) + 'd' + CHAR(39) + ') AND PART.TIPO_PRODT IN (' + CHAR(39) + 'I' + CHAR(39) + ',' + CHAR(39) + ' ' + CHAR(39) + ')'
+ '  AND COM.STATUS <> ' + CHAR(39) + 'C' + CHAR(39) + ' '
+ '	 GROUP BY COM.CVE_CLPV, COM.NUM_ALMA, ' + @CadenaAgrupacion + ' PART.CVE_ART, CANT, COST, ' + @CampoImpuesto1 + ',' + @CampoImpuesto2 + ',' + @CampoImpuesto3 + ', DESCU, TIPCAMB, COM.NUM_MONED,COM.TIP_DOC, MONED.DESCR, COM.SU_REFER,COM.DES_FIN,COM.CAN_TOT,TOTIMP3' 
EXEC sp_executeSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de compras',16,1)
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN '	INSERT #Coms (MovID, TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto3, Descuento1, DEBE, HABER, Mov, Moneda, Factura,DescGlobal,Provorig) '
ELSE '	INSERT #Coms (TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto3, Descuento1, DEBE, HABER, Mov, Moneda, Factura) ' END
+ '	SELECT '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'MovID = dbo.fnAspelJustificadocto(LTRIM(RTRIM(COM.CVE_DOC))), ' ELSE '' END
+ '	  TipoCambio	=	COM.TIPCAMB, '
+ '	  Proveedor	=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(COM.CVE_CLPV))), '
+ '	  Almacen		=	COM.NUM_ALMA, '
+ '	  Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'COM.FECHA_DOC, ' ELSE @CadenaAgrupacion END
+ '	  Articulo	= ' + char(39) + 'FLETE' + char(39) + ', '
+ '	  Cantidad	=	1, '
+ '	  Precio		=	COM.COSTOFLET/COM.TIPCAMB , '
+ '	  Impuesto1	=   COM.IMPUEFLET, '
+ '   Impuesto3	=	-(COM.COSTOFLET*(COM.RETENFLET/100)), '
+ '	  Descuento1  =	0, '
+ '   DEBE		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN SUM(COM.COSTOFLET*1) ELSE 0 END, '
+ '   HABER		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'd' + CHAR(39) + ' THEN SUM(COM.COSTOFLET*1) ELSE 0 END, '
+ '   Mov		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN ' + CHAR(39) + @MovDebe + CHAR(39) + ' ELSE ' + CHAR(39) + @MovHaber + CHAR(39) + ' END, '
+ '	  Moneda		=	LEFT(MONED.DESCR,10), '
+ '   Factura      = COM.SU_REFER, '
+ '   DescGlobal = CASE WHEN COM.DES_FIN <> 0 THEN (COM.DES_FIN * 100 / COM.CAN_TOT) ELSE 0 END,  '
+ '	  PROVORIG  = LTRIM(RTRIM(COM.CVE_CLPV)) '
+ '  FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.COMP01 COM '
+ '	 LEFT JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.PROV01 PROV ON  COM.CVE_CLPV = PROV.CPROV'
+ '  INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.MONED01 MONED ON COM.NUM_MONED = MONED.NUM_MONED ' 
+ '	 WHERE COM.TIP_DOC IN (' + CHAR(39) + 'C' + CHAR(39) + ',' + CHAR(39) + 'd' + CHAR(39) + ') AND COM.COSTOFLET <> 0 ' 
+ 'AND COM.STATUS <> ' + CHAR(39) + 'C' + CHAR(39) + ' ' 
+ '	 GROUP BY COM.CVE_CLPV, COM.NUM_ALMA, ' + @CadenaAgrupacion + ' COM.COSTOFLET, COM.IMPUEFLET, COM.RETENFLET, TIPCAMB, COM.NUM_MONED, COM.TIP_DOC, MONED.DESCR, COM.SU_REFER,COM.DES_FIN,COM.CAN_TOT '
EXEC Sp_ExecuteSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de compras (FLETES)',16,1)
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN 'INSERT #Coms (MovID, TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Descuento1, DEBE, HABER, Mov, Moneda, Factura,DescGlobal,Provorig) '
ELSE '	INSERT #Coms (TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Descuento1, DEBE, HABER, Mov, Moneda, Factura) ' END
+ '	SELECT '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'MovID = dbo.fnAspelJustificadocto(LTRIM(RTRIM(COM.CVE_DOC))), ' ELSE '' END
+ '	  TipoCambio	=	COM.TIPCAMB, '
+ '	  Proveedor	=	dbo.fnAspelJustificaClave(LTRIM(RTRIM(COM.CVE_CLPV))), '
+ '	  Almacen		=	COM.NUM_ALMA, '
+ '	  Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'COM.FECHA_DOC, ' ELSE @CadenaAgrupacion END
+ '	  Articulo	= ' + char(39) + 'INDIRECTOS' + char(39) + ', '
+ '	  Cantidad	=	1, '
+ '	  Precio	=	COM.TOT_IND, '
+ '	  Impuesto1	=   0, '
+ '	  Descuento1  =	0, '
+ '	  DEBE		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN SUM((COM.COSTOFLET-(COM.COSTOFLET*(COM.RETENFLET/100))+(COM.COSTOFLET*(COM.IMPUEFLET/100)))/(1+(COM.IMPUEFLET/100)) * 1) ELSE 0 END, '
+ '	  HABER		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'd' + CHAR(39) + ' THEN SUM((COM.COSTOFLET-(COM.COSTOFLET*(COM.RETENFLET/100))+(COM.COSTOFLET*(COM.IMPUEFLET/100)))/(1+(COM.IMPUEFLET/100)) * 1) ELSE 0 END, '
+ '   Mov		=	CASE WHEN COM.TIP_DOC = ' + CHAR(39) + 'C' + CHAR(39) + ' THEN ' + CHAR(39) + @MovDebe + CHAR(39) + ' ELSE ' + CHAR(39) + @MovHaber + CHAR(39) + ' END, '
+ '	  Moneda		=	LEFT(MONED.DESCR,10), '
+ '   Factura      = COM.SU_REFER, '
+ '   DescGlobal = CASE WHEN COM.DES_FIN <> 0 THEN (COM.DES_FIN * 100 / COM.CAN_TOT) ELSE 0 END,  '
+ '	  PROVORIG  = LTRIM(RTRIM(COM.CVE_CLPV)) '
+ '  FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.COMP01 COM '
+ '	 LEFT JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.PROV01 PROV ON  COM.CVE_CLPV = PROV.CPROV'
+ '  INNER JOIN '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.MONED01 MONED ON COM.NUM_MONED = MONED.NUM_MONED ' 
+ '	 WHERE COM.TIP_DOC IN (' + CHAR(39) + 'C' + CHAR(39) + ',' + CHAR(39) + 'd' + CHAR(39) + ') AND COM.TOT_IND <> 0 ' 
+ '	 GROUP BY COM.CVE_CLPV, COM.NUM_ALMA, ' + @CadenaAgrupacion + ' COM.TOT_IND, TIPCAMB, COM.NUM_MONED, COM.TIP_DOC, MONED.DESCR, COM.SU_REFER,COM.DES_FIN,COM.CAN_TOT '
EXEC Sp_ExecuteSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de compras (INDIRECTOS)',16,1)
SET @Sql =  ''
+ ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg(gid,cargagid,Modulo, Mayor,Empresa,Sucursal,
Moneda, Mov, Estatus, TipoCambio,Proveedor,Almacen,FechaEmision,Articulo,Cantidad,Costo,Impuesto1,Impuesto2,Impuesto3,
Descuento1,Debe,Haber,MovID, Referencia,Gastos,Cliente) '
+ ' SELECT '
+ '    GID			=	NewId() '
+ '   ,CargaGID		=	@GID '
+ '   ,Modulo		=	@Modulo '
+ '   ,Mayor		=	@Cuenta '
+ '   ,Empresa		=	@ConfE '
+ '   ,Sucursal 	=	@ConfS '
+ '   ,Moneda		=	Moneda  '
+ ' ,Mov			=	Mov '
+ ' ,Estatus		=	@Estatus '
+ '   ,TipoCambio	=	TipoCambio '
+ '   ,Proveredor	=	Proveedor '
+ '   ,Almacen		=	Almacen '
+ '   ,Fecha		=	Fecha '
+ '   ,Articulo		=	Articulo '
+ '   ,Cantidad		=	sum(Cantidad) '
+ '   ,Costo		=	Precio '
+ '   ,Impuesto1	=	Impuesto1 '
+ '   ,Impuesto2	=	Impuesto2 '
+ '   ,Impuesto3	=	Impuesto3 '
+ '   ,Descuento1	=	Descuento1 '
+ '   ,Debe			=	sum(Debe) '
+ '   ,Haber		=	sum(Haber) '
+ '   ,MovID		=	MovID '
+ '   ,Referencia             = Factura '
+ ' ,DescGlobal '
+ ' ,Provorig '
+ '  FROM #COMS '
+ ' GROUP BY Mayor, Empresa, Sucursal, Moneda, Mov, MovID, TipoCambio, Proveedor, Almacen, Fecha, Articulo, Cantidad, Precio, Impuesto1, Impuesto2, Impuesto3, Descuento1, Factura,DescGlobal,Provorig '
EXEC sp_ExecuteSql @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @ConfS varchar(30), @Moneda varchar(30), @Estatus varchar(15)',
@GID = @GID,
@Modulo = @Modulo,
@Cuenta = @Cuenta,
@ConfE = @ConfE,
@ConfS = @ConfS,
@Moneda = @Moneda,
@Estatus = @Estatus
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla permanente de compras',16,1)
Update ASPELCARGAREG
SET MOVID = ltrim(rtrim(MOVID)) + 'min'
WHERE MODULO = 'COMS' AND  ascii(left(RTRIM(LTRIM(MOVID)),1)) between 97 and 122
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Inventarios' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #Inv
(	Almacen		varchar(30),
CveArt		varchar(30),
Cantidad	float(15),
Costo		float(15),
CostoTotal	float(15),
Tipo		varchar(1)
)
SET @Sql = ''
+ 'INSERT INTO #Inv (Almacen, CveArt, Cantidad, Costo, Costototal, Tipo) '
+ 'SELECT DISTINCT COST.ALMACEN, INV.CLV_ART, COST.EXIST, INV.COSTO_PROM, (COST.EXIST * INV.COSTO_PROM), INV.TIP_COSTEO '
+ 'FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.INVE01 AS INV '
+ 'INNER JOIN '+ @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.MULT01 AS COST ON INV.CLV_ART = COST.CLV_ART '
+ 'WHERE INV.TIP_COSTEO = ' + CHAR(39) + 'P' + CHAR(39) + ' AND COST.EXIST > 0 '
+ 'ORDER BY INV.CLV_ART '
EXEC sp_executeSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de entradas de inventario1',16,1)
SET @Sql = ''
+ 'INSERT INTO #Inv (Almacen, CveArt, Cantidad, Costo, Costototal, Tipo) '
+ 'SELECT TOP (100) PERCENT COST.ALMACEN, INV.CLV_ART, COST.CANT_COST, COST.COSTO, COST.CANT_COST * COST.COSTO, '
+ 'INV.TIP_COSTEO '
+ 'FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.INVE01 AS INV '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.MINV01 AS COST ON INV.CLV_ART = COST.CLV_ART '
+ 'WHERE INV.TIP_COSTEO <> ' + CHAR(39) + 'P' + CHAR(39)
+ 'AND COST.CANT_COST > 0 '
+ 'ORDER BY INV.CLV_ART '
EXEC sp_executeSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de entradas de inventario1',16,1)
SET @Sql = ''
+ 'INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg (GID, CargaGID, Modulo, Mayor, Empresa, Sucursal, Almacen, Moneda, Mov, Estatus, Articulo, Cantidad, Debe, Costo) '
+ 'SELECT '
+ 'GID			=	NewId() '
+ ',CargaGID	=	@GID '
+ ',Modulo		=	@Modulo '
+ ',Mayor		=	@Cuenta '
+ ',Empresa		=	@ConfE '
+ ',Sucursal	=	@ConfS '
+ ',Almacen		=	Almacen '
+ ',Moneda		=	@Moneda '
+ ',Mov 		=	@MovDebe '
+ ',Estatus		=	@Estatus '
+ ',Articulo	=	CveArt'
+ ',Cantidad	=	Cantidad '
+ ',Debe		=	CostoTotal '
+ ',Costo		=	Costo '
+ 'FROM		#Inv '
EXECUTE sp_executesql @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @ConfS int, @Moneda varchar(30), @MovDebe varchar(20), @Estatus varchar(15)',
@GID = @GID,
@Modulo = @Modulo,
@Cuenta = @Cuenta,
@ConfE = @ConfE,
@ConfS = @ConfS,
@Moneda = @Moneda,
@MovDebe = @MovDebe,
@Estatus = @Estatus
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla permanente de inventario',16,1)
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Clientes' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #CXC
(
CCLIE		varchar(5)	NOT NULL,
REFER		VARCHAR(9)	NOT NULL,
TIPO		VARCHAR(1)	NOT NULL,
IMPORTEMN	FLOAT		NOT NULL,
IMPORTEME	FLOAT		NOT NULL,
FECHA_APLI	DATETIME	NULL,
FECHA_VENC	DATETIME	NULL,
DESCR	VARCHAR (30)	NULL,
TIPO_MOV VARCHAR(2)		NULL,
NUM_MONED VARCHAR(2)	NULL,
DESCRMON VARCHAR(20)	NULL,
MONTONATIVO FLOAT		NULL,
NO_FACTURA VARCHAR(7)	NULL,
DOCTO VARCHAR (9)		NULL,
MOV VARCHAR(20)			NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(1) NULL,
IVAFISCAL FLOAT NULL,
IEPSFISCAL FLOAT NULL,
IMPUESTOS FLOAT	NULL
)
SET @Sql = ''
+ 'INSERT #CXC '
+ 'SELECT ltrim(rtrim(A.CCLIE)),ltrim(rtrim(A.REFER)), TIPO, CASE WHEN B.TIPO = ' + char(39) + 'C' + char(39)+ ' THEN SUM(IMPORTE) '
+ 'ELSE -SUM(IMPORTE) END AS IMPORTEMN,CASE WHEN B.TIPO = ' + char(39)+ 'C' + char(39)+ ' THEN SUM(IMPMON_EXT) '
+ 'ELSE -SUM(IMPMON_EXT) END AS IMPORTEME,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL '
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CUEN01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONC01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'GROUP BY CCLIE,REFER,TIPO '
+ 'HAVING ABS((SUM(IMPORTE)) + ABS(SUM(IMPMON_EXT))) >0 '
EXEC sp_executesql @Sql
SELECT '#CXCSALDOS', * FROM #CXC
CREATE TABLE #CXCFECHAS
(
NUM_REG		int NOT NULL,
CCLIE		VARCHAR(5) NULL,
FECHA_APLI	DATETIME  NULL,
FECHA_VENC	DATETIME  NULL,
DESCR	VARCHAR (30) NULL,
REFER		VARCHAR(9) NOT NULL,
TIPO_MOV VARCHAR(2) NULL,
NUM_MONED VARCHAR(2) NULL,
NO_FACTURA VARCHAR(7) NULL,
DOCTO VARCHAR (9) NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(19) NULL
)
SET @Sql = ''
+ 'INSERT #CXCFECHAS '
+ 'SELECT  DISTINCT A.NUM_REG, ltrim(rtrim(CCLIE)),FECHA_APLI,FECHA_VENC,DESCR, ltrim(rtrim(REFER)),TIPO_MOV,NUM_MONED,NO_FACTURA, DOCTO,TCAMBIO, CCONREFER ' 
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CUEN01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONC01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'WHERE A.CCONREFER = ' + CHAR(39) + 'N' + CHAR(39)
+ ' ORDER BY A.NUM_REG ASC '
EXEC sp_executesql @Sql
UPDATE #CXC  SET TIPO_MOV = #CXCFECHAS.TIPO_MOV FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET FECHA_APLI = #CXCFECHAS.FECHA_APLI FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET FECHA_VENC = #CXCFECHAS.FECHA_VENC FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET DESCR = #CXCFECHAS.DESCR FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET NUM_MONED = #CXCFECHAS.NUM_MONED FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET NO_FACTURA = #CXCFECHAS.NO_FACTURA FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET DOCTO = #CXCFECHAS.DOCTO FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET TCAMBIO = #CXCFECHAS.TCAMBIO FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
UPDATE #CXC  SET CCONREFER = #CXCFECHAS.CCONREFER FROM #CXCFECHAS
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS.CCLIE))
CREATE TABLE #CXCFECHAS2
(
NUM_REG		int NOT NULL,
CCLIE		VARCHAR(5) NULL,
FECHA_APLI	DATETIME  NULL,
FECHA_VENC	DATETIME  NULL,
DESCR	VARCHAR (30) NULL,
REFER		VARCHAR(9) NOT NULL,
TIPO_MOV VARCHAR(2) NULL,
NUM_MONED VARCHAR(2) NULL,
NO_FACTURA VARCHAR(7) NULL,
DOCTO VARCHAR (9) NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(19) NULL
)
SET @Sql = ''
+ 'INSERT #CXCFECHAS2 '
+ 'SELECT  DISTINCT A.NUM_REG, ltrim(rtrim(CCLIE)),FECHA_APLI,FECHA_VENC,DESCR, ltrim(rtrim(REFER)),TIPO_MOV,NUM_MONED,NO_FACTURA, DOCTO,TCAMBIO, CCONREFER ' 
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CUEN01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONC01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'WHERE A.CCONREFER = ' + CHAR(39) + 'S' + CHAR(39)
+ ' ORDER BY A.NUM_REG ASC '
EXEC sp_executesql @Sql
UPDATE #CXC  SET TIPO_MOV = #CXCFECHAS2.TIPO_MOV FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET FECHA_VENC = #CXCFECHAS2.FECHA_VENC FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET DESCR = #CXCFECHAS2.DESCR FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET NUM_MONED = #CXCFECHAS2.NUM_MONED FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET NO_FACTURA = #CXCFECHAS2.NO_FACTURA FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET DOCTO = #CXCFECHAS2.DOCTO FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET TCAMBIO = #CXCFECHAS2.TCAMBIO FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET CCONREFER = #CXCFECHAS2.CCONREFER FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
UPDATE #CXC  SET FECHA_APLI = #CXCFECHAS2.FECHA_APLI FROM #CXCFECHAS2
WHERE ltrim(rtrim(#CXC.REFER)) = ltrim(rtrim(#CXCFECHAS2.REFER)) AND ltrim(rtrim(#CXC.CCLIE)) = ltrim(rtrim(#CXCFECHAS2.CCLIE)) AND #CXC.FECHA_APLI IS NULL
SET @Sql = ''
+ 'UPDATE #CXC  SET DESCRMON  = A.DESCR FROM '  + @ServidorOrigen + '.' + @BaseDatosOrigen +'.' + 'dbo.MONED01  A '
+ 'WHERE CONVERT(BINARY(2),#CXC.NUM_MONED) = CONVERT(BINARY(2),A.NUM_MONED)'
EXEC sp_executesql @Sql
UPDATE #CXC  SET MONTONATIVO  = CASE WHEN  NUM_MONED = '1' THEN IMPORTEMN ELSE IMPORTEME END
CREATE TABLE #FACIMPUESTOS
(
CVE_DOC			VARCHAR(7) NOT NULL,
TIP_DOC			VARCHAR(5) NULL,
IMPUESTO1		FLOAT  NULL,
IMPUESTO2		FLOAT,
TOTALIMPUESTOS	FLOAT
)
SET @Sql = ''
+ 'INSERT #FACIMPUESTOS '
+ ' SELECT CVE_DOC, TIP_DOC, (IMP_TOT1)/(CAN_TOT-DES_TOT-DES_FIN+IMP_TOT1+IMP_TOT4+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100)+COSTOFLET), '
+ ' ((IMP_TOT4)+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100))/(CAN_TOT-DES_TOT-DES_FIN+IMP_TOT1+IMP_TOT4+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100)+COSTOFLET), (IMP_TOT4+IMP_TOT1+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100))/TIPCAMB '
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.FACT01 '
+ ' WHERE TIP_DOC =  ' + CHAR(39) + 'F' + CHAR(39) + ' AND STATUS <> ' + CHAR(39) + 'C' + CHAR(39)
+ 'ORDER BY NUM_REG ASC '
EXEC sp_executesql @Sql
UPDATE #CXC  SET IEPSFISCAL = IMPUESTO1 FROM #FACIMPUESTOS				
WHERE ltrim(rtrim(#CXC.DOCTO)) = ltrim(rtrim(#FACIMPUESTOS.CVE_DOC))
UPDATE #CXC  SET IVAFISCAL = IMPUESTO2 FROM #FACIMPUESTOS				
WHERE ltrim(rtrim(#CXC.DOCTO)) = ltrim(rtrim(#FACIMPUESTOS.CVE_DOC))
UPDATE #CXC  SET IMPUESTOS = TOTALIMPUESTOS FROM #FACIMPUESTOS			
WHERE ltrim(rtrim(#CXC.DOCTO)) = ltrim(rtrim(#FACIMPUESTOS.CVE_DOC))
UPDATE #CXC  SET IVAFISCAL = 0.1304347826,IEPSFISCAL = 0, IMPUESTOS = NULL 
WHERE IVAFISCAL IS NULL
SET @Sql = ''
+ ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg (GID, CargaGID, Modulo, Mayor, Empresa, Cliente, Moneda, Mov, Estatus, TipoCambio, FechaEmision, Concepto, Referencia, MovID, Vencimiento, cantidad, Debe, Haber, Subcuenta, Serielote, Proveedor, Impuesto1,Impuesto2,Gastos)'
+ ' SELECT '
+ '  GID				=	NewId() '
+ ' ,CargaGID		=	@GID '
+ ' ,Modulo			=	@Modulo '
+ ' ,Mayor			=	@Cuenta '
+ ' ,Empresa			=	@ConfE '
+ ' ,Cliente			=	dbo.fnAspelJustificaClave(RTRIM(LTRIM(CCLIE)))'
+ ' ,Moneda			=	DESCRMON '
+ ' ,Mov				=	CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ' + char(39) + @Movdebe + char(39) + ' ELSE ' + char(39) + @Movhaber + char(39) + ' END '
+ ' ,Estatus			=	@Estatus '
+ ' ,TipoCambio		=	ROUND(TCAMBIO,5) '
+ ' ,FechaEmision	=	FECHA_APLI '
+ ' ,Concepto		=	NO_FACTURA'
+ ' ,Referencia		=	LTRIM(RTRIM(DESCR)) + ' + CHAR(39) + ' ' + CHAR(39) + ' + LTRIM(RTRIM(DOCTO)) +' + CHAR(39) + ' ' + CHAR(39) +' + CASE  WHEN CCONREFER = ' + char(39) + 'S' + char(39) + ' THEN  ' + char(39) + 'POR ACLARAR' + char(39) + ' ELSE ' + char(39) + '' + char(39) + ' END '
+ ' ,MovId			=	LTRIM(RTRIM(CCLIE)) + ' + CHAR(39) + '-' + CHAR(39) + ' + LTRIM(RTRIM(REFER))' 
+ ' ,Vencimiento		=	FECHA_VENC '
+ ' ,Cantidad		=	1 '
+ ' ,DEBE 			=  CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ABS(sum(MONTONATIVO)) ELSE 0 END '
+ ' ,HABER 			=   CASE  WHEN sum(MONTONATIVO) <0' + ' THEN ABS(sum(MONTONATIVO)) ELSE 0 END '
+ ' ,Subcuenta		= TIPO_MOV '
+ ' , SerieLote		= CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ' + char(39) + 'C'+CHAR(39) + ' ELSE ' + CHAR(39) + 'A' + CHAR(39) + ' END '
+ ' ,Proveedor		= RTRIM(LTRIM(CCLIE)) '
+ ' ,Impuesto1		=  IVAFISCAL '	
+ ' ,Impuesto2		=  IEPSFISCAL '	
+ ' ,Gastos			=  IMPUESTOS '	
+ ' FROM #CXC GROUP BY CCLIE,REFER,FECHA_APLI,FECHA_VENC,DESCR,TIPO_MOV,NUM_MONED,DESCRMON,NO_FACTURA,DOCTO,TCAMBIO, CCONREFER,IVAFISCAL,IEPSFISCAL,IMPUESTOS'
+ ' HAVING ABS(SUM(MONTONATIVO)) > 0.01 '
EXEC sp_executeSQL @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @Moneda varchar(30), @Estatus varchar(30)',
@GID     = @GID,
@Modulo  = @Modulo,
@Cuenta  = @Cuenta,
@ConfE	  = @ConfE,
@Moneda  = @Moneda,
@Estatus = @Estatus
DECLARE @Descrip varchar(30)
IF @@ERROR <> 0
BEGIN
RAISERROR('Falla al insertar en la tabla permanente de CXC',16,1)
END
ELSE
BEGIN
SELECT @Descrip = MovimientoIntelisisCxC
FROM AspelCfgConceptos WITH (NOLOCK) 
WHERE Tipo = 'C' And NumConcepto = 'Cualquier otro' And Modulo = 'CxC'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = @Descrip
WHERE Mov = @MovDebe And Modulo = 'CxC'
SELECT @Descrip = MovimientoIntelisisCxC
FROM AspelCfgConceptos WITH (NOLOCK) 
WHERE Tipo = 'A' And NumConcepto = 'Cualquier otro' And Modulo = 'CxC'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = @Descrip
WHERE Mov = @MovHaber And Modulo = 'CxC'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = C.MovimientoIntelisisCxC
FROM AspelCargaReg A, AspelCfgConceptos C WITH (NOLOCK) 
WHERE A.Subcuenta = C.NumConcepto And C.Modulo = 'CxC' AND A.MODULO = 'CXC' AND A.SerieLote = C.TIPO
END
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Proveedores' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #CXP
(
CPROV		varchar(5)	NOT NULL,
REFER		VARCHAR(9)	NOT NULL,
TIPO		VARCHAR(1)	NOT NULL,
IMPORTEMN	FLOAT		NOT NULL,
IMPORTEME	FLOAT		NOT NULL,
FECHA_APLI	DATETIME	NULL,
FECHA_VENC	DATETIME	NULL,
DESCR	VARCHAR (30)	NULL,
TIPO_MOV VARCHAR(2)		NULL,
NUM_MONED VARCHAR(2)	NULL,
DESCRMON VARCHAR(20)	NULL,
MONTONATIVO FLOAT		NULL,
NO_FACTURA VARCHAR(7)	NULL,
DOCTO VARCHAR (9)		NULL,
MOV VARCHAR(20)			NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(1) NULL,
IVAFISCAL FLOAT NULL,
IEPSFISCAL FLOAT NULL,
IMPUESTOS FLOAT	NULL
)
SET @Sql = ''
+ 'INSERT #CXP '
+ 'SELECT ltrim(rtrim(A.CPROV)),ltrim(rtrim(A.REFER)), TIPO, CASE WHEN B.TIPO = ' + char(39) + 'C' + char(39)+ ' THEN SUM(IMPORTE) '
+ 'ELSE -SUM(IMPORTE) END AS IMPORTEMN,CASE WHEN B.TIPO = ' + char(39)+ 'C' + char(39)+ ' THEN SUM(IMPMON_EXT) '
+ 'ELSE -SUM(IMPMON_EXT) END AS IMPORTEME,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL '
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.PAGA01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONP01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'GROUP BY CPROV,REFER,TIPO '
+ 'HAVING ABS((SUM(IMPORTE)) + ABS(SUM(IMPMON_EXT))) >0 '
EXEC sp_executesql @Sql
CREATE TABLE #CXPFECHAS
(
NUM_REG		int NOT NULL,
CPROV		VARCHAR(5) NULL,
FECHA_APLI	DATETIME  NULL,
FECHA_VENC	DATETIME  NULL,
DESCR	VARCHAR (30) NULL,
REFER		VARCHAR(9) NOT NULL,
TIPO_MOV VARCHAR(2) NULL,
NUM_MONED VARCHAR(2) NULL,
NO_FACTURA VARCHAR(7) NULL,
DOCTO VARCHAR (9) NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(1) NULL
)
SET @Sql = ''
+ 'INSERT #CXPFECHAS '
+ 'SELECT  DISTINCT A.NUM_REG, ltrim(rtrim(CPROV)),FECHA_APLI,FECHA_VENC,DESCR, ltrim(rtrim(REFER)),TIPO_MOV,NUM_MONED,NO_FACTURA, DOCTO,TCAMBIO, CCONREFER ' 
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.PAGA01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONP01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'WHERE A.CCONREFER = ' + CHAR(39) + 'N' + CHAR(39)
+ ' ORDER BY A.NUM_REG DESC '
EXEC sp_executesql @Sql
UPDATE #CXP  SET TIPO_MOV = #CXPFECHAS.TIPO_MOV FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET FECHA_APLI = #CXPFECHAS.FECHA_APLI FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET FECHA_VENC = #CXPFECHAS.FECHA_VENC FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET DESCR = #CXPFECHAS.DESCR FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET NUM_MONED = #CXPFECHAS.NUM_MONED FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET NO_FACTURA = #CXPFECHAS.NO_FACTURA FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET DOCTO = #CXPFECHAS.DOCTO FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET TCAMBIO = #CXPFECHAS.TCAMBIO FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
UPDATE #CXP  SET CCONREFER = #CXPFECHAS.CCONREFER FROM #CXPFECHAS
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS.CPROV))
CREATE TABLE #CXPFECHAS2
(
NUM_REG		int NOT NULL,
CPROV		VARCHAR(5) NULL,
FECHA_APLI	DATETIME  NULL,
FECHA_VENC	DATETIME  NULL,
DESCR	VARCHAR (30) NULL,
REFER		VARCHAR(9) NOT NULL,
TIPO_MOV VARCHAR(2) NULL,
NUM_MONED VARCHAR(2) NULL,
NO_FACTURA VARCHAR(7) NULL,
DOCTO VARCHAR (9) NULL,
TCAMBIO float(15)	NULL,
CCONREFER VARCHAR(19) NULL
)
SET @Sql = ''
+ 'INSERT #CXPFECHAS2 '
+ 'SELECT  DISTINCT A.NUM_REG, ltrim(rtrim(CPROV)),FECHA_APLI,FECHA_VENC,DESCR, ltrim(rtrim(REFER)),TIPO_MOV,NUM_MONED,NO_FACTURA, DOCTO,TCAMBIO, CCONREFER ' 
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.PAGA01 A '
+ 'INNER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.CONP01 B ON A.TIPO_MOV = B.NUM_CPTO '
+ 'WHERE A.CCONREFER = ' + CHAR(39) + 'S' + CHAR(39)
+ ' ORDER BY A.NUM_REG ASC '
EXEC sp_executesql @Sql
UPDATE #CXP  SET TIPO_MOV = #CXPFECHAS2.TIPO_MOV FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET FECHA_VENC = #CXPFECHAS2.FECHA_VENC FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET DESCR = #CXPFECHAS2.DESCR FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET NUM_MONED = #CXPFECHAS2.NUM_MONED FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET NO_FACTURA = #CXPFECHAS2.NO_FACTURA FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET DOCTO = #CXPFECHAS2.DOCTO FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET TCAMBIO = #CXPFECHAS2.TCAMBIO FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET CCONREFER = #CXPFECHAS2.CCONREFER FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
UPDATE #CXP  SET FECHA_APLI = #CXPFECHAS2.FECHA_APLI FROM #CXPFECHAS2
WHERE ltrim(rtrim(#CXP.REFER)) = ltrim(rtrim(#CXPFECHAS2.REFER)) AND ltrim(rtrim(#CXP.CPROV)) = ltrim(rtrim(#CXPFECHAS2.CPROV)) AND #CXP.FECHA_APLI IS NULL
SET @Sql = ''
+ 'UPDATE #CXP  SET DESCRMON  = A.DESCR FROM '  + @ServidorOrigen + '.' + @BaseDatosOrigen +'.' + 'dbo.MONED01  A '
+ 'WHERE CONVERT(BINARY(2),#CXP.NUM_MONED) = CONVERT(BINARY(2),A.NUM_MONED)'
EXEC sp_executesql @Sql
UPDATE #CXP  SET MONTONATIVO  = CASE WHEN  NUM_MONED = '1' THEN IMPORTEMN ELSE IMPORTEME END
CREATE TABLE #COMIMPUESTOS
(
CVE_DOC			VARCHAR(7) NOT NULL,
TIP_DOC			VARCHAR(5) NULL,
IMPUESTO1		FLOAT  NULL,
IMPUESTO2		FLOAT,
TOTALIMPUESTOS	FLOAT
)
SET @Sql = ''
+ 'INSERT #COMIMPUESTOS '
+ ' SELECT CVE_DOC, TIP_DOC,(IMP_TOT1)/(CAN_TOT-DES_TOT-DES_FIN+IMP_TOT1+IMP_TOT4+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100)+COSTOFLET) , '
+ ' ((IMP_TOT4)+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0))/100)/(CAN_TOT-DES_TOT-DES_FIN+IMP_TOT1+IMP_TOT4+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100)+COSTOFLET), (IMP_TOT4+IMP_TOT1+(COSTOFLET*ISNULL(IMPUEFLET,0)/100)-(COSTOFLET*ISNULL(RETENFLET,0)/100))/TIPCAMB '
+ ' FROM ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.COMP01 '
+ ' WHERE TIP_DOC =  ' + CHAR(39) + 'C' + CHAR(39) + ' AND STATUS <> ' + CHAR(39) + 'C' + CHAR(39)
+ 'ORDER BY NUM_REG ASC '
EXEC sp_executesql @Sql
UPDATE #CXP  SET IEPSFISCAL = IMPUESTO1 FROM #COMIMPUESTOS				
WHERE ltrim(rtrim(#CXP.DOCTO)) = ltrim(rtrim(#COMIMPUESTOS.CVE_DOC))
UPDATE #CXP  SET IVAFISCAL = IMPUESTO2 FROM #COMIMPUESTOS				
WHERE ltrim(rtrim(#CXP.DOCTO)) = ltrim(rtrim(#COMIMPUESTOS.CVE_DOC))
UPDATE #CXP  SET IMPUESTOS = TOTALIMPUESTOS FROM #COMIMPUESTOS			
WHERE ltrim(rtrim(#CXP.DOCTO)) = ltrim(rtrim(#COMIMPUESTOS.CVE_DOC))
UPDATE #CXP  SET IVAFISCAL = 0.1304347826,IEPSFISCAL = 0, IMPUESTOS = NULL 
WHERE IVAFISCAL IS NULL
/*
select 'DESPUES DE ACTUALIZAR IMPUESTOS CXP', * from #CXP
*/
SET @Sql = ''
+ ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg (GID, CargaGID, Modulo, Mayor, Empresa, Proveedor, Moneda, Mov, Estatus, TipoCambio, FechaEmision, Concepto, Referencia, MovID, Vencimiento, cantidad, Debe, Haber, Subcuenta, Serielote,cliente, Impuesto1, Impuesto2, Gastos)'
+ ' SELECT '
+ '  GID				=	NewId() '
+ ' ,CargaGID		=	@GID '
+ ' ,Modulo			=	@Modulo '
+ ' ,Mayor			=	@Cuenta '
+ ' ,Empresa			=	@ConfE '
+ ' ,Proveedor			=	dbo.fnAspelJustificaClave(LTRIM(CPROV))'
+ ' ,Moneda			=	DESCRMON '
+ ' ,Mov				=	CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ' + char(39) + @Movdebe + char(39) + ' ELSE ' + char(39) + @Movhaber + char(39) + ' END '
+ ' ,Estatus			=	@Estatus '
+ ' ,TipoCambio		=	ROUND(TCAMBIO,5) '
+ ' ,FechaEmision	=	FECHA_APLI '
+ ' ,Concepto		=	' + CHAR(39) + 'Proveedor' + CHAR(39) + ' '
+ ' ,Referencia		=	LTRIM(RTRIM(DESCR)) + ' + CHAR(39) + ' ' + CHAR(39) + ' + LTRIM(RTRIM(NO_FACTURA)) ' +' + CASE  WHEN CCONREFER = ' + char(39) + 'S' + char(39) + ' THEN  ' + char(39) + 'POR ACLARAR' + char(39) + ' ELSE ' + char(39) + '' + char(39) + ' END '
+ ' ,MovId			=	LTRIM(RTRIM(CPROV)) + ' + CHAR(39) + '-' + CHAR(39) + ' + LTRIM(RTRIM(REFER))' 
+ ' ,Vencimiento		=	FECHA_VENC '
+ ' ,Cantidad		=	1 '
+ ' ,DEBE 			=  CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ABS(sum(MONTONATIVO)) ELSE 0 END '
+ ' ,HABER 			=   CASE  WHEN sum(MONTONATIVO) <0' + ' THEN ABS(sum(MONTONATIVO)) ELSE 0 END '
+ ' ,Subcuenta		= TIPO_MOV '
+ ' , SerieLote		= CASE  WHEN sum(MONTONATIVO) >0' + ' THEN ' + char(39) + 'C'+CHAR(39) + ' ELSE ' + CHAR(39) + 'A' + CHAR(39) + ' END '
+ ',Cliente			= RTRIM(LTRIM(CPROV)) '
+ ' ,Impuesto1		=  IVAFISCAL '	
+ ' ,Impuesto2		=  IEPSFISCAL '	
+ ' ,Gastos			=  IMPUESTOS '	
+ ' FROM #CXP GROUP BY CPROV,REFER,FECHA_APLI,FECHA_VENC,DESCR,TIPO_MOV,NUM_MONED,DESCRMON,NO_FACTURA,DOCTO,TCAMBIO,CCONREFER,IVAFISCAL,IEPSFISCAL,IMPUESTOS'
+ ' HAVING ABS(SUM(MONTONATIVO)) > 0.01 '
EXEC sp_executeSQL @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @Moneda varchar(30), @Estatus varchar(30)',
@GID     = @GID,
@Modulo  = @Modulo,
@Cuenta  = @Cuenta,
@ConfE	  = @ConfE,
@Moneda  = @Moneda,
@Estatus = @Estatus
IF @@ERROR <> 0
BEGIN
RAISERROR('Falla al insertar en la tabla permanente de CXP',16,1)
END
ELSE
BEGIN
SELECT @Descrip = MovimientoIntelisisCxP
FROM AspelCfgConceptos WITH (NOLOCK) 
WHERE Tipo = 'C' And NumConcepto = 'Cualquier otro' And Modulo = 'CxP'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = @Descrip
WHERE Mov = @MovDebe And Modulo = 'CxP'
SELECT @Descrip = MovimientoIntelisisCxP
FROM AspelCfgConceptos WITH (NOLOCK) 
WHERE Tipo = 'A' And NumConcepto = 'Cualquier otro' And Modulo = 'CxP'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = @Descrip
WHERE Mov = @MovHaber And Modulo = 'CxP'
UPDATE AspelCargaReg WITH (ROWLOCK) SET
Mov = C.MovimientoIntelisisCxP
FROM AspelCargaReg A, AspelCfgConceptos C WITH (NOLOCK) 
WHERE A.Subcuenta = C.NumConcepto And C.Modulo = 'CxP' AND A.MODULO = 'CxP' AND A.SerieLote = C.TIPO
END
IF @ImportarCOI = 1
BEGIN
/*********** Carga de Polizas Contables ***********/
SET @Cuenta = ''
SET @Modulo = ''
SET @Agrupador = ''
SET @MovDebe = ''
SET @MovHaber = ''
SET @Estatus = ''
SET @Sql = ''
SET @Parametros = ''
SET @Parametros = '@Cuenta varchar(30) OUTPUT, @Modulo varchar(15) OUTPUT, @Agrupador varchar(15) OUTPUT, @MovDebe varchar(20) OUTPUT, @MovHaber varchar(20) OUTPUT, @Estatus varchar(15) OUTPUT'
SET @Sql =  'SELECT '
+ '@Cuenta = MAYOR '
+ ', @Modulo = Modulo '
+ ', @Agrupador = Agrupador '
+ ', @MovDebe = CASE AfectaContabilidad WHEN 1 THEN MovDebeContable ELSE MovDebeNoContable END'
+ ', @MovHaber = CASE AfectaContabilidad WHEN 1 THEN MovHaberContable ELSE MovHaberNoContable END'
+ ', @Estatus = CASE AfectaContabilidad WHEN 1 THEN EstatusContable ELSE EstatusNoContable END '
+ 'FROM '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCfgModuloMayor WHERE DESCRIPCION = ' + CHAR(39) + 'Contabilidad' + CHAR(39) + ''
EXEC sp_executesql @Sql, @Parametros,
@Cuenta = @Cuenta OUTPUT,
@Modulo = @Modulo OUTPUT,
@Agrupador = @Agrupador OUTPUT,
@MovDebe = @MovDebe OUTPUT,
@MovHaber = @MovHaber OUTPUT,
@Estatus = @Estatus OUTPUT
CREATE TABLE #POL
( 	 Empresa	varchar(10)	NULL,
Sucursal	int			NULL,
Cuenta		varchar(50)	NULL,
Concepto	varchar(250)	NULL,
Moneda		varchar(10) NULL,
TipoCambio float(15)	NULL,
Fecha		datetime	NULL,
DEBE		decimal(15,7)	NULL,
HABER		decimal(15,7)	NULL,
Mov		varchar(20)	NULL,
Tipo		varchar(20) NULL,
Numero		varchar(20)	NULL,
Subcuenta	varchar(50) NULL,
Serielote	varchar(4) NULL,
ConceptoC	varchar(250)	NULL
)
SELECT @CadenaAgrupacion = CASE @Agrupador
WHEN 'Movimiento' THEN 'FECHA_POL, NUM_POLIZ, CONCEP_PO, '
WHEN 'Dia'		THEN 'FECHA_POL, '
WHEN 'Semana'		THEN 'DATEADD(DD, - DATEPART(DW,FECHA_POL),DATEADD(WW,1,FECHA_POL)), '
WHEN 'Mes'		THEN 'DATEADD(DD, - DAY(FECHA_POL),DATEADD(MM,1,FECHA_POL)), '
WHEN 'A�o'		THEN 'DATEADD(DD, - DATEPART(DY,FECHA_POL),DATEADD(YY,1,FECHA_POL)), '
ELSE 'FECHA_POL, '
END
SET @Sql = ''
+ CASE
WHEN @Agrupador = 'Movimiento' THEN 'INSERT #POL (Numero, Concepto, Cuenta, TipoCambio, Fecha, DEBE, HABER, Mov,Subcuenta, Tipo, SerieLote, ConceptoC) '
ELSE 'INSERT #POL (Cuenta, TipoCambio, Fecha, DEBE, HABER, Mov, Tipo, ConceptoC) ' END
+ 'SELECT  '
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'Numero = NUM_POLIZ, ' ELSE '' END
+ CASE WHEN @Agrupador = 'Movimiento' THEN 'Concepto = CONCEP_PO, ' ELSE '' END
+ 'Cuenta		=	LEFT(NUM_CTA,20), '
+ 'TipoCambio	=	TIPCAMBIO,  '
+ 'Fecha		= ' + CASE WHEN @Agrupador = 'Movimiento' THEN 'FECHA_POL, ' ELSE @CadenaAgrupacion END
+ 'DEBE			=	CASE WHEN DEBE_HABER = ' + CHAR(39) + 'D' + CHAR(39) + ' THEN SUM(ISNULL(MONTOMOV,0)) ELSE 0 END, '
+ 'HABER		=	CASE WHEN DEBE_HABER = ' + CHAR(39) + 'H' + CHAR(39) + ' THEN SUM(ISNULL(MONTOMOV,0)) ELSE 0 END, '
+ 'Mov			=   dbo.fnAspelConversion(' + char(39) + 'POLIZAS' + char(39) + ',' + char(39) + 'TIPO_POLI' + char(39) + ',TIPO_POLI), '
+ 'Subcuenta	=   CASE WHEN NUMDEPTO = ' + CHAR(39) + '0' + CHAR(39) + ' THEN NULL ELSE NUMDEPTO END, '
+ 'Tipo			=	TIPO_POLI, '
+ 'SerieLote	=	SUBSTRING(REFERENCIA,3,4), '
+ 'ConceptoC	=	Concep_ca '
+ 'FROM '+@ServidorOrigen+'.'+@BaseDatosOrigen+'.dbo.POLIZAS ' 
+ 'GROUP BY ' + @CadenaAgrupacion + ' LEFT(NUM_CTA,20), TIPCAMBIO, DEBE_HABER, TIPO_POLI,NUMDEPTO, Referencia, Concep_ca '
EXEC Sp_ExecuteSql @Sql
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla temporal de Polizas',16,1)
SET @Sql =  ''
+ ' INSERT '+@ServidorDestino + '.' + @BaseDatosDestino + '.dbo.AspelCargaReg(GID, CargaGID, Modulo,Empresa,Sucursal, Mayor, Mov, MovID, TipoCambio, FechaEmision, Debe, Haber, Concepto, Estatus,Centrocostos, Referencia, Clase, Subclase) '
+ ' SELECT '
+ '  GID			=	NewId() '
+ ' ,CargaGID		=	@GID '
+ ' ,Modulo		    =	@Modulo '
+ ' ,Empresa		=	@ConfE '
+ ' ,Sucursal 	    =	@ConfS '
+ ' ,Mayor			=	Cuenta '
+ ' ,Mov			=	CASE WHEN left(Serielote,2) = ' + CHAR(39) + '13' + CHAR(39) + 'THEN ' + CHAR(39) + 'Cierre' + CHAR(39) + ' ELSE Mov END'
+ ' ,MovID			=	CASE WHEN left(Serielote,2) = ' + CHAR(39) + '13' + CHAR(39) + 'THEN  Mov +' + CHAR(39) + '-' + CHAR(39) + '+ Numero ELSE Numero END'
+ ' ,TipoCambio		=	TipoCambio '
+ ' ,FechaEmision	=	Fecha '
+ ' ,Debe			=	Debe '
+ ' ,Haber			=	Haber '
+ ' ,Concepto		=	Concepto '
+ ' ,Estatus		=	@Estatus '
+ ' ,Subcuenta		=	Subcuenta '
+ ' ,Referencia		=	Tipo '
+ ' ,Clase			=	left(ConceptoC,50) '
+ ' ,SubClase		=	substring(ConceptoC,51,50) '
+ ' FROM #POL '
EXEC sp_ExecuteSql @Sql,
N'@GID uniqueidentifier, @Modulo varchar(15), @Cuenta varchar(30), @ConfE varchar(30), @ConfS int, @Estatus varchar(30)',
@GID = @GID,
@Modulo = @Modulo,
@Cuenta = @Cuenta,
@ConfE = @ConfE,
@ConfS = @ConfS,
@Estatus = @Estatus
IF @@ERROR <> 0
RAISERROR('Falla al insertar en la tabla  permanente de Contabilidad',16,1)
END
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,Valor,Nombre, Estatus, TipoComision,'
+'Porcentaje, eMail, Tipo, Familia, Proveedor)' 
SET @Sql = @Sql + ' SELECT  NewID() '
+ ', @GID '
+ ', ' + char(39)+'Agente'+ char(39) + ' '
+ ', dbo.fnAspelJustificaClave(LTRIM(RTRIM(CLV_VEND))) '
+ ',NOMBRE '
+ ',dbo.fnAspelConversion(' + char(39) + 'VEND01' + char(39) + ',' + char(39) + 'STATUS' + char(39) + ',STATUS) '
+ ','+ char(39) + 'por Factura' + char(39) + ' '
+ ',COMI '
+ ',CORREOE '
+ ','+ char(39) + 'Vendedor' + char(39) + ', CLASIFIC ' + ', LTRIM(RTRIM(CLV_VEND)) ' 
SET @Sql = @Sql + ' FROM '+	@ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.VEND01'
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,Valor,Nombre, Estatus) '
SET @Sql = @Sql + ' SELECT  NewID() '
+ ', @GID '
+ ', ' + char(39)+'Almacen'+ char(39) + ' '
+ ',LTRIM(ALMACEN) '
+ ',' + char(39) + 'Almacen Aspel Sae ' + char(39) + ' + LTRIM(ALMACEN) '
+ ',dbo.fnAspelConversion(' + char(39) + 'MULT01' + char(39) + ',' + char(39) + 'STATUS' + char(39) + ',STATUS) '
+ ' FROM '+	@ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.MULT01 WHERE STATUS = '  + CHAR(39) + 'A' + CHAR(39)
+ ' GROUP BY ALMACEN, STATUS'
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SELECT @CampoImpuesto1 = Valor FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'IVA Articulo'
SELECT @CampoImpuesto2 = Valor FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'IEPS Articulo'
SELECT @CampoImpuesto3 = Valor FROM AspelCfgOpcion WITH (NOLOCK) WHERE Descripcion = 'Impuesto 3 Articulo'
SET @CampoImpuesto1 = CASE @CampoImpuesto1
WHEN 'IMPU4' THEN ',B.IMPUESTO4 '
WHEN 'IMPU1' THEN ',B.IMPUESTO1 '
ELSE ',0 '
END
SET @CampoImpuesto2 = CASE @CampoImpuesto2
WHEN 'IMPU4' THEN ',B.IMPUESTO4 '
WHEN 'IMPU1' THEN ',B.IMPUESTO1 '
ELSE ',0 '
END
SET @CampoImpuesto3 = CASE @CampoImpuesto3
WHEN 'IMPU2+IMPU3' THEN ',B.IMPUESTO2 + B.IMPUESTO3  '
ELSE ',0 '
END
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,Valor,Nombre, Unidad, Estatus, Tipo, Linea, Impuesto1, Impuesto2, Impuesto3,'
+ 'Proveedor, TiempoEntrega, TiempoEntregaU, PrecioLista, Precio2,'
+ 'Precio3, Precio4, Precio5, Peso, Volumen, TipoCosteo, Costo, Descripcion, Descripcion2, Categoria, Rama, CURP)'
SET @Sql = @Sql + ' SELECT NewID() '
+ ', @GID '
+ ', ' + char(39)+'Articulo'+ char(39) + ' '
+ ',LTRIM(A.CLV_ART) '
+ ',A.DESCR '
+ ',A.UNI_MED '
+ ',dbo.fnAspelConversion(' + char(39) + 'INVE01' + char(39) + ',' + char(39) + 'STATUS' + char(39) + ',A.STATUS) '
+ ',CASE WHEN TIPO_ELE = ' + CHAR(39) + 'K' + CHAR(39) + ' THEN ' + CHAR(39) + 'Juego' + CHAR(39) + ' '
+ 'WHEN TIPO_ELE = ' + CHAR(39) + 'S' + CHAR(39) + ' THEN ' + CHAR(39) + 'Servicio' + CHAR(39) + ' '
+ 'ELSE dbo.fnAspelConversion(' + char(39) + 'INVE01' + char(39) + ',' + char(39) + 'NUM_SERIE' + char(39) + ',A.NUM_SERIE) END '
+ ',A.LIN_PROD '
+ @CampoImpuesto1
+ @CampoImpuesto2
+ @CampoImpuesto3
+ ',RTRIM(LTRIM(A.PROVEEDOR1)) '
+ ',A.TIEM_SURT '
+ ',' + char(39) + 'Dias' + Char(39) + ' '
+ ',A.PRECIO1 '
+ ',A.PRECIO2 '
+ ',A.PRECIO3 '
+ ',A.PRECIO4 '
+ ',A.PRECIO5 '
+ ',A.PESO '
+ ',A.VOLUMEN '
+ ',dbo.fnAspelConversion(' + char(39) + 'INVE01' + char(39) + ',' + char(39) + 'TIP_COSTEO' + char(39) + ',A.TIP_COSTEO) '
+ ',A.ULT_COSTO, REPLACE(A.CLV_ALTER,' + CHAR(39) + ' ' + CHAR(39) + ', ' + CHAR(39) + '' + CHAR(39) + ') '
+ ', SUBSTRING(ISNULL(OI.X_OBSER, ' + CHAR(39) + '' + CHAR(39) + '),1,100) '
+ ',CASE WHEN TIPO_ELE <> ' + CHAR(39) + 'T' + CHAR(39) + ' THEN ' + CHAR(39) + 'No' + CHAR(39) + ' ELSE ' + CHAR(39) + 'Si' + CHAR(39) + ' END '
+ ', MO.DESCR '
+ ',A.UNI_ALT '
+ ' FROM '+ @ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.INVE01 A '
+ 'LEFT OUTER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.IMPU01 B ON A.CVEESQIMP = B.CVEESQIMPU '
+ 'LEFT OUTER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.OINV01 OI ON A.NUM_REG = OI.NUM_REG '
+ 'LEFT OUTER JOIN ' + @ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.MONED01 MO ON LTRIM(RTRIM(A.NUM_MON)) = LTRIM(RTRIM(MO.NUM_MONED)) '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
UPDATE ASPELCARGAPROP SET IMPUESTO1 = 15 WHERE CAMPO = 'Articulo' and Impuesto1 is null
CREATE TABLE #Artnoencontrados
(
Articulo	varchar(20)	NULL,
)
INSERT #Artnoencontrados
SELECT DISTINCT(ARTICULO) FROM ASPELCARGAreg WITH (NOLOCK) WHERE
ARTICULO NOT IN (SELECT VALOR FROM ASPELCARGAPROP WITH (NOLOCK) WHERE CAMPO = 'Articulo')
AND ARTICULO NOT IN ('FLETE','INDIRECTOS') AND ARTICULO IS NOT NULL
AND (SELECT COUNT(*) FROM ASPELCARGAREG WITH (NOLOCK) WHERE MODULO IN ('VTAS', 'COMS')) > 0
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp
(GID, CargaGID, Campo,Valor,Nombre, Unidad, Estatus, Tipo,  Impuesto1, Impuesto2, Impuesto3,'
+ ' PrecioLista, Precio2,'
+ 'Precio3, Precio4, Precio5,  TipoCosteo, Costo, Categoria, Rama)'
SET @Sql = @Sql + ' SELECT NewID() '
+ ', @GID '
+ ', ' + char(39)+'Articulo'+ char(39) + ' '
+ ',Articulo '
+ ', '+ char(39) + 'Art�culo dado de baja ASPEL-SAE' + CHAR(39)
+ ', '+ char(39) + 'pza' + CHAR(39)
+ ', '+ char(39) + 'ALTA' + CHAR(39)
+ ', '+ char(39) + 'Normal' + CHAR(39)
+ ',0 '
+ ',0 '
+ ',0 '
+ ',0 '
+ ',0 '
+ ',0 '
+ ',0 '
+ ',0 '
+ ', '+ char(39) + 'Promedio' + CHAR(39)
+ ',0 '
+ ', '+ char(39) + 'No' + CHAR(39)
+ ', '+ char(39) + 'Pesos' + CHAR(39)
+ ' FROM #Artnoencontrados '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
CREATE TABLE #Unidad
( 	 Unidad		varchar(2)	NULL,
Articulo	varchar(20)	NULL,
Factor		float(15) 	NULL,
Peso		float(15)	NULL,
Volumen	float(15)	NULL,
UniAlt		Varchar(2)	NULL
)
SET @Sql = ''
SET @Sql = @Sql + ' INSERT #Unidad (Unidad, Articulo, Factor, Peso, Volumen, UniAlt)'
SET @Sql = @Sql + ' SELECT LTRIM(UNI_MED)'
+ ',LTRIM(RTRIM(CLV_ART)) '
+ ',FAC_CONV '
+ ',FAC_CONV * PESO '
+ ',FAC_CONV * VOLUMEN '
+ ', UNI_ALT '
+ ' FROM ' +	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.INVE01 '
+ 'UNION SELECT LTRIM(UNI_ALT) '
+ ',LTRIM(RTRIM(CLV_ART)) '
+ ', 1 '
+ ',PESO '
+ ',VOLUMEN '
+ ', ' + CHAR(39) + CHAR(39) + ' '
+ ' FROM ' +	@ServidorOrigen + '.' + @BaseDatosOrigen + '.dbo.INVE01 '
EXEC sp_executeSQL @Sql
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, Articulo, Factor, Peso, Volumen, Unidad )'
SET @Sql = @Sql + ' SELECT DISTINCT NewID() '
+ ', @GID '
+ ', ' + char(39)+'Unidad'+ char(39) + ' '
+ ', Unidad '
+ ', Articulo '
+ ', Factor '
+ ', Peso '
+ ', Volumen '
+ ', UniAlt '
+ ' FROM #Unidad '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,Valor,Nombre, Orden, TipoCambio, Clave)'
SET @Sql = @Sql + ' SELECT NewID() '
+ ', @GID '
+ ', ' + char(39)+'Moneda'+ char(39) + ' '
+ ',DESCR '
+ ',DESCR '
+ ',NUM_MONED '
+ ',TCAMBIO '
+ ',LEFT(SIMBOLO,3) '
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.MONED01'
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID,
Campo, Valor, Nombre, Descripcion, Direccion, Colonia, Poblacion, Zona, CodigoPostal, Telefonos, Fax, Email,
RFC, CURP, Estatus, Familia, Rama, Descripcion2, Factor,Tipo) '
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Proveedor'+ char(39) + ', dbo.fnAspelJustificaClave(LTRIM(RTRIM(P.CPROV))), '
+ 'P.NOMBRE, P.NOMBRE, P.DIR, P.COLONIA, P.POB, P.CVE_ZONA, P.CODIGO, P.TELEFONO, P.FAX, SUBSTRING(P.EMAIL, 1,50), '
+ 'P.RFC, P.CURP, dbo.fnAspelConversion(' + char(39) + 'PROV01' + char(39) + ',' + char(39) + 'STATUS' + char(39) + ',P.STATUS), P.CLASIFIC, CASE WHEN P.DIAS_CRE > 0 THEN CONVERT(VARCHAR, P.DIAS_CRE) + ' + CHAR(39) + ' DIAS' + CHAR(39) + ' ELSE NULL END '
+ ', SUBSTRING(ISNULL(OP.X_OBSER, ' + CHAR(39) + '' + CHAR(39) + '),1,100), DESCUENTO,LTRIM(RTRIM(P.CPROV)) '
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.PROV01 P '
+ 'LEFT OUTER JOIN ' + @ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.OPRV01 OP ON P.NUM_REG = OP.NUM_REG '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
Update aspelcargaprop
SET RFC = REPLACE(RFC,'-','') WHERE CAMPO = 'proveedor'
CREATE TABLE #Pronoencontrados
(
Proveedor	varchar(5)	NULL,
)
INSERT #Pronoencontrados
SELECT DISTINCT(PROVEEDOR) FROM ASPELCARGAreg WITH (NOLOCK) WHERE
MODULO IN ('COMS','CXP') AND Proveedor NOT IN (SELECT VALOR FROM ASPELCARGAPROP WITH (NOLOCK) WHERE CAMPO = 'Proveedor')
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID,
Campo, Valor, Nombre, Estatus) '
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Proveedor'+ char(39)
+ ',Proveedor '
+ ',' +  char(39) + 'Proveedor dado de baja en ASPEL-SAE' + char(39)
+ ','+ CHAR(39) + 'ALTA' + CHAR(39)
+ ' FROM #Pronoencontrados '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,
Valor, Nombre, Descripcion, Direccion, Colonia, Poblacion, CodigoPostal, Telefonos, Fax, Contacto, Email,  RFC,CURP,
Estatus, Grupo, Rama, Descripcion2, Impuesto1, Proveedor, Factor, Tipo) ' 
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Cliente'+ char(39)
+ ',dbo.fnAspelJustificaClave(LTRIM(RTRIM(C.CCLIE))), C.NOMBRE, C.NOMBRE, C.DIR, C.COLONIA, C.POB, C.CODIGO, C.TELEFONO, C.FAX, C.ATENCION, SUBSTRING(C.EMAIL, 1,50), C.RFC, C.CURP, '
+ 'dbo.fnAspelConversion(' + char(39) + 'CLIE01' + char(39) + ',' + char(39) + 'STATUS' + char(39) + ',C.STATUS), C.CLASIFIC, CASE WHEN C.DIAS_CRE > 0 THEN CONVERT(VARCHAR, C.DIAS_CRE) + ' + CHAR(39) + ' DIAS' + CHAR(39) + ' ELSE NULL END '
+ ', SUBSTRING(ISNULL(OC.X_OBSER, ' + CHAR(39) + '' + CHAR(39) + '),1,100), C.LIM_CRED, '
+ 'dbo.fnAspelJustificaClave(LTRIM(C.VEND)), C.DESCUENTO,LTRIM(RTRIM(C.CCLIE))  ' 
SET @Sql = @Sql + ' FROM '+ @ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.CLIE01 C '
+ 'LEFT OUTER JOIN ' + @ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.OCLI01 OC ON C.NUM_REG = OC.NUM_REG '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
Update aspelcargaprop
SET RFC = REPLACE(RFC,'-','') WHERE CAMPO = 'cliente'
CREATE TABLE #Clinoencontrados
(
Cliente	varchar(5)	NULL,
)
INSERT #Clinoencontrados
SELECT DISTINCT(Cliente) FROM ASPELCARGAreg WITH (NOLOCK) WHERE
Modulo in ('VTAS','CXC') and Cliente NOT IN (SELECT VALOR FROM ASPELCARGAPROP WITH (NOLOCK) WHERE CAMPO = 'Cliente')
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,
Valor, Nombre, 	Estatus) '
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Cliente'+ char(39)
+ ',Cliente '
+ ',' + char(39) + 'Cliente dado de baja en ASPEL-SAE' + CHAR(39)
+ ',' + char(39) + 'ALTA' + CHAR(39)
SET @Sql = @Sql + ' FROM #Clinoencontrados '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' + @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo,Valor, Articulo, Almacen,'
+ 'UltimaEntrada, UltimaSalida, Costo)'
SET @Sql = @Sql + ' SELECT NewID() '
+ ', @GID '
+ ', ' + char(39)+'Serie'+ char(39) + ' '
+ ',LTRIM(A.NUM_SER) '
+ ',A.CVE_ART '
+ ',A.ALMACEN '
+ ',A.FECHA_ENT '
+ ',A.FECHA_SAL '
+ ',0 '
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.NUMSER01 A '
+ 'WHERE A.STATUS = ' + char(39) + 'D' + char(39)
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
IF @ImportarCOI = 1
BEGIN
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, ValorNumero, Rama)'
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Rubro'+ char(39) + ',DESCRIP, NUM_REG, dbo.fnAspelSetRama(NUM_REG) '
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.RANC01'
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, ValorNumero)'
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'RubroCuenta'+ char(39) + ',CUENTA, MIN(Rubro) '
SET @Sql = @Sql + 'FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.CTARUB01 '
SET @Sql = @Sql + 'GROUP BY CUENTA '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, ValorNumero)'
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'RubroCuentaB'+ char(39) + ',CUENTA, Rubro '
SET @Sql = @Sql + 'FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.CTARUB01 '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, Nombre, Estatus, Tipo, Rama,Valornumero,Descripcion)'
SET @Sql = @Sql + ' SELECT NewID(), @GID, ' + char(39)+'Cuenta'+ char(39)
+ ',num_cta '
+ ', Nombre '
+ ',dbo.fnAspelConversion(' + char(39) + 'CUENTAS' + char(39) + ',' + char(39) + 'Status' + char(39) + ',Status) '
+ ',Tipo '
+ ',Rama '
+ ',Deptsino'
+ ',Naturaleza'
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.CUENTAS'
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
CREATE TABLE #TipoPoliza
( 	 TIPO_POLI	varchar(20)	NULL,
TipoPoliza	varchar(20)	NULL,
)
SET @Sql = ''
SET @Sql = @Sql + ' INSERT #TipoPoliza (TIPO_POLI, TipoPoliza)'
SET @Sql = @Sql + ' SELECT DISTINCT '
+ ' LTRIM(TIPO_POLI) '
+ ', dbo.fnAspelConversion(' + char(39) + 'POLIZAS' + char(39) + ',' + char(39) + 'TIPO_POLI' + char(39) + ',TIPO_POLI) '
SET @Sql = @Sql + ' FROM '+	@ServidoroRigen + '.' + @BaseDatosOrigen + '.dbo.POLIZAS '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
SET @Sql = ''
SET @Sql = @Sql + ' INSERT '+ @ServidorDestino + '.' +  @BaseDatosDestino+ '.' + 'dbo.AspelCargaProp (GID, CargaGID, Campo, Valor, TipoPoliza)'
SET @Sql = @Sql + ' SELECT NewID() '
+ ', @GID '
+ ', ' + char(39) + 'TipoPoliza' + char(39)
+ ', TIPO_POLI '
+ ', TipoPoliza '
SET @Sql = @Sql + ' FROM #TipoPoliza '
EXEC sp_executeSQL @Sql,N'@GID uniqueidentifier', @GID = @GID
END
END

