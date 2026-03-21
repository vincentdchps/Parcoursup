USE parcoursup;
UPDATE
	parcoursup
SET
	acc_tot = acc_bg + acc_bt + acc_bp + acc_at,
	-- acc_tot = acc_pp + acc_pc,
	acc_neobac = acc_sansmention + acc_ab + acc_b + acc_tb + acc_tbf,
	pct_ab = IF(acc_tot = 0, 0, ROUND(100.0 * acc_ab / acc_tot)),
	pct_aca_orig_idf = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_aca_orig_idf / acc_tot)
	),
	pct_aca_orig = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_aca_orig / acc_tot)
	),
	pct_b = IF(acc_tot = 0, 0, ROUND(100.0 * acc_b / acc_tot)),
	pct_bg_mention = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_bg_mention / acc_tot)
	),
	pct_bg = IF(acc_tot = 0, 0, ROUND(100.0 * acc_bg / acc_tot)),
	pct_bp_mention = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_bp_mention / acc_tot)
	),
	pct_bp = IF(acc_tot = 0, 0, ROUND(100.0 * acc_bp / acc_tot)),
	pct_bours = IF(acc_tot = 0, 0, ROUND(100.0 * acc_brs / acc_tot)),
	pct_bt_mention = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_bt_mention / acc_tot)
	),
	pct_bt = IF(acc_tot = 0, 0, ROUND(100.0 * acc_bt / acc_tot)),
	pct_mention_nonrenseignee = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_mention_nonrenseignee / acc_tot)
	),
	pct_sansmention = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_sansmention / acc_tot)
	),
	pct_tb = IF(acc_tot = 0, 0, ROUND(100.0 * acc_tb / acc_tot)),
	pct_tbf = IF(acc_tot = 0, 0, ROUND(100.0 * acc_tbf / acc_tot)),
	pct_etab_orig = IF(
		acc_tot = 0,
		0,
		ROUND(100.0 * acc_term / acc_tot)
	);