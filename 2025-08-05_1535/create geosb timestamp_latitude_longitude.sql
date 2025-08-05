SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [geosb].[synthetic_movement_dataset_anomalous](
	[id] [smallint] NULL,
	[timestamp] [datetime2](7) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL
) ON [PRIMARY]
GO
