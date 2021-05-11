; ==============================
                    ; DÃ©finition des constantes
                    ; ==============================

                    ; MÃ©moire vidÃ©o
                    ; ------------------------------

VIDEO_START         equ     $ffb500                         ; Adresse de dÃ©part
VIDEO_WIDTH         equ     480                             ; Largeur en pixels
VIDEO_HEIGHT        equ     320                             ; Hauteur en pixels
VIDEO_SIZE          equ     (VIDEO_WIDTH*VIDEO_HEIGHT/8)    ; Taille en octets
BYTE_PER_LINE       equ     (VIDEO_WIDTH/8)                 ; Nombre d'octets par ligne

                    ; Bitmaps
                    ; ------------------------------

WIDTH               equ     0                               ; Largeur en pixels
HEIGHT              equ     2                               ; Hauteur en pixels
MATRIX              equ     4                               ; Matrice de points

                    ; ==============================
                    ; Initialisation des vecteurs
                    ; ==============================

                    org     $0

vector_000          dc.l    VIDEO_START                     ; Valeur initiale de A7
vector_001          dc.l    Main                            ; Valeur initiale du PC

                    ; ==============================
                    ; Programme principal
                    ; ==============================

                    org     $500


                    
                    ; ==============================
                    ; Sous-programmes
                    ; ==============================

PixelToByte         ; Taille en pixels + 7 -> D3.W
                    addq.w  #7,d3
                    
                    ; D3.W/8 -> D3.W
                    lsr.w   #3,d3

                    ; Sortie du sous-programme.
                    rts

CopyLine            ; Sauvegarde les registres dans la pile.
                    movem.l d3/a1,-(a7)

                    ; Nombre d'itÃ©rations = Largeur en octets
                    ; Nombre d'itÃ©rations - 1 (car DBRA) -> D3.W
                    subq.w  #1,d3

\loop               ; Copie tous les octets de la ligne.
                    move.b  (a0)+,(a1)+
                    dbra    d3,\loop

                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d3/a1
                    rts

CopyBitmap          ; Sauvegarde les registres dans la pile.
                    movem.l d3/d4/a0/a1,-(a7)

                    ; Largeur en octets -> D3.W
                    move.w  WIDTH(a0),d3
                    jsr     PixelToByte

                    ; Nombre d'itÃ©rations - 1 (car DBRA) -> D4.W
                    ; Nombre d'itÃ©rations = Hauteur en pixels
                    move.w  HEIGHT(a0),d4
                    subq.w  #1,d4

                    ; Adresse de la matrice de points -> A0.L
                    lea     MATRIX(a0),a0

\loop               ; Copie une ligne de la matrice.
                    jsr     CopyLine

                    ; Passe Ã  l'adresse vidÃ©o de ligne suivante.
                    adda.l  #BYTE_PER_LINE,a1

                    ; Reboucle tant qu'il y a des lignes Ã  afficher.
                    dbra    d4,\loop

                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d3/d4/a0/a1
                    rts

                    ; ==============================
                    ; DonnÃ©es
                    ; ==============================

                    ; ==============================
                    ; DonnÃ©es
                    ; ==============================

InvaderA_Bitmap     dc.w    24,16
                    dc.b    %00000000,%11111111,%00000000
                    dc.b    %00000000,%11111111,%00000000
                    dc.b    %00111111,%11111111,%11111100
                    dc.b    %00111111,%11111111,%11111100
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111100,%00111100,%00111111
                    dc.b    %11111100,%00111100,%00111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %00000011,%11000011,%11000000
                    dc.b    %00000011,%11000011,%11000000
                    dc.b    %00001111,%00111100,%11110000
                    dc.b    %00001111,%00111100,%11110000
                    dc.b    %11110000,%00000000,%00001111
                    dc.b    %11110000,%00000000,%00001111

InvaderB_Bitmap     dc.w    22,16
                    dc.b    %00001100,%00000000,%11000000
                    dc.b    %00001100,%00000000,%11000000
                    dc.b    %00000011,%00000011,%00000000
                    dc.b    %00000011,%00000011,%00000000
                    dc.b    %00001111,%11111111,%11000000
                    dc.b    %00001111,%11111111,%11000000
                    dc.b    %00001100,%11111100,%11000000
                    dc.b    %00001100,%11111100,%11000000
                    dc.b    %00111111,%11111111,%11110000
                    dc.b    %00111111,%11111111,%11110000
                    dc.b    %11001111,%11111111,%11001100
                    dc.b    %11001111,%11111111,%11001100
                    dc.b    %11001100,%00000000,%11001100
                    dc.b    %11001100,%00000000,%11001100
                    dc.b    %00000011,%11001111,%00000000
                    dc.b    %00000011,%11001111,%00000000

InvaderC_Bitmap     dc.w    16,16
                    dc.b    %00000011,%11000000
                    dc.b    %00000011,%11000000
                    dc.b    %00001111,%11110000
                    dc.b    %00001111,%11110000
                    dc.b    %00111111,%11111100
                    dc.b    %00111111,%11111100
                    dc.b    %11110011,%11001111
                    dc.b    %11110011,%11001111
                    dc.b    %11111111,%11111111
                    dc.b    %11111111,%11111111
                    dc.b    %00110011,%11001100
                    dc.b    %00110011,%11001100
                    dc.b    %11000000,%00000011
                    dc.b    %11000000,%00000011
                    dc.b    %00110000,%00001100
                    dc.b    %00110000,%00001100

Ship_Bitmap         dc.w    24,14
                    dc.b    %00000000,%00011000,%00000000
                    dc.b    %00000000,%00011000,%00000000
                    dc.b    %00000000,%01111110,%00000000
                    dc.b    %00000000,%01111110,%00000000
                    dc.b    %00000000,%01111110,%00000000
                    dc.b    %00000000,%01111110,%00000000
                    dc.b    %00111111,%11111111,%11111100
                    dc.b    %00111111,%11111111,%11111100
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    dc.b    %11111111,%11111111,%11111111
                    
FillScreen          ; Sauvegarde les registres dans la pile.
					movem.l d7/a0,-(a7)
					
					; Fait pointer A0 sur la mémoire vidéo.
					; Cette instruction est identique à : 
					movea.l #VIDEO_START,a0
					lea     VIDEO_START,a0
					
					; Initialisation du compteur de boucle (D7.W).
					; La copie se fera sur 32 bits, c'est-à-dire sur 4 octets.
					; Le nombre d'itérations est donc la taille en octets divisée par 4.
					; Le test de sortie se fera à l'aide de DBRA,
					; donc D7.W doit contenir le nombre d'itérations moins 1 (cf. cours).
					move.w #VIDEO_SIZE/4-1,d7
					
\loop              	; Copie la donnée dans la mémoire vidéo
					; et passe à l'adresse suivante.
					move.l d0,(a0)+
					dbra d7,\loop
					
					; Restaure les registres puis sortie.
					movem.l (a7)+,d7/a0
					rts
					
Main                lea     InvaderA_Bitmap,a0
                    lea     VIDEO_START+14+100*BYTE_PER_LINE,a1
                    jsr     CopyBitmap

                    lea     InvaderB_Bitmap,a0
                    lea     VIDEO_START+28+100*BYTE_PER_LINE,a1
                    jsr     CopyBitmap

                    lea     InvaderC_Bitmap,a0
                    lea     VIDEO_START+42+100*BYTE_PER_LINE,a1
                    jsr     CopyBitmap

                    lea     Ship_Bitmap,a0
                    lea     VIDEO_START+28+200*BYTE_PER_LINE,a1
                    jsr     CopyBitmap

					; Test 1
					move.l  #$ffffffff,d0
					jsr     FillScreen
					; Test 2
					move.l #$f0f0f0f0,d0
					jsr     FillScreen; Test 3
					move.l #$fff0fff0,d0
					jsr     FillScreen 
					; Test 4
					moveq.l #$0,d0
					jsr     FillScreen
					illegal
					
					
					
					
					
					
