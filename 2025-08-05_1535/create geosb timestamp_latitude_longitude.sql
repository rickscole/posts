SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [geosb].[timestamp_latitude_longitude](
	[id] [smallint] NULL,
	[timestamp] [datetime2](7) NULL,
	[latitude] [float] NULL,
	[longitude] [float] NULL
) ON [PRIMARY]
GO
