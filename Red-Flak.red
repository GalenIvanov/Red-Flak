Red [ 
    Title: "Brain-Flak interpreter"   
    author: "Galen Ivanov"
    version: 0.1
]

left: make block! 1000
right: make block! 1000
acc: make block! 1000
current-stack: left

toggle-stacks: does [
    current-stack: either current-stack = left [ right ] [ left ]
]

height?: does [
    length? current-stack
]

push: func [ value ] [
    insert current-stack value
]

pop: does [
    either empty? current-stack [ 0 ] [ take current-stack ]
]

push-acc: func [ value ] [
    insert acc value
]

pop-acc: does [
    either empty? acc [ 0 ] [ take acc ]
]

add-acc: func [ value ] [
    push-acc pop-acc + value
]

sub-acc: does [ 
    acc/2: acc/2 - acc/1
    take acc
]

process: func [ code ] [
    parse code [
        any [
          change "()" " add-acc 1"
        | change "[]" " add-acc height?"
        | change "{}" " add-acc pop"
        | change "<>" " toggle-stacks"
        | change [ "(" ahead [ not ")" ] ] " push-acc 0"  
        | change [ "[" ahead [ not "]" ] ] " push-acc 0"  
        | change [ "{" ahead [ not "}" ] ] " until [^/"  
        | change [ "<" ahead [ not ">" ] ] " push-acc 0"  
        | change ")" " push acc/1 add-acc pop-acc"  
        | change "]" " sub-acc" 
        | change "}" " (0 = current-stack/1) or (height? = 0)]^/"
        | change ">" " pop-acc" 
        | skip
        ]
    ]
    code
]


{ Tests }

{100 BYTES}
s: process "((((((<>))))))(((()[[]]((((()()((((([][]){}){}())[()]))[[][]])()){})()[][]))[()()[]])[]){({}<>)<>}<>"
do s
foreach n current-stack[prin to-char n]
clear left
clear right
print ""

{Fibonacci}
s: process "<>(((())))<>{<>(({}<>)<>{}<((<>{}<>))>)<>({}[()])}<><{}{}{}>"
push 10
do s
print current-stack
clear left
clear right


{multiplication of two non-negative numbers}
s: process "{({}<(({})<>{})<>>[()])}<>"
push 9
push 7
do s
print current-stack
clear left
clear right


{do process "(([()()()])(()))"
print current-stack
clear left
clear right}

