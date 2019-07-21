SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spSetInformacionContexto
@bit		varchar(50),
@Accion		bit = 1

AS BEGIN
DECLARE
@InformacionContexto		bigint,
@DosBigint					bigint,
@MiContext_Info				varbinary(128)
SELECT @DosBigint = 2
SET @InformacionContexto = ISNULL(CONVERT(int,CONVERT(varbinary(8),CONTEXT_INFO())), 0)
IF @bit = 'SINCROIS'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,0) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,0)
END ELSE
IF @bit = 'CRM' 
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,1) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,1)
END ELSE
IF @bit = 'ECOMMERCE'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,2) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,2)
END ELSE
IF @bit = 'LSB4'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,3) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,3)
END ELSE
IF @bit = 'LSB5'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,4) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,4)
END ELSE
IF @bit = 'LSB6'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,5) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,5)
END ELSE
IF @bit = 'LSB7'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,6) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,6)
END ELSE
IF @bit = 'LSB8'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,7) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,7)
END ELSE
IF @bit = 'LSB9'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,8) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,8)
END ELSE
IF @bit = 'LSB10'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,9) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,9)
END ELSE
IF @bit = 'LSB11'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,10) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,10)
END ELSE
IF @bit = 'LSB12'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,11) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,11)
END ELSE
IF @bit = 'LSB13'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,12) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,12)
END ELSE
IF @bit = 'LSB14'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,13) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,13)
END ELSE
IF @bit = 'LSB15'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,14) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,14)
END ELSE
IF @bit = 'LSB16'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,15) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,15)
END ELSE
IF @bit = 'LSB17'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,16) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,16)
END ELSE
IF @bit = 'LSB18'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,17) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,17)
END ELSE
IF @bit = 'LSB19'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,18) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,18)
END ELSE
IF @bit = 'LSB20'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,19) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,19)
END ELSE
IF @bit = 'LSB21'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,20) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,20)
END ELSE
IF @bit = 'LSB22'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,21) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,21)
END ELSE
IF @bit = 'LSB23'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,22) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,22)
END ELSE
IF @bit = 'LSB24'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,23) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,23)
END ELSE
IF @bit = 'LSB25'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,24) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,24)
END ELSE
IF @bit = 'LSB26'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,25) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,25)
END ELSE
IF @bit = 'LSB27'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,26) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,26)
END ELSE
IF @bit = 'LSB28'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,27) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,27)
END ELSE
IF @bit = 'LSB29'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,28) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,28)
END ELSE
IF @bit = 'LSB30'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,29) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,29)
END ELSE
IF @bit = 'LSB31'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,30) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,30)
END ELSE
IF @bit = 'LSB32'
BEGIN
IF @Accion = 1 AND dbo.fnInformacionContexto(@bit) = 0 SET @InformacionContexto = @InformacionContexto + POWER(@DosBigint,31) ELSE
IF @Accion = 0 AND dbo.fnInformacionContexto(@bit) = 1 SET @InformacionContexto = @InformacionContexto - POWER(@DosBigint,31)
END
SET @MiContext_Info = ISNULL(CONVERT(varbinary(128),@InformacionContexto),0X0)
SET Context_Info @MiContext_Info
END

