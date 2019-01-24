Rebol[]

;棋谱匹配算法
match: function [ord [integer!] lib [block!] turn [logic!] ] [len chance] [
	aim: copy trait                           ;复制特征棋谱
	either turn [                             ;根据下子顺序，在特征棋谱上模拟下子
		aim/:ord: aim/:ord + 0.1.0.0
	] [
		aim/:ord: aim/:ord + 1.0.0.0
	]
	len: length? aim
	tot-set: 0                                ;初始化匹配盘数，获胜盘数和胜率
	win-set: 0
	chance: 50
	
	foreach rp lib [                          ;逐一比对特征棋谱历史棋谱
		mate: 0
		either turn [
			for i 1 len 1 [
				matchpix: aim/:i * rp/:i      ;通过乘法清掉不匹配的棋子，若匹配棋子数等于当前棋子数，说明完全匹配
				mate: mate + matchpix/2 + matchpix/1
			]
			if (mate = index) [
				tot-set: tot-set + 1
			if (rp/1/4 = 0) [
				win-set: win-set + 1
			]
		]
		] [
			for i 1 len 1 [
				matchpix: aim/:i * rp/:i
				mate: mate + matchpix/1 + matchpix/2
			]
			
			if (mate = index) [
				tot-set: tot-set + 1
				if (rp/1/4 = 1) [
					win-set: win-set + 1
				]
			]
			
		]	
	]

	if (tot-set > 0) [
		chance: win-set / tot-set
		chance: round/to chance 0.01
		chance: to-integer (chance * 100)
	]
	
	return to-block reduce [chance tot-set]
]



