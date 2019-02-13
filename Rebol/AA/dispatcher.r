Rebol[]

_serv: context [
	server-port: none
	content-type-file: read/string %content-type.xml
	content-types: copy []
	backends: copy []
	backend-index: 1
	file-map: make map! []
	request-map: make map! []
	ip-map: make map! array 500
	
	bad-client-blk: make map! []
	server-awake-count: 0

	;���ؾ�̬�ļ�
	load-file: func [dir] [
		file-list: read dir
		foreach f file-list [
			either dir? f [
				load-file f
			] [
				if parse f [ [thru ".html" | thru ".css" | thru ".js"] end] [
					append file-map reduce [ rejoin [dir f] to-string read/binary rejoin [dir f] ]
				]
			]
		]
	]

	;����request
	unpack: func [str [string!] /local temp line-str header-str body-str ] [
		temp: copy reduce ['line copy [] 'headers copy [] 'body copy ""]
		line-str: copy ""
		header-str: copy ""
		body-str: copy ""
		parse str [
			copy line-str to "^M" (temp/line: parse line-str " ")
			any [
				"^M^/^M" copy body-str to end (if body-str [temp/body: copy body-str])
				|
				"^M" copy header-str to "^M" (
					parse header-str [ copy key to ":" thru " " copy value to end (append temp/headers reduce [to-word (replace key "^/" "") value])]
				)
				| skip
			]
		]
		take temp/body
		return temp
	]
	
	remove-socket: func [socket] [
		remove find system/ports/wait-list socket
		remove/part find request-map rejoin [socket/remote-ip ":" socket/remote-port] 2 
		close socket
	]

	client-awake: func [this /local forb-time buf last-gmt e e-obj catch-code requests response backend] [
		if error? e: try [
			catch-code: catch [
				forb-time: select bad-client-blk this/remote-ip
				if all [ (forb-time <> none) (now/time/precise < forb-time)] [
					throw "BadClient"
				] 
				;��ȡ�ͻ���������Ϣ
				buf: make string! 2010000
				if (read-io this buf 2010000) <= 0 [
					remove-socket this
					return false
				]
				
				either this/user-data [
					append this/user-data/body buf
					either attempt [(to-integer this/user-data/headers/Content-Length) > length? this/user-data/body] [
						return false
					] [
						requests: copy this/user-data
						this/user-data: none
					]
				] [
					requests: unpack buf
					if attempt [(to-integer requests/headers/Content-Length) > length? requests/body] [
						this/user-data: copy requests
						return false
					]
				]
				
				;probe requests
				
				;�Ƿ����������Դ·��
				if not (pick requests/line 2) [
					;probe requests/line
					throw "BadRequest"
				]
				
				;����������Դ·��
				if (parse requests/line/2 ["/?" to end]) [replace requests/line/2 "/" "/index.reb"]
				either (requests/line/2 = "/") [
					file-path: %www/index.reb       ;Ĭ��ҳ���޸Ĵ˴�
					requests/line/2: "/index.reb"
				] [
					file-path: rejoin reduce [%www first parse requests/line/2 "?" ]
				]
				
				;����socket���ʹ�Ƶ,����3�ο���ˢ��
				last-gmt: attempt [ select (find/tail (find/tail (find/tail ip-map this/remote-ip)  this/remote-ip) this/remote-ip) this/remote-ip] 
				;if last-gmt [probe (now/time/precise - last-gmt)]
				if parse requests/line/2 [ [thru ".reb" | thru ".html"] [end | "?"  to end] ] [
					take/last/part ip-map 2
					insert ip-map reduce [this/remote-ip now/precise]
					if all [(type? last-gmt) = date! (now/date - last-gmt/date) < 1  (now/time/precise - last-gmt/time) < 0:00:04] [
						print rejoin [now " " this/remote-ip " ���ʹ�Ƶ"]
						throw "BadClient"
					]
				]
				
				either (parse file-path [thru ".reb" [end | "?" to end]]) [
					;��.reb��β���ļ����ɺ�̨���д���
					repend requests [ 'remote-ip rejoin [this/remote-ip ":" this/remote-port]]
					requests: mold requests
					replace/all requests "^/" ""
					backend: pick backends backend-index
					
					write %rq.txt requests
					;backend/async-modes: 'write
					write-io backend requests length? requests
					;backend/async-modes: 'read
					
					repend request-map [ rejoin [this/remote-ip ":" this/remote-port]   this]
		
					either (backend-index >= (length? backends)) [
						system/words/_serv/backend-index: 1
					] [
						backend-index: backend-index + 1
					]
				] [
					;����Ӧ���������״̬����Ϣ
					response: copy ["HTTP/1.1 "]
					either (exists? file-path) [
						append response "200 OK^M^/"
						;��ȡ��Ӧ��Ϣ����
						either (find file-map file-path) [
							;file-bin: select file-map file-path        ;ǿ�ƶ�ȡӲ���ļ����л��˴�ע��
							file-bin: to-string read/binary file-path
						] [
							file-bin: to-string read/binary file-path
						]
						file-type: last parse file-path "."
						insert file-type "."
						
						repend response ["Content-Type:" content-types/(file-type) "; charset=gb2312^M^/"]
						repend response ["Content-Length:" (length? file-bin) "^M^/^M^/"]
						repend response file-bin
					] [
						throw "NotFound"
					]
					;������Ӧ��Ϣ
					
					response: rejoin response 
					if (type? this) <> port! [return false]
					
					either this/state/outBuffer [
						append this/state/outBuffer response
					] [
						if error? try [write-io this response length? response] [ throw "Closed"]
					]
		
					;update this
					if not find requests/headers "Keep-Alive" [
						remove-socket this	
					]	
				]
				none
			]
			if catch-code [
				
				if catch-code = "NoConnection" [print "��Ч����"]
				if catch-code = "NotFound" [
					if (type? this) <> port! [return false]
					res: copy "HTTP/1.1 404 Not Found^M^Content-Type:text/html; charset=gb2312^M^/Content-Length:18^M^/^M^/<h1>Not Found</h1>"
					write-io this res length? res
					remove-socket this
				]
				if catch-code = "BadRequest" [
					if (type? this) <> port! [return false]
					res: copy "HTTP/1.1 400 Bad Request^M^Content-Type:text/html; charset=gb2312^M^/Content-Length:20^M^/^M^/<h1>Bad Request</h1>"
					write-io this res length? res
					remove-socket this
				]
				if catch-code = "Forbidden" [
					if (type? this) <> port! [return false]
					res: copy "HTTP/1.1 403 Forbidden^M^Content-Type:text/html; charset=gb2312^M^/Content-Length:18^M^/^M^/<h1>Forbidden</h1>"
					write-io this res length? res
					remove-socket this
				]
				if catch-code = "BadClient" [
					if (type? this) <> port! [return false]
					res: copy "HTTP/1.1 403 Forbidden^M^Content-Type:text/html; charset=gb2312^M^/Content-Length:30^M^/^M^/<h1>�����Ƶ��1���Ӻ�����</h1>"
					write-io this res length? res
					either (select bad-client-blk this/remote-ip) [
						bad-client-blk/(this/remote-ip): (now/time/precise + 0:01:00)
					] [
						repend bad-client-blk [this/remote-ip (now/time/precise + 0:01:00)]
					]
					remove-socket this
				]
				if catch-code = "Closed" [
					if (type? this) <> port! [return false]
					remove-socket this
				]
			]
			none
		] [
			attempt [
				e-obj: disarm e
				print rejoin reduce [ now " code: " e-obj/code " id: " e-obj/id " near " e-obj/near " where " form e-obj/where]
				remove-socket this
			]
		]
		false
	]

	backend-awake: func [this /local buf e e-obj cookies-str remote-ip deliver result-deliver client] [
		if error? e: try [
			buf: make string! 2010000
			read-io this buf 2010000
			if buf = "alive?" [
				write-io this "yes" 3
				clear buf
				return false
			]

			cookies-str: make string! 1024
			deliver: make string! 2010000
			parse buf [copy remote-ip to "^M^/" thru "^M^/" copy cookies-str to "^M^/^M^/" thru "^M^/^M^/" copy deliver to end]
			clear buf
			
			while [ 
				all [
					(length? deliver) > 0
					(last deliver) = #"^/"
				]
			] [take/last deliver]
			
			client: select request-map remote-ip
			
			either cookies-str [
				append cookies-str "^M^/" 
			] [
				cookies-str: copy "" 
			]
			
			result-deliver: rejoin ["HTTP/1.1 200 OK^M^/Content-Type:text/html; charset=gb2312^M^/" "Content-Length:" length? deliver "^M^/" cookies-str "^M^/" deliver]
			if (type? client) <> port! [return false]
			
			either this/state/outBuffer [
				append this/state/outBuffer result-deliver
			] [
				attempt [write-io client  result-deliver length? result-deliver]
			]
			;update client
			remove/part find request-map remote-ip 2
		
		] [
			attempt [
				e-obj: disarm e
				print rejoin reduce [ now " code: " e-obj/code " id: " e-obj/id " near " form e-obj/near " where " form e-obj/where]
			]
		]
		false
	]

	server-awake: func [this /local client buf e e-obj forb-time] [
		if error? e: try [
			client: first this
			if (type? client) = port! [
				forb-time: select bad-client-blk client/remote-ip
				if all [ (forb-time <> none) (now/time/precise < forb-time)] [
					return false
				] 
				
				client/async-modes: 'read
				;client/async-modes: [read write]
				set-modes client [
					no-wait: true
				]
				client/awake: do bind load mold :client-awake _serv
				client/buffer-size: 2010000
				append system/ports/wait-list client
				
				server-awake-count: server-awake-count + 1
				if server-awake-count > 100 [
					server-awake-count: 0
					foreach [ip time] bad-client-blk [
						if time < now/time/precise [
							replace bad-client-blk reduce [ip time] []
						]
					]
					
				]
				
			]
		] [
			attempt [
				e-obj: disarm e
				print rejoin reduce [ now " code: " e-obj/code " id: " e-obj/id " near " form e-obj/near " where " form e-obj/where]
			]
		]
		false
	]

	init: does [
		parse content-type-file [ 
			some [
				thru {<td class="separateColor">} copy file-type to {</td>}
				thru {<td>} copy con-type to {</td>}
				(append content-types file-type append content-types con-type)
			]
		]
		
		load-file %www/
		
		server-port: open/binary/direct/no-wait tcp://:80
		print "����˿��ѿ���"
		
		until [
			attempt [
				;call rejoin reduce ["start " to-local-file system/script/path "\backend.r "]
				call rejoin reduce [to-local-file system/options/boot " "  to-local-file system/script/path "\backend.r "]
				wait server-port
				backend: first server-port
				if backend/host/1 = 127 [
					set-modes backend [keep-alive: true]
					
					backend/async-modes: 'read
					;backend/async-modes: ['read 'write]
					backend/awake: :backend-awake
					
					append system/ports/wait-list backend
					append backends backend
					
				]
			]
			(length? backends) = 3  ;�˴��޸ĺ�̨����
		]
		print rejoin ["��������̨����Ϊ: " length? backends]
		
		call rejoin reduce [to-local-file system/options/boot " "  to-local-file system/script/path "\session-manager.r "]
		wait server-port
		session-manager-port: first server-port
		set-modes session-manager-port [keep-alive: true]
		print "Session�������������"
		
		server-port/async-modes: 'connect
		server-port/awake: :server-awake
		append system/ports/wait-list server-port
		
		wait []
	]
]

_serv/init

halt








