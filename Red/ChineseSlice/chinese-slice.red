Red[] 

rules-map: do read %rules-map.txt

chinese-slice: func [str /local idx chars word-block n block] [
    word-block: copy []
    n: 0
    idx: 1
    chars: charset [#"0" - #"9" #"a" - #"z" #"A" - #"Z" ]
    parse str [
        some [
            copy first-word skip (
                block: select rules-map first-word
                either parse first-word [chars] [
                    either block [
                        parse at str idx [
                            copy word [block | some chars]
                        ]
                    ] [
                        parse at str idx [
                            copy word some chars
                        ]
                    ]
                    append word-block word
                    idx: idx + length? word
                    n: (length? word) - 1
                ] [
                    either block [
                        parse at str idx [ 
                            copy word block (
                                append word-block word
                                idx: idx + length? word
                                n: (length? word) - 1
                            )
                        ]   
                    ] [
                        if first-word <> " " [
                            append word-block first-word
                        ]
                        
                        idx: idx + 1
                        n: 0
                    ]
                ]    
            )      
            n skip
        ]
        end
    ]
    return word-block
]


halt
