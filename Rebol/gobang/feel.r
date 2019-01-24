Rebol[]

;模拟点击事件
click: func [ ord [integer!] turn [logic!]] [
	either turn [
		do rejoin [ "C" ord {/image: heizi} ]
		do rejoin [ "poke qp C" ord {/data to-tuple reduce [0 1 index 0]} ]
		do rejoin [ "poke trait C" ord {/data to-tuple reduce [0 1 index 0]} ]
		do rejoin [ "show C" ord ]
	] [
		do rejoin [ "C" ord {/image: baizi} ]
		do rejoin [ "poke qp C" ord {/data to-tuple reduce [1 0 index 0]} ]
		do rejoin [ "poke trait C" ord {/data to-tuple reduce [1 0 0 0]} ]
		do rejoin [ "show C" ord ]
	]
	
]


