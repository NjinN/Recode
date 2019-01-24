Rebol[]

qp-blk: []                      ;载入所有棋谱并放入一个block！
dir: read %./qp/
cd %./qp/
foreach f dir [
	qpimg: load f
	append qp-blk qpimg
]
cd %..

chance-alg: function [ turn [logic!]] 
	[thr value thr-blk val-blk most-thr most-val choice choice-blk chance-blk pix rs] [
	
	val-blk: copy []            ;优先通过价值算法选出价值最高的下子位点
	for i 1 225 1 [
		if (qp/:i/1 = 0) and (qp/:i/2 = 0) [
			value: val i turn
			append val-blk to-tuple reduce [value/1 value/2 i]
			if (value/1 >= 5) [ 
				val-blk: copy []
				append val-blk to-tuple reduce [value/1 value/2 i]
				break
			]
		]
	]
	sort val-blk
	
	thr-blk: copy []
	for i 1 225 1 [
		if (qp/:i/1 = 0) and (qp/:i/2 = 0) [
			thr: val i not turn
			append thr-blk to-tuple reduce [thr/1 thr/2 i]
			if (value/1 >= 5) [ 
				thr-blk: copy []
				append thr-blk to-tuple reduce [thr/1 thr/2 i]
				break
			]
		]
	]
	sort thr-blk

	most-thr: pick thr-blk (length? thr-blk)
	most-val: pick val-blk (length? thr-blk)
	
	choice-blk: copy []
	
	either (most-thr/1 > most-val/1) and (most-thr/1 >= 3) or (index = 2) [
		for x (length? thr-blk) 1 -1 [
			either (thr-blk/:x/1 = most-thr/1) [
				append choice-blk thr-blk/:x
			] [
				break
			]
		]
	
	] [
		for x (length? val-blk) 1 -1 [
			either (val-blk/:x/1 = most-val/1) [
				append choice-blk val-blk/:x
			] [
				break
			]
		]
	]

	chance-blk: copy []                            ;有多个最高价值的下法，通过和历史棋谱匹配，选出胜率高的下方
	for x 1 (length? choice-blk) 1 [
		either (not error? try [ t3/text ]) and ( t3/text = none ) [
			append chance-blk to-tuple reduce [50 0 choice-blk/:x/1 choice-blk/:x/2 choice-blk/:x/3]
		] [
			m: match choice-blk/:x/3 qp-blk turn
			append chance-blk to-tuple reduce [m/1 m/2 choice-blk/:x/1 choice-blk/:x/2 choice-blk/:x/3]
		]
	]
	
	choice-blk: copy []
	sort chance-blk                                 ;胜率一致的再通过总价值进行筛选
	most-chance: pick chance-blk (length? chance-blk)
	for x (length? chance-blk) 1 -1 [
		either ( chance-blk/:x/1 = most-chance/1) [
			if ( chance-blk/:x/4 = most-chance/4) [
				append choice-blk chance-blk/:x
			]
			if ( chance-blk/:x/4 > most-chance/4) [
				choice-blk: copy []
				append choice-blk chance-blk/:x
			]
		] [
			break
		]
	]
	
	random/seed now
	pix: random length? choice-blk
	rs: pick choice-blk pix
	return rs
]


