Red[
	title: "Gobang"
	Needs: 'View
]

do %img.red
do %val.red
do %feel.red
do %pre-val.red

index: 1
record: make image! [15x15 0.0.0]     ;创建记录棋谱
trait: make image! [15x15 0.0.0]      ;创建特征棋谱，用于匹配
myturn: true                          ;控制黑白子顺序

;--------------------------------------------------------------------------

view [
	title "Gobang"
	style qbox: base 30x30 238.180.34  
	on-up [
		if face/image = none  [           ;点击事件，图像为空时，根据下子顺序显示黑白子
			if myturn [
				face/image: black-chess
				poke record face/data to-tuple reduce [0 1 index 0]   ;更新记录棋谱
				poke trait face/data to-tuple reduce [0 1 0 0]    ;更新特征棋谱
				show face 
				v: val face/data myturn 				;计算单子价值
				print v
				v: v/1
				if (v >= 5) [                                     ;获胜判定和清空棋盘
					view/flags alert: layout [text "Black Win!" button "OK" [unview alert] focus] [ modal ]
					i: 1
					while [i <= 225] [
						do rejoin reduce [ "C" i {/image: none}]
						do rejoin reduce [ {show C} i ]	
						i: i + 1
					]
					record: make image! [15x15 0.0.0] 
					trait: make image! [15x15 0.0.0] 
					myturn: not myturn
				]
				myturn: not myturn
				
				index: index + 1
			]
			if (not myturn) [
				choice: val-alg myturn                            ;价值算法进行下子决策
				click choice myturn
				v: val choice myturn
				v: v/1
				if (v >= 5) [
					view/flags alert: layout [text "White Win!" focus button "OK" [unview alert] focus] [ modal ]
					i: 1
					while [i <= 225] [
						do rejoin reduce [ "C" i {/image: none}]
						do rejoin reduce [ {show C} i ]		
						i: i + 1
					]
					record: make image! [15x15 0.0.0] 
					trait: make image! [15x15 0.0.0] 
				]
				myturn: not myturn
				index: index + 1
			]		
			
		] 
	]
	
	

	origin 0x0
	panel 466x466 black [
		origin 1x1
		space 1x1
		C1: qbox with [data: 1]
		C2: qbox with [data: 2]
		C3: qbox with [data: 3]
		C4: qbox with [data: 4]
		C5: qbox with [data: 5]
		C6: qbox with [data: 6]
		C7: qbox with [data: 7]
		C8: qbox with [data: 8]
		C9: qbox with [data: 9]
		C10: qbox with [data: 10]
		C11: qbox with [data: 11]
		C12: qbox with [data: 12]
		C13: qbox with [data: 13]
		C14: qbox with [data: 14]
		C15: qbox with [data: 15]
		return
		C16: qbox with [data: 16]
		C17: qbox with [data: 17]
		C18: qbox with [data: 18]
		C19: qbox with [data: 19]
		C20: qbox with [data: 20]
		C21: qbox with [data: 21]
		C22: qbox with [data: 22]
		C23: qbox with [data: 23]
		C24: qbox with [data: 24]
		C25: qbox with [data: 25]
		C26: qbox with [data: 26]
		C27: qbox with [data: 27]
		C28: qbox with [data: 28]
		C29: qbox with [data: 29]
		C30: qbox with [data: 30]
		return
		C31: qbox with [data: 31]
		C32: qbox with [data: 32]
		C33: qbox with [data: 33]
		C34: qbox with [data: 34]
		C35: qbox with [data: 35]
		C36: qbox with [data: 36]
		C37: qbox with [data: 37]
		C38: qbox with [data: 38]
		C39: qbox with [data: 39]
		C40: qbox with [data: 40]
		C41: qbox with [data: 41]
		C42: qbox with [data: 42]
		C43: qbox with [data: 43]
		C44: qbox with [data: 44]
		C45: qbox with [data: 45]
		return
		C46: qbox with [data: 46]
		C47: qbox with [data: 47]
		C48: qbox with [data: 48]
		C49: qbox with [data: 49]
		C50: qbox with [data: 50]
		C51: qbox with [data: 51]
		C52: qbox with [data: 52]
		C53: qbox with [data: 53]
		C54: qbox with [data: 54]
		C55: qbox with [data: 55]
		C56: qbox with [data: 56]
		C57: qbox with [data: 57]
		C58: qbox with [data: 58]
		C59: qbox with [data: 59]
		C60: qbox with [data: 60]
		return
		C61: qbox with [data: 61]
		C62: qbox with [data: 62]
		C63: qbox with [data: 63]
		C64: qbox with [data: 64]
		C65: qbox with [data: 65]
		C66: qbox with [data: 66]
		C67: qbox with [data: 67]
		C68: qbox with [data: 68]
		C69: qbox with [data: 69]
		C70: qbox with [data: 70]
		C71: qbox with [data: 71]
		C72: qbox with [data: 72]
		C73: qbox with [data: 73]
		C74: qbox with [data: 74]
		C75: qbox with [data: 75]
		return
		C76: qbox with [data: 76]
		C77: qbox with [data: 77]
		C78: qbox with [data: 78]
		C79: qbox with [data: 79]
		C80: qbox with [data: 80]
		C81: qbox with [data: 81]
		C82: qbox with [data: 82]
		C83: qbox with [data: 83]
		C84: qbox with [data: 84]
		C85: qbox with [data: 85]
		C86: qbox with [data: 86]
		C87: qbox with [data: 87]
		C88: qbox with [data: 88]
		C89: qbox with [data: 89]
		C90: qbox with [data: 90]
		return
		C91: qbox with [data: 91]
		C92: qbox with [data: 92]
		C93: qbox with [data: 93]
		C94: qbox with [data: 94]
		C95: qbox with [data: 95]
		C96: qbox with [data: 96]
		C97: qbox with [data: 97]
		C98: qbox with [data: 98]
		C99: qbox with [data: 99]
		C100: qbox with [data: 100]
		C101: qbox with [data: 101]
		C102: qbox with [data: 102]
		C103: qbox with [data: 103]
		C104: qbox with [data: 104]
		C105: qbox with [data: 105]
		return
		C106: qbox with [data: 106]
		C107: qbox with [data: 107]
		C108: qbox with [data: 108]
		C109: qbox with [data: 109]
		C110: qbox with [data: 110]
		C111: qbox with [data: 111]
		C112: qbox with [data: 112]
		C113: qbox with [data: 113]
		C114: qbox with [data: 114]
		C115: qbox with [data: 115]
		C116: qbox with [data: 116]
		C117: qbox with [data: 117]
		C118: qbox with [data: 118]
		C119: qbox with [data: 119]
		C120: qbox with [data: 120]
		return
		C121: qbox with [data: 121]
		C122: qbox with [data: 122]
		C123: qbox with [data: 123]
		C124: qbox with [data: 124]
		C125: qbox with [data: 125]
		C126: qbox with [data: 126]
		C127: qbox with [data: 127]
		C128: qbox with [data: 128]
		C129: qbox with [data: 129]
		C130: qbox with [data: 130]
		C131: qbox with [data: 131]
		C132: qbox with [data: 132]
		C133: qbox with [data: 133]
		C134: qbox with [data: 134]
		C135: qbox with [data: 135]
		return
		C136: qbox with [data: 136]
		C137: qbox with [data: 137]
		C138: qbox with [data: 138]
		C139: qbox with [data: 139]
		C140: qbox with [data: 140]
		C141: qbox with [data: 141]
		C142: qbox with [data: 142]
		C143: qbox with [data: 143]
		C144: qbox with [data: 144]
		C145: qbox with [data: 145]
		C146: qbox with [data: 146]
		C147: qbox with [data: 147]
		C148: qbox with [data: 148]
		C149: qbox with [data: 149]
		C150: qbox with [data: 150]
		return
		C151: qbox with [data: 151]
		C152: qbox with [data: 152]
		C153: qbox with [data: 153]
		C154: qbox with [data: 154]
		C155: qbox with [data: 155]
		C156: qbox with [data: 156]
		C157: qbox with [data: 157]
		C158: qbox with [data: 158]
		C159: qbox with [data: 159]
		C160: qbox with [data: 160]
		C161: qbox with [data: 161]
		C162: qbox with [data: 162]
		C163: qbox with [data: 163]
		C164: qbox with [data: 164]
		C165: qbox with [data: 165]
		return
		C166: qbox with [data: 166]
		C167: qbox with [data: 167]
		C168: qbox with [data: 168]
		C169: qbox with [data: 169]
		C170: qbox with [data: 170]
		C171: qbox with [data: 171]
		C172: qbox with [data: 172]
		C173: qbox with [data: 173]
		C174: qbox with [data: 174]
		C175: qbox with [data: 175]
		C176: qbox with [data: 176]
		C177: qbox with [data: 177]
		C178: qbox with [data: 178]
		C179: qbox with [data: 179]
		C180: qbox with [data: 180]
		return
		C181: qbox with [data: 181]
		C182: qbox with [data: 182]
		C183: qbox with [data: 183]
		C184: qbox with [data: 184]
		C185: qbox with [data: 185]
		C186: qbox with [data: 186]
		C187: qbox with [data: 187]
		C188: qbox with [data: 188]
		C189: qbox with [data: 189]
		C190: qbox with [data: 190]
		C191: qbox with [data: 191]
		C192: qbox with [data: 192]
		C193: qbox with [data: 193]
		C194: qbox with [data: 194]
		C195: qbox with [data: 195]
		return
		C196: qbox with [data: 196]
		C197: qbox with [data: 197]
		C198: qbox with [data: 198]
		C199: qbox with [data: 199]
		C200: qbox with [data: 200]
		C201: qbox with [data: 201]
		C202: qbox with [data: 202]
		C203: qbox with [data: 203]
		C204: qbox with [data: 204]
		C205: qbox with [data: 205]
		C206: qbox with [data: 206]
		C207: qbox with [data: 207]
		C208: qbox with [data: 208]
		C209: qbox with [data: 209]
		C210: qbox with [data: 210]
		return
		C211: qbox with [data: 211]
		C212: qbox with [data: 212]
		C213: qbox with [data: 213]
		C214: qbox with [data: 214]
		C215: qbox with [data: 215]
		C216: qbox with [data: 216]
		C217: qbox with [data: 217]
		C218: qbox with [data: 218]
		C219: qbox with [data: 219]
		C220: qbox with [data: 220]
		C221: qbox with [data: 221]
		C222: qbox with [data: 222]
		C223: qbox with [data: 223]
		C224: qbox with [data: 224]
		C225: qbox with [data: 225]
	
	]
]