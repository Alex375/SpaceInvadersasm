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



HLines              ; Sauvegarde les registres dans la pile.
                    movem.l d6/d7/a0,-(a7)
                    ; Fait pointer A0 sur la mémoire vidéo.
                    lea     VIDEO_START,a0
                    ; D7.W = Compteur de boucle
                    ; = Nombre d'itérations - 1 (car DBRA).
                    ; ------------------------------
                    ; Nombre d'itérations = Nombre de rayures blanches et noires
                    ; Hauteur d'un rayure blanche = 8 pixels
                    ; Hauteur d'un rayure noire = 8 pixels
                    ; Nombre de rayures blanches et noires = Hauteur de la fenêtre / 2x8 
                    move.l #VIDEO_HEIGHT/16-1,d7

\loop               ; Dessine une rayure blanche (8 lignes blanches).
                    ; ------------------------------
                    ; D6.W = Compteur de boucles
                    ;      = Nombre d'itérations - 1 (car DBRA)
                    ; ------------------------------
                    ; Nombre d'itérations = Nombre de mots longs
                    ; Nombre de mots longs = Nombre d'octets / 4
                    ; Nombre d'octets = BYTE_PER_LINE x Hauteur d'une rayure blanche ; Hauteur d'une ligne = 8 pixels
                    move.w #BYTE_PER_LINE*8/4-1,d6



\white_loop         move.l #$ffffffff,(a0)+
                    dbra d6,\white_loop

                    ; Dessine une rayure noire (8 lignes noires).
                    move.w  #BYTE_PER_LINE*8/4-1,d6

\black_loop         clr.l   (a0)+
                    dbra    d6,\black_loop
                    ; Reboucle tant qu'il reste des rayures ; blanches et noires à dessiner.
                    dbra d7,\loop
                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d6/d7/a0
                    rts



WhiteSquare32       ; Sauvegarde les registres dans la pile.
                    movem.l d7/a0,-(a7)
                    ; Fait pointer A0 sur l'emplacement du carré.
                    ; ------------------------------
                    ; Centrage horizontal :
                    ; La largeur ci-dessous est mesurée en octets.
                    ; Largeur totale = Largeur de la fenêtre = BYTE_PER_LINE
                    ; Largeur du carré = 4 octets (32 pixels)
                    ; Déplacement horizontal en octets
                    ; = (Largeur totale - Largeur du carré) / 2
                    ; ------------------------------
                    ; Centrage vertical :
                    ; La hauteur ci-dessous est mesurée en pixels.
                    ; Hauteur totale = Hauteur de la fenêtre = VIDEO_HEIGHT
                    ; Hauteur du carré = 32 pixels
                    ; Déplacement vertical en pixels
                    ; = (Hauteur totale - Hauteur du carré) / 2
                    ; Déplacement vertical en octets
                    ; = Déplacement vertical en pixels x BYTE_PER_LINE
                    ; ------------------------------
                    ; Adresse du carré
                    ; = VIDEO_START + (Déplacement horizontal) + (Déplacement vertical) 
                    lea VIDEO_START+((BYTE_PER_LINE-4)/2)+(((VIDEO_HEIGHT-32)/2)*BYTE_PER_LINE),a0
                    ; Initialisation du compteur de boucle (D7.W).
                    ; Nombre d'itérations = Nombre de lignes du carré (32). 
                    ; D7.W = Nombre d'itération - 1 (car DBRA).
                    move.w #32-1,d7
\loop               ; Copie 32 pixels blancs dans la mémoire vidéo 
                    ; et passe à l'adresse suivante.
                    move.l #$ffffffff,(a0)
                    adda.l #BYTE_PER_LINE,a0
                    dbra    d7,\loop
                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d7/a0
                    rts

WhiteSquare128      ; Sauvegarde les registres dans la pile.
                    movem.l d7/a0,-(a7)
                    ; Fait pointer A0 sur l'emplacement du carré.
                    ; ------------------------------
                    ; Centrage horizontal :
                    ; La largeur ci-dessous est mesurée en octets.
                    ; Largeur totale = Largeur de la fenêtre = BYTE_PER_LINE
                    ; Largeur du carré = 16 octets (128 pixels)
                    ; Déplacement horizontal en octets
                    ; = (Largeur totale - Largeur du carré) / 2
                    ; ------------------------------
                    ; Centrage vertical :
                    ; La hauteur ci-dessous est mesurée en pixels.
                    ; Hauteur totale = Hauteur de la fenêtre = VIDEO_HEIGHT
                    ; Hauteur du carré = 128 pixels
                    ; Déplacement vertical en pixels
                    ; = (Hauteur totale - Hauteur du carré) / 2
                    ; Déplacement vertical en octets
                    ; = Déplacement vertical en pixels x BYTE_PER_LINE
                    ; ------------------------------
                    ; Adresse du carré
                    ; = VIDEO_START + (Déplacement horizontal) + (Déplacement vertical) 
                    lea VIDEO_START+((BYTE_PER_LINE-16)/2)+(((VIDEO_HEIGHT-128)/2)*BYTE_PER_LINE),a0
                    ; Initialisation du compteur de boucle (D7.W).
                    ; Nombre d'itérations = Nombre de lignes du carré (128). ; D7.W = Nombre d'itération - 1 (car DBRA).
                    move.w #128-1,d7

\loop               ; Copie 128 pixels blancs dans la mémoire vidéo ; et passe à l'adresse suivante.
                    move.l #$ffffffff,(a0)
                    move.l #$ffffffff,4(a0)
                    move.l #$ffffffff,8(a0)
                    move.l #$ffffffff,12(a0)
                    adda.l #BYTE_PER_LINE,a0
                    dbra   d7,\loop
                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d7/a0
                    rts
 

WhiteLine           ; Sauvegarde les registres dans la pile.
                    movem.l d0/a0,-(a7)
                    ; Nombre d'itérations = Taille de la ligne en octets 
                    ; D0.W = Nombre d'itérations - 1 (car DBRA)
                    subq.w #1,d0

\loop               ; Copie 8 pixels blancs et passe à l'adresse suivante.
                    move.b  #$ff,(a0)+
                    dbra    d0,\loop
                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d0/a0
                    rts


WhiteSquare         ; Sauvegarde les registres dans la pile.
                    movem.l d0-d2/a0,-(a7)
                    ; D2.W = Taille en pixels du carré.
                    move.w  d0,d2
                    lsl.w   #3,d2
                    ; Fait pointer A0 sur la mémoire vidéo.
                    lea     VIDEO_START,a0
                    ; Centre horizontalement.
                    ; A0 + (Largeur totale - largeur carré) / 2 
                    move.w #BYTE_PER_LINE,d1
                    sub.w d0,d1
                    lsr.w #1,d1
                    adda.w d1,a0
                    ; Centre verticalement.
                    ; A0 + ((Hauteur totale - Hauteur carré) / 2) * BYTE_PER_LINE 
                    move.w #VIDEO_HEIGHT,d1
                    sub.w d2,d1
                    lsr.w #1,d1
                    mulu.w #BYTE_PER_LINE,d1
                    adda.w d1,a0
                    ; Nombre d'itérations = Taille en pixels
                    ; D2.W = Nombre d'itérations - 1 (car DBRA) 
                    subq.w #1,d2


\loop               ; Affiche la ligne en cours et passe à la ligne suivante.
                    jsr     WhiteLine
                    adda.l  #BYTE_PER_LINE,a0
                    dbra    d2,\loop
                    ; Restaure les registres puis sortie.
                    movem.l (a7)+,d0-d2/a0
                    rts
                    
CopyLine           	; Sauvegarde les registres.
					movem.l d1-d4/a1,-(a7)
					
					; Nombre d'itérations = Largeur en octets
					; Nombre d'itérations - 1 (car DBRA) -> D3.W
					subq.w #1,d3
					
\loop				; Octet à copier -> D1.B et D2.B
					move.b (a0)+,d1
					move.b d1,d2
					
					; Décale D1.B vers la droite de D0 bits.
					lsr.b d0,d1
					
					; Décale D2.B vers la gauche de (8 - D0) bits.
					moveq.l #8,d4
					sub.w d0,d4
					lsl.b d4,d2
					; Copie D1.B et D2.B dans la mémoire vidéo.
					or.b d1,(a1)+
					or.b d2,(a1)
					
					; Reboucle tant qu'il y a des octets à copier.
					dbra d3,\loop
					; Restaure les registres puis sortie.
					movem.l (a7)+,d1-d4/a1
					rts
					
PixelToAdress  		; Sauvegarde les registres.
					movem.l d1/d2,-(a7)
					
					; Détermine le nombre d'octets à ajouter en abscisse.
					; Divise l'abscisse par 8 :
					; Quotient -> D1.W (nombre d'octets)
					; Reste -> D0.W (décalage)
					move.w d1,d0
					lsr.w #3,d1
					andi.w #%111,d0
					
					; Détermine le nombre d'octets à ajouter en ordonnée.
					; Multiplie l'ordonnée par le nombre d'octets par ligne.
					; D2.W * BYTE_PER_LINE -> D2.L
					mulu.w #BYTE_PER_LINE,d2
					
					; Détermine l'adresse vidéo.
					; VIDEO_START + Nombre d'octets à ajouter en abscisse et en ordonnée.
					lea     VIDEO_START,a1
					adda.w d1,a1
					adda.l d2,a1
					; Restaure les registres puis sortie.
					movem.l (a7)+,d1/d2
					rts
