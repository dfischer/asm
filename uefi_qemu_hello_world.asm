;; qemu-system-x86_64 -bios OVMF.fd -net none -drive format=raw,file=fat:rw:drive/
;; https://johv.dk/blog/bare-metal-assembly-tutorial.html

format pe64 efi

entry main

section '.text' executable readable

main: 
    ;; Recall that RDX contains a pointer to the System Table when
    ;; our application is called. So rdx + 64 is the address of the
    ;; pointer to ConOut, and [rdx + 64] is the pointer itself.
    mov rcx, [rdx + 64]

    ;; Now, RCX contains the ConOut pointer. Thus, the address of
    ;; the OutputString function is at rcx + 8. We'll move this
    ;; function into RAX:
    mov rax, [rcx + 8]

    ;; We already have the ConOut pointer in RCX. Let's load the
    ;; string pointer into RDX:
    mov rdx, string

    ;; Set up the shadow space. We just need to reserve 32 bytes
    ;; on the stack, which we do by manipulating the stack pointer:
    sub rsp, 32

    ;; Now we can call the OutputString function, whose address is
    ;; in the RAX register:
    call rax

    ;; Finally, we'll clean up the shadow space and then return:
    add rsp, 32

    ret

section '.data' readable writable
string du 'Hello, World!', 0xD, 0xA, 0
