SET DATEFIRST 7    
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1  
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO

-- =======================================================================================================================================
-- NOMBRE			: SP_MaviRM0492AListaEnrutAvales
-- AUTOR			: Marco Valdovinos
-- FECHA CREACION	: 2013/03/26
-- DESARROLLO		: RM0492A  LISTADO DE ENRUTAMIENTO AVALES
-- MODULO			: EMB
-- DESCRIPCION		: COPIA DEL SP_MaviRM0492BListaEnrutamientoEspecial 
--                   QUE ENLISTA LA COBRANZA DE CADA MES REQUERIDO  POR AGENTE, POR CLIENTE O POR NIVEL
--                   ADAPATADO PARA TRAER LA INFORMACION DE LOS AVALES DE LAS CUENTAS QUE SE LES ASIGNO EL AVAL A UN AGENTE
-- ========================================================================================================================================
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		01/05/2013      Por: MArco Valdovinos
-- Se agreagn los cobros los movimientos "Aplicacion de Saldo" para que se sume a los cobros y puedan tomarse en
-- cuenta las apliaciones de los pagos hechos como enganche o Anticipo.
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		06/09/2013      Por: MArco Valdovinos
-- Se hace modificación para que cuando el movimiento sea un seguro se muestren en blanco los campos plazo,Importe de compra,Fecha ultimo abono y  Abonos, 
--    además el campo "SDO T."(saldo total) mostrará unicamente el saldo vencido.
-- Se modifica para que en los abonos provenientes de "MaviComplementoCXCUnicaja" tome sólo el campo "PAGOUNICAJA" porque anteriormente le sumaba a este el campo "otroabonounicaja".
-- Se adapta para que al correrse el reporte en Mavicob cuando no encuentre pagos de unicaja en la tabla  "MaviComplementoCXCUnicaja" los busque en la base IntelisisTmp en la tabla con ese mismo nombre. igual para el campo ultimobono del reporte 
-- Se agrega envío de reporte a TXT mediante el SDK intelisis y se agreag boton a la forma para que se puedan enviar a excel y txt sin mandarlo a pantalla primero.                                              
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		23/09/2013      Por: Angel Alberto Gómez Tapia
--Se le agregaron dos dato mas los cuales son "Monedero" y "Cruce" los cuales son informativos y no afectan a la operacion de los datos.
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		29/03/2014      Por: Miguel Alonso Ramos Michel
--Se modificó la consulta donde se toman los días vencidos y los días inactivos para que considere el monedero
--se cambió la zona, ahora se toma directamente de DM0196MavirecupAvalesTbl y no de ZonaCobranzaHis
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		19/01/2015      Por: Miguel Alonso Ramos Michel
--	Se agregan la Region, Division y Equipo correspondientes a la Zona del Aval, así como el Estado y un nuevo cálculo para Exigible
-- ========================================================================================================================================
-- ========================================================================================================================================
-- FECHA Y AUTOR MODIFICACION:		11/12/2015      Por: JOSE CARLOS ORTIZ FLORES
--	 SE AGREGAN LOS CAMPOS DIVISION,CANAL DE VENTA , CATEGORIA Y EL NIVEL QUE TENIA LA CUENTA EN MAVIRECUPERACION.
-- ========================================================================================================================================

ALTER PROCEDURE  [dbo].[SP_MaviRM0492AListaEnrutAvales]
 	@Ejercicio		 INT,
	@Quincena		 TINYINT,
	@Cliente		 VARCHAR(12),
	@Agente			 VARCHAR(12),
	@nivelcobranza	 varchar(255),
	@Zona			 Varchar(30)

As
Begin


DECLARE @FeIni_cxc DATETIME, @FeFin_cxc DATETIME, @Mes VARCHAR(3)

SET @Mes = CAST(CEILING(CAST(@Quincena AS FLOAT) / 2)As VarChar(3))

IF (@Quincena % 2) != 0
	BEGIN
	SELECT @FeIni_cxc = Cast(@Ejercicio As Varchar) + '/' + Cast(@Mes As Varchar) + '/' + '2'
	SELECT @FeFin_cxc = Cast(@Ejercicio As Varchar) + '/' + Cast(@Mes As Varchar) + '/' + '16 23:59:59'
	END
ELSE
	BEGIN
	SELECT @FeIni_cxc = Cast(@Ejercicio As Varchar) + '/' + Cast(@Mes As Varchar) + '/' + '17'
	SELECT @FeFin_cxc = case when @Mes = 12 then Cast(@Ejercicio+1 As Varchar) + '/' + Cast(1 As Varchar) + '/' + '1 23:59:59'
							ELSE Cast(@Ejercicio As Varchar) + '/' + Cast(@Mes+1 As Varchar) + '/' + '1 23:59:59'
					END
	END

/*·····················································
·· 1 ·········Clientes que Jugaran en el Reporte·······
···········Con respectivos padres asignados···········*/
Declare @Consulta NVarchar(Max)

IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AClientes') AND type ='U')
	Drop Table #AClientes

Create Table #AClientes
	(
	Cliente			Varchar(100) null,
	rutaCobranza	Varchar(100) null,
	AgenteCobrador	Varchar(50) null,
	nivelCobranza	VarChar(100) null,
	PadreMavi	Varchar(20) null,
	PadreIdMavi Varchar(20) null,
	Renglon		Int null,
	idaval		int,
	ventaid		int NULL,
	idmov		int,
	Zona		Varchar(30),
	Condicion	Varchar(50) null,
	Categoria   Varchar(50) null,
	CanalVenta   Varchar(50) null,
	DivisionAval  Varchar(30) null
	)

Set @Consulta = 'Select MR.Cliente, MR.RutaCobAval, MR.AgenteCobAval, MR.NivelCobranza, MR.mov, mr.movid, Min(VD.Renglon) Renglon,
		MR.idaval, V.id, mr.Idmov, MR.ZonaAval Zona, V.Condicion,mr.Categoria,mr.CanalVenta,mr.DivisionAval
    From DM0196MavirecupAvalesTbl MR With(NOLOCK)
	left join Venta V With(NOLOCK) on V.MovId = MR.movid and V.Mov = mr.mov
	left join VentaD VD With(NOLOCK) on VD.Id = V.Id
	left join Art A With(NOLOCK) on A.Articulo = VD.Articulo and a.tipo != ''Servicio''
	left join BonifSiMavi BM With(NOLOCK) on BM.idcxc = mr.Idmov
    Where 1=1'
    If IsNull(@Cliente,'') != '' Set @Consulta = @Consulta + ' And MR.Cliente = '''+@Cliente+''''
    If IsNull(@Quincena,'') != '' Set @Consulta =  @Consulta + ' And MR.quincena = '+Str(@Quincena)
    If IsNull(@Ejercicio,'') != '' Set @Consulta =  @Consulta + ' And MR.Ejercicio = '+Str(@Ejercicio)
    If IsNull(@Agente,'') != '' Set @Consulta =  @Consulta + ' And MR.AgenteCobaval = '''+@Agente+''''
    If IsNull(@NivelCobranza,'') != '' Set @Consulta =  @Consulta + ' And MR.NivelCobranza = '''+@NivelCobranza+''''
    If IsNull(@Zona,'') != '' Set @Consulta =  @Consulta + ' And MR.ZonaAval = '''+@Zona+''''
    Set @Consulta= @Consulta + ' Group By MR.Cliente,RutaCobAval,AgenteCobAval,MR.NivelCobranza,mr.mov,mr.movid,mr.idaval,v.id,mr.Idmov, MR.ZonaAval, V.Condicion,mr.Categoria,mr.CanalVenta,mr.DivisionAval'

Insert Into #AClientes Exec(@Consulta)

Create Index Cliente	 on #AClientes (Cliente)
Create Index PadreMavi	 on #AClientes (PadreMavi)
Create Index PadreIdMavi on #AClientes (PadreIdMavi)



/*·················································
·· 2 ··· Se toma la Descripcion de los Articulos··
·················································*/ 
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#Articulos') AND type ='U')
	Drop Table #Articulos

Select arti.padremavi, arti.padreidmavi, isnull(isnull(art.Descripcion1,bm.articulo), c.concepto) artDescripcion
into #Articulos
From(--Arti
	Select padremavi,padreidmavi,min(renglon) as renglon ,ventaid,idmov
	From( --RA
		Select padremavi, padreidmavi, isnull(ac.Renglon,vtd.renglon) renglon, ventaid, idmov
		from #AClientes ac
		left join ventad vtd With(NoLock) on vtd.id = ac.ventaid and  ac.renglon is null
		)RA
	group by padremavi,padreidmavi,ventaid,idmov
	)Arti
left join ventad vd With(NOLOCK) on vd.id = arti.ventaid and arti.renglon = vd.renglon
left join art With(NOLOCK) on vd.articulo = art.articulo
left join BonifSiMavi BM With(NOLOCK) on BM.idcxc = arti.Idmov
left join cxc c With(NOLOCK) on arti.padremavi = c.mov and arti.padreidmavi = c.movid and arti.padremavi like 'Nota cargo%'

/*···················································
·· 3 ····Clientes para el reporte·····················
·····················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AClienteFiltro') AND type ='U')
	Drop Table #AClienteFiltro

Select Cliente into #AClienteFiltro From #AClientes Group By Cliente

Create Index Cliente on #AClienteFiltro (Cliente)

/*···················································
·· 4 ···· Dias vencidos ·····························
·····················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ADVTemp') AND type ='U')
	Drop Table #ADVTemp

Create Table #ADVTemp
	(
	DV	Float Null,
	PadreMavi	Varchar(50) null,
	PadreIdMavi VarChar(50) null
	)

Insert into #ADVTemp
Select Diasvencidos = max(case when Prediasvencidos >= 1 then ROUND(PrediasVencidos, .5) else(case when Prediasvencidos >= 0.5 then 1 else 0 End ) End),
		padremavi,padreidmavi
From(--F
	Select padremavi, padreidmavi, mov, movid, Importetotal, Diasnaturales, proporcionsaldo, fechalimiteproporcion, Mesnaturaltranscurrido,
		Case when diasnaturales <= Mesnaturaltranscurrido then ISNULL(DiasNaturales,0.0) * ISNULL(ProporcionSaldo,0.0)
			Else ISNULL(DiasNaturales,0.0) - ISNULL(MesNaturalTranscurrido,0.0) + (ISNULL(MesNaturalTranscurrido,0.0) * ISNULL(ProporcionSaldo,0.0))
		End PreDiasvencidos 
	From( --D
		SELECT c.Importe, c.Impuestos, c.Retencion, ms.Monedero, ms.padremavi, ms.padreidmavi, c.mov, c.movid,
			CASE WHEN Left(C.Mov,10) = 'Nota Cargo' And Left(C.Concepto,10) = 'CANC COBRO' THEN (c.Importe + c.Impuestos)- isnull(c.retencion,0)
				ELSE (c.Importe + c.Impuestos)- isnull(c.retencion,0)-ISNULL(Monedero,0) 
			END Importetotal,
			DATEDIFF(dd,VEncimiento, getdate()) DiasNaturales,
			CASE WHEN Left(C.Mov,10) = 'Nota Cargo' And Left(C.Concepto,10) = 'CANC COBRO' THEN  c.Saldo /((c.Importe + c.Impuestos)- isnull(c.retencion,0))
				ELSE c.Saldo /((c.Importe + c.Impuestos)- isnull(c.retencion,0)-ISNULL(Monedero,0))
			END ProporcionSaldo, 
			DATEADD(mm,1,Vencimiento) AS Fechalimiteproporcion, DATEDIFF(dd,Vencimiento,DATEADD(mm,1,Vencimiento)) Mesnaturaltranscurrido, c.ID iddoc
		FROM( -- MS   
			SELECT m.Padremavi,m.PadreidMavi, SUM(ISNULL(ap.Abono,0))/  Max(Case When Cn.DA = 1 Then Cn.DANumeroDocumentos Else 1 End)Monedero
			FROM #Aclientes m
			LEFT JOIN AuxiliarP ap With(NoLock) ON ap.Mov = m.Padremavi and ap.movid = m.Padreidmavi AND ap.Modulo = 'VTAS'
			LEFT JOIN Condicion Cn With(NoLock) On Cn.Condicion = m.Condicion
			GROUP BY m.PadreMavi,m.PadreidMavi
			)MS
		inner join Cxc c with(nolock) on c.padremavi = ms.padremavi and c.padreidmavi = ms.padreidmavi and c.estatus = 'pendiente' 
		)D
	)F
Group by padremavi, padreidmavi

/*···················································
·· 5 ······Cobros de los Clientes····················
····················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ACobros') AND type ='U')
	Drop Table #ACobros
		
Select cob.padremavi, cob.padreidmavi, sum(cob.importe)cobros, max(cob.fechaemision) AS fechaemision
Into #ACobros
From( --cob
	Select movi.padremavi,movi.padreidmavi,c.mov,c.movid,importe = c.importe + c.impuestos,c.fechaemision
	From( --movi
			Select c.padremavi,c.padreidmavi,c.id, c.mov,c.movid,c.concepto
			From #AClientes AC
			inner join cxc c with(nolock) on AC.padremavi = c.padremavi and AC.padreidmavi = c.padreidmavi
		Union all
			Select AC.padremavi, AC.padreidmavi, c.id, c.mov, c.movid, c.concepto
			From #AClientes AC
			inner join movcampoextra mv with(nolock) on mv.modulo = 'cxc' and AC.padremavi + '_'+ AC.padreidmavi = mv.valor
			left join cxc c with(nolock) on c.id = mv.id and c.concepto like 'Moratorios%' and campoextra like '%Factura'
			)movi
	INNER join cxcd cd with(nolock) on cd.aplica = movi.mov and cd.aplicaid = movi.movid
	INNER join cxc c With(NoLock) on c.id = cd.id and c.mov in ('cobro','cobro instituciones','Aplicacion Saldo') AND C.estatus IN ('Concluido')
	Group by movi.padremavi, movi.padreidmavi, c.mov, c.movid, c.fechaemision, c.importe, c.impuestos
	)cob
Group by cob.padremavi, cob.padreidmavi

/* ···················································
·· 6 ····Datos del cliente provenientes··············
··········de unicaja·································
··················································· */
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AAbonoCargoUnicaja') AND type ='U')
	Drop Table #AAbonoCargoUnicaja

Select C.mov, C.MovId, MCU.Id, MCU.MaviUltimoPago, (MCU.PagoUnicaja) Abono, (MCU.DevolucionUnicaja + MCU.OtroCargoUnicaja + MCU.ChequeDevUnicaja)Cargos
Into #AAbonoCargoUnicaja
From Cxc C With(NoLock)
Inner Join MaviComplementocxcUnicaja MCU With(NoLock) on C.Id = MCU.Id 
Inner Join #AClienteFiltro Cliente on C.Cliente = Cliente.Cliente
Group By MCU.Id, MCU.OtroAbonoUnicaja, MCU.MaviUltimoPago, MCU.DevolucionUnicaja, MCU.OtroCargoUnicaja,
		MCU.ChequeDevUnicaja, MCU.PagoUnicaja, C.mov, C.MovId
	
-- Se condiciona para que cuando se corra en Mavicob tome 
-- los pagos de unicaja de la base de intelisitmp, poque  que no se pasaron a mavicob 

IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AACUnicajaIntTmp') AND type ='U')
	Drop Table #AACUnicajaIntTmp

DECLARE @Baseactual varchar (30)

SELECT @Baseactual = DB_NAME() 

CREATE TABLE #AACUnicajaIntTmp
	(
	Mov				varchar(30) null,
	movid			varchar(30)null,
	AbonoUniTMP		int null,
	UltimoPagoITMP	datetime null
	)	

IF @Baseactual ='MaviCob' -- Se condiciona para que solo busque otra vez en la tabla cuando este en Mavicob
	BEGIN
	Insert into #AACUnicajaIntTmp
	Select C.mov, C.MovId,Isnull(MCU.PagoUnicaja,0) AbonoUniTMP, MCU.MaviUltimoPago
	From IntelisisTmp.dbo.Cxc C With(NoLock)
	Inner Join #Clientes Clt on c.mov = clt.Padremavi and c.movid = clt.padreidmavi
	Inner Join IntelisisTmp.dbo.MaviComplementocxcUnicaja MCU With(NoLock) on C.Id = MCU.Id
	Group By C.mov, C.MovId, MCU.PagoUnicaja, MCU.OtroAbonoUnicaja, MCU.MaviUltimoPago
	END

/*·····················································
·· 7 ····Dinerito Vencido······························
·····················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ADineritoVencido') AND type ='U')
	Drop Table #ADineritoVencido

Select C2.Id,Sum(CP.Saldo) Vencido,C2.Mov, C2.MovId, C2.FechaEmision
Into #ADineritoVencido
From CxcPendiente CP With(NoLock) 
inner Join #AClienteFiltro Cliente on CP.Cliente = Cliente.Cliente
inner Join cxc C With(NoLock) on CP.Id = C.Id
inner Join cxc C2 With(NoLock) on C2.Mov = C.PadreMavi And C2.Movid = C.PadreIdMavi
where CP.Vencimiento < GetDate()
Group By C2.Id,C2.Mov, C2.MovId, C2.FechaEmision,C2.Id

/*···················································
·· 9 ····Exigible - Por Vencer····························
···················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#Exigible') AND type ='U')
	DROP TABLE #Exigible

CREATE TABLE #Exigible
	(
	IdMov		int,
	Mov			Varchar(20) null,
	MovId		Varchar(20) null,
	Exigible	Money null
	)

INSERT INTO #Exigible
SELECT C2.Idmov, C2.PadreMavi as mov, C2.PadreIdMavi as movid, sum(CP.Saldo) Exigible
FROM #AClientes c2
INNER JOIN cxc C With(NoLock) ON C2.PadreMavi = C.PadreMavi And C2.PadreIdMavi = C.PadreIdMavi
INNER JOIN CxcPendiente CP With(NoLock) ON CP.Id = C.Id
WHERE CP.Vencimiento BETWEEN @FeIni_cxc AND @FeFin_cxc
GROUP BY C2.Idmov,C2.PadreMavi, C2.PadreIdMavi
ORDER BY C2.PadreIdMavi

/*···················································
·· 8 ···········Moratorios···························
···················································*/
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AMoratorios') AND type ='U')
	Drop Table #AMoratorios

Select IdFactura, Mov, MovId,Sum(Moratorios) Moratorios
Into #AMoratorios
From TablaMoratoriosDoctos TMD With(NoLock)
Join Cxc C With(NoLock) on TMD.IdFactura = C.Id and Cliente In (Select Cliente From #AClienteFiltro)
Group by IdFactura, Mov, MovId

/*·····················································
·· 9 ·············Consulta Principal···················
······················································*/
Select Mov, Movid, total.Cliente, Nombre, NombreAval, RutaCobranza, total.Zona, AgenteCobrador, Case when mov  not like 'Seguro%' then ImporteVenta end ImporteVenta,
		Case when mov  not like 'Seguro%' then Cobros end Cobros, FechaEmision, Case when mov  not like 'Seguro%' then ImpporCapital end ImpporCapital, DiasVencidos,
		convert(float,DateDiff(Day,Case when IsNull(FechaEmision,'1986/02/20') > [1er Vencimiento] then 
				IsNull(FechaEmision,[1er Vencimiento]) else [1er Vencimiento] end,Getdate())) DiasInactivos,
		Domicilio, Cruces, Colonia, Poblacion, Articulo, Telefono, Case when mov  not like 'Seguro%' then Condicion end Condicion,
		total.NivelCobranza, ZCH.NivelCobranza,nor.NivOr NivelOrigen, Case when mov like 'Seguro%' then Vencido else ImpporCapital end SC, Vencido + Moratorios Vencido,
		Vencido CV, Moratorios, Case when mov like 'Seguro%' then Vencido + Moratorios else ImpporCapital + Moratorios  end SaldoTotal,
		OtrosCargos, isnull(Cargo,0) Monedero, ZCH.Region,total.DivisionAval, ZCH.Equipo, total.Estado, total.Exigible,total.Categoria,total.CanalVenta
From( --total
	Select C2.Mov, C2.MovId, C.Cliente, CTE.Nombre ,CTO.apellidopaterno+' '+CTO.apellidomaterno+' '+CTO.nombre  as NombreAval , MR.RutaCobranza,
		MR.Zona,MR.AgenteCobrador, C2.Importe+C2.Impuestos ImporteVenta, IsNull(Cobros.Cobros,0)+ IsNull( ACU.Abono,IsNull(AbonoUniTMP,0)) cobros,
	    IsNull( Max(Cobros.FechaEmision), IsNull(Max(ACU.MaviUltimoPago),Max(ACUITMP.UltimoPagoITMP)) ) FechaEmision, Sum(C.Saldo) ImpporCapital,
	    IsNull(M.Moratorios,0) Moratorios, DVT.DV DiasVencidos, IsNull(Max(C2.Vencimiento),'') [1er Vencimiento],
	    CT.Direccion+', '+CT.MAviNumero+' Int: '+IsNull(CT.MaviNumeroInterno,'S/N') Domicilio,CT.Cruces, CT.Colonia, CT.Poblacion, CT.Estado,
	    isnull(ats.Artdescripcion,'') Articulo, CTO.Telefonos Telefono, C2.Condicion, MR.NivelCobranza,IsNull(DineritoV.Vencido,0) Vencido,
	    IsNull(ACU.Cargos,0) OtrosCargos, Axp.Cargo, EX.Exigible,mr.Categoria,mr.CanalVenta,mr.DivisionAval
	From #AClientes MR
    left join ctecto cto With(NoLock) on cto.id = mr.idaval 
    left join ctectodireccion ct With(NoLock) on ct.id =cto.id and ct.tipo = 'particular' and ct.codigopostal != '0'
	join CXC C With(NoLock) on MR.Cliente = C.Cliente and C.PadreMavi = MR.PadreMavi And C.PadreIdMavi = MR.PadreIdMavi
	join CXC C2 With(NoLock) on C.PadreMavi = C2.Mov And C.PadreIdMavi = C2.Movid
    join CTE With(NoLock) on CTE.Cliente = C.Cliente
	left join #ADVTemp DVT on DVT.PadreMavi = C2.PadreMavi And DVT.PadreIdMavi = C2.PadreIdMavi
	left join #AMoratorios M On M.Mov = C2.Mov and M.MovId = C2.MovId
	left join BonifSiMavi BM With(NoLock) on BM.idcxc = C2.Id 
	left join #ACobros Cobros on Cobros.PadreMavi = C2.Mov And Cobros.PadreIdMavi = C2.MovId
	left join #ADineritoVencido DineritoV on DineritoV.Mov = C2.Mov and DineritoV.MovId = C2.Movid
	left join #AAbonoCargoUnicaja ACU on ACU.Mov = C2.Mov and ACU.MovId = C2.Movid
	left join #AACUnicajaIntTmp ACUITMP on ACUITMP.Mov = C2.Mov and ACUITMP.MovId = C2.Movid
    left join #Articulos ats on ats.padremavi = mr.padremavi and ats.padreidmavi = mr.padreidmavi 
    Left join AuxiliarP Axp With(NoLock) on mr.padremavi=Axp.Mov and mr.padreidmavi=Axp.MovId and Axp.Cargo is not NULL
	LEFT JOIN #Exigible EX ON EX.Mov = MR.Padremavi AND EX.MovId = MR.Padreidmavi
	Group By C2.Mov, C2.MovId, C.Cliente, CTE.Nombre, MR.RutaCobranza, MR.AgenteCobrador, C2.Importe + C2.Impuestos, Cobros.Cobros,
		ACU.Abono, M.Moratorios, DVT.DV, CT.Direccion, CT.MaviNumero, CT.MaviNumeroInterno, CT.Colonia, CT.Poblacion, ats.artDescripcion,
		C2.Condicion, MR.NivelCobranza, DineritoV.Vencido, ACU.Cargos, CTO.nombre, CTO.apellidopaterno, CTO.apellidomaterno,
		cto.Telefonos, ACUITMP.AbonoUniTMP, Axp.Cargo, ct.cruces, MR.Zona, CT.Estado, EX.Exigible,mr.Categoria,mr.CanalVenta,mr.DivisionAval
	Having Sum(C.Saldo) is not null
	)total
    LEFT JOIN ZonaCobranzaHis ZCH WITH(NOLOCK) ON ZCH.Zona = total.Zona AND ZCH.Ruta = total.rutaCobranza AND ZCH.NivelCobranza = total.nivelCobranza
											AND ZCH.Quincena = @Quincena AND ZCH.Ejercicio = @Ejercicio
    LEFT JOIN (
               select Cliente,max(NivelCobranza)NivOr from MaviRecuperacion
               where Ejercicio=@Ejercicio
               and Quincena=@Quincena
               group by Cliente
              )	NOR
             ON total.CLIENTE=NOR.Cliente										
Order By total.Cliente, FechaEmision



IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AClientes') AND type ='U')
	Drop Table #AClientes
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AClienteFiltro') AND type ='U')
	Drop Table #AClienteFiltro
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ADVTemp') AND type ='U')
	Drop Table #ADVTemp
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ACobros') AND type ='U')
	Drop Table #ACobros
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AAbonoCargoUnicaja') AND type ='U')
	Drop Table #AAbonoCargoUnicaja
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#ADineritoVencido') AND type ='U')
	Drop Table #ADineritoVencido
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AMoratorios') AND type ='U')
	Drop Table #AMoratorios
IF EXISTS(SELECT id FROM tempdb.sys.sysobjects WHERE id=OBJECT_ID('tempdb.dbo.#AACUnicajaIntTmp') AND type ='U')
	Drop Table #AACUnicajaIntTmp

End
