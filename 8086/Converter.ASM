kod segment
    assume  cs:kod, ds:dane, ss:stos
	
start:  mov ax,dane
        mov ds,ax
        mov ax,stos
        mov ss,ax
        mov sp,offset szczyt
 
        mov dx,offset powitanie
        mov ah,09h
        int 21h
 
        mov ah, 0Ah
        mov dx, offset buffor
        int 21h
 
        call printemptyline
        call zamianaterminatora
        call sprawdzczyliczba
        call sprawdzczyzzakresu
        call konw10do2
        call konw10do16
 
        call printemptyline
        call printdec
        call printemptyline
        call printbin
        call printemptyline
        call printhex
        call printemptyline
 
        mov ah,4Ch
        int 21h
 
zamianaterminatora:
        mov si, offset buffor + 1 ;adres bajtu dlugosc lancucha
        mov cl, [ si ] ;zapisz do cl
        mov ch, 0      ;wyczysc ch
        inc cx
        add si, cx ;adres terminatora
        mov al, '$'
        mov [ si ], al ;zamiana terminatora na $
        ret
 
sprawdzczyliczba:
        mov si, offset buffor + 1 ;adres bajtu dlugosc lancucha
        mov cl, [ si ] ;zapisz do cl - liczba iteracji
        mov ch, 0
    petla1:
        inc si
        mov al, [si]
        cmp al, 30h ;sprawdza czy znak jest z zakresu 30h-39h
        jb nieliczba
        mov al, [si]
        cmp al, 39h
        ja nieliczba
        loop petla1
        ret
 
nieliczba:
        mov dx,offset notanumber
        mov ah,09h
        int 21h
        jmp koniecprogramu
 
sprawdzczyzzakresu:
		mov si, offset buffor + 1 ;adres bajtu dlugosc lancucha
        mov cl, [ si ] ;zapisz do cl - liczba iteracji
        mov ch, 0
        mov bx, 0
        mov ax, 0
	petla2:
        inc si
        mov dx, 10
		mul dx
		mov bl, [si]
		mov bh, 0
		sub bl, 30h
		add ax, bx
		jc spozazakresu
		loop petla2
		mov si, offset liczba
		mov [si], ax ;zapisz wynik
		cmp dx, 0 ;przy mno¿eniu liczba w dx oznacza przekroczenie 16-bitowej wartoœci
		jnz spozazakresu
		ret
 
spozazakresu:
        mov dx,offset outofrange
        mov ah,09h
        int 21h
        jmp koniecprogramu
 
konw10do2:
        mov si, offset liczba ;adres liczby
        mov dx, [si]
        mov bx, 0 ;licznik
        mov cx, 16
    petla3:
        shl dx,1
        jc jedynka
        jnc zero
        .ret3:
        inc bx
        loop petla3
        ret
 
jedynka:
        mov al, 31h
        mov si, offset liczba2
        mov [si+bx], al
        jmp .ret3
 
zero:      
        mov al, 30h
        mov si, offset liczba2
        mov [si+bx], al
        jmp .ret3
 
konw10do16:
        mov si, offset liczba ;adres liczby
        mov dx, [si]
 
        mov ax, dx
        and ah, 11110000b
        shr ah, 4
 
        mov si, offset hextab
        mov al, ah
        mov ah, 0
        add si, ax ;adres symbolu z tablicy hex
 
        mov ah, [si]
        mov si, offset liczbah
        mov [si], ah
 
        mov ax, dx
        and ah, 00001111b
 
        mov si, offset hextab
        mov al, ah
        mov ah, 0
        add si, ax ;adres symbolu z tablicy hex
 
        mov ah, [si]
        mov si, offset liczbah
        mov [si+1], ah
 
        mov ax, dx
        and al, 11110000b
        shr al, 4
 
        mov si, offset hextab
        mov ah, 0
        add si, ax ;adres symbolu z tablicy hex
 
        mov ah, [si]
        mov si, offset liczbah
        mov [si+2], ah
  
        mov ax, dx
        and al, 00001111b
 
        mov si, offset hextab
        mov ah, 0
        add si, ax ;adres symbolu z tablicy hex
 
        mov ah, [si]
        mov si, offset liczbah
        mov [si+3], ah
 
        ret        
 
printemptyline:
        mov dx, offset newline
        mov ah,09h
        int 21h
        ret
 
printdec:
        mov dx, offset buffor+2
        mov ah,09h
        int 21h
        ret
		
printhex:
        mov dx, offset liczbah
        mov ah,09h
        int 21h
        ret
		
printbin:
        mov dx, offset liczba2
        mov ah,09h
        int 21h
        ret
		
koniecprogramu:
        mov ah,4Ch
        int 21h
 
 
kod ends
 
dane segment
    powitanie db 'Podaj liczbe z zakresu 0-65535:',10,13,'$'
    newline db 10,13,'$'
    notanumber db 'Nie poda³eœ liczby',10,13,'$'
    outofrange db 'Liczba spoza zakresu',10,13,'$'
buffor  db 6;max dlugosc lancucha
        db ?;dlugosc wprowadzonego lancucha
        db 6 dup(0);lancuch
liczba  db 2 dup(0)
liczba2 db '0000000000000000b$'
liczbah db '0000h$'
hextab  db '0123456789ABCDEF'
 
dane ends
 
stos segment
    dw    100h dup(0)
    szczyt  Label word
stos ends
 
end start