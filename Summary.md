**List the average strokes gained by tournament winners in each of the strokes gained 
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
