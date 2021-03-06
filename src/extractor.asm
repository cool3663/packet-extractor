;========================================================================
;  Copyright (c) 2010 OpenKore Team
;
;  This software is open source, licensed under the GNU General Public
;  License, version 2.
;  Basically, this means that you're allowed to modify and distribute
;  this software. However, if you distribute modified versions, you MUST
;  also distribute the source code.
;  See http://www.gnu.org/licenses/gpl.html for the full license.
;
;  $Revision: 7546 $
;  $Id: extractor.asm 7546 2010-10-22 01:19:43Z kLabMouse $
;
;========================================================================

format PE console
entry start

include 'win32a.inc'

;=======================================
section '.code' code readable executable
;=======================================

; Got this function for MS compiled app ;)
proc __alloca_probe
	push ecx
	cmp eax, 00001000
	lea ecx, dword [esp+08h]
	jb l2
l1:
	sub ecx, 00001000
	sub eax, 00001000
	test dword [ecx], eax
	cmp eax, 00001000
	jnb l1
l2:
	sub ecx, eax
	mov eax, esp
	test dword [ecx], eax
	mov esp, ecx
	mov ecx, dword [eax]
	mov eax, dword [eax+04h]
	push eax
	ret
endp

; Prepares params for print_packet2
proc set_packet_len
	push ebp
	mov ebp, esp
	mov edx, dword [ebp+0Ch] ; edx -> PacketLen
	mov eax, ecx
	mov ecx, dword [ebp+08h] ; ecx -> PacketInnerLen
	mov dword [eax], ecx ; offset+00h -> PacketInnerLen
	mov dword [eax+04h], edx ; offset+04h -> PacketLen
	pop ebp
	retn 8
endp

; Prepares params for print_packet4 and print_packet5
proc set_packet_len2
	push ebp
	mov ebp, esp
	mov edx, dword [ebp+0Ch] ; edx -> PacketLen
	mov eax, ecx
	mov ecx, dword [ebp+08h] ; ecx -> PacketInnerLen
	mov [eax], ecx ; offset+00h -> PacketInnerLen
	mov ecx, dword [ebp+10h] ; ecx -> Unknown ??? O_o
	mov dword [eax+04h], edx ; offset+04h -> PacketLen
	mov dword [eax+08h], ecx ; offset+08h ->  Unknown ??? O_o
	pop ebp
	retn 0Ch
endp

; Print out packet (type 1)
proc print_packet1
	push ebp
	mov ebp, esp
	mov eax, ecx
	push eax
	mov ecx, dword [ebp+08h]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov ecx, dword [ebp+0Ch]
	mov edx, dword [ecx] ; edx -> PacketLen
	mov ecx, dword [ecx+04h] ; ecx -> PacketInnerLen
	ccall [printf], str2, eax, edx, ecx
	pop eax
	pop ebp
	retn 8
endp

; Print out packet (type 2)
proc print_packet2
	push ebp
	mov ebp, esp
	mov ecx, dword [ebp+0Ch]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov ecx, dword [ebp+10h]
	mov edx, dword [ecx] ; edx -> PacketLen
	mov ecx, dword [ecx+04h] ; ecx -> PacketInnerLen
	ccall [printf], str2, eax, edx, ecx
	pop ebp
	ret
endp

; Print out packet (type 3)
proc print_packet3
	push ebp
	mov ebp, esp
	mov ecx, dword [ebp+0Ch]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov edx, dword [ecx+04h] ; edx -> PacketLen
	mov ecx, dword [ecx+08h] ; ecx -> PacketInnerLen
	ccall [printf], str2, eax, edx, ecx
	pop ebp
	ret
endp

; Print out packet (type 4)
proc print_packet4
	push ebp
	mov ebp, esp
	mov ecx, dword [ebp+08h]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov ecx, dword [ebp+0Ch]
	mov edx, dword [ecx] ; edx -> PacketLen
	mov ebx, dword [ecx+04h] ; ebx -> PacketInnerLen
	mov ecx, dword [ecx+08h] ; ecx ->  Unknown ??? O_o
	ccall [printf], str3, eax, edx, ebx, ecx
	pop ebp
	ret
endp

; Print out packet (type 5)
proc print_packet5
	push ebp
	mov ebp, esp
	mov ecx, dword [ebp+0Ch]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov ecx, dword [ebp+10h]
	mov edx, dword [ecx] ; edx -> PacketLen
	mov ebx, dword [ecx+04h] ; ebx -> PacketInnerLen
	mov ecx, dword [ecx+08h] ; ecx ->  Unknown ??? O_o
	ccall [printf], str3, eax, edx, ebx, ecx
	pop ebp
	ret
endp


; Print out packet (type 6)
proc print_packet6
	push ebp
	mov ebp, esp
	mov ecx, dword [ebp+0Ch]
	mov eax, dword [ecx] ; eax -> Packet_ID
	mov edx, dword [ecx+04h] ; edx -> PacketLen
	mov ebx, dword [ecx+08h] ; ebx -> PacketInnerLen
	mov ecx, dword [ecx+0Ch] ; ecx -> Unknown ??? O_o
	ccall [printf], str3, eax, edx, ebx, ecx
	pop ebp
	ret
endp

; Print out packet (type 7)
proc print_packet7
	push ebp
	mov ebp, esp
	mov eax, ecx
	push eax
	mov eax, dword [ebp+08h] ; eax -> Packet_ID
	mov ecx, dword [ebp+0Ch] ; ecx -> PacketLen
	mov edx, dword [ebp+10h] ; edx -> PacketInnerLen
	mov ebx, dword [ebp+14h] ; ebx ->  Unknown ??? O_o
	ccall [printf], str3, eax, ecx, edx, ebx
	pop eax
	pop ebp
	retn 8
endp

; Dummy Function to replace old std::map calls
proc dummy
	push ebp
	mov ebp, esp
	sub esp, 8
	; My Code here
	mov esp, ebp
	pop ebp
	retn 8
endp

; Stolen Code
; Packet Len Map
proc packet_len_map
  ; Allocate 200Kb for stolen function
  db 032000h dup(090h) ; Fill with 'nop'
  retn
endp

start:
	; Output the two Intro lines
	ccall	[printf],str0
	ccall	[printf],str1
	; Call our Stolen code
	call packet_len_map
	; Wait for user Input
	; ccall   [getchar]
	; Exit process, as Always =)
	stdcall [ExitProcess],0

;======================================
section '.data' data readable writeable
;======================================
; Just to keep functions on their places (No to loose them).
dd __alloca_probe
dd set_packet_len
dd set_packet_len2
dd print_packet1
dd print_packet2
dd print_packet3
dd print_packet4
dd print_packet5
dd print_packet6
dd print_packet7
dd dummy

str0	db '# Packet Extractor by kLabMouse',0Ah,0
str1	db '# Extracted from ', 0FFh dup(70h),0 ; Replace the 0x70... sequence with original source name
str2	db 0Ah,'%0.4X %d %d',0
str3	db 0Ah,'%0.4X %d %d %d',0
hello_msg db 'Hello, world!',0

;====================================
section '.idata' import data readable
;====================================

library kernel,'kernel32.dll',\
	msvcrt,'msvcrt.dll'

import kernel,\
       ExitProcess,'ExitProcess'

import msvcrt,\
       printf,'printf',\
       getchar,'_fgetchar'