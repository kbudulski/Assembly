Progr segment
	assume  cs:Progr,ds:dane,ss:stosik
 
Start: 

    mov ax,dane
    mov ds,ax
    mov	ax,stosik
    mov	ss,ax
    mov	sp,offset szczyt
	
    xor	ah,ah
    mov	al, 03h
    int	10h
	
    ;wypełnienie
    mov	ax, 0b800h
    mov	es, ax  ; es jako pamięć graficzna
    mov	dl,'A'	; pierwszy symbol
	
    outerLoop:
    mov	cx,80
	
        innerLoop:
	    mov al, dl ; ustawienie symbolu
	    mov ah, 40H ; kolor (07 - czarne tlo biale litery)
	    inc dl
	    stosw
	    LOOP innerLoop
		
    inc	dl
    inc	bx
    cmp	bx, 25
    jl 	outerLoop
	
INFINITEloop:
    ;pseudolosowanie
    xor	ah,ah
    int 1ah ; przerwanie zegarowe, zapis wrejestrach cx i dx
    mov	al,dl
    mov	si,ax ; zapisanie losowej wartosci w dl do si
    mov	dl,tablica(si)	; wykorzystanie wartosci do wylosowania wiersza z tabeli
    mov	al, 160
    mul	dl
    mov	bx,ax
	
    ;wykonanie kopii
    cld
    mov cx,80
    push ds
    pop es
    push ds
    mov ax,0b800h
    mov ds,ax
    mov di,offset bufor
    mov si,bx
    rep movsw ;DS:SI -> ES:DI
    pop ds
	
    ;belka
    mov	ax,0b800h
    mov	es,ax
    mov	di,bx
    mov	al,177	; ustawienie symbolu belki
    mov	ah, bh ; kolor RANDOM (40 - czerwony)
    mov	cx, 80
    rep	stosw

    ;czas pół sekundy
    mov	cx,8
    mov	ah,86h
    int	15h
	
    ;wklejanie
    mov cx,80
    mov ax,0b800h
    mov es,ax
    mov si,offset bufor
    mov di,bx
    rep movsw
	
    ;czas pół sekundy
    mov cx,8
    mov ah,86h
    int 15h
	
    ;koniec programu
    mov	ah, 01h
    int	16h
    cmp	al, 0dh
    jz koniecprogramu

    jmp	INFINITEloop
			
koniecprogramu:
    mov	ah,08h ;wyczyść bufor klawiatury         
    int	21h
    mov	ah,4Ch
    int	21h		
			
Progr ends

dane segment

    bufor db 160 dup(?)
    tablica db 7,3,17,1,9,15,19,22,20,14,5,23,11,12,6,16,24,21,18,0,4,13,8,2,10,1,10,19,14,17,4,3,0,8,20,24,12,9,15,23,6,5,21,18,16,7,22,13,11,2,20,12,7,9,17,16,8,19,0,1,24,18,4,3,5,15,11,10,14,23,21,2,22,13,6,14,8,19,1,21,2,5,22,12,11,4,24,18,20,16,13,15,17,23,6,10,9,0,7,3,5,22,8,0,21,10,1,11,24,12,15,18,2,16,3,17,9,19,4,13,23,20,6,14,7,21,18,0,3,1,24,2,7,19,23,8,17,15,9,20,6,22,5,11,10,4,16,12,14,13,18,8,0,4,17,16,24,3,2,5,15,10,22,9,20,1,14,21,13,6,23,7,11,19,12,11,20,0,15,10,24,8,3,23,2,9,22,21,17,1,18,12,19,13,14,16,4,6,5,7,21,2,1,12,3,14,18,4,17,0,23,15,5,20,8,13,22,11,6,9,7,19,24,16,10,10,18,19,13,24,16,6,0,23,9,1,12,4,17,20,5,15,21,3,14,11,7,22,2,8,19,7,13,17,6,4,12,9,1,22,18,20,23,14,8,15,10,11,0,16,24,5,21,2,3,22,13,16,4,17,12,15,21,23,18,5,11,24,1,10,7,9,20,0,14,2,8,3,19,6

dane ends
 
stosik segment
 
    dw 100h dup(0)
	szczyt label word
 
stosik ends

end start
