--Active Clients

Select top 100 *
From dbo.client

Select top 100 *
From dbo.ClientCampus

-- FACT CLIENT --

SELECT TOP 100
	c.ClientId
	,dbo.IsActiveClient(c.ClientId)						AS [ClientIsActive]
	,dbo.FirstShiftForClientAgency(c.ClientId, 4)		AS [KandaFirstShift]
	,dbo.LastShiftForClientAgency(c.ClientId, 4)		AS [KandaLastShift]
	,dbo.TotalAgencyHoursWorkedForClient(c.ClientId, 4)	AS [KandaTotalWorkerHours]
	,dbo.CountClientCampuses(c.ClientId)				AS [ClientCampuses]
	,c.PrimaryAgencyID
	,c.AccreditedFacilityStatus
	,c.NoLiftPolicyStatus
	,c.AcceptMidwifeStatus
	,c.ManualHandlingStatus
	,c.WorkingWithChildrenCheck
	,c.CriminalRecordCheckStatus
	,c.RequireOrientation
	,c.EnabledStatus
	,c.StatusChangedDate
FROM dbo.Client c
LEFT JOIN dbo.ClientAgency ca ON c.ClientId = ca.ClientID
LEFT JOIN dbo.Location l on c.LocationId = l.LocationId
LEFT JOIN dbo.Region r on l.RegionID = r.RegionID
where ca.AgencyID = 4

-- DIM CLIENT --

SELECT
	c.ClientId	AS [ClientId]
	,c.Name		AS [ClientName]
	,l.Name		AS [State]
	,r.Name		AS [Region]
	,c.CEO		AS [CEO]
	,c.DON		AS [DON]
FROM dbo.Client c
LEFT JOIN dbo.Location l on c.LocationId = l.LocationId
LEFT JOIN dbo.Region r on l.RegionID = r.RegionID
