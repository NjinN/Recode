Red[]

comment {
	实现了对winmm.dll中mciSendStringW接口的调用，并且能够正确地拿到返回值了
	需要的同学可以在自己的Red程序中用#include %this-file 
	然后编译时需加入 -r 选项才能完成编译
	mci-cmd 加上一个mci命令字符串即可执行该命令，并拿到返回值
	常用命令可参考MP3Player的例子
}

#system [
	mci: context [
		#import [
		   "winmm.dll" stdcall [
			   mciCommand: "mciSendStringW" [
				   lpszCommand [c-string!]
				   lpszReturnString [c-string!]
				   cchReturn [integer!]
				   hwndCallback [integer!]
			   ]
		   ]
		   "msvcrt.dll" cdecl [
			   malloc: "malloc" [
				   size    [integer!]
				   return: [c-string!]
			   ]
			   free: "free" [
				   block   [c-string!]
			   ]
		   ]
		]
		
		mciSendString: func [redStr [red-string!] return: [red-string!] /local cmdStr [c-string!] buffer [c-string!] rs [red-string!]] [
			cmdStr:  unicode/to-utf16 redStr
			buffer:  malloc 256
			mciCommand cmdStr buffer 256 0
			rs: string/load buffer u16len? buffer UTF-16LE
			free buffer
			return as red-string! stack/set-last as red-value! rs
		]
		
		u16len?: func [s [c-string!] return: [integer!] /local len [integer!] index-next [integer!]] [
			len: -1
			until [
				len: len + 2
				index-next: len + 1
				all [s/len = #"^@"	s/index-next = #"^@"]		
			]
			return len / 2 
		]
	]
]

mci-cmd: routine [str [string!] return: [string!]] [mci/mciSendString str]




