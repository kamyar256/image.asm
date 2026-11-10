.ORIG	x3000
START   JSR CLEAR

        LD R3, X_COORD_LOC
        LD R4, Y_COORD_LOC
        LD R5, START_X
        LD R6, START_Y
        STR R5, R3, #0
        STR R6, R4, #0
        
        LD R2, ONELEVEN_NEG
        LEA R0, PROMPT
        PUTS

RE_GETC GETC
        ADD R1, R0, R2
        BRz IMAGE_O
        ADD R1, R1, #-9
        BRz IMAGE_X
        BRnzp RE_GETC

IMAGE_O OUT
        LD R3, DATA_O
        LEA R4, IMG_DATA
        STR R3, R4, #0
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON

IMAGE_X OUT
        LD R3, DATA_X
        LEA R4, IMG_DATA
        STR R3, R4, #0
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON

GAME_ON GETC
        LD R1, HEX_A_MINUS
        ADD R0, R0, R1
        BRz MV_LEFT
        ADD R0, R0, #-2
        BRz START
        ADD R0, R0, #-1
        BRz MV_RITE
        ADD R0, R0, #-13
        BRz DONE
        ADD R0, R0, #-2
        BRz MV_DOWN
        ADD R0, R0, #-4
        BRz MV_UP
        BRnzp GAME_ON

MV_LEFT LDI R3, X_COORD_LOC
        ADD R3, R3, #-8
        BRn X_ZERO
EDGE_L  STI R3, X_COORD_LOC
        JSR CLEAR
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON
X_ZERO  AND R3, R3, #0
        BRnzp EDGE_L

MV_RITE LDI R3, X_COORD_LOC
        ADD R3, R3, #8
        LD R2, ONELEVEN_NEG
        ADD R2, R2, #4
        ADD R2, R3, R2
        BRp X_MAX
EDGE_R  STI R3, X_COORD_LOC
        JSR CLEAR
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON
X_MAX   LD R3, ONETWOEIGHT
        LD R1, TWENTY_NEG
        ADD R3, R3, R1
        BRnzp EDGE_R

MV_DOWN LDI R3, Y_COORD_LOC
        ADD R3, R3, #8
        LD R2, ONELEVEN_NEG
        ADD R2, R2, #8
        ADD R2, R3, R2
        BRp Y_MAX
EDGE_B  STI R3, Y_COORD_LOC
        JSR CLEAR
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON
Y_MAX   LD R3, ONETWOEIGHT
        ADD R3, R3, #-4
        LD R1, TWENTY_NEG
        ADD R3, R3, R1
        BRnzp EDGE_B

MV_UP   LDI R3, Y_COORD_LOC
        ADD R3, R3, #-8
        BRn Y_ZERO
EDGE_T  STI R3, Y_COORD_LOC
        JSR CLEAR
        JSR GET_LOC
        JSR DRAW
        BRnzp GAME_ON
Y_ZERO  AND R3, R3, #0
        BRnzp EDGE_T

DONE    HALT

CLEAR           AND R4, R4, #0
                LD R6, NUM_PIXELS
                LD R5, PIXEL
CLR_LOOP        STR R4, R5, #0
                ADD R5, R5, #1
                ADD R6, R6, #-1
                BRp CLR_LOOP
                RET

GET_LOC         LD R4, PIXEL
                LDI R5, X_COORD_LOC
                ADD R4, R4, R5
                LD R0, ONETWOEIGHT
                LDI R6, Y_COORD_LOC
                BRz END_LOOP
Y_COORD_LOOP    ADD R4, R4, R0
                ADD R6, R6, #-1
                BRp Y_COORD_LOOP
END_LOOP        RET    

DRAW            LD R6, ONETWOEIGHT
                LD R5, TWENTY_NEG
                LD R1, TWENTY
                LD R0, TWENTY
                LD R3, IMG_DATA
DRAW_LOOP       LDR R2, R3, #0
                STR R2, R4, #0
                ADD R4, R4, #1
                ADD R3, R3, #1
                ADD R0, R0, #-1
                BRp DRAW_LOOP
                LD R0, TWENTY
                ADD R4, R4, R6
                ADD R4, R4, R5
                ADD R1, R1, #-1
                BRp DRAW_LOOP
                RET

PROMPT          .STRINGZ "Please enter x or o: "
ONELEVEN_NEG    .FILL xFF91
ONETWOEIGHT     .FILL x0080
TWENTY          .FILL x0014
TWENTY_NEG      .FILL xFFEC
NUM_PIXELS      .FILL x3E00 ; 128 * 124
PIXEL           .FILL xC000
START_X         .FILL x0036
START_Y         .FILL x0034
DATA_X          .FILL xA000
DATA_O          .FILL xA200
HEX_A_MINUS     .FILL xFF9F
X_COORD_LOC     .FILL x4000
Y_COORD_LOC     .FILL x4001
IMG_DATA        .FILL x0000
        
.END