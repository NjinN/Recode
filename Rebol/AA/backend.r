Rebol[]
_backend: context [

	relet: func [str [string!] /local relet-str code-block s-str c-str e-str] [
		relet-str: copy str
		code-block: copy []
		parse relet-str [
			copy s-str to {<?} (if s-str [repend code-block [ " keep " mold s-str " "]])		
			some [
				thru {<?} copy c-str to {?>} (repend code-block ["  " c-str "  "])
				[
					thru {?>} copy s-str to {<?} (repend code-block [ " keep " mold s-str " "])
					|
					thru {?>} copy e-str to end (if e-str [ repend code-block [ " keep " mold e-str " "]])
				]
			]
			
		]
		relet-str: rejoin code-block
		insert relet-str "collect [ "
		append relet-str " ]"
		return relet-str
	]
	
	get-get: func [str [string!] /local hexs temp url-str bin bin-str blk h-str b-str ] [
		hexs: charset "0123456789ABCDEF"
		temp: copy str
		bin-str: copy "#{"
		parse str [
			any [
				copy url-str some [
					"%" copy bin 2 hexs (append bin-str bin)
				] (append bin-str "}" replace temp url-str to-string do bin-str)
				|
				skip (bin-str: copy "#{")
			]
		]

		blk: copy []
		parse temp [
			thru "?"
			any [
				copy h-str to "=" 
				thru "=" [
					copy b-str to "&" thru "&"
					| copy b-str to end
				] 
				(append blk reduce [to-word h-str b-str])
				| skip
			]
		]
		return blk
	]
	
	get-post: func [str [string!] /local blk h-str b-str ] [
		blk: copy []
		parse str [
			any [
				copy h-str to "=" 
				thru "=" [
					copy b-str to "&" thru "&"
					| copy b-str to end
				] 
				(append blk reduce [h-str b-str])
				| skip
			]
		]
		return blk
	]
	
	get-cookies: func [str [string!] /local result temp cookie] [
		result: copy []
		temp: parse str ";"
		cookie: copy []
		foreach item temp [
			cookie: parse item "="
			repend result [(to-word first cookie) (last cookie)]
		]
		return result
	]
	
	start-session: func [str [string!] /local temp] [
		temp: load rejoin [%session/ str]
		temp/expires: now/precise + 0:30:00
		return temp
	]
	

	
	
	;加载reb文件
	load-file: func [dir] [
		file-list: read dir
		foreach f file-list [
			either dir? f [
				load-file f
			] [
				if parse f [ thru ".reb" end] [
					append file-map reduce [ rejoin [dir f] relet read/string rejoin [dir f] ]
				]
			]
		]
	]
	

	dispatcher: open/binary/direct/no-wait tcp://localhost:80
	
	backend-path: copy system/script/path
	get-request?: false
	file-path: none
	e: none
	requests: none
	remote-ip: none
	file-bin: none
	result-str: none
	result: none
	e-obj: none
	file-map: make map! []
	load-file %www/

]

_post: none
_get: none
_content: none
_cookies: none
_session: none

_set-session: func [arg  val] [
	either _session = none [
		_session: make block! 20 
		repend _session [arg val]
	] [
		either select _session arg [
			_session/(arg): val
		] [
			repend _session [arg val]
		]
	]
]

_get-session: func [arg] [
	attempt [_session/(arg)]
]

;print "后台启动"
check-num: 0
do %mysql.r
do %utg.r

forever [
	attempt [
		;print rejoin [ "^/"  "----------------"  "^/" ]
		;是否获取到请求
		_backend/get-request?: false
		;资源路径
		_backend/file-path: none
		
		_backend/requests: copy []
		_get: copy []
		_headers: copy []
		_post: copy []
		_content: copy []
		_cookies: copy []
		_set-cookies: copy []
		_deliver-cookies: make string! 1024
		_session-file: copy ""
		_session: none
		
		wait [_backend/dispatcher]
		if error? _backend/e: try [
			;获取客户端连接
			;print rejoin ["开始读取前台消息"  now/time/precise]
			
			buf: make string! 2010000
			read-io _backend/dispatcher buf 2010000
			 
			_backend/requests: do buf
			clear buf
			;probe _backend/requests
			_backend/get-request?: true
		
			_get: copy _backend/get-get url-to-gbk to-string _backend/requests/line/2
			
			_headers: copy _backend/requests/headers
			
			_post: copy _backend/get-post url-to-gbk _backend/requests/body 
			
			_content: copy _backend/requests/body
			
			if (cookie-str: select _headers 'Cookie) [ _cookies: _backend/get-cookies cookie-str  ]

			if find _cookies 'RebSessionID [
				_session: attempt [ _backend/start-session _cookies/RebSessionID]
				_session-file: _cookies/RebSessionID
			]
			if not _session [
				_session-file: enbase/base checksum/secure rejoin [_backend/requests/remote-ip now/precise] 16
				append _set-cookies rejoin [
				"RebSessionID="
				_session-file
				"; path=/"
				]
				_session: make block! 20
				repend _session ['expires (now/precise + 0:30:00)]
			]

			_backend/file-path: rejoin reduce [%www first parse _backend/requests/line/2 "?"]
			
			change-dir rejoin [_backend/backend-path %www/]
			if error? e2: try [
				either find _backend/file-map _backend/file-path [
					;_backend/result-str: rejoin do select _backend/file-map _backend/file-path           ;强制读取硬盘文件请切换此处注释
					_backend/result-str: rejoin do _backend/relet read/string rejoin [%../ _backend/file-path]
				] [
					_backend/result-str: rejoin do _backend/relet read/string rejoin [%../ _backend/file-path]
				]	
			] [
				probe disarm e2
				_backend/result-str: copy ""
			]
			change-dir _backend/backend-path 
			
			either not empty? _set-cookies [
				foreach cookie _set-cookies [
					repend _deliver-cookies ["Set-Cookie:" cookie "^M^/"]
				]
			] [
				_deliver-cookies: copy "^M^/"
			]
			
			_backend/result-str: rejoin [to-string _backend/requests/remote-ip "^M^/" _deliver-cookies "^M^/" _backend/result-str]
			
			write rejoin [%session/ _session-file] mold _session
			write-io _backend/dispatcher _backend/result-str length? _backend/result-str
			
			
			none
		] [
			attempt [
				if _backend/get-request? [
					_backend/e-obj: disarm _backend/e
					print rejoin reduce [ now " code: " _backend/e-obj/code " id: " _backend/e-obj/id " near " _backend/e-obj/near " where " form _backend/e-obj/where]
				]
				
				check-num: check-num + 1
				if check-num > 100 [check-num: 0]
				if check-num = 100 [
					write-io _backend/dispatcher "alive?" 6
					if (wait [_backend/dispatcher 3]) = none [quit]
					alive: copy ""
					loop 3 [
						attempt [
							alive: _backend/readline _backend/dispatcher
							if alive = "yes" [break]
						]
					]
					if alive <> "yes" [quit]
				]	
			]
		] 
	
	]
]




