Red[Needs: 'View] 
#include %./mci-cmd.red

;加载声音、图片资源
now-dir: to-local-file what-dir
mci-cmd rejoin [{open "} now-dir "\res\sound\fly.mp3" {" type MPEGVideo}]
mci-cmd rejoin [{open "} now-dir "\res\sound\pass.mp3" {" type MPEGVideo}]
mci-cmd rejoin [{open "} now-dir "\res\sound\bump.mp3" {" type MPEGVideo}]

bg-img: load %./res/img/bg.jpg
land-img: load %./res/img/land.jpg
bird-img-files: read %./res/img/bird/
bird-imgs: []
pipe-down-img: load %./res/img/pipe_down.png
pipe-up-img: load %./res/img/pipe_up.png
change-dir %./res/img/bird/
foreach file bird-img-files [
	append bird-imgs load file
]

;碰撞检测函数
bump?: func [i j] [
	return all [ 
		(i/4/1 > j/3/1)  
		(i/3/1 < j/4/1)
		(i/4/2 > j/3/2)
		(i/3/2 < j/4/2)
	]
]
playing?: true
img-index: 1
bird-img: bird-imgs/(img-index)
staus: 0
step: 1
score: 0

random/seed now
system/view/auto-sync?: no

view [
	size 288x512
	title "FlappyBird by Red"
	origin 0x0
	space 0x0
	frame: base 288x512 rate 0:0.04 draw [
		bg: image bg-img 0x0 576x512
		bird: rotate 0 77x217 [image bird-img 60x200 94x234]
		pipe1-1: image pipe-down-img 300x-200 352x120
		pipe1-2: image pipe-up-img 300x250 352x570
		pipe2-1: image pipe-down-img 450x-150 502x170
		pipe2-2: image pipe-up-img 450x300 502x620
		pipe3-1: image pipe-down-img 600x-170 652x150
		pipe3-2: image pipe-up-img 600x280 652x600
		land: image land-img 0x400 576x512
		
	] on-time [
        if not playing? [return false]
		img-index: img-index + 1
		if img-index > 3 [img-index: 1]
		bird/4/2: bird-imgs/(img-index)
        
        either bg/3/1 <= -286 [
            bg/3: 0x0
            bg/4: 576x512
            land/3: 0x400
            land/4: 576x512
        ] [
            bg/3: bg/3 - 2x0
            bg/4: bg/4 - 2x0
            land/3: land/3 - 2x0
            land/4: land/4 - 2x0
        ]
        
        foreach [pdown pup] reduce [pipe1-1 pipe1-2 pipe2-1 pipe2-2 pipe3-1 pipe3-2] [
            pdown/3: pdown/3 - 2x0
            pdown/4: pdown/4 - 2x0
            pup/3: pup/3 - 2x0
            pup/4: pup/4 - 2x0
            ;重置管子
            if pdown/4/1 < 0 [
                pdown/3: to-pair reduce [420 + random 40  -250 + random 150]
                pdown/4: pdown/3 + 52x320
                pup/3: pdown/3 + 0x320 + (to-pair reduce [0 115 + random 30])
                pup/4: pup/3 + 52x320
            
            ]
            ;碰撞检测
            if any [(bump? bird/4 pdown) (bump? bird/4 pup)] [
                ending/visible?: true
                ending/text: rejoin ["得分: " score]
                playing?: false
                mci-cmd rejoin [{seek "} now-dir "\res\sound\bump.mp3" {" to 0}]
				mci-cmd rejoin [{play "} now-dir "\res\sound\bump.mp3" {"}]
            ]
            ;得分检测
            if (pup/4/1 = 60) or (pup/4/1 = 59) [
                score: score + 1
				score-text/text: to-string score
                mci-cmd rejoin [{seek "} now-dir "\res\sound\pass.mp3" {" to 0}]
				mci-cmd rejoin [{play "} now-dir "\res\sound\pass.mp3" {"}]
            ]
            
        ]
        
		either staus > 0 [
			;小鸟上升
			either step > 10 [ 
				staus: -1 
				step: 1
			] [
				step: step + 1
				if bird/2 > -30 [ 
					bird/2: bird/2 - 5  ;小鸟图片角度朝上
				]
				if bird/4/3/2 > 10 [
					bird/4/3: bird/4/3 - 0x8
                    bird/4/4: bird/4/4 - 0x8
                    bird/3: bird/4/3 + 17x17
				]
			]
		] [
			;小鸟下降
			if bird/2 < 30 [
				bird/2: bird/2 + 10  ;小鸟图片角度朝下
			]
			if bird/4/3/2 < 356 [
				bird/4/3: bird/4/3 + 0x12
                    bird/4/4: bird/4/4 + 0x12
                    bird/3: bird/4/3 + 17x17
			]
		]
        show frame
        show score-text
        show ending
		
	] on-down [
		either playing? [
			;单击切换小鸟飞行状态
			staus: 1
			step: 1
			mci-cmd rejoin [{seek "} now-dir "\res\sound\fly.mp3" {" to 0}]
			mci-cmd rejoin [{play "} now-dir "\res\sound\fly.mp3" {"}]
		] [
			;重新开局
			ending/visible?: false
			playing?: true
			score: 0
			score-text/text: "0"
			
            bg/3: 0x0
            bg/4: 576x512
            land/3: 0x400
            land/4: 576x512
            bird/4/3: 60x200
            bird/4/4: 94x234
            pipe1-1/3: 300x-200
            pipe1-1/4: 352x120
            pipe1-2/3: 300x250
            pipe1-2/4: 352x570
            pipe2-1/3: 450x-150
            pipe2-1/4: 502x170
            pipe2-2/3: 450x300
            pipe2-2/4: 502x620
            pipe3-1/3: 600x-170
            pipe3-1/4: 652x150
            pipe3-2/3: 600x280
            pipe3-2/4: 652x600
         
		]
	]
    
    ;分数标签
	at 0x0 score-text: base 80x40 transparent "0" font-size 16 red
    ;成绩面板
    at 80x150 ending: base 150x50 green font-size 16 with [visible?: false]
]

