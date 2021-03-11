--Alternative #1
--Be aware this one cropps at 4000 chars just in case you have a long procedure. Use OBJECTPROPERTY method instead
SELECT ROUTINE_NAME, ROUTINE_DEFINITION
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_DEFINITION LIKE '%Foo%' 
    AND ROUTINE_TYPE='PROCEDURE'

--Alternative #2
SELECT OBJECT_NAME(id) 
FROM SYSCOMMENTS 
WHERE [text] LIKE '%Foo%' 
    AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
GROUP BY OBJECT_NAME(id)

--Alternative #3
SELECT OBJECT_NAME(object_id)
FROM sys.sql_modules
WHERE OBJECTPROPERTY(object_id, 'IsProcedure') = 1
    AND definition LIKE '%Foo%'