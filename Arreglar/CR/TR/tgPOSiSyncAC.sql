SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER TRIGGER tgPOSiSyncAC ON POSiSync

FOR INSERT,UPDATE
AS BEGIN
DECLARE
@EsOrigenA            bit,
@EsOrigenB            bit,
@SincronizaArtSucA    bit,
@SincronizaArtSucB    bit
SELECT @EsOrigenA = ISNULL(EsOrigen,0), @SincronizaArtSucA =  ISNULL(SincronizaArtSuc,0)  FROM INSERTED
SELECT @EsOrigenB = ISNULL(EsOrigen,0), @SincronizaArtSucB =  ISNULL(SincronizaArtSuc,0)   FROM DELETED
IF @EsOrigenA = 1 AND @SincronizaArtSucA = 1
BEGIN
EXEC sxActivarPOSArtSucursal 1
END
IF @EsOrigenA = 1 AND @SincronizaArtSucA = 0
BEGIN
EXEC sxActivarPOSArtSucursal 0
END
IF @EsOrigenA = 0 AND @SincronizaArtSucA = 0
BEGIN
EXEC sxActivarPOSArtSucursal 0
END
IF @EsOrigenA = 0 AND @SincronizaArtSucA = 1
BEGIN
EXEC sxActivarPOSArtSucursal 0
END
END

