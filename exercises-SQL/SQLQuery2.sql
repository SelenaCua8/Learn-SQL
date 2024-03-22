SELECT * 
INTO #temporal
FROM
(
SELECT '1114' ccuenta, 10 nsaldo, '2021-01-10' dFecha union all
SELECT '1114', 20, '2021-01-11' union all 
SELECT '1114', 80, '2021-01-12' union all 
SELECT '1114', 50, '2021-01-13' union all 
SELECT '1114', 70, '2021-01-14' union all 
SELECT '2810', 50, '2021-01-09' union all 
SELECT '2810', 70, '2021-01-09' union all 
SELECT '2810', 50, '2021-01-09' 
)x

--Con una tabla hacer un join (?


select *, T1.nsaldo - T.nsaldo as [Diferencia]
from #temporal T1
JOIN #temporal T ON t.dFecha = DATEADD(DAY, 1, T1.dFecha)

where T1.ccuenta ='1114'