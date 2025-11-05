select distinct(OutcomeType)
from dbo.Shift
Where StartDate >= DATEADD(year,-5,GETDATE()) and MemberID <> 1

-- FACT SHIFT --
SELECT top 100
	s.ShiftId
	,s.AgencyID
	,s.ClientId
	,s.MemberID
	,s.InvoiceID
	,s.PayslipID
	,s.CampusId
	,s.StartDate						AS [StartDateTime]
	,s.FinishDate						AS [FinishDateTime]
	,CAST(s.StartDate AS DATE)			AS [StartDate]
	,CAST(s.FinishDate AS DATE)			AS [FinishDate]
	,DATEDIFF(MINUTE, s.StartDate, s.FinishDate)	AS [ShiftDurationMins]
	,s.PayHrsPaid1
	,s.PayRate1
	,s.PayAmount1
	,s.PayHrsPaid2
	,s.PayRate2
	,s.PayAmount2
	,s.PaidMealBreakStatus
	,s.OrderedBy
	,dbo.FirstUpdateForShift(s.ShiftId) AS ShiftCreated
	,s.ConfirmedDate					AS ShiftConfirmed
	,dbo.LastUpdateForShift(s.ShiftId)	AS ShiftLastUpdated
	,dbo.isEducationShift(s.ShiftID)	AS [EducationShiftFlag]
	,o.description						AS [Outcome]
	,GETDATE()							AS [ExtractDate]
FROM dbo.Shift s
LEFT JOIN (
	select *
	from dbo.decode 
	where category = 'Outcome'
) o on s.OutcomeType = o.value 
where --s.AgencyID = 4 
	(s.MemberID <> 1 OR s.MemberID IS NULL) and
	s.StartDate >= DATEADD(year,-5,GETDATE())
	and s.ShiftID NOT IN (6495638, 6495680, 6496332)

select top 100 *
from dbo.decode
where Category like '%Outcome%'


-- this query shows that only matched shifts are added to dbo.shift. Need to work out how to count all shifts not just matched shifts. 
--select top 100 * 
--from (
--Select *
--	,ROW_NUMBER() OVER(
--		PARTITION BY ShiftId
--		Order by UpdateTime Asc) as rn
--	from dbo.ShiftAudit) sa
--where StartDate >= DATEADD(year,-5,GETDATE()) and RN = 1
