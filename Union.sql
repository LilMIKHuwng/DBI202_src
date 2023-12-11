(SELECT top 5  s.name--, SUM(m.mark * a.[percent]) as 'AverageMark' 
FROM 
Students s JOIN enroll e ON s.id = e.studentId
JOIN Courses c ON c.id = e.courseId
JOIN marks m ON m.enrollId = e.enrollId
JOIN Assessments a ON a.id = m.assessmentId
JOIN semesters se ON se.id = e.semesterId
GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
ORDER BY SUM(m.mark * a.[percent]) desc)

union all

(SELECT top 5  s.name--, SUM(m.mark * a.[percent]) as 'AverageMark' 
FROM 
Students s JOIN enroll e ON s.id = e.studentId
JOIN Courses c ON c.id = e.courseId
JOIN marks m ON m.enrollId = e.enrollId
JOIN Assessments a ON a.id = m.assessmentId
JOIN semesters se ON se.id = e.semesterId
GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
ORDER BY SUM(m.mark * a.[percent]) asc)

-- Union

SELECT name
FROM (
    SELECT top 5 s.name, SUM(m.mark * a.[percent]) as 'AverageMark'
    FROM Students s
    JOIN enroll e ON s.id = e.studentId
    JOIN Courses c ON c.id = e.courseId
    JOIN marks m ON m.enrollId = e.enrollId
    JOIN Assessments a ON a.id = m.assessmentId
    JOIN semesters se ON se.id = e.semesterId
    GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
    ORDER BY 'AverageMark' DESC
) AS top_high_scores
UNION ALL
SELECT name
FROM (
    SELECT TOP 5 s.name, SUM(m.mark * a.[percent]) as 'AverageMark'
    FROM Students s
    JOIN enroll e ON s.id = e.studentId
    JOIN Courses c ON c.id = e.courseId
    JOIN marks m ON m.enrollId = e.enrollId
    JOIN Assessments a ON a.id = m.assessmentId
    JOIN semesters se ON se.id = e.semesterId
    GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
    ORDER BY 'AverageMark' ASC
) AS top_low_scores;

CREATE PROCEDURE P3 @stID INT, @avg float OUTPUT
AS
  SELECT @avg = SUM(m.mark * a.[percent]) 
    FROM Students s
    JOIN enroll e ON s.id = e.studentId
    JOIN Courses c ON c.id = e.courseId
    JOIN marks m ON m.enrollId = e.enrollId
    JOIN Assessments a ON a.id = m.assessmentId
    JOIN semesters se ON se.id = e.semesterId
    GROUP BY m.enrollId, c.id, s.id, s.name, se.code, se.id, c.title
	having s.id = @stID
GO

drop PROCEDURE P3

DECLARE @x float

EXEC P3 1, @x OUTPUT
SELECT
  @x AS AVGR;