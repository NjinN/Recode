Rebol[
    "ChineseSlice, Rebol3 only"
] 

print "开始"
txt: read %dict.txt

word-block: copy []

parse txt [
    some [
        copy word to " "
        (append word-block to-string word)
        thru "^/"
    ]
    end
]

temp-block: copy []

print "完成提词"

foreach word word-block [
    block: select temp-block to-string word/1
    either block [
        append temp-block/(to-string word/1) to-string word 
    ] [
        append temp-block reduce [to-string word/1 reduce [to-string word]]
    ]
]

print "完成提词分类"

rules-block: copy []

idx: 1
foreach [k v] temp-block [
    probe k
    probe v
    sort/compare v func [x y] [(length? x) > (length? y)]
    rules: copy []
    foreach rule v [
        either empty? rules [
            append rules rule
        ] [
            append rules quote |
            append rules rule
        ]  
    ]
    append rules-block reduce [k rules]
    print rejoin ["完成第" idx "条规则"]
    idx: idx + 1
]
print "完成规则构建"

map: make map! rules-block

write %rules-map.txt mold map
print "完成规则map写出"

halt
