USE [TRACKING_MAO_HOMOLOG]
GO

/****** Object:  Table [dbo].[ShippingPlan_Partial]    Script Date: 09/29/2017 16:29:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ShippingPlan_Partial](
	[ID] [int] NOT NULL,
	[PO_Number] [varchar](50) NOT NULL,
	[Item] [varchar](25) NOT NULL,
	[PO_Line] [int] NOT NULL,
	[Invoice] [varchar](30) NULL,
	[Invoice_Qty] [decimal](18, 4) NULL,
	[Modal] [varchar](3) NULL,
	[Carrier] [varchar](50) NULL,
	[ETD] [datetime] NULL,
	[RTD] [datetime] NULL,
	[Balance] [decimal](18, 4) NULL,
	[Reason] [varchar](50) NULL,
	[ReasonComments] [varchar](200) NULL,
 CONSTRAINT [PK_ShippingPlan_Partial] PRIMARY KEY CLUSTERED 
(
	[ID] ASC,
	[PO_Number] ASC,
	[Item] ASC,
	[PO_Line] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


