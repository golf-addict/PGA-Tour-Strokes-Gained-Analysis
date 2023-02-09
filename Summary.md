**1) List the average strokes gained by tournament winners in each of the strokes gained 
categories including the combined short game and ball-striking categories.**

```sql
SELECT 
	AVG(sg_putt)
	, AVG(sg_arg)
	, AVG(sg_app)
	, AVG(sg_ott)
	, AVG(sg_putt_arg)
	, AVG(sg_app_ott)
	, AVG(sg_total)
FROM ptdr_ranks_v3
WHERE finish = 1
```

| AVG(sg_putt) | AVG(sg_arg) | AVG(sg_app) | AVG(sg_ott) | AVG(sg_putt_arg) | AVG(sg_app_ott) | AVG(sg_total) |
| ------------ | ----------- | ----------- | ----------- | ---------------- | --------------- | ------------- |
| 1.2369421487603305 | 0.4280165289256198 | 1.30698347107438 | 0.6847933884297516 | 1.6649586776859508 | 1.9917768595041316 | 3.6397107438016527 |

**Analysis:** Of the 4 official strokes gained categories (sg_putt, sg_arg, sg_app, and sg_ott), we can see that tournament 
winners gain the most strokes on approach shots.  Putting is a close second, with tee shots and shots around the green 
contributing significantly fewer strokes gained compared to approach shots and putts.

I also included the two combined categories of sg_putt_arg (i.e. short game) and sg_app_ott (i.e. ball-striking).  On average,
winners gain roughly 1/3 more strokes in ball-striking vs. the short game.


**2) Show the average finish by the top-10 players in each of the strokes gained categories.**

```sql
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
```

| top_10_putt_avg_fin | top_10_arg_avg_fin | top_10_app_avg_fin | top_10_ott_avg_fin | top_10_putt_arg_avg_fin | top_10_app_ott_avg_fin |
| ------------------- | ------------------ | ------------------ | ------------------ | ----------------------- | ---------------------- |
| 19.629674306393245  | 25.926222935044105 | 18.430181086519112 | 22.810897435897434 | 16.69935170178282       | 14.814245244840146     | 

**Analysis:** Here we see a similar trend to the previous query.  The four official strokes gained categories are in the same order - 
approach, putting, off the tee, and around the green - in terms of where a player in the top 10 in each category will finish (on average).  The 
average finishes for players in the top 10 in approach shots and putts are very similar.  And being in the top 10 off the tee or around the greens 
leads (on average) to a finish several spots lower.

In the combined categories, ball-striking once again wins out over short game with the top 10 ball-strikers finishing roughly 2 spots higher
than the top 10 in the short game.


**3) Show the number of winners grouped by rank in each of the strokes gained categories.**
```sql
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
```

**Analysis:** See Tableau visualizations.


**4) Show the percentage of winners coming from different ranges of short game ranks.**
```sql
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
```

| _1_to_5 | _6_to_10 | _11_to_15 | _16_to_20 | _20_plus |
| ------- | -------- | --------- | --------- | -------- |
|44.21487603305785 | 19.834710743801654 | 10.330578512396695 | 10.330578512396695 | 15.289256198347108 |

**Analysis:**


**5) Show the percentage of winners coming from different ranges of ball-striking ranks.**
```sql
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
```

| _1_to_5 | _6_to_10 | _11_to_15 | _16_to_20 | _20_plus |
| ------- | -------- | --------- | --------- | -------- |
| 53.30578512396694 | 23.140495867768596 | 9.090909090909092 | 4.545454545454546 | 9.917355371900827 |

**Analysis:**


**6)How many winners are the best putter from amongst the top-10 in ball-striking?**
```sql
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
```

| COUNT(*) |
| -------- |
| ------91 |

**Analysis:** Of the tournament winners, 91 are ranked as the best putter from among the top-10 ball-strikers.
