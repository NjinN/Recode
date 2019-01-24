Red[]

val-alg: func[ turn [logic!] /local thr value thr-blk val-blk most-thr most-val choice] [
	
	val-blk: copy [] 	;计算每一个空格下正子的价值
	i: 1
	while [i <= 225] [
		if (record/:i/1 = 0) and (record/:i/2 = 0) [
			value: val i turn
			append val-blk to-tuple reduce [value/1 value/2 i]
			if (value/1 >= 5) [return i]
		]
		i: i + 1
	]
	sort val-blk
	
	thr-blk: copy []                              ;计算每一个空格下反子的价值，也即威胁值
	i: 1
	while [i <= 225] [
		if (record/:i/1 = 0) and (record/:i/2 = 0) [
			thr: val i not turn
			append thr-blk to-tuple reduce [thr/1 thr/2 i]
			if (thr/1 >= 5) [return i]
		]
		i: i + 1
	]
	sort thr-blk
	
	most-val: pick val-blk (length? thr-blk)      ;通过之前的排序，获取最高价值和最高威胁值
	most-thr: pick thr-blk (length? thr-blk)
	
	
	
	choice-blk: copy []
	random/seed now
												  ;根据最高价值和最高威胁值的情况决定下子决策
	either ((most-thr/1 > most-val/1) and (most-thr/1 >= 3)) or (index = 2) [
		x: (length? thr-blk)
		while [x >= 1] [
			either (thr-blk/:x/1 = most-thr/1) [
				if (thr-blk/:x/2 = most-thr/2) [
					append choice-blk thr-blk/:x
				]
				if (thr-blk/:x/2 > most-thr/2) [
					choice-blk: copy []
					append choice-blk thr-blk/:x
				]
			] [
				break
			]
			x: x - 1
		]
		choice: take random choice-blk
	] [
		x: (length? val-blk)
		while [x >= 1] [
			either (val-blk/:x/1 = most-val/1) [
				if (val-blk/:x/2 = most-val/2) [
					append choice-blk val-blk/:x
				]
				if (val-blk/:x/2 > most-val/2) [
					choice-blk: copy []
					append choice-blk val-blk/:x
				]
			] [
				break
			]
			x: x - 1
		]	
		choice: take random choice-blk              ;根据最高值和总值，获取最优选择，如有多个选择，随机选取
	] 
	return choice/3
]


