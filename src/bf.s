global _main
extern _puts
extern _putchar
extern _getchar

section .text

_main:
  call    print_intro
  call    interpret

  ret

print_intro:
  lea     rdi, [message]
  call    _puts

  ret

interpret:
  lea  rdi, [code]
  call _puts
  lea  rbx, [code]

  mov word [pointer], 0

; rbx is used as a pointer to the current character in the code
; rax is used to store the current character in the code
; rcx and rdx are used as main registers for all the operations

.loop:
  ; Load the first character of the code into rax
  mov rax, [rbx]

  ; If the character is 0, we're done
  mov   rax, [rbx]
  cmp   rax, 0
  je    done

  ; If the character is +, increment the byte at the pointer
  movzx  rax, byte [rbx]

  cmp  rax, '+'
  jne  .not_plus
  call plus
  .not_plus:

  cmp  rax, '-'
  jne  .not_minus
  call minus
  .not_minus:

  cmp  rax, '.'
  jne  .not_dot
  call print_char
  .not_dot:

  cmp rax, '>'
  jne .not_right
  add word [pointer], 1
  .not_right:

  cmp rax, '<'
  jne .not_left
  sub word [pointer], 1
  .not_left:

  cmp rax, ','
  jne .not_comma
  call read_char
  .not_comma:

  cmp rax, '['
  jne .not_left_bracket
  call left_bracket
  .not_left_bracket:

  cmp rax, ']'
  jne .not_right_bracket
  call right_bracket
  .not_right_bracket:

  inc    rbx

  jmp    .loop

plus:
    lea rcx, [pointer]
    mov rcx, [rcx] ; rbx now has the value of pointer

    lea rdx, [buffer]
    add rcx, rdx ; rbx now has the address of the byte we want to increment

    inc byte [rcx]
  ret

minus:
    lea rcx, [pointer]
    mov rcx, [rcx] ; rcx now has the value of pointer

    ; load address of buffer into rsi
    lea rdx, [buffer]
    add rcx, rdx ; rcx now has the address of the byte we want to increment

    dec byte [rcx]

  ret

print_char:
    lea   rcx, [pointer]
    mov   rcx, [rcx] ; rcx now has the value of pointer

    ; load address of buffer into rsi
    lea rdx, [buffer]
    add rcx, rdx ; rcx now has the address of the byte we want to increment

    mov rcx, [rcx]

    mov rdi, rcx

    call _putchar
  ret

read_char:
    call _getchar

    lea   rcx, [pointer]
    mov   rcx, [rcx] ; rcx now has the value of pointer

    lea rdx, [buffer]
    add rcx, rdx
    mov  [rcx], al ; store the character in the buffer
  ret

left_bracket:
  ret

right_bracket:
  ret

done:
    lea     rdi, [end_message]
    call    _puts

    mov word [pointer], 0

    lea   rdi, [pointer]
    mov   rdi, [rdi] ; rdi now has the value of pointer

    ; load address of buffer into rsi
    lea rsi, [buffer]
    add rdi, rsi ; rdi now has the address of the byte we want to increment

    mov rdi, [rdi]

    call _putchar

    mov    rax, 0 ; Return 0
    ret

section .bss
buffer:         resb    65536 ; 64k buffer
pointer:        resw    1 ; word is 2 bytes. To index the buffer, we need 2 bytes

section .data
message:
    db   "Brainfuck interpreter", 0

plus_message:
  db "Got plus", 10, 0

end_message: 
  db 10, "End", 10, 0

code:
  default rel
    db   ",.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.+++-.>+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.<.", 0
