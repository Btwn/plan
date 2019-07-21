SET DATEFIRST 7
SET ANSI_NULLS OFF
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
SET LOCK_TIMEOUT -1
SET QUOTED_IDENTIFIER OFF
SET NOCOUNT ON
SET IMPLICIT_TRANSACTIONS OFF
GO
ALTER PROCEDURE xpCFDFlexValidarXML
(
@XML			varchar(MAX),
@Ok			int OUTPUT,
@OkRef		varchar(255) OUTPUT
)
AS
BEGIN
IF CHARINDEX('<detallista:orderIdentification><detallista:referenceIdentification type="ON"/>',@XML,1) >0
OR CHARINDEX('<detallista:orderIdentification><detallista:referenceIdentification type="ON"></detallista:referenceIdentification>',@XML,1) >0
SELECT @Ok=71600 ,@OkRef = '<detallista:orderIdentification><detallista:referenceIdentification type="ON"/>'
IF CHARINDEX('<detallista:referenceIdentification type="ATZ"></detallista:referenceIdentification>',@XML,1) >0
OR CHARINDEX('<detallista:referenceIdentification type="ATZ"/>',@XML,1) >0
SELECT @Ok=71600 ,@OkRef = '<detallista:referenceIdentification type="ATZ"/>'
IF CHARINDEX('<detallista:alternatePartyIdentification type="SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"></detallista:alternatePartyIdentification>',@XML,1) >0
OR CHARINDEX('<detallista:alternatePartyIdentification type="SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"/>',@XML,1) >0
SELECT @Ok=71600 ,@OkRef = '<detallista:alternatePartyIdentification type="SELLER_ASSIGNED_IDENTIFIER_FOR_A_PARTY"/>'
IF CHARINDEX('<detallista:alternateTradeItemIdentification type="SUPPLIER_ASSIGNED"></detallista:alternateTradeItemIdentification>',@XML,1) >0
OR CHARINDEX('<detallista:alternateTradeItemIdentification type="SUPPLIER_ASSIGNED"/>',@XML,1) >0
SELECT @Ok=71600 ,@OkRef = '<detallista:alternateTradeItemIdentification type="SUPPLIER_ASSIGNED"/>'
END

