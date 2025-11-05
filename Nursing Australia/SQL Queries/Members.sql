--FACT WORKFORCE---

SELECT top 100
	m.MemberID 															AS [MemberId]
	,dbo.IsActiveMember(m.MemberID)										AS [ActiveMemberFlag]
	,dbo.IsActiveDoctor(m.MemberID)										AS [ActiveDoctorFlag]
	,dbo.IsActiveNurse(m.MemberID)										AS [ActiveNurseFlag]
	,dbo.MemberTotalShiftsWorkedForAgencyHrs(m.MemberID, 4)				AS [TotalHoursWorkedNursingAustralia]
	,CAST(dbo.MemberJoined(m.MemberID) AS DATE)							AS [EmploymentStartDate]
	,dbo.FirstShiftForMember(m.MemberID)								AS [FirstShiftDate]
	,dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, 365, GETDATE()))	AS [LastShiftDate]
	,dbo.NextShiftForMember(m.MemberID, GETDATE())						AS [NextShiftDate]
	,CASE
		WHEN mp.VISAExpiryDate is not null THEN 1
		ELSE 0
	END																	AS [OnVisaFlag]
	,mp.VISAExpiryDate													AS [VisaExpiryDate]
	,CASE
		WHEN ma.ExitReasonId IS NULL OR 
			dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, -182, GETDATE())) IS NOT NULL  then dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, 365, GETDATE()))
			--if last shift was greater than 6 months ago assume the worker no longer takes shifts with us
		ELSE null
	END																	AS [TerminationDate]
	,CASE
		WHEN ma.ExitReasonId IS NULL OR 
			dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, -182, GETDATE())) IS NOT NULL  then 'Agency Termination' 
			--if last shift was greater than 6 months ago assume the worker no longer takes shifts with us
		ELSE null
	END																	AS [TerminationType]
	,m.BirthDate														AS [DateOfBirth]
	,GETDATE()															AS [ExtractDate]
		,CAST(CASE
		WHEN CAST(dbo.MemberJoined(m.MemberID) AS DATE) IS NOT NULL AND
			CAST(dbo.FirstShiftForMember(m.MemberID) AS DATE) IS NULL
			THEN 1
		ELSE 0
	END	AS BIT)																AS [NeverStartFlag]
FROM dbo.member m
LEFT JOIN dbo.MemberContact mc ON m.MemberID = mc.MemberID
LEFT JOIN dbo.MemberProfile mp ON m.MemberID = mp.MemberID
LEFT JOIN (
	SELECT * 
	FROM dbo.MemberAgency 
	WHERE AgencyID = 4
) ma ON ma.MemberID = m.MemberID
WHERE m.MemberID not in (1, 54326, 56116, 56961, 54389, 54334, 54328, 54193)


select top 100 *
from dbo.MemberAgency

select * 
from dbo.Decode
where Category like 'What%'

--DIM WORKFORCE--
select 
	m.MemberID										as [MemberId]
	,m.GivenName									as [FirstName]
	,m.Surname										AS [LastName]
	,dbo.MemberOutletName(m.MemberID)				as [Location]
	,dbo.php_UserFullName(ma.AgencyRepresentative)	as [PrimaryManager]
	,d.[Description]								as [TerminationReason]
	,case
		when ma.ExitReasonId is not null OR 
			dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, -182, GETDATE())) IS NOT NULL then 'Terminated'
		else null
	end												as [EmploymentStatus]
	,a.[Name]										as [EmployingEntity]
	,v.Name											as [VisaType]
	,'No'											as [IsManagerFlag]
	,m.GivenName + ' ' + m.Surname					as [FullName]
	,CASE 
		WHEN m.sex = 'F' THEN 'Female'
		WHEN m.sex = 'M' THEN 'Male' 
		END											as [Gender]
	,mc.Postcode									as [EmployeeAddressPostcode]
	,w.Description									as [WhatPromptedYou]
	,GETDATE()										as [ExtractDate]	
	,l.Name											AS [State]
from dbo.member m
left join dbo.MemberContact mc on m.MemberID = mc.MemberID
left join dbo.MemberProfile mp on m.MemberID = mp.MemberID
LEFT JOIN dbo.location l ON m.LocationID = l.LocationId
left join dbo.Visa v on mp.VISAType = v.VisaID
left join (
	select * 
	from dbo.MemberAgency 
	where AgencyID = 4
) ma on ma.MemberID = m.MemberID
left join (
	select *
	from dbo.decode 
	where category = 'Exit Reason'
)d on ma.ExitReasonId = d.value 
LEFT JOIN (
	select *
	from dbo.decode 
	where category = 'What Prompted You'
) w on ma.ExitReasonId = w.value 
left join dbo.Agency a on ma.AgencyID = a.AgencyID
where m.MemberID not in (1, 54326, 56116, 56961, 54389, 54334, 54328, 54193) 

--DIM JOB HISTORY --
SELECT 
	'Agency Nursing Australia'				AS [JobTitle]
	,CASE
		WHEN m.EmploymentType = '' then null
		else m.EmploymentType
	END										AS [EmploymentType]
	,CAST(dbo.FirstShiftForMember(m.MemberID) AS DATE)	AS [Start Date]
	,CAST(dbo.LastShiftForMember(m.MemberID, DATEADD(DAY, 365, GETDATE())) AS DATE)	AS [End date]
	,NULL									AS [Contract type]
	,'HR' + CAST(m.MemberID as varchar)		AS [Member ID]
	,a.[Name]								AS [Employing entity]
	,GETDATE()								AS [Extract Date]
	,'agy'									AS [Source Entity]
	,0										AS MemberLatestJobFlag
from dbo.member m
left join (
	select * 
	from dbo.MemberAgency 
	where AgencyID = 4
) ma on ma.MemberID = m.MemberID
left join dbo.Agency a on ma.AgencyID = a.AgencyID
	where m.MemberID <> 1 and ma.AgencyID = 4

--FACT FIRST SHIFT--
WITH FirstShifts AS(
	select
		m.MemberID	as [MemberId]
		,dbo.FirstShiftForMember(m.MemberID)	as [First Shift Date]
		,GETDATE()				as [ExtractDatetime]
	from dbo.member m
	where m.MemberID <> 1 )
Select *
From FirstShifts
where [First Shift Date] IS NOT NULL


select top 100 * 
from dbo.Member
where surname like '%member%'