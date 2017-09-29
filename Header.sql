USE [TRACKING_MAO_HOMOLOG]
GO

/****** Object:  Table [dbo].[SHIPPING_PLAN_HEADER]    Script Date: 09/29/2017 16:29:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[SHIPPING_PLAN_HEADER](
	[PO] [varchar](3) NULL,
	[IMPORTER] [varchar](3) NULL,
	[USER] [varchar](20) NULL,
	[PO_NUMBER] [varchar](50) NOT NULL,
	[PO_LINE] [int] NOT NULL,
	[ITEM] [varchar](50) NOT NULL,
	[DESCRIPTION] [varchar](100) NULL,
	[QTY] [decimal](18, 4) NULL,
	[EXPORTER] [varchar](20) NULL,
	[MOS] [varchar](3) NULL,
	[INVOICE] [varchar](20) NULL,
	[INVOICEQTY] [decimal](18, 4) NULL,
	[ETD] [datetime] NULL,
	[CARRIER] [varchar](50) NULL,
	[RTA] [datetime] NULL,
	[RTD] [datetime] NULL,
	[Balance] [decimal](18, 4) NULL,
	[Reason] [varchar](50) NULL,
	[ReasonComments] [varchar](200) NULL,
 CONSTRAINT [PK_SHIPPING_PLAN_HEADER] PRIMARY KEY CLUSTERED 
(
	[PO_NUMBER] ASC,
	[PO_LINE] ASC,
	[ITEM] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


