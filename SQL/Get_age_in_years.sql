/*
 * Gets the age of a person, or anything else, in years.
 *
 * The thing that makes this code useful is it takes the number of months and days passed on both dates in the comparison
 * into account. As opposed to only looking at the year part of the datetime when using a plain DATEDIFF() without the 
 * case statement used bellowl
 */

DECLARE @BirthDate DATETIME
DECLARE @CurrentDate DATETIME

SELECT @CurrentDate = '20070210', @BirthDate = '19790519'

SELECT
  DATEDIFF(YY, @BirthDate, @CurrentDate) -
  CASE
    WHEN(
      (MONTH(@BirthDate)*100 + DAY(@BirthDate)) >
      (MONTH(@CurrentDate)*100 + DAY(@CurrentDate))
    ) THEN 1
    ELSE 0
  END