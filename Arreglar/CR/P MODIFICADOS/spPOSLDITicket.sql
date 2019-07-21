SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE spPOSLDITicket
@ID	            varchar(36),
@IDLog          int,
@Estacion       int,
@Bandera2		bit = 0

AS
BEGIN
DECLARE
@Comprobante	varchar(max),
@Campo			varchar(255),
@IDt			int,
@Bandera		bit,
@Campo2			varchar(255),
@IDt2			int
SELECT @Comprobante = Comprobante
FROM POSLDIlog WITH(NOLOCK)
WHERE IDModulo = @ID
IF @Comprobante IS NULL
BEGIN
SELECT @IDLog = MAX(ID)
FROM POSLDILog WITH(NOLOCK)
WHERE IDModulo = @ID
SELECT @Comprobante = Comprobante
FROM POSLDIlog WITH(NOLOCK)
WHERE IDModulo = @ID AND ID = @IDLog
END
IF EXISTS (SELECT * FROM POSLDITicket WITH(NOLOCK) WHERE RID = @ID)
DELETE POSLDITicket WHERE RID = @ID
IF SUBSTRING(@Comprobante,465,12) = '@br@br@br@br'
SELECT @Comprobante = substring(@Comprobante,1,464)
IF SUBSTRING(@Comprobante,1,6)='@Logo1'
BEGIN
INSERT  POSLDITicket(
Estacion, RID, Campo)
SELECT
@Estacion, @ID, Campo
FROM dbo.fnPOSGenerarTicket(@Comprobante,'@')
DECLARE crBC1 CURSOR LOCAL FOR
SELECT plt.ID, plt.Campo
FROM POSLDITicket plt
WHERE plt.RID = @ID
OPEN crBC1
FETCH NEXT FROM crBC1 INTO @IDt, @Campo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @Bandera = 0
SELECT @Campo = REPLACE(@Campo,'Logo1', '' ), @Bandera = 1
SELECT @Campo = REPLACE(@Campo,'cnb ', '' ), @Bandera = 1
IF @Campo LIKE '%cnn%'
SELECT @Campo = REPLACE(@Campo,'cnn ', '' ), @Bandera = 1
IF @Campo LIKE '%br%'
SELECT @Campo = REPLACE(@Campo,'br ', '' ), @Bandera = 1
SELECT @Campo = REPLACE(@Campo,'br', '' ), @Bandera = 1
IF @Campo LIKE '%lnn%'
SELECT @Campo = REPLACE(@Campo,'lnn ', '' ), @Bandera = 1
IF @Campo LIKE '% br br br br br br br br%'
SELECT @Campo = REPLACE(@Campo,'br br br br br br br br', '' ), @Bandera = 1
IF @Bandera = 1
UPDATE POSLDITicket WITH(ROWLOCK) SET Campo = @Campo WHERE RID = @ID AND ID = @IDt
END
FETCH NEXT FROM crBC1 INTO @IDt, @Campo
END
CLOSE crBC1
DEALLOCATE crBC1
IF @Bandera2 = 1 AND EXISTS (SELECT * FROM POSLDITicket WITH(NOLOCK) WHERE RID = @ID AND Campo LIKE '%C-O-M-E-R-C-I-O%')
BEGIN
SELECT @IDt2 = ID, @Campo2 = Campo
FROM POSLDITicket WITH(NOLOCK)
WHERE RID = @ID AND Campo LIKE '%C-O-M-E-R-C-I-O%'
SELECT @Campo2 = REPLACE(@Campo2,'C-O-M-E-R-C-I-O', 'C-L-I-E-N-T-E')
UPDATE POSLDITicket WITH(ROWLOCK) SET Campo = @Campo2 WHERE RID = @ID AND ID = @IDt2
END
END
ELSE IF substring(@Comprobante,6,1)='B' 
BEGIN
INSERT  POSLDITicket(
Estacion, RID, Campo)
SELECT
@Estacion, @ID, Campo
FROM dbo.fnPOSGenerarTicket(@Comprobante,'@')
DECLARE crBC1 CURSOR LOCAL FOR
SELECT plt.ID, plt.Campo
FROM POSLDITicket plt
WHERE plt.RID = @ID
OPEN crBC1
FETCH NEXT FROM crBC1 INTO @IDt, @Campo
WHILE @@FETCH_STATUS <> -1
BEGIN
IF @@FETCH_STATUS <> -2
BEGIN
SET @Bandera = 0
IF @Campo LIKE '%cnb%' AND @Bandera = 0
SELECT @Campo = REPLACE(@Campo,'cnb', '          ' ), @Bandera = 1
IF @Campo LIKE '%cnn%' AND @Bandera = 0
SELECT @Campo = REPLACE(@Campo,'cnn', '' ), @Bandera = 1
IF @Campo LIKE 'br%' AND @Bandera = 0
SELECT @Campo = REPLACE(@Campo,'br', '' ), @Bandera = 1
IF @Campo LIKE '%lnn%' AND @Bandera = 0
SELECT @Campo = REPLACE(@Campo,'lnn', '' ), @Bandera = 1
IF @Bandera = 1
UPDATE POSLDITicket WITH(ROWLOCK) SET Campo = @Campo WHERE RID = @ID AND ID = @IDt
END
FETCH NEXT FROM crBC1 INTO @IDt, @Campo
END
CLOSE crBC1
DEALLOCATE crBC1
END
ELSE
BEGIN	
INSERT  POSLDITicket(
Estacion, RID, Campo)
SELECT
@Estacion, @ID, Campo
FROM dbo.fnPOSGenerarTicket(@Comprobante,'<BR>')
END
END

