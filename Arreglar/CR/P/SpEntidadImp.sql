SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE dbo.SpEntidadImp
@Entidad                                varchar(30)

AS BEGIN
SELECT DISTINCT
v.valor
FROM PersonalPropValor v, Personal p, Sucursal s
WHERE v.propiedad = '% Impuesto Nominas'
AND v.Cuenta = S.Sucursal
AND V.Rama = 'SUC'
AND S.Sucursal = P.SucursalTrabajo
AND S.Estado = @Entidad
AND V.Valor <> '0'
END

