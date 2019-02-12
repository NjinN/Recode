Red[Needs: 'View] 
comment {
	调用winmm.dll实现了一个功能版mp3播放器，有需要在程序中播放声音的同学了解一下
	这个例子实现了dll的调用、获取返回数据，也基本展示了Red和Red/System之间传递字符串的方法
	这里同时用了winmm的两个接口，分别对应ASCII编码和UTF16编码
}
#system [
    #import [
       "winmm.dll" stdcall [
			mciCommandA: "mciSendStringA" [
               lpszCommand [c-string!]
               lpszReturnString [c-string!]
               cchReturn [integer!]
               hwndCallback [integer!]
           ]
           mciCommandW: "mciSendStringW" [
               lpszCommand [c-string!]
               lpszReturnString [c-string!]
               cchReturn [integer!]
               hwndCallback [integer!]
           ]
       ]
    ]
	;用#u16可以在Red/System中将字符串转为UTF16编码，以调用UTF16接口
    set-cmd: #u16 {set Mp3File time format ms}
    seek-cmd: #u16 {seek Mp3File to 0}
    play-cmd: #u16 {play Mp3File}
    mci-play: func [s [red-string!] /local cs [c-string!]] [
        cs: unicode/to-utf16 s -1
        mciCommandW cs null 0 0
        mciCommandW set-cmd null 0 0
        mciCommandW seek-cmd null 0 0
        mciCommandW play-cmd null 0 0
    ]
	mci-stop: func [] [mciCommandA {close Mp3File} null 0 0]
	
	;将c-string!转换为red-string!并返回
	mci-get-position: func [return: [red-string!] /local s [c-string!]] [
		s: "0123456789abcdef"
		mciCommandA  {status Mp3File position} s 128 0
		return as red-string! stack/set-last as red-value! string/load s length? s UTF-8
	]
	
	mci-get-length: func [return: [red-string!] /local s [c-string!]] [
		s: "0123456789abcdef"
		mciCommandA {status Mp3File length} s 128 0
		return as red-string! stack/set-last as red-value! string/load s length? s UTF-8
	]
	
	mci-cmd: func [s [red-string!] /local cs [c-string!]] [
		cs: unicode/to-utf16 s -1
		mciCommandW cs null 0 0
	]

]
;用routine调用Red/System中的函数，貌似方法体中必须符合Red/System语法
play: routine [s [string!]] [mci-play s]
stop: routine [] [mci-stop]
get-position: routine [return: [string!]] [mci-get-position]
get-length: routine [return: [string!]] [mci-get-length]
send-cmd: routine [s [string!]] [mci-cmd s]

now-dir: what-dir
mp3-list: []     ;歌曲列表
file-list: []    ;歌曲文件列表
;导入列表信息
either exists? %./music-list.ini [
	file-list: load %./music-list.ini
	foreach file file-list [
		append mp3-list last split file {\}
	]
] [
	write %./music-list.ini "[]"
]

now-file: ""        ;当前文件
music-len: 0        ;歌曲长度
volume: 1000        ;音量
random/seed now     ;初始化random

;获取短格式的时间类型字符串
get-short-time: func [s [string!] /local res chars] [
	chars: charset {0:}
	parse s [thru some chars copy res to end]
	either res = none [
		res: copy at s 4
	] [
		if (length? res) < 3 [
			res: copy at s 4
		]
	] 
	return res
]

;打包了从头播放音乐的函数
start-play: func [/local index] [
	if not empty? now-file [ stop ]
	cmd: rejoin [ {open "} now-file {" type MPEGVideo alias Mp3File}]
	play cmd
	send-cmd rejoin [{setaudio Mp3File volume to } volume]
	music-len: to-integer get-length
	len-text/text: get-short-time to-string to-time music-len / 1000
	playing?/data: true
	
	index: (length? file-list) - (length? find file-list now-file) + 1
	list/selected: index
]


win: layout [
	title "功能版MP3播放器"
	size 300x300
	across
	
	len-text: text "0:00" 35                ;歌曲长度标签
	pos-bar: slider 170 with [data: 0.0]    ;进度条
	on-down [
		send-cmd {pause Mp3File}
		playing?/data: false
	]
	on-up [
		position: to-integer pos-bar/data * music-len 
		pos-cmd: rejoin [{seek Mp3File to } position]
		send-cmd pos-cmd
		send-cmd {play Mp3File}
		playing?/data: true
	]
	pos-text: text "0:00" 35 rate 0:0.1 on-time [        ;当前播放进度
		if playing?/data [
			play-pos: to-integer get-position
			pos-text/text: get-short-time to-string to-time play-pos / 1000
			pos-bar/data: play-pos / (to-float music-len)
		]
		if pos-bar/data = 1.0 [
			switch loop-style/selected [
				1 [start-play]
				2 [
					either (list/selected < (length? file-list)) [
						list/selected: list/selected + 1
						now-file: file-list/(list/selected)
						start-play
					] [
						list/selected: 1
						now-file: file-list/1
						start-play
					]
				]
				3 [
					list/selected: random length? file-list
					now-file: file-list/(list/selected)
					start-play
				]
			]
		]
	]
	return
	play-btn: button "播放" 35 [      ;播放/暂停按钮
		either playing?/data [
			if empty? now-file [return]
			send-cmd {pause Mp3File}
			playing?/data: false
		] [
			either (empty? now-file) [
				now-file: file-list/(list/selected)
				start-play
			] [
				send-cmd {play Mp3File}
				playing?/data: true
			]
		]
		
	] react [play-btn/text: either playing?/data ["暂停"] ["播放"] ]
	stop-btn: button  "停止" 35 [          ;停止按钮
		send-cmd {pause Mp3File}
		send-cmd {seek Mp3File to 0}
		pos-bar/data: 0.0
		pos-text/text: "00:00"
		playing?/data: false
	]
	loop-style: drop-down 50 with [ data: ["单曲" "列表" "随机"] selected: 1 ]    ;循环模式选择列表
	text "Vol:" 25 right
	vol-bar: slider 90 with [data: 1.0] [      ;音量条
		volume: to-integer vol-bar/data * 1000
		vol-cmd: rejoin [{setaudio Mp3File volume to } volume]
		send-cmd vol-cmd
	]
	return
	list: text-list with [size: 280x200 data: mp3-list]    ;歌曲列表
	on-change  [
		now-file: file-list/(list/selected)
		start-play
	] 
	on-dbl-click  [
		stop
		now-file: ""
		playing?/data: false
		take at mp3-list list/selected
		take at file-list list/selected
		write %./music-list.ini mold file-list
		
	]
	playing?: text with [visible?: false data: false size: 0x0]
]

;菜单栏
win/menu: [
	"文件" [
		"打开文件" open-file
		"导入文件夹" import-dir
	]
	"关于" about-inf
]
;菜单栏绑定事件
win/actors: make object! [
	on-menu: func [face [object!] event [event!]] [
		switch event/picked [
			open-file [
				now-file: to-local-file request-file
				if empty? now-file [return]
				either parse lowercase now-file [thru ".mp3" end] [
					if (not find file-list now-file) [
						append file-list now-file
						append mp3-list last split now-file {\}
						change-dir now-dir
						write %./music-list.ini mold file-list
					]
					start-play
				] [
					view/flags [title "注意" text "文件格式错误"] [modal  popup ]
				]
			
			]
			import-dir [
				dir: request-dir
				if empty? dir [return]
				dir-str: to-local-file dir
				foreach file read dir [
					file-str: to-local-file file
					if parse lowercase file-str [thru ".mp3" end] [
						if (not find file-list rejoin [dir-str file-str]) [
							append file-list rejoin [dir-str file-str]
							append mp3-list last split file-str {\}
						]
					]
				]
				change-dir now-dir
				write %./music-list.ini mold file-list
			]
			about-inf [view/flags [title "关于" text "功能版MP3播放器  Just for fun" return text "列表栏单击播放，双击删除"] [modal popup]]
		]
	]
]

view win




