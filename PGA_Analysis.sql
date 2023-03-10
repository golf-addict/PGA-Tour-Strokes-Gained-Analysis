/*
 * Create a view that includes the combined short game (sg_putt plus sg_arg) and ball-
 * striking (sg_app plus sg_ott) stats and the tournament ranks in each sg category.  The
 * view also removes all players who did not finish the tournament (i.e. players who
 * missed the primary or secondary cut and players who DNF'ed or were DQ'ed).
 */
CREATE VIEW ptdr_ranks_v3 AS
SELECT
    *
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_putt DESC) AS sg_putt_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_arg DESC) AS sg_arg_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_app DESC) AS sg_app_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_ott DESC) AS sg_ott_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_t2g DESC) AS sg_t2g_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_total DESC) AS sg_total_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_putt_arg DESC) AS sg_putt_arg_rank
    , RANK() OVER(PARTITION BY "tournament id" ORDER BY sg_app_ott DESC) AS sg_app_ott_rank
FROM (
	SELECT 
		*
		, sg_putt + sg_arg AS sg_putt_arg
		, sg_app + sg_ott AS sg_app_ott
	FROM PGA_Tournament_Data_Revised 
	WHERE finish < 100
)

/*
 * List the average strokes gained by tournament winners in each of the strokes gained 
 * categories including the combined short game and ball-striking categories.
 */
SELECT 
	AVG(sg_putt)
	, AVG(sg_arg)
	, AVG(sg_app)
	, AVG(sg_ott)
	, AVG(sg_putt_arg)
	, AVG(sg_app_ott)
FROM ptdr_ranks_v3
WHERE finish = 1

/*
 * List the average strokes gained RANKs by tournament winners in each of the strokes 
 * gained categories including the combined short game and ball-striking categories.
 */
SELECT 
	AVG(sg_putt_rank)
	, AVG(sg_arg_rank)
	, AVG(sg_app_rank)
	, AVG(sg_ott_rank)
	, AVG(sg_putt_arg_rank)
	, AVG(sg_app_ott_rank)
FROM ptdr_ranks_v3
WHERE finish = 1


--Show the average finish by the top-10 players in each of the strokes gained categories.
SELECT * 
FROM 
	(SELECT AVG(finish) AS top_10_putt_avg_fin
	 FROM ptdr_ranks_v3
	 WHERE sg_putt_rank <= 10)
CROSS JOIN
	(SELECT AVG(finish) AS top_10_arg_avg_fin
	 FROM ptdr_ranks_v3
	 WHERE sg_arg_rank <= 10) 
CROSS JOIN 
	(SELECT AVG(finish) AS top_10_app_avg_fin
	 FROM ptdr_ranks_v3
	 WHERE sg_app_rank <= 10)
CROSS JOIN 
	(SELECT AVG(finish) AS top_10_ott_avg_fin
 	 FROM ptdr_ranks_v3
	 WHERE sg_ott_rank <= 10)
CROSS JOIN 
	(SELECT AVG(finish) AS top_10_putt_arg_avg_fin
 	 FROM ptdr_ranks_v3
	 WHERE sg_putt_arg_rank <= 10)
CROSS JOIN 
	(SELECT AVG(finish) AS top_10_app_ott_avg_fin
 	 FROM ptdr_ranks_v3
	 WHERE sg_app_ott_rank <= 10)
   
   
--See the number of winners by rank in each of the strokes gained categories.
SELECT 
	sg_putt_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_putt_rank


SELECT 
	sg_arg_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_arg_rank


SELECT 
	sg_app_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_app_rank


SELECT 
	sg_ott_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_ott_rank


SELECT 
	sg_putt_arg_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_putt_arg_rank


SELECT 
	sg_app_ott_rank, 
	COUNT(*) AS num_winners
FROM ptdr_ranks_v3
WHERE finish = 1
GROUP BY sg_app_ott_rank



--See the percentage of winners coming from different ranges of short game ranks
SELECT 
	SUM(CASE WHEN sg_putt_arg_rank <= 5 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _1_to_5
	, SUM(CASE WHEN sg_putt_arg_rank BETWEEN 6 AND 10 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _6_to_10
	, SUM(CASE WHEN sg_putt_arg_rank BETWEEN 11 AND 15 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _11_to_15
	, SUM(CASE WHEN sg_putt_arg_rank BETWEEN 16 AND 20 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _16_to_20
	, SUM(CASE WHEN sg_putt_arg_rank > 20 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _20_plus
FROM (
	SELECT 
		sg_putt_arg_rank, 
		COUNT(*) AS num_winners
	FROM ptdr_ranks_v3
	WHERE finish = 1
	GROUP BY sg_putt_arg_rank
)



--See the percentage of winners coming from different ranges of ball-striking ranks
SELECT 
	SUM(CASE WHEN sg_app_ott_rank <= 5 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _1_to_5
	, SUM(CASE WHEN sg_app_ott_rank BETWEEN 6 AND 10 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _6_to_10
	, SUM(CASE WHEN sg_app_ott_rank BETWEEN 11 AND 15 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _11_to_15
	, SUM(CASE WHEN sg_app_ott_rank BETWEEN 16 AND 20 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _16_to_20
	, SUM(CASE WHEN sg_app_ott_rank > 20 THEN num_winners ELSE 0 END) * 100.00 / SUM(num_winners) AS _20_plus
FROM (
	SELECT 
		sg_app_ott_rank, 
		COUNT(*) AS num_winners
	FROM ptdr_ranks_v3
	WHERE finish = 1
	GROUP BY sg_app_ott_rank
)


--How many winners are the best putter from amongst the top-10 in ball-striking?
SELECT COUNT(*)
FROM (
	SELECT
	    "tournament id",
	    player,
	    "tournament name",
	    finish,
	    MIN(sg_putt_rank),
	    sg_app_ott_rank
	FROM (
		SELECT *
		FROM ptdr_ranks_v3
		WHERE sg_app_ott_rank <= 10
	)
	GROUP BY "tournament id"
)
WHERE finish = 1


/*
 * Looking at the average strokes gained ranks of tournament winners in the short game 
 * and ball-striking categories.  Kept only those courses with 3+ tournaments in the 
 * dataset. 
 */
SELECT A.course, A.num_tournaments, A.avg_sg_putt_arg_rank, B.avg_sg_app_ott_rank 
FROM 
	(
	SELECT course, COUNT(*) AS num_tournaments, AVG(sg_putt_arg_rank) AS avg_sg_putt_arg_rank 
	FROM ptdr_ranks_v3
	WHERE finish = 1
	GROUP BY course
	ORDER BY AVG(sg_putt_arg_rank)
	) AS A
	INNER JOIN 
	(
	SELECT course, AVG(sg_app_ott_rank) AS avg_sg_app_ott_rank 
	FROM ptdr_ranks_v3
	WHERE finish = 1
	GROUP BY course
	ORDER BY AVG(sg_app_ott_rank)
	) AS B
	ON A.course = B.course
WHERE num_tournaments >= 3