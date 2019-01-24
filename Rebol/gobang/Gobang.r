Rebol[
	title: "Gobang"
]

do %val.r
do %pre-val.r
do %feel.r
do %img.r

index: 1
qp: make image! 15x15         ;创建记录棋谱
trait: make image! 15x15      ;创建特征棋谱，用于匹配
myturn: true                  ;控制黑白子顺序

;--------------------------------------------------------------------------
view layout [
	origin 0
	style qbox box 30x30 238.180.34 [ 
		if face/image = none  [           ;点击事件，图像为空时，根据下子顺序显示黑白子
			if myturn [
				face/image: heizi
				poke qp face/data to-tuple reduce [0 1 index 0]   ;更新记录棋谱
				poke trait face/data to-tuple reduce [0 1 0 0]    ;更新特征棋谱
				show face 
				v: val face/data myturn                           ;计算单子价值
				v: v/1
				if (v >= 5) [                                     ;获胜判定和清空棋盘
					alert "Black Win"
					for i 1 225 1 [
						do rejoin reduce [ "C" i {/image: none}]
						do rejoin reduce [ {show C} i ]						
					]
					qp: make image! 15x15
					trait: make image! 15x15
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
					alert "White Win"
					for i 1 225 1 [
						do rejoin reduce [ "C" i {/image: none}]
						do rejoin reduce [ {show C} i ]						
					]
					qp: make image! 15x15
					trait: make image! 15x15
				]
				myturn: not myturn
				index: index + 1
			]		
			
		] 
	]
	
	
	panel 466x466 black [                               ;以下为棋盘代码
		origin 1
		space 1
		across
		C1: qbox with [data: 1 font/size: 11]
			C2: qbox with [data: 2 font/size: 11]
			C3: qbox with [data: 3 font/size: 11]
			C4: qbox with [data: 4 font/size: 11]
			C5: qbox with [data: 5 font/size: 11]
			C6: qbox with [data: 6 font/size: 11]
			C7: qbox with [data: 7 font/size: 11]
			C8: qbox with [data: 8 font/size: 11]
			C9: qbox with [data: 9 font/size: 11]
			C10: qbox with [data: 10 font/size: 11]
			C11: qbox with [data: 11 font/size: 11]
			C12: qbox with [data: 12 font/size: 11]
			C13: qbox with [data: 13 font/size: 11]
			C14: qbox with [data: 14 font/size: 11]
			C15: qbox with [data: 15 font/size: 11]
			return
			C16: qbox with [data: 16 font/size: 11]
			C17: qbox with [data: 17 font/size: 11]
			C18: qbox with [data: 18 font/size: 11]
			C19: qbox with [data: 19 font/size: 11]
			C20: qbox with [data: 20 font/size: 11]
			C21: qbox with [data: 21 font/size: 11]
			C22: qbox with [data: 22 font/size: 11]
			C23: qbox with [data: 23 font/size: 11]
			C24: qbox with [data: 24 font/size: 11]
			C25: qbox with [data: 25 font/size: 11]
			C26: qbox with [data: 26 font/size: 11]
			C27: qbox with [data: 27 font/size: 11]
			C28: qbox with [data: 28 font/size: 11]
			C29: qbox with [data: 29 font/size: 11]
			C30: qbox with [data: 30 font/size: 11]
			return
			C31: qbox with [data: 31 font/size: 11]
			C32: qbox with [data: 32 font/size: 11]
			C33: qbox with [data: 33 font/size: 11]
			C34: qbox with [data: 34 font/size: 11]
			C35: qbox with [data: 35 font/size: 11]
			C36: qbox with [data: 36 font/size: 11]
			C37: qbox with [data: 37 font/size: 11]
			C38: qbox with [data: 38 font/size: 11]
			C39: qbox with [data: 39 font/size: 11]
			C40: qbox with [data: 40 font/size: 11]
			C41: qbox with [data: 41 font/size: 11]
			C42: qbox with [data: 42 font/size: 11]
			C43: qbox with [data: 43 font/size: 11]
			C44: qbox with [data: 44 font/size: 11]
			C45: qbox with [data: 45 font/size: 11]
			return
			C46: qbox with [data: 46 font/size: 11]
			C47: qbox with [data: 47 font/size: 11]
			C48: qbox with [data: 48 font/size: 11]
			C49: qbox with [data: 49 font/size: 11]
			C50: qbox with [data: 50 font/size: 11]
			C51: qbox with [data: 51 font/size: 11]
			C52: qbox with [data: 52 font/size: 11]
			C53: qbox with [data: 53 font/size: 11]
			C54: qbox with [data: 54 font/size: 11]
			C55: qbox with [data: 55 font/size: 11]
			C56: qbox with [data: 56 font/size: 11]
			C57: qbox with [data: 57 font/size: 11]
			C58: qbox with [data: 58 font/size: 11]
			C59: qbox with [data: 59 font/size: 11]
			C60: qbox with [data: 60 font/size: 11]
			return
			C61: qbox with [data: 61 font/size: 11]
			C62: qbox with [data: 62 font/size: 11]
			C63: qbox with [data: 63 font/size: 11]
			C64: qbox with [data: 64 font/size: 11]
			C65: qbox with [data: 65 font/size: 11]
			C66: qbox with [data: 66 font/size: 11]
			C67: qbox with [data: 67 font/size: 11]
			C68: qbox with [data: 68 font/size: 11]
			C69: qbox with [data: 69 font/size: 11]
			C70: qbox with [data: 70 font/size: 11]
			C71: qbox with [data: 71 font/size: 11]
			C72: qbox with [data: 72 font/size: 11]
			C73: qbox with [data: 73 font/size: 11]
			C74: qbox with [data: 74 font/size: 11]
			C75: qbox with [data: 75 font/size: 11]
			return
			C76: qbox with [data: 76 font/size: 11]
			C77: qbox with [data: 77 font/size: 11]
			C78: qbox with [data: 78 font/size: 11]
			C79: qbox with [data: 79 font/size: 11]
			C80: qbox with [data: 80 font/size: 11]
			C81: qbox with [data: 81 font/size: 11]
			C82: qbox with [data: 82 font/size: 11]
			C83: qbox with [data: 83 font/size: 11]
			C84: qbox with [data: 84 font/size: 11]
			C85: qbox with [data: 85 font/size: 11]
			C86: qbox with [data: 86 font/size: 11]
			C87: qbox with [data: 87 font/size: 11]
			C88: qbox with [data: 88 font/size: 11]
			C89: qbox with [data: 89 font/size: 11]
			C90: qbox with [data: 90 font/size: 11]
			return
			C91: qbox with [data: 91 font/size: 11]
			C92: qbox with [data: 92 font/size: 11]
			C93: qbox with [data: 93 font/size: 11]
			C94: qbox with [data: 94 font/size: 11]
			C95: qbox with [data: 95 font/size: 11]
			C96: qbox with [data: 96 font/size: 11]
			C97: qbox with [data: 97 font/size: 11]
			C98: qbox with [data: 98 font/size: 11]
			C99: qbox with [data: 99 font/size: 11]
			C100: qbox with [data: 100 font/size: 11]
			C101: qbox with [data: 101 font/size: 11]
			C102: qbox with [data: 102 font/size: 11]
			C103: qbox with [data: 103 font/size: 11]
			C104: qbox with [data: 104 font/size: 11]
			C105: qbox with [data: 105 font/size: 11]
			return
			C106: qbox with [data: 106 font/size: 11]
			C107: qbox with [data: 107 font/size: 11]
			C108: qbox with [data: 108 font/size: 11]
			C109: qbox with [data: 109 font/size: 11]
			C110: qbox with [data: 110 font/size: 11]
			C111: qbox with [data: 111 font/size: 11]
			C112: qbox with [data: 112 font/size: 11]
			C113: qbox with [data: 113 font/size: 11]
			C114: qbox with [data: 114 font/size: 11]
			C115: qbox with [data: 115 font/size: 11]
			C116: qbox with [data: 116 font/size: 11]
			C117: qbox with [data: 117 font/size: 11]
			C118: qbox with [data: 118 font/size: 11]
			C119: qbox with [data: 119 font/size: 11]
			C120: qbox with [data: 120 font/size: 11]
			return
			C121: qbox with [data: 121 font/size: 11]
			C122: qbox with [data: 122 font/size: 11]
			C123: qbox with [data: 123 font/size: 11]
			C124: qbox with [data: 124 font/size: 11]
			C125: qbox with [data: 125 font/size: 11]
			C126: qbox with [data: 126 font/size: 11]
			C127: qbox with [data: 127 font/size: 11]
			C128: qbox with [data: 128 font/size: 11]
			C129: qbox with [data: 129 font/size: 11]
			C130: qbox with [data: 130 font/size: 11]
			C131: qbox with [data: 131 font/size: 11]
			C132: qbox with [data: 132 font/size: 11]
			C133: qbox with [data: 133 font/size: 11]
			C134: qbox with [data: 134 font/size: 11]
			C135: qbox with [data: 135 font/size: 11]
			return
			C136: qbox with [data: 136 font/size: 11]
			C137: qbox with [data: 137 font/size: 11]
			C138: qbox with [data: 138 font/size: 11]
			C139: qbox with [data: 139 font/size: 11]
			C140: qbox with [data: 140 font/size: 11]
			C141: qbox with [data: 141 font/size: 11]
			C142: qbox with [data: 142 font/size: 11]
			C143: qbox with [data: 143 font/size: 11]
			C144: qbox with [data: 144 font/size: 11]
			C145: qbox with [data: 145 font/size: 11]
			C146: qbox with [data: 146 font/size: 11]
			C147: qbox with [data: 147 font/size: 11]
			C148: qbox with [data: 148 font/size: 11]
			C149: qbox with [data: 149 font/size: 11]
			C150: qbox with [data: 150 font/size: 11]
			return
			C151: qbox with [data: 151 font/size: 11]
			C152: qbox with [data: 152 font/size: 11]
			C153: qbox with [data: 153 font/size: 11]
			C154: qbox with [data: 154 font/size: 11]
			C155: qbox with [data: 155 font/size: 11]
			C156: qbox with [data: 156 font/size: 11]
			C157: qbox with [data: 157 font/size: 11]
			C158: qbox with [data: 158 font/size: 11]
			C159: qbox with [data: 159 font/size: 11]
			C160: qbox with [data: 160 font/size: 11]
			C161: qbox with [data: 161 font/size: 11]
			C162: qbox with [data: 162 font/size: 11]
			C163: qbox with [data: 163 font/size: 11]
			C164: qbox with [data: 164 font/size: 11]
			C165: qbox with [data: 165 font/size: 11]
			return
			C166: qbox with [data: 166 font/size: 11]
			C167: qbox with [data: 167 font/size: 11]
			C168: qbox with [data: 168 font/size: 11]
			C169: qbox with [data: 169 font/size: 11]
			C170: qbox with [data: 170 font/size: 11]
			C171: qbox with [data: 171 font/size: 11]
			C172: qbox with [data: 172 font/size: 11]
			C173: qbox with [data: 173 font/size: 11]
			C174: qbox with [data: 174 font/size: 11]
			C175: qbox with [data: 175 font/size: 11]
			C176: qbox with [data: 176 font/size: 11]
			C177: qbox with [data: 177 font/size: 11]
			C178: qbox with [data: 178 font/size: 11]
			C179: qbox with [data: 179 font/size: 11]
			C180: qbox with [data: 180 font/size: 11]
			return
			C181: qbox with [data: 181 font/size: 11]
			C182: qbox with [data: 182 font/size: 11]
			C183: qbox with [data: 183 font/size: 11]
			C184: qbox with [data: 184 font/size: 11]
			C185: qbox with [data: 185 font/size: 11]
			C186: qbox with [data: 186 font/size: 11]
			C187: qbox with [data: 187 font/size: 11]
			C188: qbox with [data: 188 font/size: 11]
			C189: qbox with [data: 189 font/size: 11]
			C190: qbox with [data: 190 font/size: 11]
			C191: qbox with [data: 191 font/size: 11]
			C192: qbox with [data: 192 font/size: 11]
			C193: qbox with [data: 193 font/size: 11]
			C194: qbox with [data: 194 font/size: 11]
			C195: qbox with [data: 195 font/size: 11]
			return
			C196: qbox with [data: 196 font/size: 11]
			C197: qbox with [data: 197 font/size: 11]
			C198: qbox with [data: 198 font/size: 11]
			C199: qbox with [data: 199 font/size: 11]
			C200: qbox with [data: 200 font/size: 11]
			C201: qbox with [data: 201 font/size: 11]
			C202: qbox with [data: 202 font/size: 11]
			C203: qbox with [data: 203 font/size: 11]
			C204: qbox with [data: 204 font/size: 11]
			C205: qbox with [data: 205 font/size: 11]
			C206: qbox with [data: 206 font/size: 11]
			C207: qbox with [data: 207 font/size: 11]
			C208: qbox with [data: 208 font/size: 11]
			C209: qbox with [data: 209 font/size: 11]
			C210: qbox with [data: 210 font/size: 11]
			return
			C211: qbox with [data: 211 font/size: 11]
			C212: qbox with [data: 212 font/size: 11]
			C213: qbox with [data: 213 font/size: 11]
			C214: qbox with [data: 214 font/size: 11]
			C215: qbox with [data: 215 font/size: 11]
			C216: qbox with [data: 216 font/size: 11]
			C217: qbox with [data: 217 font/size: 11]
			C218: qbox with [data: 218 font/size: 11]
			C219: qbox with [data: 219 font/size: 11]
			C220: qbox with [data: 220 font/size: 11]
			C221: qbox with [data: 221 font/size: 11]
			C222: qbox with [data: 222 font/size: 11]
			C223: qbox with [data: 223 font/size: 11]
			C224: qbox with [data: 224 font/size: 11]
			C225: qbox with [data: 225 font/size: 11]
	]
]
