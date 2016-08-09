--Tipo Documento;fecha;Nombre cliente;Direccion;Comuna;Ciudad;Telefono;Giro;1;Rut;Digito Verificador;2;3;4;5;Cantidad Articulos;Neto;;Iva;;Total
use starpmshotel

DECLARE @FolioNumber AS nvarchar(30)
SET @FolioNumber = '1016226'

SELECT
-- R.*,
top 1
'33' as [DocumentType],--Tipo Documento;
';' AS [Separator],
GETDATE() as [Date], --fecha;
';' AS [Separator],
G.last_ +' ' + G.first_ as [Name],  --Nombre cliente;
';' AS [Separator],
G.address1_ As [Address], -- Direccion;
';' AS [Separator],
'Comuna' AS [Comuna],  --Comuna;
';' AS [Separator],
'Ciudad' AS [City],  --Ciudad;
';' AS [Separator],
G.telephone_ AS [Phone], --Telefono;
';' AS [Separator],
'Giro' as [Giro], --Giro;
';' AS [Separator],
';' AS [Empty1],
';'  AS [RUT], 
';;' AS [VerifyDigit],
';' AS [Empty2],
';' AS [Empty3],
';' AS [Empty4],
';' AS [Empty5]
FROM Folio F
INNER JOIN RESERVATION R ON R.id_reservation = F.id_Reservation
INNER JOIN guest g on g.id_guest = R.id_Guest
--INNER JOIN COUNTRY CU ON CU.id_country = g.
--INNER JOIN city ct on ct.id_city = g.city_
INNER JOIN FOLIO_ITEM FI ON FI.id_Folio = F.id_Folio
INNER JOIN EVENT EV ON EV.id_Event = FI.id_Event
INNER JOIN SERVICE S ON S.id_service = EV.id_service
where F.folionumber_ = @FolioNumber
--WHERE  R.id_reservation = 15818 --10456 --15818 --F.id_Guest is not null

 
--select * from tax 
 -- Cantidad Articulos;Neto;;Iva;;Total
SELECT 
count (EV.Value_) AS [Items],
';' AS [Separator],
round ((SUM (EV.value_))/1.19,0) AS [Neto], --round (SUM (EV.value_)- (SUM (EV.value_))/1.19,0) AS [Tax], 
';;' AS [Separator],
round (SUM (EV.value_)- (SUM (EV.value_))/1.19,0) AS [Tax],   -- SUM (FI.tax) AS [Tax],
';;' AS [Separator],
SUM (EV.value_) + SUM (FI.tax) AS [Total],
SUM (EV.value_) AS [Total1]
 from folio F
inner join Folio_item FI ON FI.id_folio = F.id_folio
inner join event ev on ev.id_event = fi.id_event AND EV.Class IN (1,3) 
where folionumber_ = @FolioNumber


-- Lineas Detalle;Codigo;Cantidad;Descripcion Articulo;Valor;;;;Valor;;;;;;;;;;;;
SELECT 
S.DepCode_ AS [Code],
';' AS [Separator],
EV.Quantity_ AS [Quantity],
';' AS [Separator],
S.Name_ AS [Description], 
';' AS [Separator],
EV.Value_ AS [Value],
';;;;' AS [Separator],
EV.Value_ AS [Value],
';;;;;;;;;;;;' AS [Separator]
 from folio F
inner join Folio_item FI ON FI.id_folio = F.id_folio
inner join event ev on ev.id_event = fi.id_event AND EV.Class IN ( 1,3)
Inner Join SERVICE S ON S.id_Service = Ev.id_Service
where folionumber_ = @FolioNumber
