Red[]

;模拟点击事件
click: func [ ord [integer!] turn [logic!]] [
	either turn [
		do rejoin [ "C" ord {/image: black-chess} ]
		do rejoin [ "poke record C" ord {/data to-tuple reduce [0 1 index 0]} ]
		do rejoin [ "poke trait C" ord {/data to-tuple reduce [0 1 index 0]} ]
		do rejoin [ "show C" ord ]
	] [
		do rejoin [ "C" ord {/image: white-chess} ]
		do rejoin [ "poke record C" ord {/data to-tuple reduce [1 0 index 0]} ]
		do rejoin [ "poke trait C" ord {/data to-tuple reduce [1 0 0 0]} ]
		do rejoin [ "show C" ord ]
	]
	
]


