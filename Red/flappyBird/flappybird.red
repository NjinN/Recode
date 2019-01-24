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
		(i/offset/1 > (j/offset/1 - i/size/1))  
		(i/offset/1 < (j/offset/1 + j/size/1))
		(i/offset/2 > (j/offset/2 - i/size/2))
		(i/offset/2 < (j/offset/2 + j/size/2))
	]
]
playing?: true
img-index: 1
bird-img: bird-imgs/(img-index)
staus: 0
step: 1
score: 0

system/view/auto-sync?:  no
view [
	size 288x512
	title "FlappyBird by Red"
	origin 0x0
	space 0x0
	main-pane: panel 288x512 [ 
		origin 0x0
		space 0x0
		across
		;背景图片
		bg: base 576x512 bg-img
		;小鸟图片
		at 60x200 bird: base 34x34 transparent draw [ b: rotate 0 17x17 image bird-img 0.0.0.0]
		;管子
		at 300x-200 pipe1-1: base 52x320 transparent draw [image pipe-down-img]
		at 300x250 pipe1-2: base 52x320 transparent draw [image pipe-up-img]
		at 450x-150 pipe2-1: base 52x320 transparent draw [image pipe-down-img]
		at 450x300 pipe2-2: base 52x320 transparent draw [image pipe-up-img]
		at 600x-170 pipe3-1: base 52x320 transparent draw [image pipe-down-img]
		at 600x280 pipe3-2: base 52x320 transparent draw [image pipe-up-img]
		;地面图片
		at 0x400 land: base 576x112 land-img
		;分数标签
		at 0x0 score-text: base 80x40 transparent "0" font-size 16 red
		;成绩面板
		at 80x150 ending: base 150x50 green font-size 16 with [visible?: false]
	] rate 0:0.04 on-time [
		if playing? [
			;小鸟图片切换
			img-index: img-index + 1
			if img-index > 3 [img-index: 1]
			b/5: bird-imgs/(img-index)
			;背景、管子移动
			bg/offset: bg/offset - 2x0
			land/offset: land/offset - 2x0
			pipe1-1/offset: pipe1-1/offset - 2x0
			pipe1-2/offset: pipe1-2/offset - 2x0
			pipe2-1/offset: pipe2-1/offset - 2x0
			pipe2-2/offset: pipe2-2/offset - 2x0
			pipe3-1/offset: pipe3-1/offset - 2x0
			pipe3-2/offset: pipe3-2/offset - 2x0
			
			foreach [i j] reduce [pipe1-1 pipe1-2 pipe2-1 pipe2-2 pipe3-1 pipe3-2] [
				;碰撞检测
				if any [(bump? bird i) (bump? bird j)] [
					ending/visible?: true
					ending/text: rejoin ["得分: " score]
					playing?: false
					mci-cmd rejoin [{seek "} now-dir "\res\sound\bump.mp3" {" to 0}]
					mci-cmd rejoin [{play "} now-dir "\res\sound\bump.mp3" {"}]
				]
				;得分检测
				if (i/offset/1 = 8) or (i/offset/1 = 7)  [
					score: score + 1
					score-text/text: to-string score
					mci-cmd rejoin [{seek "} now-dir "\res\sound\pass.mp3" {" to 0}]
					mci-cmd rejoin [{play "} now-dir "\res\sound\pass.mp3" {"}]
				]
				;重置管子
				if (i/offset/1) < -52 [
					new-x: 420 + random 40
					new-y: -250 + random 150
					new-pad: 120 + random 30
					i/offset: to-pair reduce [new-x new-y]
					j/offset: to-pair reduce [new-x (320 + new-y + new-pad)]
				]
				
			]
			
			;重置背景图片
			if bg/offset/1 <= -287 [
				bg/offset: 0x0
				land/offset: 0x400
			]
			
			either staus > 0 [
				;小鸟上升
				either step > 10 [ 
					staus: -1 
					step: 1
				] [
					step: step + 1
					if b/2 > -30 [ 
						b/2: b/2 - 5  ;小鸟图片角度朝上
					]
					if bird/offset/2 > 10 [
						bird/offset: bird/offset - 0x8
					]
				]
			] [
				;小鸟下降
				if b/2 < 30 [
					b/2: b/2 + 10  ;小鸟图片角度朝下
				]
				if bird/offset/2 < 356 [
					bird/offset: bird/offset + 0x12
				]
			]

			show face
		] 
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
			bird/offset: 60x200 
			pipe1-1/offset: 300x-200
			pipe1-2/offset: 300x250
			pipe2-1/offset: 450x-150
			pipe2-2/offset: 450x300
			pipe3-1/offset: 600x-170
			pipe3-2/offset: 600x280
			
		]
		
	]
	
	
]


