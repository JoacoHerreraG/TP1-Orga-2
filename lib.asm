extern malloc
extern free
extern listRemove
extern printf
extern fprintf

section .data
formato_fprintfString: db '%s', 0
formato_fprintfPuntero: db '%p', 0
formato_fprintfChar: db '%c', 0
formato_fprintfEntero: db '%u', 0
tira_NULL: db 'NULL', 0
tira_EspIgualEsp: db ' = ', 0
section .text



global strLen
global strClone
global strCmp
global strConcat
global strDelete
global strPrint
global listNew
global listAddFirst
global listAddLast
global listAdd
global listClone
global listDelete
global listPrint
global sorterNew
global sorterAdd
global sorterRemove
global sorterGetSlot
global sorterGetConcatSlot
global sorterCleanSlot
global sorterDelete
global sorterPrint
global fs_sizeModFive
global fs_firstChar
global fs_bitSplit

;*** String ***

strClone:
  ;18 instrucciones, sin contar el %define.

  ;Se arma marco sobre pila (stackframe).

  push rbp
  mov rbp, rsp

  ;Asumiento que la funcion que llam'o a strClone
  ;fue programada en convencion C para AMD/intel64,
  ;en este punto la pila qued'o alineada a 16 bytes.

  push rbx
  push r12

  ;se resguarda el puntero que recibimos por rdi
  ;sobre rbx que sabemos que se preserva...

  mov rbx, rdi
  %define tiraOrig_ptr rbx

  ;Se pretende reservar memoria para una nueva tira.
  ;Para reservar memoria se puede usar malloc.
  ;Se va a llamar a strLen para saber cuantos bytes hay que reservar.
  ;Dado que strClone y strLen comparten aridad
  ;el puntero a la tira ya esta en el registro rdi,
  ;donde tiene que estar para llamar a strLen.

  call strLen

  ;Sobre el registro rax se obtuvo el largo de la tira.
  ;Se limppian los 32 bit altos

  shl rax, 32
  shr rax, 32

  ;Ahora tenemos que pasar ese dato como par'ametro a malloc.
  ;Por convenci'on C para AMD/intel64
  ;el primer par'ametro se entrega sobre registro rdi.

  mov rdi, rax

  ;Para indicar el final de la tira se debe almacenar
  ;luego del 'ultimo caracter el valor 0.
  ;Esto implica un byte m'as, por ello se incrementa rsi.

  inc rdi

  ;Est'an dadas las condiciones para llamar a malloc.
  ;Pero para no perder el --largo de la tira m'as 1--
  ;salvaguardamos su valor en r12.

  mov r12, rdi
  call malloc

  ;Sobre el registro rax se obtuvo el puntero
  ;a los registros de memoria reservados

  ;Se va a usar la instrucci'on movsb.
  ;Se ubican los parametros en los registros correspondientes.

  mov rdi, rax           ;Direccion de la tira destino.
  mov rsi, tiraOrig_ptr  ;Direccion de la tira original.
  mov rcx, r12      ;Cantidad de bytes a ser copiados.
  cld               ;Se limpian los bits de control (flags).
  REPE movsb


  ;Se desarma marco sobre pila (stackframe).

  pop r12
  pop rbx

  pop rbp
ret


strLen:
  ;6 instrucciones

  ;Como no llamamos a ninguna funci'on,
  ;no hace falta armar marco sobre pila (stackframe)
  ;push rbp
  ;mov rbp, rsp

  ;rdi es la direcci'on de comienzo de tira

  ;Sobre rax retornamos longitud de la tira, y
  ;adem'as nos sirve de indice para recorrerla.
  xor rax, rax

  ;En sil (8 bits mas bajos de rsi) guardamos el caracter a evaluar.
  ;No limpiamos el registro rsi
  ;mov rsi, 0

  .ciclo:
    mov sil, byte [rdi + rax]
    test sil, sil
    je .fin
    inc rax
    jmp .ciclo

  .fin:

  ;No hay marco marco sobre pila (stackframe) para desarmar
	;pop rbp
ret


strCmp:

  ;Como no llamamos a ninguna funci'on,
  ;no hace falta armar marco sobre pila (stackframe)
  ;push rbp
  ;mov rbp, rsp

	xor rdx, rdx ; limpiamos aunque no usemos todos los 64 bit
	xor rcx, rcx ; limpiamos aunque no usemos todos los 64 bit
	xor r8, r8   ; iniciamos contador en 0

	.ciclo:
    	mov dl, [rdi+r8] ;a
    	mov cl, [rsi+r8] ;b
    	cmp dl, 0
    	je .chr_izq_cero		;si a = 0, me fijo el valor de b
    	cmp cl, 0
    	je .mayor				;si b = 0, a es mayor que b
    	cmp dl, cl
    	jg .mayor
    	jl .menor
    	inc r8
	jmp .ciclo
	.chr_izq_cero:
	cmp cl, 0			;si a = 0 y b != 0, a es menor que b
	je .iguales
	.menor:
	mov rax, 1		;a < b
	jmp .finciclo
	.mayor:
	mov rax, -1		;a > b
	jmp .finciclo
	.iguales:
	xor rax, rax
  .finciclo:

  ;No hay marco marco sobre pila (stackframe) para desarmar
	;pop rbp
ret


strConcat:

  ;44 instrucciones, sin contar los %define.
  push rbp
  mov rbp, rsp

  ;En este punto la pila qued'o alineada a 16 bytes.

  sub rsp, 8
  push rbx
  push r12
  push r13
  push r14
  push r15

  ;Se resguardan los punteros que recibimos por rdi y rsi
  ;sobre rbx y r12 que sabemos que se preservan cuando se hacen llamados...

  %define tira1_ptr rbx
  %define tira2_ptr r12
  %define tira1_len r13
  %define tira2_len r14
  %define tiraConc_ptr r15

  mov tira1_ptr, rdi
  mov tira2_ptr, rsi

  ;en rdi ya est'a el puntero tira_ptr
  call strLen

  shl rax, 32
  shr rax, 32

  mov tira1_len, rax

  mov rdi, tira2_ptr
  call strLen

  shl rax, 32
  shr rax, 32

  mov tira2_len, rax

  mov rdi, tira1_len
  add rdi, tira2_len
  inc rdi
  call malloc
  mov tiraConc_ptr, rax

  mov rdi, tiraConc_ptr
  mov rsi, tira1_ptr
  mov rcx, tira1_len
  cld
  REPE movsb

  cmp rbx, r12 ; Se chequea que no se trate de un solo string en mismo lugar de memoria.
  je .copiar_tira2 ; Si es el mismo lugar de memoria se saltea liberaci'on de memoria.

  mov rdi, tira1_ptr
  call free

  .copiar_tira2:
  mov rdi, tiraConc_ptr
  add rdi, tira1_len
  mov rsi, tira2_ptr
  mov rcx, tira2_len
  add rcx, 1 ;+1 para copiamos el 0 que indica el tambi'en
  cld
  REPE movsb

  mov rdi, tira2_ptr
  call free

  mov rax, tiraConc_ptr

  pop r15
  pop r14
  pop r13
  pop r12
  pop rbx
  add rsp, 8

	pop rbp
ret


strDelete:
  call free
ret


;void strPrint(char* a, FILE *pFile);
;rdi <- char* a
;rsi <- FILE
;fprintf(fileID, formatSpec, char*)

strPrint:
  push rbp
  mov rbp, rsp

  cmp rdi, 0
  je .fin

  cmp byte [rdi], 0x00
  jne .noEsNull
  mov rdx, tira_NULL
  jmp .imprimir
  .noEsNull:
  mov rdx, rdi                    ;rdx <- puntero a dato a imprimir

  .imprimir:
  mov rdi, rsi                    ;rdi <- archivo de salida
  mov rsi, formato_fprintfString  ;rsi <- formato de salida necesario de fprintf
  call fprintf

  .fin:

  pop rbp
ret


;*** List ***

%define list_size 16
%define list_first_offset 0
%define list_last_offset 8

%define elem_size 24
%define elem_data_offset 0
%define elem_next_offset 8
%define elem_prev_offset 16

;typedef struct s_list{
;    struct s_listElem *first; -> 8 bytes / 0-8
;    struct s_listElem *last; -> 8 bytes / 9-16
;} list_t;

;typedef struct s_listElem{
;    void *data; -> puntero a data, 8 bytes / 0-8
;    struct s_listElem *next; -> 8 bytes / 9-16
;    struct s_listElem *prev; -> 8 bytes / 17-24
;} listElem_t;

listNew:
  push rbp
  mov rbp, rsp

  mov rdi, list_size
  call malloc
  mov qword [rax + list_first_offset], 0
  mov qword [rax + list_last_offset], 0

  pop rbp
ret

;listAddFirst(list_t* l, void* data);
;rdi <- l
;rsi <- data

listAddFirst:
  push rbp
  mov rbp, rsp
  push rbx
  push r12

  mov rbx, rdi                        ; puntero a lista          se guarda  en rbx
  mov r12, rsi                        ; puntero_a_dato nuevo     se guarda  en r12

  mov rdi, elem_size                  ; Se prepara parametro cantidad de bytes a reservar
  call malloc                         ; Se reserva memoria para el nodo nuevo

                                      ; En rax quedo la direccion del nuevo nodo,
                                      ; y esto se mantiene asi hasta el final de esta funcion

                                      ; Se guarda el valor de la direcci'on del primer elemento de la lista en rdi
  mov rdi, [rbx+list_first_offset]    ; lista_puntero_a_primero  se guarda  en rdi

                                      ; Se guarda el valor de la direcci'on del ultimo elemento de la lista en rdi
                                      ; (esto se usa????? no, por eso lo convertimos en comentario)
  ;mov rsi, [rbx+elem_prev_offset]    ; lista_puntero_a_ultimo   se guarda  en rsi

                                      ; Sobre el nuevo nodo se guarda el puntero al dato
  mov [rax+elem_data_offset], r12     ; puntero_a_dato           se guarda  en nodo_alojado_nuevo.puntero_a_dato

                                      ; Sobre el nuevo nodo se guarda el puntero al siguiente, el que antes fuera el primero.
  mov [rax+elem_next_offset], rdi     ; lista_puntero_a_primero  se guarda  en nodo_alojado_nuevo.puntero_a_sguiente

                                      ; El nuevo nodo es el primero, y no tiene anteriror, por loque en el puntero a anterior se guarda 0000 (puntero con valor ''NULL'')
  mov qword [rax+elem_prev_offset], 0 ; 00000000 ...             se guarda  en nodo_alojado_nuevo.puntero_a_anterior

  cmp qword [rbx+list_last_offset], 0
  jne .listaNoEraVacia

  ;listaEraVacia:                     ; Si la lista estaba previamente vac'ia, hay que apuntar tambien el puntero a 'ultimo al nuevo nodo agregado, que es el unico existente.

  mov [rbx+list_last_offset], rax
  jmp .fin
  .listaNoEraVacia:                   ; Si la lista tenia previamente nodos, hay que apuntar el puntero a 'ultimo al nuevo nodo agregado delante.
  mov [rdi+elem_prev_offset],rax

  .fin:                               ; Se guarda la direccion del nuevo (agregado adelante) en el puntero a primer nodo.
  mov [rbx+list_first_offset], rax

  pop r12
  pop rbx
  pop rbp
ret


listAddLast:    ;funciona al igual que listAddFirst solo que agregando al final en vez de al principio
  push rbp
  mov rbp, rsp

  push rbx
  push r12

  mov rbx, rdi                        ; puntero a lista          se guarda  en rbx
  mov r12, rsi                        ; puntero_a_dato nuevo     se guarda  en r12

  mov rdi, elem_size                  ; Se prepara parametro cantidad de bytes a reservar
  call malloc                         ; Se reserva memoria para el nodo nuevo
                                      ; En rax qued'o la direccion del nuevo nodo,
                                      ; y esto se mantiene asi hasta el final de esta funcion

  mov rdi, [rbx+list_last_offset]     ; lista_puntero_a_ultimo   se guarda  en rdi
  mov [rax+elem_prev_offset], rdi     ; lista_puntero_a_ultimo   se guarda  en nodo_alojado_nuevo.puntero_a_anterior
  ;mov rsi, [rbx+elem_next_offset]
  mov [rax+elem_data_offset], r12     ; puntero_a_dato           se guarda  en nodo_alojado_nuevo.puntero_a_dato

  mov qword [rax+elem_next_offset], 0 ; 00000000 ...             se guarda  en nodo_alojado_nuevo.puntero_a_sguiente

  cmp qword [rbx+list_first_offset], 0
  jne .ListaNoEraVacia

  ;listaEraVacia:                     ; Si la lista estaba previamente vac'ia, hay que apuntar tambien el puntero a primero al nuevo nodo agregado, que es el unico existente.
  mov [rbx+list_first_offset], rax
  jmp .fin
  .ListaNoEraVacia:                   ; Si la lista tenia previamente nodos, hay que apuntar el puntero a primero al nuevo nodo agregado al final.
  mov [rdi+elem_next_offset],rax

  .fin:
  mov [rbx+list_last_offset], rax     ; Se guarda la direccion del nuevo nodo (agregado al final) en el puntero a ultimo nodo.

  pop r12
  pop rbx

  pop rbp
ret

;void listAdd(list_t* l, void* data, funcCmp_t* fc);
;rdi <- l
;rsi <- data
;rdx <- fc

listAdd:
  push rbp
  mov rbp, rsp
  push rbx
  push r12
  push r13
  push r14

  ; Se guardan los par'ametros recibidos en los registros que se preservan.
  mov rbx, rdi    ;puntero a l
  mov r12, rsi    ;puntero a data
  mov r13, rdx    ;puntero a fc

  cmp qword [rbx+list_first_offset], 0    ; Si la lista viene vac'ia, first apunta a 0.
  jne .ListaNoVieneVacia

  call listAddFirst     ; Par'amatros: puntero a l en rdi, puntero a data en rsi.
  jmp .fin



  .ListaNoVieneVacia:

  mov r14, [rbx+list_first_offset]    ; Se guarda en r14 la direcci'on del primer nodo.
  mov rdi, [r14+elem_data_offset]     ; Valor "a" para comparar.
  mov rsi, r12                        ; Valor "b" para comparar.
  call r13      ; Se llama a la funcion comparadora.
                ; Si devuelve 1, el dato del primer nodo es menor que el pasado por parametro.
                ; Si devuelve 0, son iguales.
                ; Si devuelve -1, el dato del primer nodo es mayor que el pasado por parametro
                ; Se elije poner al dato pasado por parametro por delante del primer dato si es menor o igual
  cmp eax, -1
  jne .buscoPosEnMedio     ; Si la comparacion da 1 o 0, se agrega adelante. Sino se busca posici'on para intercalar.

  ;agregoAdelante:
  mov rdi, rbx
  mov rsi, r12
  call listAddFirst        ;agrego al principio tomando como parametros a rdi (puntero a l) y a rsi (puntero a data)
  jmp .fin

  .buscoPosEnMedio:        ;avanzo a la siguiente posicion dentro de la lista y vuelvo a comparar
                           ;lo que puede suceder ahora es que, en la siguiente posicion no haya nada o que tenga que seguir avanzando

  cmp qword [r14+elem_next_offset], 0
  je .agregoAlFinal                     ;si es igual a 0, quiere decir que r14 apuntaba al 'ultimo elemento de la lista

  mov r14, [r14+elem_next_offset]       ;avanzo dentro de la lista
  mov rdi, [r14+elem_data_offset]
  mov rsi, r12
  call r13                        ;vuelvo a llamar a la funcion que compara para determinar donde agregar al nodo
  cmp eax, -1
  jne .buscoPosEnMedio            ; Si la comparaci'on da 1 o 0, el elemento del nodo es menor y hay que continuar avanzando.
                                  ; Si la comparaci'on da -1,    el elemento del nodo es mayor y hay que ingresar el dato antes.

  ;ingresoEnMedio:
  mov rdi, elem_size
  call malloc
  mov rdi, [r14+elem_prev_offset]   ;guardo en rdi el puntero al anterior de r14 (el indice)
  mov [rdi+elem_next_offset], rax   ;hago que el siguiente de rdi apunte al nuevo nodo
  mov [r14+elem_prev_offset], rax   ;hago que el anterior de r14 apunte al nuevo nodo

  mov [rax+elem_data_offset], r12   ;guardo el dato pasado por parametro en el nuevo nodo
  mov [rax+elem_next_offset], r14   ;apunto el siguiente del nuevo nodo a r14
  mov [rax+elem_prev_offset], rdi   ;apunto el anterior del nuevo nodo al que era el anterior a r14
  jmp .fin

  .agregoAlFinal:
  mov rdi, rbx
  mov rsi, r12
  call listAddLast        ;agrego al final tomando como parametros a rdi (puntero a l) y a rsi (puntero a data)


  .fin:
  pop r14
  pop r13
  pop r12
  pop rbx
  pop rbp
ret


;list_t* listClone(list_t* l, funcDup_t* fn);
; rdi <- l
; rsi <- fn
;void listAddLast(list_t* l, void* data);


listClone:
  push rbp
  mov rbp, rsp

  push rbx
  push r12
  push r13
  push r14

  mov rbx, rdi  ; Se preserva el puntero a l
  mov r12, rsi  ; Se preserva el puntero a fn
  mov r14, [rdi+list_first_offset]
  call listNew
  cmp r14, 0
  je .fin
  mov r13, rax  ; Se preserva el puntero a la nueva lista

  %define l_orig rbx
  %define l_clon r13
  %define d_copiar r12
  %define l_orig_Nodo r14

  .loop:
    mov rdi, [l_orig_Nodo+elem_data_offset]   ; Puntero a dato para clonar
    call d_copiar
    mov rsi, rax
    mov rdi, l_clon                           ; Par'ametro de lista nueva para listAddLast


    call listAddLast

    mov l_orig_Nodo, [l_orig_Nodo+elem_next_offset]
    cmp l_orig_Nodo, 0
    je .fin
  jmp .loop

  .fin:

  mov rax, r13

  pop r14
  pop r13
  pop r12
  pop rbx

  pop rbp
ret

;void listDelete(list_t* l, funcDelete_t* fd);
;void strPrint(char* a, FILE *pFile);
;rdi <- char* a
;rsi <- FILE
;fprintf(fileID, formatSpec, char*)
listDelete:
  push rbp
  mov rbp, rsp
  push rbx
  push r12

  mov rbx, rdi    ;puntero a l
  mov r12, rsi    ;puntero a fd

  cmp qword [rdi+list_first_offset], 0    ;me fijo que la lista no sea vacia
  je .fin



  .loop:
  mov rdi, [rbx+list_first_offset]

  cmp qword [rdi+elem_next_offset], 0     ;me fijo si el primero es el ultimo elemento
  jne .noEsUltimo

  ;esUltimo
    cmp qword r12, 0  ;si fd es 0, no se llama a ninguna funcion de borrado de dato, se asume que no hace falta borrarlo por una fd.
    je .borrarNodoPrim

      ;borrarDatoPrim:
      mov rdi, [rdi+elem_data_offset]
      call r12                    ;libero la memoria a la que apunta rdi (el primer elemento de la lista)

    .borrarNodoPrim:
    mov rdi, [rbx+list_first_offset]
    call free
    jmp .fin

  .noEsUltimo:

    cmp qword r12, 0  ;si fd es 0, no se llama a ninguna funcion de borrado de dato, se asume que no hace falta borrarlo por una fd.
    je .borrarNodoSig

      ;borrarDatoSig:
      mov rdi, [rdi+elem_data_offset]
      call r12

    .borrarNodoSig:
    ; Puede haber reconecciones excesivas
    ; que no hacen falta, pues de todas maneras todos los nodos se van a borrar.
    ; Se podr'ia optimizar
    mov rdi, [rbx+list_first_offset]
    mov rsi, [rdi+elem_next_offset]
    mov [rbx+list_first_offset], rsi
    mov qword [rsi+elem_prev_offset], 0
    call free
  jmp .loop

  .fin:

  mov rdi, rbx    ; Argumento para funci'on free
  call free

  ;mov rdi, 0      ; Devolvemos el par'ametro apuntado a 0

  pop r12
  pop rbx
  pop rbp
ret

;void listPrint(list_t* l, FILE *pFile, funcPrint_t* fp);
;rdi <- l
;rsi <- FILE
;rdx <- fp
listPrint:
  push rbp
  mov rbp, rsp

  cmp rdi, 0
  je .noIniciada

  push rbx
  push r12
  push r13
  push r14

  mov rbx, rdi    ; Se preserva el puntero a l
  mov r12, rsi    ; Se preserva el puntero a FILE
  mov r13, rdx    ; Se preserva el puntero a fp
  mov r14, [rdi+list_first_offset]

  mov rdx, 0x5B
  mov rdi, r12
  mov rsi, formato_fprintfChar
  call fprintf    ; Se imprime el caracter '['

  cmp r14, 0      ; Si el primer elemento es nulo, no se imprimo nada
  je .fin

  .loop:
  mov rdi, r12                      ; En rdi se guarda el puntero al archivo de salida
  cmp r13, 0
  je .imprimoPuntero

  ;imprimoCon_fp:
  mov rdi, [r14+elem_data_offset]   ; pongo en rdx el dato a imprimir
  mov rsi, r12
  call r13
  jmp .siguiente

  .imprimoPuntero:
  mov rdx, r14                       ;pongo en rdx el puntero a imprimir
  mov rsi, formato_fprintfPuntero    ;le doy a rsi el formato a puntero
  call fprintf

  .siguiente:
  mov r14, [r14+elem_next_offset]
  cmp r14, 0    ;si avanzo al siguiente y este es NULL, termino la ejecucion
  je .fin

  mov rdx, 0x2C
  mov rdi, r12
  mov rsi, formato_fprintfChar
  call fprintf    ; Se imprime el caracter ','
  jmp .loop

  .fin:
  mov rdx, 0x5D
  mov rdi, r12
  mov rsi, formato_fprintfChar
  call fprintf    ; Se imprime el caracter ']'

  pop r14
  pop r13
  pop r12
  pop rbx

  .noIniciada:

  pop rbp
ret


;*** Sorter ***

;typedef struct s_sorter{
;   uint16_t size;
;   funcSorter_t *sorterFunction;
;   funcCmp_t *compareFunction;
;   list_t **slots;
;} sorter_t;


%define sorter_size 32
%define sorter_size_offset 0
%define sorter_fs_offset 8
%define sorter_fc_offset 16
%define sorter_slots_offset 24



sorterNew:
  push rbp
  mov rbp, rsp

  sub rsp, 8
  push rbx
  push r12
  push r13

  %define slotsCant bx
  xor rbx, rbx
  mov slotsCant, di
  mov r12, rsi  ;fs
  mov r13, rdx  ;fc

  mov rdi, sorter_size
  call malloc

  mov qword [rax + sorter_size_offset], 0

  mov word [rax + sorter_size_offset], slotsCant
  mov [rax + sorter_fs_offset], r12
  mov [rax + sorter_fc_offset], r13

  mov r12, rax     ; En r12 ahora guardamos el puntero al sorter.

  xor rdi, rdi
  mov word di, slotsCant
  imul di, 8    ;cada slot contiene un puntero, cada puntero ocupa 8byte.
  call malloc

  mov r13, rax    ; En r13 ahora guardamos el puntero los slots.

  mov [r12 + sorter_slots_offset], r13

  dec rbx

  .iniciarListas:

  call listNew
  mov rcx, r13      ; esto es por si listNew pis'o rcx.    Podemos optimizar usando rbx,  que puede usarse como base de direccionamiento, y sabemos que se conserva a diferencia de rcx   No podemos! Ya lo usamos para slotsCant
  mov [rcx + rbx*8], rax

  dec rbx
  cmp rbx, 0
  jge .iniciarListas

  mov rax, r12

  pop r13
  pop r12
  pop rbx
  add rsp, 8

  pop rbp
ret


sorterAdd:

  push rbp
  mov rbp, rsp

  push rbx
  push r12

  mov rbx, rdi    ;sorterPtr
  mov r12, rsi    ;dataPtr

  mov rdi, r12

  call [rbx+sorter_fs_offset]      ; Se llama a la funcion sorter.

  ; En ax ahora est'a el n'umero de slot en que corresponde guardar el dato.

  shl rax, 48
  shr rax, 48

  mov rdi, [rbx+sorter_slots_offset]
  mov rdi, [rdi+rax*8]

  ; En rdi est'a la direccion de la lista a la que tiene que ir el dato.

  mov rsi, r12     ;dataPtr
  mov rdx, [rbx+sorter_fc_offset]    ; Se carga parametro funcion comparacion.
  call listAdd

  pop r12
  pop rbx

  pop rbp

ret


sorterRemove:

  push rbp
  mov rbp, rsp


  push rbx
  push r12
  push r13
  push r14

  mov rbx, rdi    ;sorterPtr
  mov r12, rsi    ;dataPtr
  mov r13, rdx    ;fdPtr

  mov rdi, r12

  call [rbx+sorter_fs_offset]      ; Se llama a la funcion sorter.

  ; En ax ahora est'a el n'umero de slot en que corresponde guardar el dato.

  mov rdi, [rbx+sorter_slots_offset]
  xor rcx, rcx
  mov cx, ax
  mov rdi, [rdi+rcx*8]            ; En rdi queda la direccion de la lista del dato.
  mov rsi, r12                    ; Parametro dataPtr con referencia a borrar.
  mov rdx, [rbx+sorter_fc_offset] ; Par'ametro puntero a funci'on de comparaci'on de datos.
  mov rcx, r13                    ; Par'ametro puntero a funci'on de borrado de dato.

  call listRemove

  pop r14
  pop r13
  pop r12
  pop rbx


  pop rbp

ret


sorterGetSlot:
  push rbp
  mov rbp, rsp
                                     ; rdi contiene sorterPtr
                                     ;  si contiene slotN
                                     ; rdx contiene fn
  xor rcx, rcx
  mov cx, si                         ; rcx contiene slotN

  mov rdi, [rdi+sorter_slots_offset] ; rdi contiene slotsPtr ; Se pierde sorterPtr pero ya no se usa.
  mov rdi, [rdi+rcx*8]               ; rdi contiene listNPtr, primer argumento para listClone  ; Se pierde slotsPtr pero ya no se usa.
  mov rsi, rdx                       ; rsi contiene fn,  segundo argumento para listClone

  call listClone
  ; listClone dej'o el puntero a la lista en rax que es donde lo tiene que dejar sorterGetSlot.

  pop rbp
ret


sorterGetConcatSlot:

  ; En rdi est'a sorterPtr.
  ; En rsi est'a el nro de slot.

  ; Suponiendo que se quiere mantener strings originales,
  ; es decir,
  ; evitar dejar nodos de la lista del slot apuntando a strings liberados,
  ; no podemos usar strConcat, que libera la mamoria de los strings.

  ; Se puede en cambio:
  ; - Sumar los largos de todos los strings
  ;   para luego reservar con malloc esa cantidad + 1 de bytes en memoria.

  ; Esto es un algoritmo m'as eficiente que usar strConcat,
  ; que implica alojar, escribir y desalojar muchas veces en memoria.

  push rbp
  mov rbp, rsp

  push rbx
  push r12
  push r13
  push r14

  xor r12, r12
  mov r12w, si                       ; r12 contiene slotN
  mov r13, [rdi+sorter_slots_offset] ; r13 contiene slotsPtr
  mov r13, [r13+r12*8]               ; r13 contiene listNPtr ; Se pierde slotsPtr pero no se usa.


  ; Se pretende recorrer la lista para calcular primero
  ; longitud + 1 de memoria a reservar para tira final concatenada.

  mov r12, 1        ; Sobre r12 se calcula longitud + 1 de tira final concatenada.

  ; Se verifica primero que no est'e vacia.
  ; Aunque sorterNew inicializa listas en el sorter,
  ; pueden haberse borrado luego, y
  ; esperamos que en esos borrados los punteros hayan sido apuntados a NULL.
  cmp r13, 0
  je .finLoopLong ; Si se salta a finLoopLong ahora significa que hay que reservar 1 byte para almacenar valor 0.


  mov r14, [r13 + list_first_offset] ; r14 contiene listNodeFirstPtr.
  .loopLong:
  cmp r14, 0
  je .finLoopLong
  mov rdi, [r14 + elem_data_offset]
  call strLen

  shl rax, 32
  shr rax, 32

  add r12, rax
  mov r14, [r14 + elem_next_offset]  ; r14 contiene listNodePtr.
  jmp .loopLong
  .finLoopLong:


  ; Ya se calcul'o la cantidad de bytes a reservar para la tira final.
  ; Se reserva memoria
  mov rdi, r12
  call malloc
  mov rbx, rax      ; rbx ahora contiene puntero a tira final concatenada.
  mov r12, rbx      ; r12 ahora contiene direcci'on para escribir dentro de la tira de salida.

  ; Se pretende copiar los strings invividuales al string final.
  ; Se va a usar la instrucci'on movsb varias veces, y se recalcula strLen cada vez.
  ; En su lugar podriamos tambi'en copiar byte a byte, evitando usar strLen.
  ; Se ubican los parametros en los registros correspondientes.

  mov r14, [r13 + list_first_offset] ; r14 contiene listNodeFirstPtr.
  .loopCopiar:
  cmp r14, 0
  je .finloopCopiar
  mov rdi, [r14 + elem_data_offset]
  call strLen
  shl rax, 32
  shr rax, 32
  mov r13, rax      ; Se resguarda la cantidad de bytes a ser copiados, para sumar luego de copiar sobre r12
  mov rdi, r12      ; Direcci'on para escribir dentro de la tira de salida.
  mov rsi, [r14 + elem_data_offset]      ; Direcci'on de la tira original.
  mov rcx, r13      ; Cantidad de bytes a ser copiados.
  cld               ; Se limpian los bits de control (flags).
  REPE movsb
  add r12, r13      ; r12 contiene direcci'on para escribir dentro de la tira de salida.
  mov r14, [r14 + elem_next_offset]  ; r14 contiene listNodePtr.
  jmp .loopCopiar
  .finloopCopiar:

  mov byte [r12], 0    ; Byte con valor 0 para indicar final de tira.

  mov rax, rbx


  pop r14
  pop r13
  pop r12
  pop rbx

  pop rbp
ret


sorterCleanSlot:

  push rbp
  mov rbp, rsp

  push rbx
  push r12
                                     ; rdi contiene sorterPtr
                                     ;  si contiene slotN
                                     ; rdx contiene fd
  xor rcx, rcx
  mov cx, si                         ; rcx contiene slotN
  mov r12, rcx                       ; r12 contiene slotN
  mov rbx, [rdi+sorter_slots_offset] ; rbx contiene slotsPtr
  mov rdi, [rbx+rcx*8]               ; rdi contiene listNPtr, primer argumento para listDelete  ; Se pierde sorterPtr pero ya no se usa.
  mov rsi, rdx                       ; rsi contiene fd,  segundo argumento para listDelete
  call listDelete
  call listNew                       ; como sorterNew deja como estandar las listas iniciadas, se prefiere que sorterCleanSlot tambien deje listas vacias iniciadas
  mov rcx, r12
  mov [rbx+rcx*8], rax            ; se apunta listNPtr dentro del array de slots a NULL.

  pop r12
  pop rbx
  pop rbp
ret


sorterDelete:
  push rbp
  mov rbp, rsp

  push rbx
  push r12
  push r13
  push r14

  xor rbx, rbx

  mov r13, rdi                        ;sorter
  mov r12, [r13+sorter_slots_offset]  ;slotsPter
  mov bx, [r13+sorter_size_offset]    ;slotsCant
  mov r14, rsi                        ;fd

  dec rbx

  .borrarListas:
  mov rcx, r12
  mov rdi, [rcx + rbx*8]
  mov rsi, r14

  call listDelete

  dec rbx
  cmp rbx, 0
  jge .borrarListas

  mov rdi, r12
  call free
  mov rdi, r13
  call free

  pop r14
  pop r13
  pop r12
  pop rbx

  pop rbp

ret


;void sorterPrint(sorter_t* sorter, FILE *pFile, funcPrint_t* fp)

sorterPrint:
  push rbp
  mov rbp, rsp

  sub rsp, 8
  push rbx
  push r12
  push r13
  push r14
  push r15

  mov r12, [rdi+sorter_slots_offset]  ;slotsPter
  mov r13, rsi
  mov r15w, [rdi+sorter_size_offset]  ;slotsCant
  mov r14, rdx                        ;fp

  xor rbx, rbx                          ;slotN

  .imprimirListas:

    mov rdx, rbx                 ; slotN
    mov rdi, r13                 ; Puntero a flujo (stream) hacia archivo de salida.
    mov rsi, formato_fprintfEntero
    call fprintf                 ; Se llama a funcion fprintf para imprimir sobre archivo.

    mov rdx, tira_EspIgualEsp    ; Tira ' = '
    mov rdi, r13                 ; Puntero a flujo (stream) hacia archivo de salida.
    mov rsi, formato_fprintfString
    call fprintf                 ; Se llama a funcion fprintf para imprimir sobre archivo.

    mov rcx, r12
    mov rdi, [rcx + rbx*8]
    mov rsi, r13
    mov rdx, r14

    call listPrint

    mov rdx, 0x0A   ; Caracter salto de l'inea (o '\n') en sistemas Unix.
    mov rdi, r13    ; Puntero a flujo (stream) hacia archivo de salida.
    mov rsi, formato_fprintfChar
    call fprintf    ; Se llama a funcion fprintf para imprimir sobre archivo.

    inc bx
    cmp bx, r15w

  jl .imprimirListas

  pop r15
  pop r14
  pop r13
  pop r12
  pop rbx
  add rsp, 8

  pop rbp
ret


;*** aux Functions ***


fs_sizeModFive:

  push rbp
  mov rbp, rsp

  call strLen      ; En rdi ya est'a el puntero a la tira (argumento de strLen).

  ; En eax (32 bits bajos de rax) ya se tiene el largo de la tira.

  xor edx, edx       ; Se limpia la parte alta del dividendo.
  mov ecx, 5       ; Se carga el divisor.
  div ecx          ; Lo que est'a en edx:eax se divide por lo que est'a en ecx.

  ; resultado de division queda en eax
  ; resto de division en edx

  xor ax, ax       ; Se limpia ax. Resultado de divisi'on queda descartado.
  mov ax, dx      ; Se retorna el resto de la divisi'on sobre rax.

  pop rbp

ret

;uint16_t fs_firstChar(char* s);
;rdi <- s
fs_firstChar:
  xor ax, ax
	mov al, [rdi]	;  En al se guarda el byte del primer caracter.
ret

;uint16_t fs_bitSplit(char* s);
;rdi <- s
;si el primer caracter es 0, al <- 8
;si es potencia de 2 (2^n), al <- n
;else, al <- 9

;fs_bitSplit:
;mov ax, 0
;	mov sil, [rdi]	; En al se guarda el byte del primer caracter
;	cmp sil, 0
;	je .esCero
;
;	mov al, 1
;	mov dl, 1	;exponente
;	jne .loop	;si no es 0, me fijo si es potencia de 2
;
;	.esCero:
;  mov ax, 0
;	mov al, 8
;	jmp .fin

;	.loop:
;	cmp al, sil
;	je .fin
;	shl al, 1	; Se trasladan los bits (shiftean) 1 posici'on hacia la izquierda
;	inc dl
;	cmp dl, 9
;	jne .loop

;	;.next:
;  mov ax, 0
;	mov al, dl

;	.fin:
;ret

fs_bitSplit:
  mov r8b, [rdi]

  mov rax, 9
  mov rsi, 1   ; Generador de potencias de 2
  mov cx, -1   ; C'alculo de Log_2(rsi)

  .loop:
  inc cx
  cmp sil, r8b
  je .esPotencia
  cmp sil, 0
  je .noEsPotencia
  shl sil, 1
  jmp .loop

  .esPotencia:
  mov ax, cx
  .noEsPotencia:

ret
