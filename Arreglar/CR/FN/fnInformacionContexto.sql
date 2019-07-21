SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER FUNCTION fnInformacionContexto
(
@bit				varchar(100)
)
RETURNS bit

AS BEGIN
DECLARE
@Estatus		bit,
@DosBigint		bigint
SET @Estatus = 0
SET @DosBigint = 2
IF @bit = 'SINCROIS' AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,0))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'CRM'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,1))  <> 0 SET @Estatus = 1 ELSE 
IF @bit = 'ECOMMERCE'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,2))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB4'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,3))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB5'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,4))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB6'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,5))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB7'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,6))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB8'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,7))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB9'     AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,8))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB10'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,9))  <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB11'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,10)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB12'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,11)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB13'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,12)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB14'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,13)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB15'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,14)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB16'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,15)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB17'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,16)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB18'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,17)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB19'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,18)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB20'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,19)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB21'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,20)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB22'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,21)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB23'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,22)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB24'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,23)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB25'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,24)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB26'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,25)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB27'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,26)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB28'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,27)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB29'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,28)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB30'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,29)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB31'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,30)) <> 0 SET @Estatus = 1 ELSE
IF @bit = 'LSB32'    AND (CONVERT(varbinary(8),CONTEXT_INFO()) & POWER(@DosBigint,31)) <> 0 SET @Estatus = 1
RETURN (@Estatus)
END

