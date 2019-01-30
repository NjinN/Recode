Rebol[]

s: open/binary tcp://localhost:80
wait 5

if not exists? %session/ [make-dir %session/]

cd %session/

session-clean: does [
	files: read %./
	foreach file files [
		attempt [
			temp: load file
			t-now: now/precise
			expires: temp/expires
			if ((t-now/date - expires/date) * 24:00:00 + t-now/time - expires/time) > 0:00:00 [
				delete file
			]
		]
	]
] 


forever [
	session-clean
	if (wait [s 30]) <> none [quit]
]



