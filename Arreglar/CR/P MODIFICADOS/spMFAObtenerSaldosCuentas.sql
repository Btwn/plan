SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE [dbo].[spMFAObtenerSaldosCuentas](@Empresa varchar(5), @Ejercicio int)

AS
BEGIN
SELECT cta.cuentacontable cuenumero, isnull(cta.sainicial,0) sainicial, isnull(tt.Sade11,0) sade11,isnull(tt.Saha11,0) saha11,isnull(tt.Sade12,0) sade12,isnull(tt.Saha12,0) saha12,isnull(tt.Sade13,0) sade13,isnull(tt.Saha13,0) saha13,
isnull(tt.Sade14,0) sade14,isnull(tt.Saha14,0) saha14,isnull(tt.Sade15,0) sade15,isnull(tt.Saha15,0) saha15,isnull(tt.Sade16,0) sade16,isnull(tt.Saha16,0) saha16,isnull(tt.Sade17,0) sade17,isnull(tt.Saha17,0) saha17,
isnull(tt.Sade18,0) sade18,isnull(tt.Saha18,0) saha18,isnull(tt.Sade19,0) sade19,isnull(tt.Saha19,0) saha19,isnull(tt.Sade20,0) sade20,isnull(tt.Saha20,0) saha20,isnull(tt.Sade21,0) sade21,isnull(tt.Saha21,0) saha21,
isnull(tt.Sade22,0) sade22,isnull(tt.Saha22,0) saha22, 0 Sade23, 0 Saha23, 0 Sade24, 0 Saha24 FROM
(
Select cc.cuentacontable, si.saldoinicial sainicial from cuentascontables cc WITH (NOLOCK)  left join saldosini si  WITH (NOLOCK) on cc.cuentacontable = si.cuentacontable
where si.empresa = @Empresa and si.anio = @Ejercicio
) as cta
LEFT OUTER JOIN
(
select distinct t0.cuentacontable, t1.Sade11,t0.Saha11,t1.Sade12,t0.Saha12,t1.Sade13,t0.Saha13,t1.Sade14,t0.Saha14,t1.Sade15,t0.Saha15,t1.Sade16,t0.Saha16,t1.Sade17,t0.Saha17,t1.Sade18,t0.Saha18,t1.Sade19,t0.Saha19,t1.Sade20,t0.Saha20,t1.Sade21,t0.Saha21,t1.Sade22,t0.Saha22 from (
select cuentacontable, sum(isnull([1],0)) Saha11,sum(isnull([2],0)) Saha12,sum(isnull([3],0)) Saha13,sum(isnull([4],0)) Saha14,sum(isnull([5],0)) Saha15,sum(isnull([6],0)) Saha16,sum(isnull([7],0)) Saha17,sum(isnull([8],0)) Saha18,sum(isnull([9],0)) Saha19,sum(isnull([10],0)) Saha20,sum(isnull([11],0)) Saha21,sum(isnull([12],0)) Saha22 from movcontables WITH (NOLOCK) 
pivot (
sum (Abono) for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) as mes
where anio = @Ejercicio and Empresa = @Empresa
group by cuentacontable
) as t0
inner join
(
select cuentacontable, sum(isnull([1],0)) Sade11,sum(isnull([2],0)) Sade12,sum(isnull([3],0)) Sade13,sum(isnull([4],0)) Sade14,sum(isnull([5],0)) Sade15,sum(isnull([6],0)) Sade16,sum(isnull([7],0)) Sade17,sum(isnull([8],0)) Sade18,sum(isnull([9],0)) Sade19,sum(isnull([10],0)) Sade20,sum(isnull([11],0)) Sade21,sum(isnull([12],0)) Sade22 from movcontables WITH (NOLOCK) 
pivot (
sum (Cargo) for mes in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12])
) as mes
where anio = @Ejercicio and Empresa = @Empresa
group by cuentacontable
) as t1 on t0.cuentacontable = t1.cuentacontable
) as tt on tt.cuentacontable = cta.cuentacontable
RETURN
END

