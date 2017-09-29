USE [TRACKING_MAO_HOMOLOG]
GO

/****** Object:  StoredProcedure [dbo].[USP_GET_SHIPPINGPLAN_PARTIAL]    Script Date: 09/29/2017 16:30:39 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER PROCEDURE [dbo].[USP_GET_SHIPPINGPLAN_PARTIAL] @PONUMBER VARCHAR(10)--, @IMPORTER VARCHAR(10), @EXPORTER VARCHAR(10)

AS

SET DATEFORMAT DMY

--TRUNCATE TABLE SHIPPING_PLAN_HEADER
insert into SHIPPING_PLAN_HEADER

      ([PO]
      ,[IMPORTER]
      ,[USER]
      ,[PO_NUMBER]
      ,[PO_LINE]
      ,[ITEM]
      ,[DESCRIPTION]
      ,[QTY]
      ,[EXPORTER]
      ,[MOS]
      ,[INVOICE]
      ,[ETD]
      ,[CARRIER]
      ,[RTA]
      ,[RTD]) 
      
      SELECT  sp.[PO]
      ,sp.[IMPORTER]
      ,sp.[USER]
      ,sp.[PO_NUMBER]
      ,sp.[PO_LINE]
      ,sp.[ITEM]
      ,sp.[DESCRIPTION]
      ,sp.[QTY]
      ,sp.[EXPORTER]
      ,sp.[MOS]
      ,null
      ,null
      ,null
      ,sp.[PO RTA]
      ,null
  FROM [dbo].[VW_SHIPPING_PLAN_TELA] SP with (nolock)
  left join SHIPPING_PLAN_HEADER HE with (nolock)
  ON SP.PO_Number = HE.PO_NUMBER
  and SP.Item = HE.ITEM
  and sp.PO_Line = HE.PO_LINE
  where HE.PO_NUMBER is null
  
--select sp.PO_NUMBER, sp.ITEM, SP.PO_Line, sp.DESCRIPTION, sp.QTY, convert(varchar(10),sp.[RTA],103) as 'PO_RTA',
--case when part.ID is not null then part.Invoice else sp.Invoice end as Invoice,
--case when part.ID is not null then 
--	part.Invoice_Qty
--else
--	sp.InvoiceQty end as Invoice_Qty,
--case when part.Modal IS null OR part.Modal = '' then sp.MOS else part.Modal end as MOS,
--case when part.ID is not null then 
--	case when part.Modal = 'AIR' then null else part.carrier end
--else 
--	sp.carrier end as Carrier,
--case when part.ID is not null then
--	case when part.ETD is not null then convert(varchar(10),part.ETD,103) else null end
--else
--	case when sp.ETD is not null then convert(varchar(10),sp.ETD,103) else null end end as ETD, 
--case when part.ID is not null then
--	case when part.RTD is not null then convert(varchar(10),part.RTD,103) else null end
--else
--	case when sp.RTD is not null then convert(varchar(10),sp.RTD,103) else null end end as RTD, 
--part.ID,
--case when part.Balance is null then (case when  sp.Balance is null then sp.QTY else sp.balance end) else part.Balance end as 'Balance'
----case when (sum(case when part.Balance is null then 0 else part.Balance end)) = 0 then sp.QTY 
----else sum(case when part.Balance is null then 0 else part.Balance end)end as 'Balance'
--from SHIPPING_PLAN_HEADER sp with (nolock)
--left join dbo.ShippingPlan_Partial part with (nolock)
--on sp.PO_NUMBER = part.PO_Number
--and sp.ITEM = part.Item
--and sp.po_line = part.po_line
--right join VW_SHIPPING_PLAN_TELA sp_tela
--on (sp_tela.PO_NUMBER = sp.PO_NUMBER and sp_tela.ITEM = sp.ITEM and sp_tela.PO_LINE = sp.PO_LINE)
----where sp.PO_NUMBER = '1085549'
--WHERE SP.PO_NUMBER = @PONUMBER
--group by
--sp.PO_NUMBER, sp.PO_Line, sp.ITEM, sp.DESCRIPTION, sp.QTY, sp.Balance, sp.[RTA],
--part.Invoice, sp.INVOICE, part.Invoice_Qty, sp.InvoiceQty, sp.MOS, part.Modal, part.Carrier, sp.CARRIER,
--part.ETD, sp.ETD, part.RTD, sp.RTD, part.Balance, part.ID
--ORDER BY sp.ITEM, part.ID  asc


select sp.PO_NUMBER, 
sp.ITEM, 
CASE WHEN PART.PO_Line IS NULL THEN SP.PO_Line ELSE PART.PO_Line end AS PO_Line, 
sp.DESCRIPTION, 
sp.QTY, 
convert(varchar(10),sp.[RTA],103) as 'PO_RTA',
case when part.ID is not null then part.Invoice else sp.Invoice end as Invoice,
case when part.ID is not null then 
	part.Invoice_Qty
else
	sp.InvoiceQty end as Invoice_Qty,
case when part.Modal IS null OR part.Modal = '' then sp.MOS else part.Modal end as MOS,
case when part.ID is not null then 
	case when part.Modal = 'AIR' then null else part.carrier end
else 
	sp.carrier end as Carrier,
case when part.ID is not null then
	case when part.ETD is not null then convert(varchar(10),part.ETD,103) else null end
else
	case when sp.ETD is not null then convert(varchar(10),sp.ETD,103) else null end end as ETD, 
case when part.ID is not null then
	case when part.RTD is not null then convert(varchar(10),part.RTD,103) else null end
else
	case when sp.RTD is not null then convert(varchar(10),sp.RTD,103) else null end end as RTD, 
part.ID,
case when part.Balance is null then (case when  sp.Balance is null then sp.QTY else sp.balance end) else part.Balance end as 'Balance',

CASE WHEN sp.ETD IS NOT NULL  THEN CONVERT(VARCHAR(10),sp.ETD+LT.TransitTimeFornecedorPedido,103) 
ELSE CONVERT(VARCHAR(10),part.ETD+LT.TransitTimeFornecedorPedido,103) END AS ETA,

CASE WHEN sp.ETD is NOT NULL THEN  case when (convert(int,sp.[RTA]) - CONVERT(int,sp.ETD+LT.TransitTimeFornecedorPedido))<0 THEN 'NG'
when (convert(int,sp.[RTA]) - CONVERT(int,sp.ETD+LT.TransitTimeFornecedorPedido))>0 THEN 'ANTECIPATE'
else 'OK' end 

when part.ETD is not NULL THEN  case when (convert(int,sp.[RTA]) - CONVERT(int,part.ETD+LT.TransitTimeFornecedorPedido))<0 THEN 'NG'
when (convert(int,sp.[RTA]) - CONVERT(int,part.ETD+LT.TransitTimeFornecedorPedido))>0 THEN 'ANTECIPATE'
else 'OK' end 
end as [STATUS],

case when part.Reason is not null then part.Reason else sp.Reason end as Reason,

case when part.ReasonComments is not null then part.ReasonComments else sp.ReasonComments end as ReasonComments



--case when (sum(case when part.Balance is null then 0 else part.Balance end)) = 0 then sp.QTY 
--else sum(case when part.Balance is null then 0 else part.Balance end)end as 'Balance'
from SHIPPING_PLAN_HEADER sp
left join dbo.ShippingPlan_Partial part
on sp.PO_NUMBER = part.PO_Number
and sp.ITEM = part.Item
--and sp.po_line = part.po_line
right join VW_SHIPPING_PLAN_TELA sp_tela
on (sp_tela.PO_NUMBER = sp.PO_NUMBER and sp_tela.ITEM = sp.ITEM and sp_tela.PO_LINE = sp.PO_LINE)
--where sp.PO_NUMBER = '1085549'
INNER JOIN Exportador EX with (nolock)
ON EX.ExpSigla = sp_tela.EXPORTER
left join dbo.VW_TRANSIT_TIME_EXPORTADOR LT with (nolock)
ON LT.[numCodigoDoExportador] = EX.numCodigoDoExportador
and LT.txtViaDeTransporte = sp_tela.MOS

where SP.PO_NUMBER = @PONUMBER
--AND SP.ITEM = '17365KVS F000'
group by
sp.PO_NUMBER, sp.PO_Line, part.PO_Line, sp.ITEM, sp.DESCRIPTION, sp.QTY, sp.Balance, sp.[RTA],
part.Invoice, sp.INVOICE, part.Invoice_Qty, sp.InvoiceQty, sp.MOS, part.Modal, part.Carrier, sp.CARRIER,
part.ETD, sp.ETD, part.RTD, sp.RTD, part.Balance, part.ID,LT.TransitTimeFornecedorPedido,sp.Reason,sp.ReasonComments,part.Reason,part.ReasonComments
ORDER BY sp.ITEM, part.ID  asc




GO


