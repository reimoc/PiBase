
build/kernel8-rpi4.elf:	file format elf64-littleaarch64

Disassembly of section .text.boot:

0000000000080000 <_start>:
   80000: d53800a0     	mrs	x0, MPIDR_EL1
   80004: 92401c00     	and	x0, x0, #0xff
   80008: b4000040     	cbz	x0, 0x80010 <master>
   8000c: 1400000e     	b	0x80044 <proc_hang>

0000000000080010 <master>:
   80010: d5384241     	mrs	x1, CurrentEL
   80014: d342fc21     	lsr	x1, x1, #2
   80018: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8001c: 9137c000     	add	x0, x0, #0xdf0
   80020: d0000001     	adrp	x1, 0x82000 <_estack_size+0x72000>
   80024: 9137e021     	add	x1, x1, #0xdf8
   80028: cb000021     	sub	x1, x1, x0
   8002c: 940006a4     	bl	0x81abc <memzero>
   80030: 90002120     	adrp	x0, 0x4a4000 <__stack_start+0xf1c8>
   80034: 9138e000     	add	x0, x0, #0xe38
   80038: 9100001f     	mov	sp, x0
   8003c: 9400037e     	bl	0x80e34 <kernel_main>
   80040: 14000001     	b	0x80044 <proc_hang>

0000000000080044 <proc_hang>:
   80044: d503205f     	wfe
   80048: 17ffffff     	b	0x80044 <proc_hang>

Disassembly of section .text:

000000000008004c <compute_xor_checksum>:
   8004c: d10083ff     	sub	sp, sp, #0x20
   80050: f90007e0     	str	x0, [sp, #0x8]
   80054: b90007e1     	str	w1, [sp, #0x4]
   80058: b9001fff     	str	wzr, [sp, #0x1c]
   8005c: b9001bff     	str	wzr, [sp, #0x18]
   80060: 1400000a     	b	0x80088 <compute_xor_checksum+0x3c>
   80064: f94007e0     	ldr	x0, [sp, #0x8]
   80068: b9401be1     	ldr	w1, [sp, #0x18]
   8006c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80070: b9401fe1     	ldr	w1, [sp, #0x1c]
   80074: 4a000020     	eor	w0, w1, w0
   80078: b9001fe0     	str	w0, [sp, #0x1c]
   8007c: b9401be0     	ldr	w0, [sp, #0x18]
   80080: 11000400     	add	w0, w0, #0x1
   80084: b9001be0     	str	w0, [sp, #0x18]
   80088: b9401be1     	ldr	w1, [sp, #0x18]
   8008c: b94007e0     	ldr	w0, [sp, #0x4]
   80090: 6b00003f     	cmp	w1, w0
   80094: 54fffe83     	b.lo	0x80064 <compute_xor_checksum+0x18>
   80098: b9401fe0     	ldr	w0, [sp, #0x1c]
   8009c: 910083ff     	add	sp, sp, #0x20
   800a0: d65f03c0     	ret

00000000000800a4 <update_reference_checksums>:
   800a4: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   800a8: 910003fd     	mov	x29, sp
   800ac: f90017e0     	str	x0, [sp, #0x28]
   800b0: b90027e1     	str	w1, [sp, #0x24]
   800b4: f9000fe2     	str	x2, [sp, #0x18]
   800b8: b90023e3     	str	w3, [sp, #0x20]
   800bc: b94027e1     	ldr	w1, [sp, #0x24]
   800c0: f94017e0     	ldr	x0, [sp, #0x28]
   800c4: 97ffffe2     	bl	0x8004c <compute_xor_checksum>
   800c8: 2a0003e1     	mov	w1, w0
   800cc: f94017e0     	ldr	x0, [sp, #0x28]
   800d0: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   800d4: b9100001     	str	w1, [x0, #0x1000]
   800d8: f94017e0     	ldr	x0, [sp, #0x28]
   800dc: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   800e0: f9400fe1     	ldr	x1, [sp, #0x18]
   800e4: f9080801     	str	x1, [x0, #0x1010]
   800e8: f94017e0     	ldr	x0, [sp, #0x28]
   800ec: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   800f0: b94023e1     	ldr	w1, [sp, #0x20]
   800f4: b9101801     	str	w1, [x0, #0x1018]
   800f8: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   800fc: 912ba000     	add	x0, x0, #0xae8
   80100: 94000486     	bl	0x81318 <uart_send_string>
   80104: f94017e0     	ldr	x0, [sp, #0x28]
   80108: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   8010c: b9500000     	ldr	w0, [x0, #0x1000]
   80110: 940004ac     	bl	0x813c0 <uart_send_hex>
   80114: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   80118: 912c2000     	add	x0, x0, #0xb08
   8011c: 9400047f     	bl	0x81318 <uart_send_string>
   80120: f94017e0     	ldr	x0, [sp, #0x28]
   80124: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   80128: b9501800     	ldr	w0, [x0, #0x1018]
   8012c: 7100001f     	cmp	w0, #0x0
   80130: 54000080     	b.eq	0x80140 <update_reference_checksums+0x9c>
   80134: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   80138: 912ca000     	add	x0, x0, #0xb28
   8013c: 94000477     	bl	0x81318 <uart_send_string>
   80140: f9400fe0     	ldr	x0, [sp, #0x18]
   80144: 94000475     	bl	0x81318 <uart_send_string>
   80148: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   8014c: 912ce000     	add	x0, x0, #0xb38
   80150: 94000472     	bl	0x81318 <uart_send_string>
   80154: d503201f     	nop
   80158: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   8015c: d65f03c0     	ret

0000000000080160 <send_banner>:
   80160: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
   80164: 910003fd     	mov	x29, sp
   80168: 528000a0     	mov	w0, #0x5                // =5
   8016c: 94000482     	bl	0x81374 <uart_line_breaks>
   80170: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   80174: 912d0000     	add	x0, x0, #0xb40
   80178: 94000468     	bl	0x81318 <uart_send_string>
   8017c: 52800040     	mov	w0, #0x2                // =2
   80180: 9400047d     	bl	0x81374 <uart_line_breaks>
   80184: b0000000     	adrp	x0, 0x81000 <kernel_main+0x1cc>
   80188: 912d8000     	add	x0, x0, #0xb60
   8018c: 94000463     	bl	0x81318 <uart_send_string>
   80190: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80194: 9102e000     	add	x0, x0, #0xb8
   80198: 94000460     	bl	0x81318 <uart_send_string>
   8019c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801a0: 9103a000     	add	x0, x0, #0xe8
   801a4: 9400045d     	bl	0x81318 <uart_send_string>
   801a8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801ac: 9104c000     	add	x0, x0, #0x130
   801b0: 9400045a     	bl	0x81318 <uart_send_string>
   801b4: d503201f     	nop
   801b8: a8c17bfd     	ldp	x29, x30, [sp], #0x10
   801bc: d65f03c0     	ret

00000000000801c0 <send_command_description>:
   801c0: a9bf7bfd     	stp	x29, x30, [sp, #-0x10]!
   801c4: 910003fd     	mov	x29, sp
   801c8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801cc: 9105e000     	add	x0, x0, #0x178
   801d0: 94000452     	bl	0x81318 <uart_send_string>
   801d4: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801d8: 91062000     	add	x0, x0, #0x188
   801dc: 9400044f     	bl	0x81318 <uart_send_string>
   801e0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801e4: 91068000     	add	x0, x0, #0x1a0
   801e8: 9400044c     	bl	0x81318 <uart_send_string>
   801ec: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801f0: 91070000     	add	x0, x0, #0x1c0
   801f4: 94000449     	bl	0x81318 <uart_send_string>
   801f8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   801fc: 91076000     	add	x0, x0, #0x1d8
   80200: 94000446     	bl	0x81318 <uart_send_string>
   80204: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80208: 9107e000     	add	x0, x0, #0x1f8
   8020c: 94000443     	bl	0x81318 <uart_send_string>
   80210: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80214: 91086000     	add	x0, x0, #0x218
   80218: 94000440     	bl	0x81318 <uart_send_string>
   8021c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80220: 91090000     	add	x0, x0, #0x240
   80224: 9400043d     	bl	0x81318 <uart_send_string>
   80228: d503201f     	nop
   8022c: a8c17bfd     	ldp	x29, x30, [sp], #0x10
   80230: d65f03c0     	ret

0000000000080234 <set_curr_arr_size>:
   80234: d10043ff     	sub	sp, sp, #0x10
   80238: b9000fe0     	str	w0, [sp, #0xc]
   8023c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80240: 9136a000     	add	x0, x0, #0xda8
   80244: b9400fe1     	ldr	w1, [sp, #0xc]
   80248: b9000001     	str	w1, [x0]
   8024c: d503201f     	nop
   80250: 910043ff     	add	sp, sp, #0x10
   80254: d65f03c0     	ret

0000000000080258 <get_curr_arr_size>:
   80258: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8025c: 9136a000     	add	x0, x0, #0xda8
   80260: b9400000     	ldr	w0, [x0]
   80264: d65f03c0     	ret

0000000000080268 <do_fill>:
   80268: a9bc7bfd     	stp	x29, x30, [sp, #-0x40]!
   8026c: 910003fd     	mov	x29, sp
   80270: f90017e0     	str	x0, [sp, #0x28]
   80274: b90027e1     	str	w1, [sp, #0x24]
   80278: f9000fe2     	str	x2, [sp, #0x18]
   8027c: 97fffff7     	bl	0x80258 <get_curr_arr_size>
   80280: b9003fe0     	str	w0, [sp, #0x3c]
   80284: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80288: 9109a000     	add	x0, x0, #0x268
   8028c: 94000423     	bl	0x81318 <uart_send_string>
   80290: f9400fe0     	ldr	x0, [sp, #0x18]
   80294: 94000421     	bl	0x81318 <uart_send_string>
   80298: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8029c: 9109e000     	add	x0, x0, #0x278
   802a0: 9400041e     	bl	0x81318 <uart_send_string>
   802a4: b94027e1     	ldr	w1, [sp, #0x24]
   802a8: f94017e0     	ldr	x0, [sp, #0x28]
   802ac: 940005a7     	bl	0x81948 <test_array_fill>
   802b0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   802b4: 910a0000     	add	x0, x0, #0x280
   802b8: 94000418     	bl	0x81318 <uart_send_string>
   802bc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   802c0: 910a2000     	add	x0, x0, #0x288
   802c4: 94000415     	bl	0x81318 <uart_send_string>
   802c8: 52800023     	mov	w3, #0x1                // =1
   802cc: f9400fe2     	ldr	x2, [sp, #0x18]
   802d0: b9403fe1     	ldr	w1, [sp, #0x3c]
   802d4: f94017e0     	ldr	x0, [sp, #0x28]
   802d8: 97ffff73     	bl	0x800a4 <update_reference_checksums>
   802dc: d503201f     	nop
   802e0: a8c47bfd     	ldp	x29, x30, [sp], #0x40
   802e4: d65f03c0     	ret

00000000000802e8 <do_fill_incremental>:
   802e8: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   802ec: 910003fd     	mov	x29, sp
   802f0: f9000fe0     	str	x0, [sp, #0x18]
   802f4: 97ffffd9     	bl	0x80258 <get_curr_arr_size>
   802f8: b9002fe0     	str	w0, [sp, #0x2c]
   802fc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80300: 910aa000     	add	x0, x0, #0x2a8
   80304: 94000405     	bl	0x81318 <uart_send_string>
   80308: f9400fe0     	ldr	x0, [sp, #0x18]
   8030c: 940005bc     	bl	0x819fc <test_array_fill_incremental>
   80310: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80314: 910a0000     	add	x0, x0, #0x280
   80318: 94000400     	bl	0x81318 <uart_send_string>
   8031c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80320: 910b2000     	add	x0, x0, #0x2c8
   80324: 940003fd     	bl	0x81318 <uart_send_string>
   80328: 52800003     	mov	w3, #0x0                // =0
   8032c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80330: 910ba002     	add	x2, x0, #0x2e8
   80334: b9402fe1     	ldr	w1, [sp, #0x2c]
   80338: f9400fe0     	ldr	x0, [sp, #0x18]
   8033c: 97ffff5a     	bl	0x800a4 <update_reference_checksums>
   80340: d503201f     	nop
   80344: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   80348: d65f03c0     	ret

000000000008034c <do_checksum_xor>:
   8034c: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   80350: 910003fd     	mov	x29, sp
   80354: f9000fe0     	str	x0, [sp, #0x18]
   80358: 97ffffc0     	bl	0x80258 <get_curr_arr_size>
   8035c: b9002fe0     	str	w0, [sp, #0x2c]
   80360: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80364: 910c0000     	add	x0, x0, #0x300
   80368: 940003ec     	bl	0x81318 <uart_send_string>
   8036c: b9402fe1     	ldr	w1, [sp, #0x2c]
   80370: f9400fe0     	ldr	x0, [sp, #0x18]
   80374: 97ffff36     	bl	0x8004c <compute_xor_checksum>
   80378: b9002be0     	str	w0, [sp, #0x28]
   8037c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80380: 910c8000     	add	x0, x0, #0x320
   80384: 940003e5     	bl	0x81318 <uart_send_string>
   80388: b9402be0     	ldr	w0, [sp, #0x28]
   8038c: 9400040d     	bl	0x813c0 <uart_send_hex>
   80390: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80394: 910d0000     	add	x0, x0, #0x340
   80398: 940003e0     	bl	0x81318 <uart_send_string>
   8039c: f9400fe0     	ldr	x0, [sp, #0x18]
   803a0: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   803a4: b9500000     	ldr	w0, [x0, #0x1000]
   803a8: 94000406     	bl	0x813c0 <uart_send_hex>
   803ac: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   803b0: 910d8000     	add	x0, x0, #0x360
   803b4: 940003d9     	bl	0x81318 <uart_send_string>
   803b8: f9400fe0     	ldr	x0, [sp, #0x18]
   803bc: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   803c0: f9480800     	ldr	x0, [x0, #0x1010]
   803c4: 940003d5     	bl	0x81318 <uart_send_string>
   803c8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   803cc: 910dc000     	add	x0, x0, #0x370
   803d0: 940003d2     	bl	0x81318 <uart_send_string>
   803d4: f9400fe0     	ldr	x0, [sp, #0x18]
   803d8: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   803dc: b9501800     	ldr	w0, [x0, #0x1018]
   803e0: 7100001f     	cmp	w0, #0x0
   803e4: 54000080     	b.eq	0x803f4 <do_checksum_xor+0xa8>
   803e8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   803ec: 910ea000     	add	x0, x0, #0x3a8
   803f0: 940003ca     	bl	0x81318 <uart_send_string>
   803f4: f9400fe0     	ldr	x0, [sp, #0x18]
   803f8: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   803fc: f9480800     	ldr	x0, [x0, #0x1010]
   80400: 940003c6     	bl	0x81318 <uart_send_string>
   80404: f9400fe0     	ldr	x0, [sp, #0x18]
   80408: 91482000     	add	x0, x0, #0x208, lsl #12 // =0x208000
   8040c: b9500000     	ldr	w0, [x0, #0x1000]
   80410: b9402be1     	ldr	w1, [sp, #0x28]
   80414: 6b00003f     	cmp	w1, w0
   80418: 54000081     	b.ne	0x80428 <do_checksum_xor+0xdc>
   8041c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80420: 910ee000     	add	x0, x0, #0x3b8
   80424: 14000003     	b	0x80430 <do_checksum_xor+0xe4>
   80428: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8042c: 910f2000     	add	x0, x0, #0x3c8
   80430: 940003ba     	bl	0x81318 <uart_send_string>
   80434: d503201f     	nop
   80438: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   8043c: d65f03c0     	ret

0000000000080440 <send_first_16_elements>:
   80440: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   80444: 910003fd     	mov	x29, sp
   80448: f9000fe0     	str	x0, [sp, #0x18]
   8044c: b90017e1     	str	w1, [sp, #0x14]
   80450: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80454: 910f8000     	add	x0, x0, #0x3e0
   80458: 940003b0     	bl	0x81318 <uart_send_string>
   8045c: b94017e0     	ldr	w0, [sp, #0x14]
   80460: 94000446     	bl	0x81578 <uart_send_dec>
   80464: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80468: 91102000     	add	x0, x0, #0x408
   8046c: 940003ab     	bl	0x81318 <uart_send_string>
   80470: b9002fff     	str	wzr, [sp, #0x2c]
   80474: 14000013     	b	0x804c0 <send_first_16_elements+0x80>
   80478: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8047c: 91104000     	add	x0, x0, #0x410
   80480: 940003a6     	bl	0x81318 <uart_send_string>
   80484: b9402fe0     	ldr	w0, [sp, #0x2c]
   80488: 9400043c     	bl	0x81578 <uart_send_dec>
   8048c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80490: 91106000     	add	x0, x0, #0x418
   80494: 940003a1     	bl	0x81318 <uart_send_string>
   80498: f9400fe0     	ldr	x0, [sp, #0x18]
   8049c: b9402fe1     	ldr	w1, [sp, #0x2c]
   804a0: b8617800     	ldr	w0, [x0, x1, lsl #2]
   804a4: 940003c7     	bl	0x813c0 <uart_send_hex>
   804a8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   804ac: 9109e000     	add	x0, x0, #0x278
   804b0: 9400039a     	bl	0x81318 <uart_send_string>
   804b4: b9402fe0     	ldr	w0, [sp, #0x2c]
   804b8: 11000400     	add	w0, w0, #0x1
   804bc: b9002fe0     	str	w0, [sp, #0x2c]
   804c0: b9402fe0     	ldr	w0, [sp, #0x2c]
   804c4: 71003c1f     	cmp	w0, #0xf
   804c8: 54fffd89     	b.ls	0x80478 <send_first_16_elements+0x38>
   804cc: d503201f     	nop
   804d0: d503201f     	nop
   804d4: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   804d8: d65f03c0     	ret

00000000000804dc <delay_us>:
   804dc: d10083ff     	sub	sp, sp, #0x20
   804e0: b9000fe0     	str	w0, [sp, #0xc]
   804e4: d2860080     	mov	x0, #0x3004             // =12292
   804e8: f2bfc000     	movk	x0, #0xfe00, lsl #16
   804ec: b9400000     	ldr	w0, [x0]
   804f0: b9001fe0     	str	w0, [sp, #0x1c]
   804f4: d503201f     	nop
   804f8: d2860080     	mov	x0, #0x3004             // =12292
   804fc: f2bfc000     	movk	x0, #0xfe00, lsl #16
   80500: b9400001     	ldr	w1, [x0]
   80504: b9401fe0     	ldr	w0, [sp, #0x1c]
   80508: 4b000020     	sub	w0, w1, w0
   8050c: b9400fe1     	ldr	w1, [sp, #0xc]
   80510: 6b00003f     	cmp	w1, w0
   80514: 54ffff28     	b.hi	0x804f8 <delay_us+0x1c>
   80518: d503201f     	nop
   8051c: d503201f     	nop
   80520: 910083ff     	add	sp, sp, #0x20
   80524: d65f03c0     	ret

0000000000080528 <emfi_pulse_precise>:
   80528: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   8052c: 910003fd     	mov	x29, sp
   80530: b9001fe0     	str	w0, [sp, #0x1c]
   80534: 52800021     	mov	w1, #0x1                // =1
   80538: 52800080     	mov	w0, #0x4                // =4
   8053c: 9400021a     	bl	0x80da4 <gpio_set>
   80540: b9401fe0     	ldr	w0, [sp, #0x1c]
   80544: 97ffffe6     	bl	0x804dc <delay_us>
   80548: 52800001     	mov	w1, #0x0                // =0
   8054c: 52800080     	mov	w0, #0x4                // =4
   80550: 94000215     	bl	0x80da4 <gpio_set>
   80554: d503201f     	nop
   80558: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   8055c: d65f03c0     	ret

0000000000080560 <run_emfi_test>:
   80560: a9b67bfd     	stp	x29, x30, [sp, #-0xa0]!
   80564: 910003fd     	mov	x29, sp
   80568: f90017e0     	str	x0, [sp, #0x28]
   8056c: f90013e1     	str	x1, [sp, #0x20]
   80570: b9001fe2     	str	w2, [sp, #0x1c]
   80574: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80578: 91108000     	add	x0, x0, #0x420
   8057c: 94000367     	bl	0x81318 <uart_send_string>
   80580: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80584: 9110e000     	add	x0, x0, #0x438
   80588: 94000364     	bl	0x81318 <uart_send_string>
   8058c: 52800021     	mov	w1, #0x1                // =1
   80590: 52800080     	mov	w0, #0x4                // =4
   80594: 940001a8     	bl	0x80c34 <gpio_pin_set_func>
   80598: 52800080     	mov	w0, #0x4                // =4
   8059c: 940001de     	bl	0x80d14 <gpio_pin_enable>
   805a0: b9009fff     	str	wzr, [sp, #0x9c]
   805a4: d2860080     	mov	x0, #0x3004             // =12292
   805a8: f2bfc000     	movk	x0, #0xfe00, lsl #16
   805ac: b9400000     	ldr	w0, [x0]
   805b0: b9006be0     	str	w0, [sp, #0x68]
   805b4: b9009bff     	str	wzr, [sp, #0x98]
   805b8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   805bc: 9137d000     	add	x0, x0, #0xdf4
   805c0: b9406be1     	ldr	w1, [sp, #0x68]
   805c4: b9000001     	str	w1, [x0]
   805c8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   805cc: 91114000     	add	x0, x0, #0x450
   805d0: 94000352     	bl	0x81318 <uart_send_string>
   805d4: b9401fe1     	ldr	w1, [sp, #0x1c]
   805d8: f94017e0     	ldr	x0, [sp, #0x28]
   805dc: 97fffe9c     	bl	0x8004c <compute_xor_checksum>
   805e0: b90097e0     	str	w0, [sp, #0x94]
   805e4: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   805e8: 91120000     	add	x0, x0, #0x480
   805ec: 9400034b     	bl	0x81318 <uart_send_string>
   805f0: b9409fe0     	ldr	w0, [sp, #0x9c]
   805f4: 11000400     	add	w0, w0, #0x1
   805f8: b9009fe0     	str	w0, [sp, #0x9c]
   805fc: 94000447     	bl	0x81718 <uart_read_ready>
   80600: 7100001f     	cmp	w0, #0x0
   80604: 540005c0     	b.eq	0x806bc <run_emfi_test+0x15c>
   80608: 94000338     	bl	0x812e8 <uart_recv>
   8060c: 39019fe0     	strb	w0, [sp, #0x67]
   80610: 39419fe0     	ldrb	w0, [sp, #0x67]
   80614: 7101fc1f     	cmp	w0, #0x7f
   80618: 54000521     	b.ne	0x806bc <run_emfi_test+0x15c>
   8061c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80620: 91122000     	add	x0, x0, #0x488
   80624: 9400033d     	bl	0x81318 <uart_send_string>
   80628: b9409fe0     	ldr	w0, [sp, #0x9c]
   8062c: 940003d3     	bl	0x81578 <uart_send_dec>
   80630: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80634: 9112c000     	add	x0, x0, #0x4b0
   80638: 94000338     	bl	0x81318 <uart_send_string>
   8063c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80640: 9112e000     	add	x0, x0, #0x4b8
   80644: 94000335     	bl	0x81318 <uart_send_string>
   80648: b9409fe0     	ldr	w0, [sp, #0x9c]
   8064c: 940003cb     	bl	0x81578 <uart_send_dec>
   80650: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80654: 91138000     	add	x0, x0, #0x4e0
   80658: 94000330     	bl	0x81318 <uart_send_string>
   8065c: b90093ff     	str	wzr, [sp, #0x90]
   80660: 14000013     	b	0x806ac <run_emfi_test+0x14c>
   80664: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80668: 9113a000     	add	x0, x0, #0x4e8
   8066c: 9400032b     	bl	0x81318 <uart_send_string>
   80670: b94093e0     	ldr	w0, [sp, #0x90]
   80674: 940003c1     	bl	0x81578 <uart_send_dec>
   80678: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8067c: 9113c000     	add	x0, x0, #0x4f0
   80680: 94000326     	bl	0x81318 <uart_send_string>
   80684: f94017e0     	ldr	x0, [sp, #0x28]
   80688: b94093e1     	ldr	w1, [sp, #0x90]
   8068c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80690: 9400034c     	bl	0x813c0 <uart_send_hex>
   80694: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80698: 9112c000     	add	x0, x0, #0x4b0
   8069c: 9400031f     	bl	0x81318 <uart_send_string>
   806a0: b94093e0     	ldr	w0, [sp, #0x90]
   806a4: 11000400     	add	w0, w0, #0x1
   806a8: b90093e0     	str	w0, [sp, #0x90]
   806ac: b94093e0     	ldr	w0, [sp, #0x90]
   806b0: 71003c1f     	cmp	w0, #0xf
   806b4: 54fffd89     	b.ls	0x80664 <run_emfi_test+0x104>
   806b8: 140000e2     	b	0x80a40 <run_emfi_test+0x4e0>
   806bc: b9008fff     	str	wzr, [sp, #0x8c]
   806c0: 14000016     	b	0x80718 <run_emfi_test+0x1b8>
   806c4: f94017e0     	ldr	x0, [sp, #0x28]
   806c8: b9808fe1     	ldrsw	x1, [sp, #0x8c]
   806cc: b8617800     	ldr	w0, [x0, x1, lsl #2]
   806d0: b9003fe0     	str	w0, [sp, #0x3c]
   806d4: b9403fe1     	ldr	w1, [sp, #0x3c]
   806d8: 528001a0     	mov	w0, #0xd                // =13
   806dc: 1b007c21     	mul	w1, w1, w0
   806e0: b9403fe0     	ldr	w0, [sp, #0x3c]
   806e4: 53077c00     	lsr	w0, w0, #7
   806e8: 4a000021     	eor	w1, w1, w0
   806ec: 5294b4a0     	mov	w0, #0xa5a5             // =42405
   806f0: 72b4b4a0     	movk	w0, #0xa5a5, lsl #16
   806f4: 0b000020     	add	w0, w1, w0
   806f8: b9003fe0     	str	w0, [sp, #0x3c]
   806fc: f94017e0     	ldr	x0, [sp, #0x28]
   80700: b9808fe1     	ldrsw	x1, [sp, #0x8c]
   80704: b9403fe2     	ldr	w2, [sp, #0x3c]
   80708: b8217802     	str	w2, [x0, x1, lsl #2]
   8070c: b9408fe0     	ldr	w0, [sp, #0x8c]
   80710: 11000400     	add	w0, w0, #0x1
   80714: b9008fe0     	str	w0, [sp, #0x8c]
   80718: b9408fe0     	ldr	w0, [sp, #0x8c]
   8071c: b9401fe1     	ldr	w1, [sp, #0x1c]
   80720: 6b00003f     	cmp	w1, w0
   80724: 54fffd08     	b.hi	0x806c4 <run_emfi_test+0x164>
   80728: f94017e0     	ldr	x0, [sp, #0x28]
   8072c: 927ae400     	and	x0, x0, #0xffffffffffffffc0
   80730: f90043e0     	str	x0, [sp, #0x80]
   80734: f94017e0     	ldr	x0, [sp, #0x28]
   80738: aa0003e1     	mov	x1, x0
   8073c: b9401fe0     	ldr	w0, [sp, #0x1c]
   80740: d37ef400     	lsl	x0, x0, #2
   80744: 8b000020     	add	x0, x1, x0
   80748: f9002fe0     	str	x0, [sp, #0x58]
   8074c: f9003fff     	str	xzr, [sp, #0x78]
   80750: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80754: 9113e000     	add	x0, x0, #0x4f8
   80758: 940002f0     	bl	0x81318 <uart_send_string>
   8075c: 14000009     	b	0x80780 <run_emfi_test+0x220>
   80760: f94043e0     	ldr	x0, [sp, #0x80]
   80764: d50b7e20     	dc	civac, x0
   80768: f94043e0     	ldr	x0, [sp, #0x80]
   8076c: 91010000     	add	x0, x0, #0x40
   80770: f90043e0     	str	x0, [sp, #0x80]
   80774: f9403fe0     	ldr	x0, [sp, #0x78]
   80778: 91000400     	add	x0, x0, #0x1
   8077c: f9003fe0     	str	x0, [sp, #0x78]
   80780: f94043e1     	ldr	x1, [sp, #0x80]
   80784: f9402fe0     	ldr	x0, [sp, #0x58]
   80788: eb00003f     	cmp	x1, x0
   8078c: 54fffea3     	b.lo	0x80760 <run_emfi_test+0x200>
   80790: d5033f9f     	dsb	sy
   80794: d5033fdf     	isb
   80798: b9401fe1     	ldr	w1, [sp, #0x1c]
   8079c: f94017e0     	ldr	x0, [sp, #0x28]
   807a0: 97fffe2b     	bl	0x8004c <compute_xor_checksum>
   807a4: b90057e0     	str	w0, [sp, #0x54]
   807a8: b94057e1     	ldr	w1, [sp, #0x54]
   807ac: b94097e0     	ldr	w0, [sp, #0x94]
   807b0: 6b00003f     	cmp	w1, w0
   807b4: 54000b00     	b.eq	0x80914 <run_emfi_test+0x3b4>
   807b8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   807bc: 91140000     	add	x0, x0, #0x500
   807c0: 940002d6     	bl	0x81318 <uart_send_string>
   807c4: b9409fe0     	ldr	w0, [sp, #0x9c]
   807c8: 9400036c     	bl	0x81578 <uart_send_dec>
   807cc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   807d0: 9114a000     	add	x0, x0, #0x528
   807d4: 940002d1     	bl	0x81318 <uart_send_string>
   807d8: b94097e0     	ldr	w0, [sp, #0x94]
   807dc: 940002f9     	bl	0x813c0 <uart_send_hex>
   807e0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   807e4: 91156000     	add	x0, x0, #0x558
   807e8: 940002cc     	bl	0x81318 <uart_send_string>
   807ec: b94057e0     	ldr	w0, [sp, #0x54]
   807f0: 940002f4     	bl	0x813c0 <uart_send_hex>
   807f4: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   807f8: 9112c000     	add	x0, x0, #0x4b0
   807fc: 940002c7     	bl	0x81318 <uart_send_string>
   80800: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80804: 9115e000     	add	x0, x0, #0x578
   80808: 940002c4     	bl	0x81318 <uart_send_string>
   8080c: 940003c3     	bl	0x81718 <uart_read_ready>
   80810: 7100001f     	cmp	w0, #0x0
   80814: 54ffffc0     	b.eq	0x8080c <run_emfi_test+0x2ac>
   80818: 940002b4     	bl	0x812e8 <uart_recv>
   8081c: 39011fe0     	strb	w0, [sp, #0x47]
   80820: 39411fe0     	ldrb	w0, [sp, #0x47]
   80824: 71018c1f     	cmp	w0, #0x63
   80828: 54000040     	b.eq	0x80830 <run_emfi_test+0x2d0>
   8082c: 17fffff8     	b	0x8080c <run_emfi_test+0x2ac>
   80830: d503201f     	nop
   80834: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80838: 9116e000     	add	x0, x0, #0x5b8
   8083c: 940002b7     	bl	0x81318 <uart_send_string>
   80840: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80844: 91178000     	add	x0, x0, #0x5e0
   80848: 940002b4     	bl	0x81318 <uart_send_string>
   8084c: b90077ff     	str	wzr, [sp, #0x74]
   80850: 14000022     	b	0x808d8 <run_emfi_test+0x378>
   80854: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80858: 9113e000     	add	x0, x0, #0x4f8
   8085c: 940002af     	bl	0x81318 <uart_send_string>
   80860: b90073ff     	str	wzr, [sp, #0x70]
   80864: 14000016     	b	0x808bc <run_emfi_test+0x35c>
   80868: f94013e0     	ldr	x0, [sp, #0x20]
   8086c: b98073e1     	ldrsw	x1, [sp, #0x70]
   80870: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80874: b90043e0     	str	w0, [sp, #0x40]
   80878: b94043e1     	ldr	w1, [sp, #0x40]
   8087c: 528001a0     	mov	w0, #0xd                // =13
   80880: 1b007c21     	mul	w1, w1, w0
   80884: b94043e0     	ldr	w0, [sp, #0x40]
   80888: 53077c00     	lsr	w0, w0, #7
   8088c: 4a000021     	eor	w1, w1, w0
   80890: 5294b4a0     	mov	w0, #0xa5a5             // =42405
   80894: 72b4b4a0     	movk	w0, #0xa5a5, lsl #16
   80898: 0b000020     	add	w0, w1, w0
   8089c: b90043e0     	str	w0, [sp, #0x40]
   808a0: f94013e0     	ldr	x0, [sp, #0x20]
   808a4: b98073e1     	ldrsw	x1, [sp, #0x70]
   808a8: b94043e2     	ldr	w2, [sp, #0x40]
   808ac: b8217802     	str	w2, [x0, x1, lsl #2]
   808b0: b94073e0     	ldr	w0, [sp, #0x70]
   808b4: 11000400     	add	w0, w0, #0x1
   808b8: b90073e0     	str	w0, [sp, #0x70]
   808bc: b94073e0     	ldr	w0, [sp, #0x70]
   808c0: b9401fe1     	ldr	w1, [sp, #0x1c]
   808c4: 6b00003f     	cmp	w1, w0
   808c8: 54fffd08     	b.hi	0x80868 <run_emfi_test+0x308>
   808cc: b94077e0     	ldr	w0, [sp, #0x74]
   808d0: 11000400     	add	w0, w0, #0x1
   808d4: b90077e0     	str	w0, [sp, #0x74]
   808d8: b94077e0     	ldr	w0, [sp, #0x74]
   808dc: b9409fe1     	ldr	w1, [sp, #0x9c]
   808e0: 6b00003f     	cmp	w1, w0
   808e4: 54fffb88     	b.hi	0x80854 <run_emfi_test+0x2f4>
   808e8: b9401fe2     	ldr	w2, [sp, #0x1c]
   808ec: f94013e1     	ldr	x1, [sp, #0x20]
   808f0: f94017e0     	ldr	x0, [sp, #0x28]
   808f4: 94000079     	bl	0x80ad8 <print_array_diffs>
   808f8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   808fc: 91188000     	add	x0, x0, #0x620
   80900: 94000286     	bl	0x81318 <uart_send_string>
   80904: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80908: 9118e000     	add	x0, x0, #0x638
   8090c: 94000283     	bl	0x81318 <uart_send_string>
   80910: 1400004c     	b	0x80a40 <run_emfi_test+0x4e0>
   80914: b94057e0     	ldr	w0, [sp, #0x54]
   80918: b90097e0     	str	w0, [sp, #0x94]
   8091c: b9409fe0     	ldr	w0, [sp, #0x9c]
   80920: 12001c00     	and	w0, w0, #0xff
   80924: 7100001f     	cmp	w0, #0x0
   80928: 54000401     	b.ne	0x809a8 <run_emfi_test+0x448>
   8092c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80930: 91196000     	add	x0, x0, #0x658
   80934: 94000279     	bl	0x81318 <uart_send_string>
   80938: b9409fe0     	ldr	w0, [sp, #0x9c]
   8093c: 9400030f     	bl	0x81578 <uart_send_dec>
   80940: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80944: 91138000     	add	x0, x0, #0x4e0
   80948: 94000274     	bl	0x81318 <uart_send_string>
   8094c: b9006fff     	str	wzr, [sp, #0x6c]
   80950: 14000013     	b	0x8099c <run_emfi_test+0x43c>
   80954: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80958: 9113a000     	add	x0, x0, #0x4e8
   8095c: 9400026f     	bl	0x81318 <uart_send_string>
   80960: b9406fe0     	ldr	w0, [sp, #0x6c]
   80964: 94000305     	bl	0x81578 <uart_send_dec>
   80968: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8096c: 9113c000     	add	x0, x0, #0x4f0
   80970: 9400026a     	bl	0x81318 <uart_send_string>
   80974: f94017e0     	ldr	x0, [sp, #0x28]
   80978: b9406fe1     	ldr	w1, [sp, #0x6c]
   8097c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80980: 94000290     	bl	0x813c0 <uart_send_hex>
   80984: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80988: 911a2000     	add	x0, x0, #0x688
   8098c: 94000263     	bl	0x81318 <uart_send_string>
   80990: b9406fe0     	ldr	w0, [sp, #0x6c]
   80994: 11000400     	add	w0, w0, #0x1
   80998: b9006fe0     	str	w0, [sp, #0x6c]
   8099c: b9406fe0     	ldr	w0, [sp, #0x6c]
   809a0: 71003c1f     	cmp	w0, #0xf
   809a4: 54fffd89     	b.ls	0x80954 <run_emfi_test+0x3f4>
   809a8: d2860080     	mov	x0, #0x3004             // =12292
   809ac: f2bfc000     	movk	x0, #0xfe00, lsl #16
   809b0: b9400000     	ldr	w0, [x0]
   809b4: b90053e0     	str	w0, [sp, #0x50]
   809b8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   809bc: 9137d000     	add	x0, x0, #0xdf4
   809c0: b9400000     	ldr	w0, [x0]
   809c4: b94053e1     	ldr	w1, [sp, #0x50]
   809c8: 4b000020     	sub	w0, w1, w0
   809cc: b9004fe0     	str	w0, [sp, #0x4c]
   809d0: b9404fe1     	ldr	w1, [sp, #0x4c]
   809d4: 5289ba60     	mov	w0, #0x4dd3             // =19923
   809d8: 72a20c40     	movk	w0, #0x1062, lsl #16
   809dc: 9ba07c20     	umull	x0, w1, w0
   809e0: d360fc00     	lsr	x0, x0, #32
   809e4: 53067c00     	lsr	w0, w0, #6
   809e8: b9004be0     	str	w0, [sp, #0x48]
   809ec: b9404be1     	ldr	w1, [sp, #0x48]
   809f0: b9409be0     	ldr	w0, [sp, #0x98]
   809f4: 4b000020     	sub	w0, w1, w0
   809f8: 710f9c1f     	cmp	w0, #0x3e7
   809fc: 54ffdfa9     	b.ls	0x805f0 <run_emfi_test+0x90>
   80a00: b9404be0     	ldr	w0, [sp, #0x48]
   80a04: b9009be0     	str	w0, [sp, #0x98]
   80a08: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a0c: 911a4000     	add	x0, x0, #0x690
   80a10: 94000242     	bl	0x81318 <uart_send_string>
   80a14: b9404be0     	ldr	w0, [sp, #0x48]
   80a18: 940002d8     	bl	0x81578 <uart_send_dec>
   80a1c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a20: 911aa000     	add	x0, x0, #0x6a8
   80a24: 9400023d     	bl	0x81318 <uart_send_string>
   80a28: b9409fe0     	ldr	w0, [sp, #0x9c]
   80a2c: 940002d3     	bl	0x81578 <uart_send_dec>
   80a30: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a34: 9112c000     	add	x0, x0, #0x4b0
   80a38: 94000238     	bl	0x81318 <uart_send_string>
   80a3c: 17fffeed     	b	0x805f0 <run_emfi_test+0x90>
   80a40: a8ca7bfd     	ldp	x29, x30, [sp], #0xa0
   80a44: d65f03c0     	ret

0000000000080a48 <print_diff_range>:
   80a48: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   80a4c: 910003fd     	mov	x29, sp
   80a50: b9001fe0     	str	w0, [sp, #0x1c]
   80a54: b9001be1     	str	w1, [sp, #0x18]
   80a58: b90017e2     	str	w2, [sp, #0x14]
   80a5c: b90013e3     	str	w3, [sp, #0x10]
   80a60: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a64: 911ac000     	add	x0, x0, #0x6b0
   80a68: 9400022c     	bl	0x81318 <uart_send_string>
   80a6c: b9401fe0     	ldr	w0, [sp, #0x1c]
   80a70: 940002c2     	bl	0x81578 <uart_send_dec>
   80a74: b9401be1     	ldr	w1, [sp, #0x18]
   80a78: b9401fe0     	ldr	w0, [sp, #0x1c]
   80a7c: 6b00003f     	cmp	w1, w0
   80a80: 540000cd     	b.le	0x80a98 <print_diff_range+0x50>
   80a84: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a88: 911ae000     	add	x0, x0, #0x6b8
   80a8c: 94000223     	bl	0x81318 <uart_send_string>
   80a90: b9401be0     	ldr	w0, [sp, #0x18]
   80a94: 940002b9     	bl	0x81578 <uart_send_dec>
   80a98: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80a9c: 911b0000     	add	x0, x0, #0x6c0
   80aa0: 9400021e     	bl	0x81318 <uart_send_string>
   80aa4: b94017e0     	ldr	w0, [sp, #0x14]
   80aa8: 94000246     	bl	0x813c0 <uart_send_hex>
   80aac: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ab0: 911b4000     	add	x0, x0, #0x6d0
   80ab4: 94000219     	bl	0x81318 <uart_send_string>
   80ab8: b94013e0     	ldr	w0, [sp, #0x10]
   80abc: 94000241     	bl	0x813c0 <uart_send_hex>
   80ac0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ac4: 9112c000     	add	x0, x0, #0x4b0
   80ac8: 94000214     	bl	0x81318 <uart_send_string>
   80acc: d503201f     	nop
   80ad0: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   80ad4: d65f03c0     	ret

0000000000080ad8 <print_array_diffs>:
   80ad8: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
   80adc: 910003fd     	mov	x29, sp
   80ae0: f90017e0     	str	x0, [sp, #0x28]
   80ae4: f90013e1     	str	x1, [sp, #0x20]
   80ae8: b9001fe2     	str	w2, [sp, #0x1c]
   80aec: 12800000     	mov	w0, #-0x1               // =-1
   80af0: b9004fe0     	str	w0, [sp, #0x4c]
   80af4: b9004bff     	str	wzr, [sp, #0x48]
   80af8: b90047ff     	str	wzr, [sp, #0x44]
   80afc: b90043ff     	str	wzr, [sp, #0x40]
   80b00: 1400003c     	b	0x80bf0 <print_array_diffs+0x118>
   80b04: f94017e0     	ldr	x0, [sp, #0x28]
   80b08: b94043e1     	ldr	w1, [sp, #0x40]
   80b0c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80b10: b9003fe0     	str	w0, [sp, #0x3c]
   80b14: f94013e0     	ldr	x0, [sp, #0x20]
   80b18: b94043e1     	ldr	w1, [sp, #0x40]
   80b1c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80b20: b9003be0     	str	w0, [sp, #0x38]
   80b24: b9403fe1     	ldr	w1, [sp, #0x3c]
   80b28: b9403be0     	ldr	w0, [sp, #0x38]
   80b2c: 6b00003f     	cmp	w1, w0
   80b30: 54000420     	b.eq	0x80bb4 <print_array_diffs+0xdc>
   80b34: b9404fe0     	ldr	w0, [sp, #0x4c]
   80b38: 3100041f     	cmn	w0, #0x1
   80b3c: 54000101     	b.ne	0x80b5c <print_array_diffs+0x84>
   80b40: b94043e0     	ldr	w0, [sp, #0x40]
   80b44: b9004fe0     	str	w0, [sp, #0x4c]
   80b48: b9403fe0     	ldr	w0, [sp, #0x3c]
   80b4c: b9004be0     	str	w0, [sp, #0x48]
   80b50: b9403be0     	ldr	w0, [sp, #0x38]
   80b54: b90047e0     	str	w0, [sp, #0x44]
   80b58: 14000023     	b	0x80be4 <print_array_diffs+0x10c>
   80b5c: b9403fe1     	ldr	w1, [sp, #0x3c]
   80b60: b9404be0     	ldr	w0, [sp, #0x48]
   80b64: 6b00003f     	cmp	w1, w0
   80b68: 540000a1     	b.ne	0x80b7c <print_array_diffs+0xa4>
   80b6c: b9403be1     	ldr	w1, [sp, #0x38]
   80b70: b94047e0     	ldr	w0, [sp, #0x44]
   80b74: 6b00003f     	cmp	w1, w0
   80b78: 54000360     	b.eq	0x80be4 <print_array_diffs+0x10c>
   80b7c: b94043e0     	ldr	w0, [sp, #0x40]
   80b80: 51000400     	sub	w0, w0, #0x1
   80b84: b94047e3     	ldr	w3, [sp, #0x44]
   80b88: b9404be2     	ldr	w2, [sp, #0x48]
   80b8c: 2a0003e1     	mov	w1, w0
   80b90: b9404fe0     	ldr	w0, [sp, #0x4c]
   80b94: 97ffffad     	bl	0x80a48 <print_diff_range>
   80b98: b94043e0     	ldr	w0, [sp, #0x40]
   80b9c: b9004fe0     	str	w0, [sp, #0x4c]
   80ba0: b9403fe0     	ldr	w0, [sp, #0x3c]
   80ba4: b9004be0     	str	w0, [sp, #0x48]
   80ba8: b9403be0     	ldr	w0, [sp, #0x38]
   80bac: b90047e0     	str	w0, [sp, #0x44]
   80bb0: 1400000d     	b	0x80be4 <print_array_diffs+0x10c>
   80bb4: b9404fe0     	ldr	w0, [sp, #0x4c]
   80bb8: 3100041f     	cmn	w0, #0x1
   80bbc: 54000140     	b.eq	0x80be4 <print_array_diffs+0x10c>
   80bc0: b94043e0     	ldr	w0, [sp, #0x40]
   80bc4: 51000400     	sub	w0, w0, #0x1
   80bc8: b94047e3     	ldr	w3, [sp, #0x44]
   80bcc: b9404be2     	ldr	w2, [sp, #0x48]
   80bd0: 2a0003e1     	mov	w1, w0
   80bd4: b9404fe0     	ldr	w0, [sp, #0x4c]
   80bd8: 97ffff9c     	bl	0x80a48 <print_diff_range>
   80bdc: 12800000     	mov	w0, #-0x1               // =-1
   80be0: b9004fe0     	str	w0, [sp, #0x4c]
   80be4: b94043e0     	ldr	w0, [sp, #0x40]
   80be8: 11000400     	add	w0, w0, #0x1
   80bec: b90043e0     	str	w0, [sp, #0x40]
   80bf0: b94043e1     	ldr	w1, [sp, #0x40]
   80bf4: b9401fe0     	ldr	w0, [sp, #0x1c]
   80bf8: 6b00003f     	cmp	w1, w0
   80bfc: 54fff843     	b.lo	0x80b04 <print_array_diffs+0x2c>
   80c00: b9404fe0     	ldr	w0, [sp, #0x4c]
   80c04: 3100041f     	cmn	w0, #0x1
   80c08: 54000100     	b.eq	0x80c28 <print_array_diffs+0x150>
   80c0c: b9401fe0     	ldr	w0, [sp, #0x1c]
   80c10: 51000400     	sub	w0, w0, #0x1
   80c14: b94047e3     	ldr	w3, [sp, #0x44]
   80c18: b9404be2     	ldr	w2, [sp, #0x48]
   80c1c: 2a0003e1     	mov	w1, w0
   80c20: b9404fe0     	ldr	w0, [sp, #0x4c]
   80c24: 97ffff89     	bl	0x80a48 <print_diff_range>
   80c28: d503201f     	nop
   80c2c: a8c57bfd     	ldp	x29, x30, [sp], #0x50
   80c30: d65f03c0     	ret

0000000000080c34 <gpio_pin_set_func>:
   80c34: d10083ff     	sub	sp, sp, #0x20
   80c38: 39003fe0     	strb	w0, [sp, #0xf]
   80c3c: b9000be1     	str	w1, [sp, #0x8]
   80c40: 39403fe1     	ldrb	w1, [sp, #0xf]
   80c44: 2a0103e0     	mov	w0, w1
   80c48: 531f7800     	lsl	w0, w0, #1
   80c4c: 0b010001     	add	w1, w0, w1
   80c50: 52911120     	mov	w0, #0x8889             // =34953
   80c54: 72b11100     	movk	w0, #0x8888, lsl #16
   80c58: 9b207c20     	smull	x0, w1, w0
   80c5c: d360fc00     	lsr	x0, x0, #32
   80c60: 0b000020     	add	w0, w1, w0
   80c64: 13047c02     	asr	w2, w0, #4
   80c68: 131f7c20     	asr	w0, w1, #31
   80c6c: 4b000042     	sub	w2, w2, w0
   80c70: 2a0203e0     	mov	w0, w2
   80c74: 531c6c00     	lsl	w0, w0, #4
   80c78: 4b020000     	sub	w0, w0, w2
   80c7c: 531f7800     	lsl	w0, w0, #1
   80c80: 4b000022     	sub	w2, w1, w0
   80c84: 2a0203e0     	mov	w0, w2
   80c88: 39007fe0     	strb	w0, [sp, #0x1f]
   80c8c: 39403fe1     	ldrb	w1, [sp, #0xf]
   80c90: 529999a0     	mov	w0, #0xcccd             // =52429
   80c94: 72b99980     	movk	w0, #0xcccc, lsl #16
   80c98: 9ba07c20     	umull	x0, w1, w0
   80c9c: d360fc00     	lsr	x0, x0, #32
   80ca0: 53037c00     	lsr	w0, w0, #3
   80ca4: 39007be0     	strb	w0, [sp, #0x1e]
   80ca8: d2bfc400     	mov	x0, #0xfe200000         // =4263510016
   80cac: 39407be1     	ldrb	w1, [sp, #0x1e]
   80cb0: 93407c21     	sxtw	x1, w1
   80cb4: b8617800     	ldr	w0, [x0, x1, lsl #2]
   80cb8: b9001be0     	str	w0, [sp, #0x18]
   80cbc: 39407fe0     	ldrb	w0, [sp, #0x1f]
   80cc0: 528000e1     	mov	w1, #0x7                // =7
   80cc4: 1ac02020     	lsl	w0, w1, w0
   80cc8: 2a2003e0     	mvn	w0, w0
   80ccc: 2a0003e1     	mov	w1, w0
   80cd0: b9401be0     	ldr	w0, [sp, #0x18]
   80cd4: 0a010000     	and	w0, w0, w1
   80cd8: b9001be0     	str	w0, [sp, #0x18]
   80cdc: 39407fe0     	ldrb	w0, [sp, #0x1f]
   80ce0: b9400be1     	ldr	w1, [sp, #0x8]
   80ce4: 1ac02020     	lsl	w0, w1, w0
   80ce8: b9401be1     	ldr	w1, [sp, #0x18]
   80cec: 2a000020     	orr	w0, w1, w0
   80cf0: b9001be0     	str	w0, [sp, #0x18]
   80cf4: d2bfc400     	mov	x0, #0xfe200000         // =4263510016
   80cf8: 39407be1     	ldrb	w1, [sp, #0x1e]
   80cfc: 93407c21     	sxtw	x1, w1
   80d00: b9401be2     	ldr	w2, [sp, #0x18]
   80d04: b8217802     	str	w2, [x0, x1, lsl #2]
   80d08: d503201f     	nop
   80d0c: 910083ff     	add	sp, sp, #0x20
   80d10: d65f03c0     	ret

0000000000080d14 <gpio_pin_enable>:
   80d14: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   80d18: 910003fd     	mov	x29, sp
   80d1c: 39007fe0     	strb	w0, [sp, #0x1f]
   80d20: d2bfc400     	mov	x0, #0xfe200000         // =4263510016
   80d24: b900941f     	str	wzr, [x0, #0x94]
   80d28: d28012c0     	mov	x0, #0x96               // =150
   80d2c: 94000368     	bl	0x81acc <delay>
   80d30: 39407fe0     	ldrb	w0, [sp, #0x1f]
   80d34: 12001000     	and	w0, w0, #0x1f
   80d38: 52800021     	mov	w1, #0x1                // =1
   80d3c: 1ac02022     	lsl	w2, w1, w0
   80d40: d2bfc401     	mov	x1, #0xfe200000         // =4263510016
   80d44: 39407fe0     	ldrb	w0, [sp, #0x1f]
   80d48: 53057c00     	lsr	w0, w0, #5
   80d4c: 12001c00     	and	w0, w0, #0xff
   80d50: 93407c00     	sxtw	x0, w0
   80d54: 91009000     	add	x0, x0, #0x24
   80d58: d37ef400     	lsl	x0, x0, #2
   80d5c: 8b000020     	add	x0, x1, x0
   80d60: b9000802     	str	w2, [x0, #0x8]
   80d64: d28012c0     	mov	x0, #0x96               // =150
   80d68: 94000359     	bl	0x81acc <delay>
   80d6c: d2bfc400     	mov	x0, #0xfe200000         // =4263510016
   80d70: b900941f     	str	wzr, [x0, #0x94]
   80d74: d2bfc401     	mov	x1, #0xfe200000         // =4263510016
   80d78: 39407fe0     	ldrb	w0, [sp, #0x1f]
   80d7c: 53057c00     	lsr	w0, w0, #5
   80d80: 12001c00     	and	w0, w0, #0xff
   80d84: 93407c00     	sxtw	x0, w0
   80d88: 91009000     	add	x0, x0, #0x24
   80d8c: d37ef400     	lsl	x0, x0, #2
   80d90: 8b000020     	add	x0, x1, x0
   80d94: b900081f     	str	wzr, [x0, #0x8]
   80d98: d503201f     	nop
   80d9c: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   80da0: d65f03c0     	ret

0000000000080da4 <gpio_set>:
   80da4: d10043ff     	sub	sp, sp, #0x10
   80da8: 39003fe0     	strb	w0, [sp, #0xf]
   80dac: b9000be1     	str	w1, [sp, #0x8]
   80db0: b9400be0     	ldr	w0, [sp, #0x8]
   80db4: 7100001f     	cmp	w0, #0x0
   80db8: 540001e0     	b.eq	0x80df4 <gpio_set+0x50>
   80dbc: 39403fe0     	ldrb	w0, [sp, #0xf]
   80dc0: 12001000     	and	w0, w0, #0x1f
   80dc4: 52800021     	mov	w1, #0x1                // =1
   80dc8: 1ac02022     	lsl	w2, w1, w0
   80dcc: d2bfc401     	mov	x1, #0xfe200000         // =4263510016
   80dd0: 39403fe0     	ldrb	w0, [sp, #0xf]
   80dd4: 53057c00     	lsr	w0, w0, #5
   80dd8: 12001c00     	and	w0, w0, #0xff
   80ddc: 93407c00     	sxtw	x0, w0
   80de0: 91001000     	add	x0, x0, #0x4
   80de4: d37ef400     	lsl	x0, x0, #2
   80de8: 8b000020     	add	x0, x1, x0
   80dec: b9000c02     	str	w2, [x0, #0xc]
   80df0: 1400000e     	b	0x80e28 <gpio_set+0x84>
   80df4: 39403fe0     	ldrb	w0, [sp, #0xf]
   80df8: 12001000     	and	w0, w0, #0x1f
   80dfc: 52800021     	mov	w1, #0x1                // =1
   80e00: 1ac02022     	lsl	w2, w1, w0
   80e04: d2bfc401     	mov	x1, #0xfe200000         // =4263510016
   80e08: 39403fe0     	ldrb	w0, [sp, #0xf]
   80e0c: 53057c00     	lsr	w0, w0, #5
   80e10: 12001c00     	and	w0, w0, #0xff
   80e14: 93407c00     	sxtw	x0, w0
   80e18: 91002000     	add	x0, x0, #0x8
   80e1c: d37ef400     	lsl	x0, x0, #2
   80e20: 8b000020     	add	x0, x1, x0
   80e24: b9000802     	str	w2, [x0, #0x8]
   80e28: d503201f     	nop
   80e2c: 910043ff     	add	sp, sp, #0x10
   80e30: d65f03c0     	ret

0000000000080e34 <kernel_main>:
   80e34: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   80e38: 910003fd     	mov	x29, sp
   80e3c: 940000d0     	bl	0x8117c <uart_init>
   80e40: 52800021     	mov	w1, #0x1                // =1
   80e44: 52800080     	mov	w0, #0x4                // =4
   80e48: 97ffff7b     	bl	0x80c34 <gpio_pin_set_func>
   80e4c: 52800080     	mov	w0, #0x4                // =4
   80e50: 97ffffb1     	bl	0x80d14 <gpio_pin_enable>
   80e54: 52800001     	mov	w1, #0x0                // =0
   80e58: 52800080     	mov	w0, #0x4                // =4
   80e5c: 97ffffd2     	bl	0x80da4 <gpio_set>
   80e60: 97fffcc0     	bl	0x80160 <send_banner>
   80e64: 528000a0     	mov	w0, #0x5                // =5
   80e68: 94000143     	bl	0x81374 <uart_line_breaks>
   80e6c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80e70: 911b8000     	add	x0, x0, #0x6e0
   80e74: 94000129     	bl	0x81318 <uart_send_string>
   80e78: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80e7c: 911be000     	add	x0, x0, #0x6f8
   80e80: 94000126     	bl	0x81318 <uart_send_string>
   80e84: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80e88: 9137e000     	add	x0, x0, #0xdf8
   80e8c: 9400014d     	bl	0x813c0 <uart_send_hex>
   80e90: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80e94: 911c2000     	add	x0, x0, #0x708
   80e98: 94000120     	bl	0x81318 <uart_send_string>
   80e9c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ea0: 911c4000     	add	x0, x0, #0x710
   80ea4: 9400011d     	bl	0x81318 <uart_send_string>
   80ea8: f0001040     	adrp	x0, 0x28b000 <arr+0x208208>
   80eac: 91386000     	add	x0, x0, #0xe18
   80eb0: 94000144     	bl	0x813c0 <uart_send_hex>
   80eb4: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80eb8: 911c2000     	add	x0, x0, #0x708
   80ebc: 94000117     	bl	0x81318 <uart_send_string>
   80ec0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ec4: 911c8000     	add	x0, x0, #0x720
   80ec8: 94000114     	bl	0x81318 <uart_send_string>
   80ecc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ed0: f946e800     	ldr	x0, [x0, #0xdd0]
   80ed4: 9400013b     	bl	0x813c0 <uart_send_hex>
   80ed8: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80edc: 911c2000     	add	x0, x0, #0x708
   80ee0: 9400010e     	bl	0x81318 <uart_send_string>
   80ee4: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ee8: 911cc000     	add	x0, x0, #0x730
   80eec: 9400010b     	bl	0x81318 <uart_send_string>
   80ef0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80ef4: f946e000     	ldr	x0, [x0, #0xdc0]
   80ef8: 94000132     	bl	0x813c0 <uart_send_hex>
   80efc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f00: 911c2000     	add	x0, x0, #0x708
   80f04: 94000105     	bl	0x81318 <uart_send_string>
   80f08: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f0c: 911d0000     	add	x0, x0, #0x740
   80f10: 94000102     	bl	0x81318 <uart_send_string>
   80f14: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f18: f946dc00     	ldr	x0, [x0, #0xdb8]
   80f1c: 94000129     	bl	0x813c0 <uart_send_hex>
   80f20: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f24: 911c2000     	add	x0, x0, #0x708
   80f28: 940000fc     	bl	0x81318 <uart_send_string>
   80f2c: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f30: 911d6000     	add	x0, x0, #0x758
   80f34: 940000f9     	bl	0x81318 <uart_send_string>
   80f38: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f3c: f946e400     	ldr	x0, [x0, #0xdc8]
   80f40: 94000120     	bl	0x813c0 <uart_send_hex>
   80f44: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f48: 911c2000     	add	x0, x0, #0x708
   80f4c: 940000f3     	bl	0x81318 <uart_send_string>
   80f50: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f54: 911dc000     	add	x0, x0, #0x770
   80f58: 940000f0     	bl	0x81318 <uart_send_string>
   80f5c: 52800040     	mov	w0, #0x2                // =2
   80f60: 94000105     	bl	0x81374 <uart_line_breaks>
   80f64: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f68: 911e2000     	add	x0, x0, #0x788
   80f6c: 940000eb     	bl	0x81318 <uart_send_string>
   80f70: 94000137     	bl	0x8144c <uart_receive_number>
   80f74: b9001be0     	str	w0, [sp, #0x18]
   80f78: b9401be0     	ldr	w0, [sp, #0x18]
   80f7c: 97fffcae     	bl	0x80234 <set_curr_arr_size>
   80f80: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f84: 911f8000     	add	x0, x0, #0x7e0
   80f88: 940000e4     	bl	0x81318 <uart_send_string>
   80f8c: b9401be0     	ldr	w0, [sp, #0x18]
   80f90: 9400017a     	bl	0x81578 <uart_send_dec>
   80f94: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80f98: 91200000     	add	x0, x0, #0x800
   80f9c: 940000df     	bl	0x81318 <uart_send_string>
   80fa0: 52800040     	mov	w0, #0x2                // =2
   80fa4: 940000f4     	bl	0x81374 <uart_line_breaks>
   80fa8: 97fffc86     	bl	0x801c0 <send_command_description>
   80fac: 52800040     	mov	w0, #0x2                // =2
   80fb0: 940000f1     	bl	0x81374 <uart_line_breaks>
   80fb4: 940000cd     	bl	0x812e8 <uart_recv>
   80fb8: 39005fe0     	strb	w0, [sp, #0x17]
   80fbc: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80fc0: 9120a000     	add	x0, x0, #0x828
   80fc4: 940000d5     	bl	0x81318 <uart_send_string>
   80fc8: 39405fe0     	ldrb	w0, [sp, #0x17]
   80fcc: 940000b7     	bl	0x812a8 <uart_send>
   80fd0: d0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   80fd4: 911c2000     	add	x0, x0, #0x708
   80fd8: 940000d0     	bl	0x81318 <uart_send_string>
   80fdc: 9400009a     	bl	0x81244 <uart_flush>
   80fe0: 52800020     	mov	w0, #0x1                // =1
   80fe4: 39007fe0     	strb	w0, [sp, #0x1f]
   80fe8: 39405fe0     	ldrb	w0, [sp, #0x17]
   80fec: 7101e01f     	cmp	w0, #0x78
   80ff0: 540008a0     	b.eq	0x81104 <kernel_main+0x2d0>
   80ff4: 7101e01f     	cmp	w0, #0x78
   80ff8: 540009ec     	b.gt	0x81134 <kernel_main+0x300>
   80ffc: 7101c81f     	cmp	w0, #0x72
   81000: 540006a0     	b.eq	0x810d4 <kernel_main+0x2a0>
   81004: 7101c81f     	cmp	w0, #0x72
   81008: 5400096c     	b.gt	0x81134 <kernel_main+0x300>
   8100c: 7101a41f     	cmp	w0, #0x69
   81010: 54000540     	b.eq	0x810b8 <kernel_main+0x284>
   81014: 7101a41f     	cmp	w0, #0x69
   81018: 540008ec     	b.gt	0x81134 <kernel_main+0x300>
   8101c: 7101901f     	cmp	w0, #0x64
   81020: 540007a0     	b.eq	0x81114 <kernel_main+0x2e0>
   81024: 7101901f     	cmp	w0, #0x64
   81028: 5400086c     	b.gt	0x81134 <kernel_main+0x300>
   8102c: 7101101f     	cmp	w0, #0x44
   81030: 540007a0     	b.eq	0x81124 <kernel_main+0x2f0>
   81034: 7101101f     	cmp	w0, #0x44
   81038: 540007ec     	b.gt	0x81134 <kernel_main+0x300>
   8103c: 7100c01f     	cmp	w0, #0x30
   81040: 54000080     	b.eq	0x81050 <kernel_main+0x21c>
   81044: 7100c41f     	cmp	w0, #0x31
   81048: 540001e0     	b.eq	0x81084 <kernel_main+0x250>
   8104c: 1400003a     	b	0x81134 <kernel_main+0x300>
   81050: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81054: 9120e002     	add	x2, x0, #0x838
   81058: 52800001     	mov	w1, #0x0                // =0
   8105c: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81060: 9137e000     	add	x0, x0, #0xdf8
   81064: 97fffc81     	bl	0x80268 <do_fill>
   81068: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8106c: 9120e002     	add	x2, x0, #0x838
   81070: 52800001     	mov	w1, #0x0                // =0
   81074: d0001040     	adrp	x0, 0x28b000 <arr+0x208208>
   81078: 91386000     	add	x0, x0, #0xe18
   8107c: 97fffc7b     	bl	0x80268 <do_fill>
   81080: 14000033     	b	0x8114c <kernel_main+0x318>
   81084: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81088: 91210002     	add	x2, x0, #0x840
   8108c: 12800001     	mov	w1, #-0x1               // =-1
   81090: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81094: 9137e000     	add	x0, x0, #0xdf8
   81098: 97fffc74     	bl	0x80268 <do_fill>
   8109c: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   810a0: 91210002     	add	x2, x0, #0x840
   810a4: 12800001     	mov	w1, #-0x1               // =-1
   810a8: d0001040     	adrp	x0, 0x28b000 <arr+0x208208>
   810ac: 91386000     	add	x0, x0, #0xe18
   810b0: 97fffc6e     	bl	0x80268 <do_fill>
   810b4: 14000026     	b	0x8114c <kernel_main+0x318>
   810b8: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   810bc: 9137e000     	add	x0, x0, #0xdf8
   810c0: 97fffc8a     	bl	0x802e8 <do_fill_incremental>
   810c4: d0001040     	adrp	x0, 0x28b000 <arr+0x208208>
   810c8: 91386000     	add	x0, x0, #0xe18
   810cc: 97fffc87     	bl	0x802e8 <do_fill_incremental>
   810d0: 1400001f     	b	0x8114c <kernel_main+0x318>
   810d4: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   810d8: 91212000     	add	x0, x0, #0x848
   810dc: 9400008f     	bl	0x81318 <uart_send_string>
   810e0: 97fffc5e     	bl	0x80258 <get_curr_arr_size>
   810e4: b90013e0     	str	w0, [sp, #0x10]
   810e8: b94013e2     	ldr	w2, [sp, #0x10]
   810ec: d0001040     	adrp	x0, 0x28b000 <arr+0x208208>
   810f0: 91386001     	add	x1, x0, #0xe18
   810f4: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   810f8: 9137e000     	add	x0, x0, #0xdf8
   810fc: 97fffd19     	bl	0x80560 <run_emfi_test>
   81100: 14000013     	b	0x8114c <kernel_main+0x318>
   81104: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81108: 9137e000     	add	x0, x0, #0xdf8
   8110c: 97fffc90     	bl	0x8034c <do_checksum_xor>
   81110: 1400000f     	b	0x8114c <kernel_main+0x318>
   81114: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81118: 91218000     	add	x0, x0, #0x860
   8111c: 9400007f     	bl	0x81318 <uart_send_string>
   81120: 1400000b     	b	0x8114c <kernel_main+0x318>
   81124: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81128: 91218000     	add	x0, x0, #0x860
   8112c: 9400007b     	bl	0x81318 <uart_send_string>
   81130: 14000007     	b	0x8114c <kernel_main+0x318>
   81134: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81138: 9121e000     	add	x0, x0, #0x878
   8113c: 94000077     	bl	0x81318 <uart_send_string>
   81140: 97fffc20     	bl	0x801c0 <send_command_description>
   81144: 39007fff     	strb	wzr, [sp, #0x1f]
   81148: d503201f     	nop
   8114c: 39407fe0     	ldrb	w0, [sp, #0x1f]
   81150: 12000000     	and	w0, w0, #0x1
   81154: 7100001f     	cmp	w0, #0x0
   81158: 54fff2e0     	b.eq	0x80fb4 <kernel_main+0x180>
   8115c: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81160: 91224000     	add	x0, x0, #0x890
   81164: 9400006d     	bl	0x81318 <uart_send_string>
   81168: 52800040     	mov	w0, #0x2                // =2
   8116c: 94000082     	bl	0x81374 <uart_line_breaks>
   81170: 97fffc14     	bl	0x801c0 <send_command_description>
   81174: 94000034     	bl	0x81244 <uart_flush>
   81178: 17ffff8f     	b	0x80fb4 <kernel_main+0x180>

000000000008117c <uart_init>:
   8117c: d10043ff     	sub	sp, sp, #0x10
   81180: d2820600     	mov	x0, #0x1030             // =4144
   81184: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81188: b900001f     	str	wzr, [x0]
   8118c: d2800080     	mov	x0, #0x4                // =4
   81190: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81194: b9400000     	ldr	w0, [x0]
   81198: b9000fe0     	str	w0, [sp, #0xc]
   8119c: b9400fe0     	ldr	w0, [sp, #0xc]
   811a0: 120e6400     	and	w0, w0, #0xfffc0fff
   811a4: b9000fe0     	str	w0, [sp, #0xc]
   811a8: b9400fe1     	ldr	w1, [sp, #0xc]
   811ac: 52880000     	mov	w0, #0x4000             // =16384
   811b0: 72a00040     	movk	w0, #0x2, lsl #16
   811b4: 2a000020     	orr	w0, w1, w0
   811b8: b9000fe0     	str	w0, [sp, #0xc]
   811bc: d2800080     	mov	x0, #0x4                // =4
   811c0: f2bfc400     	movk	x0, #0xfe20, lsl #16
   811c4: b9400fe1     	ldr	w1, [sp, #0xc]
   811c8: b9000001     	str	w1, [x0]
   811cc: d2801c80     	mov	x0, #0xe4               // =228
   811d0: f2bfc400     	movk	x0, #0xfe20, lsl #16
   811d4: b9400001     	ldr	w1, [x0]
   811d8: d2801c80     	mov	x0, #0xe4               // =228
   811dc: f2bfc400     	movk	x0, #0xfe20, lsl #16
   811e0: 12006c21     	and	w1, w1, #0xfffffff
   811e4: b9000001     	str	w1, [x0]
   811e8: d2820880     	mov	x0, #0x1044             // =4164
   811ec: f2bfc400     	movk	x0, #0xfe20, lsl #16
   811f0: 5280ffe1     	mov	w1, #0x7ff              // =2047
   811f4: b9000001     	str	w1, [x0]
   811f8: d2820480     	mov	x0, #0x1024             // =4132
   811fc: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81200: 52800341     	mov	w1, #0x1a               // =26
   81204: b9000001     	str	w1, [x0]
   81208: d2820500     	mov	x0, #0x1028             // =4136
   8120c: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81210: 52800061     	mov	w1, #0x3                // =3
   81214: b9000001     	str	w1, [x0]
   81218: d2820580     	mov	x0, #0x102c             // =4140
   8121c: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81220: 52800e01     	mov	w1, #0x70               // =112
   81224: b9000001     	str	w1, [x0]
   81228: d2820600     	mov	x0, #0x1030             // =4144
   8122c: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81230: 52806021     	mov	w1, #0x301              // =769
   81234: b9000001     	str	w1, [x0]
   81238: d503201f     	nop
   8123c: 910043ff     	add	sp, sp, #0x10
   81240: d65f03c0     	ret

0000000000081244 <uart_flush>:
   81244: d10043ff     	sub	sp, sp, #0x10
   81248: d503201f     	nop
   8124c: d2820300     	mov	x0, #0x1018             // =4120
   81250: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81254: b9400000     	ldr	w0, [x0]
   81258: 12190000     	and	w0, w0, #0x80
   8125c: 7100001f     	cmp	w0, #0x0
   81260: 54ffff60     	b.eq	0x8124c <uart_flush+0x8>
   81264: 14000007     	b	0x81280 <uart_flush+0x3c>
   81268: d2820000     	mov	x0, #0x1000             // =4096
   8126c: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81270: b9400000     	ldr	w0, [x0]
   81274: 12001c00     	and	w0, w0, #0xff
   81278: 39003fe0     	strb	w0, [sp, #0xf]
   8127c: 39403fe0     	ldrb	w0, [sp, #0xf]
   81280: d2820300     	mov	x0, #0x1018             // =4120
   81284: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81288: b9400000     	ldr	w0, [x0]
   8128c: 121c0000     	and	w0, w0, #0x10
   81290: 7100001f     	cmp	w0, #0x0
   81294: 54fffea0     	b.eq	0x81268 <uart_flush+0x24>
   81298: d503201f     	nop
   8129c: d503201f     	nop
   812a0: 910043ff     	add	sp, sp, #0x10
   812a4: d65f03c0     	ret

00000000000812a8 <uart_send>:
   812a8: d10043ff     	sub	sp, sp, #0x10
   812ac: 39003fe0     	strb	w0, [sp, #0xf]
   812b0: d503201f     	nop
   812b4: d2820300     	mov	x0, #0x1018             // =4120
   812b8: f2bfc400     	movk	x0, #0xfe20, lsl #16
   812bc: b9400000     	ldr	w0, [x0]
   812c0: 121b0000     	and	w0, w0, #0x20
   812c4: 7100001f     	cmp	w0, #0x0
   812c8: 54ffff61     	b.ne	0x812b4 <uart_send+0xc>
   812cc: d2820000     	mov	x0, #0x1000             // =4096
   812d0: f2bfc400     	movk	x0, #0xfe20, lsl #16
   812d4: 39403fe1     	ldrb	w1, [sp, #0xf]
   812d8: b9000001     	str	w1, [x0]
   812dc: d503201f     	nop
   812e0: 910043ff     	add	sp, sp, #0x10
   812e4: d65f03c0     	ret

00000000000812e8 <uart_recv>:
   812e8: d503201f     	nop
   812ec: d2820300     	mov	x0, #0x1018             // =4120
   812f0: f2bfc400     	movk	x0, #0xfe20, lsl #16
   812f4: b9400000     	ldr	w0, [x0]
   812f8: 121c0000     	and	w0, w0, #0x10
   812fc: 7100001f     	cmp	w0, #0x0
   81300: 54ffff61     	b.ne	0x812ec <uart_recv+0x4>
   81304: d2820000     	mov	x0, #0x1000             // =4096
   81308: f2bfc400     	movk	x0, #0xfe20, lsl #16
   8130c: b9400000     	ldr	w0, [x0]
   81310: 12001c00     	and	w0, w0, #0xff
   81314: d65f03c0     	ret

0000000000081318 <uart_send_string>:
   81318: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   8131c: 910003fd     	mov	x29, sp
   81320: f9000fe0     	str	x0, [sp, #0x18]
   81324: 1400000c     	b	0x81354 <uart_send_string+0x3c>
   81328: f9400fe0     	ldr	x0, [sp, #0x18]
   8132c: 39400000     	ldrb	w0, [x0]
   81330: 7100281f     	cmp	w0, #0xa
   81334: 54000061     	b.ne	0x81340 <uart_send_string+0x28>
   81338: 528001a0     	mov	w0, #0xd                // =13
   8133c: 97ffffdb     	bl	0x812a8 <uart_send>
   81340: f9400fe0     	ldr	x0, [sp, #0x18]
   81344: 91000401     	add	x1, x0, #0x1
   81348: f9000fe1     	str	x1, [sp, #0x18]
   8134c: 39400000     	ldrb	w0, [x0]
   81350: 97ffffd6     	bl	0x812a8 <uart_send>
   81354: f9400fe0     	ldr	x0, [sp, #0x18]
   81358: 39400000     	ldrb	w0, [x0]
   8135c: 7100001f     	cmp	w0, #0x0
   81360: 54fffe41     	b.ne	0x81328 <uart_send_string+0x10>
   81364: d503201f     	nop
   81368: d503201f     	nop
   8136c: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   81370: d65f03c0     	ret

0000000000081374 <uart_line_breaks>:
   81374: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   81378: 910003fd     	mov	x29, sp
   8137c: b9001fe0     	str	w0, [sp, #0x1c]
   81380: b9002fff     	str	wzr, [sp, #0x2c]
   81384: 14000007     	b	0x813a0 <uart_line_breaks+0x2c>
   81388: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8138c: 91226000     	add	x0, x0, #0x898
   81390: 97ffffe2     	bl	0x81318 <uart_send_string>
   81394: b9402fe0     	ldr	w0, [sp, #0x2c]
   81398: 11000400     	add	w0, w0, #0x1
   8139c: b9002fe0     	str	w0, [sp, #0x2c]
   813a0: b9402fe1     	ldr	w1, [sp, #0x2c]
   813a4: b9401fe0     	ldr	w0, [sp, #0x1c]
   813a8: 6b00003f     	cmp	w1, w0
   813ac: 54fffeeb     	b.lt	0x81388 <uart_line_breaks+0x14>
   813b0: d503201f     	nop
   813b4: d503201f     	nop
   813b8: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   813bc: d65f03c0     	ret

00000000000813c0 <uart_send_hex>:
   813c0: a9bc7bfd     	stp	x29, x30, [sp, #-0x40]!
   813c4: 910003fd     	mov	x29, sp
   813c8: b9001fe0     	str	w0, [sp, #0x1c]
   813cc: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   813d0: 91228000     	add	x0, x0, #0x8a0
   813d4: 9100a3e2     	add	x2, sp, #0x28
   813d8: aa0003e3     	mov	x3, x0
   813dc: a9400460     	ldp	x0, x1, [x3]
   813e0: a9000440     	stp	x0, x1, [x2]
   813e4: 39404060     	ldrb	w0, [x3, #0x10]
   813e8: 39004040     	strb	w0, [x2, #0x10]
   813ec: 528000e0     	mov	w0, #0x7                // =7
   813f0: b9003fe0     	str	w0, [sp, #0x3c]
   813f4: 1400000f     	b	0x81430 <uart_send_hex+0x70>
   813f8: b9403fe0     	ldr	w0, [sp, #0x3c]
   813fc: 531e7400     	lsl	w0, w0, #2
   81400: b9401fe1     	ldr	w1, [sp, #0x1c]
   81404: 1ac02420     	lsr	w0, w1, w0
   81408: 12000c00     	and	w0, w0, #0xf
   8140c: 2a0003e0     	mov	w0, w0
   81410: 9100a3e1     	add	x1, sp, #0x28
   81414: 38606820     	ldrb	w0, [x1, x0]
   81418: 3900efe0     	strb	w0, [sp, #0x3b]
   8141c: 3940efe0     	ldrb	w0, [sp, #0x3b]
   81420: 97ffffa2     	bl	0x812a8 <uart_send>
   81424: b9403fe0     	ldr	w0, [sp, #0x3c]
   81428: 51000400     	sub	w0, w0, #0x1
   8142c: b9003fe0     	str	w0, [sp, #0x3c]
   81430: b9403fe0     	ldr	w0, [sp, #0x3c]
   81434: 7100001f     	cmp	w0, #0x0
   81438: 54fffe0a     	b.ge	0x813f8 <uart_send_hex+0x38>
   8143c: d503201f     	nop
   81440: d503201f     	nop
   81444: a8c47bfd     	ldp	x29, x30, [sp], #0x40
   81448: d65f03c0     	ret

000000000008144c <uart_receive_number>:
   8144c: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   81450: 910003fd     	mov	x29, sp
   81454: b9002fff     	str	wzr, [sp, #0x2c]
   81458: 97ffffa4     	bl	0x812e8 <uart_recv>
   8145c: 39008fe0     	strb	w0, [sp, #0x23]
   81460: 39408fe0     	ldrb	w0, [sp, #0x23]
   81464: 7100341f     	cmp	w0, #0xd
   81468: 54000080     	b.eq	0x81478 <uart_receive_number+0x2c>
   8146c: 39408fe0     	ldrb	w0, [sp, #0x23]
   81470: 7100281f     	cmp	w0, #0xa
   81474: 54000161     	b.ne	0x814a0 <uart_receive_number+0x54>
   81478: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   8147c: 91226000     	add	x0, x0, #0x898
   81480: 97ffffa6     	bl	0x81318 <uart_send_string>
   81484: d503201f     	nop
   81488: b9802fe0     	ldrsw	x0, [sp, #0x2c]
   8148c: 910043e1     	add	x1, sp, #0x10
   81490: 3820683f     	strb	wzr, [x1, x0]
   81494: b9002bff     	str	wzr, [sp, #0x28]
   81498: b90027ff     	str	wzr, [sp, #0x24]
   8149c: 14000030     	b	0x8155c <uart_receive_number+0x110>
   814a0: 39408fe0     	ldrb	w0, [sp, #0x23]
   814a4: 7100bc1f     	cmp	w0, #0x2f
   814a8: 54000229     	b.ls	0x814ec <uart_receive_number+0xa0>
   814ac: 39408fe0     	ldrb	w0, [sp, #0x23]
   814b0: 7100e41f     	cmp	w0, #0x39
   814b4: 540001c8     	b.hi	0x814ec <uart_receive_number+0xa0>
   814b8: b9402fe0     	ldr	w0, [sp, #0x2c]
   814bc: 7100381f     	cmp	w0, #0xe
   814c0: 5400016c     	b.gt	0x814ec <uart_receive_number+0xa0>
   814c4: b9402fe0     	ldr	w0, [sp, #0x2c]
   814c8: 11000401     	add	w1, w0, #0x1
   814cc: b9002fe1     	str	w1, [sp, #0x2c]
   814d0: 93407c00     	sxtw	x0, w0
   814d4: 910043e1     	add	x1, sp, #0x10
   814d8: 39408fe2     	ldrb	w2, [sp, #0x23]
   814dc: 38206822     	strb	w2, [x1, x0]
   814e0: 39408fe0     	ldrb	w0, [sp, #0x23]
   814e4: 97ffff71     	bl	0x812a8 <uart_send>
   814e8: 1400000d     	b	0x8151c <uart_receive_number+0xd0>
   814ec: 39408fe0     	ldrb	w0, [sp, #0x23]
   814f0: 7101fc1f     	cmp	w0, #0x7f
   814f4: 54fffb21     	b.ne	0x81458 <uart_receive_number+0xc>
   814f8: b9402fe0     	ldr	w0, [sp, #0x2c]
   814fc: 7100001f     	cmp	w0, #0x0
   81500: 54fffacd     	b.le	0x81458 <uart_receive_number+0xc>
   81504: b9402fe0     	ldr	w0, [sp, #0x2c]
   81508: 51000400     	sub	w0, w0, #0x1
   8150c: b9002fe0     	str	w0, [sp, #0x2c]
   81510: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81514: 9122e000     	add	x0, x0, #0x8b8
   81518: 97ffff80     	bl	0x81318 <uart_send_string>
   8151c: 17ffffcf     	b	0x81458 <uart_receive_number+0xc>
   81520: b9402be1     	ldr	w1, [sp, #0x28]
   81524: 2a0103e0     	mov	w0, w1
   81528: 531e7400     	lsl	w0, w0, #2
   8152c: 0b010000     	add	w0, w0, w1
   81530: 531f7800     	lsl	w0, w0, #1
   81534: 2a0003e2     	mov	w2, w0
   81538: b98027e0     	ldrsw	x0, [sp, #0x24]
   8153c: 910043e1     	add	x1, sp, #0x10
   81540: 38606820     	ldrb	w0, [x1, x0]
   81544: 0b000040     	add	w0, w2, w0
   81548: 5100c000     	sub	w0, w0, #0x30
   8154c: b9002be0     	str	w0, [sp, #0x28]
   81550: b94027e0     	ldr	w0, [sp, #0x24]
   81554: 11000400     	add	w0, w0, #0x1
   81558: b90027e0     	str	w0, [sp, #0x24]
   8155c: b94027e1     	ldr	w1, [sp, #0x24]
   81560: b9402fe0     	ldr	w0, [sp, #0x2c]
   81564: 6b00003f     	cmp	w1, w0
   81568: 54fffdcb     	b.lt	0x81520 <uart_receive_number+0xd4>
   8156c: b9402be0     	ldr	w0, [sp, #0x28]
   81570: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   81574: d65f03c0     	ret

0000000000081578 <uart_send_dec>:
   81578: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   8157c: 910003fd     	mov	x29, sp
   81580: b9001fe0     	str	w0, [sp, #0x1c]
   81584: 52800140     	mov	w0, #0xa                // =10
   81588: b9002fe0     	str	w0, [sp, #0x2c]
   8158c: b9802fe0     	ldrsw	x0, [sp, #0x2c]
   81590: 910083e1     	add	x1, sp, #0x20
   81594: 3820683f     	strb	wzr, [x1, x0]
   81598: b9401fe0     	ldr	w0, [sp, #0x1c]
   8159c: 7100001f     	cmp	w0, #0x0
   815a0: 540003e1     	b.ne	0x8161c <uart_send_dec+0xa4>
   815a4: 52800600     	mov	w0, #0x30               // =48
   815a8: 97ffff40     	bl	0x812a8 <uart_send>
   815ac: 14000026     	b	0x81644 <uart_send_dec+0xcc>
   815b0: b9401fe2     	ldr	w2, [sp, #0x1c]
   815b4: 529999a0     	mov	w0, #0xcccd             // =52429
   815b8: 72b99980     	movk	w0, #0xcccc, lsl #16
   815bc: 9ba07c40     	umull	x0, w2, w0
   815c0: d360fc00     	lsr	x0, x0, #32
   815c4: 53037c01     	lsr	w1, w0, #3
   815c8: 2a0103e0     	mov	w0, w1
   815cc: 531e7400     	lsl	w0, w0, #2
   815d0: 0b010000     	add	w0, w0, w1
   815d4: 531f7800     	lsl	w0, w0, #1
   815d8: 4b000041     	sub	w1, w2, w0
   815dc: 12001c20     	and	w0, w1, #0xff
   815e0: b9402fe1     	ldr	w1, [sp, #0x2c]
   815e4: 51000421     	sub	w1, w1, #0x1
   815e8: b9002fe1     	str	w1, [sp, #0x2c]
   815ec: 1100c000     	add	w0, w0, #0x30
   815f0: 12001c02     	and	w2, w0, #0xff
   815f4: b9802fe0     	ldrsw	x0, [sp, #0x2c]
   815f8: 910083e1     	add	x1, sp, #0x20
   815fc: 38206822     	strb	w2, [x1, x0]
   81600: b9401fe1     	ldr	w1, [sp, #0x1c]
   81604: 529999a0     	mov	w0, #0xcccd             // =52429
   81608: 72b99980     	movk	w0, #0xcccc, lsl #16
   8160c: 9ba07c20     	umull	x0, w1, w0
   81610: d360fc00     	lsr	x0, x0, #32
   81614: 53037c00     	lsr	w0, w0, #3
   81618: b9001fe0     	str	w0, [sp, #0x1c]
   8161c: b9401fe0     	ldr	w0, [sp, #0x1c]
   81620: 7100001f     	cmp	w0, #0x0
   81624: 54000080     	b.eq	0x81634 <uart_send_dec+0xbc>
   81628: b9402fe0     	ldr	w0, [sp, #0x2c]
   8162c: 7100001f     	cmp	w0, #0x0
   81630: 54fffc0c     	b.gt	0x815b0 <uart_send_dec+0x38>
   81634: 910083e1     	add	x1, sp, #0x20
   81638: b9802fe0     	ldrsw	x0, [sp, #0x2c]
   8163c: 8b000020     	add	x0, x1, x0
   81640: 97ffff36     	bl	0x81318 <uart_send_string>
   81644: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   81648: d65f03c0     	ret

000000000008164c <uart_send_dec64>:
   8164c: a9bc7bfd     	stp	x29, x30, [sp, #-0x40]!
   81650: 910003fd     	mov	x29, sp
   81654: f9000fe0     	str	x0, [sp, #0x18]
   81658: 52800280     	mov	w0, #0x14               // =20
   8165c: b9003fe0     	str	w0, [sp, #0x3c]
   81660: b9803fe0     	ldrsw	x0, [sp, #0x3c]
   81664: 910083e1     	add	x1, sp, #0x20
   81668: 3820683f     	strb	wzr, [x1, x0]
   8166c: f9400fe0     	ldr	x0, [sp, #0x18]
   81670: f100001f     	cmp	x0, #0x0
   81674: 540003a1     	b.ne	0x816e8 <uart_send_dec64+0x9c>
   81678: 52800600     	mov	w0, #0x30               // =48
   8167c: 97ffff0b     	bl	0x812a8 <uart_send>
   81680: 14000024     	b	0x81710 <uart_send_dec64+0xc4>
   81684: f9400fe2     	ldr	x2, [sp, #0x18]
   81688: b202e7e0     	mov	x0, #-0x3333333333333334 // =-3689348814741910324
   8168c: f29999a0     	movk	x0, #0xcccd
   81690: 9bc07c40     	umulh	x0, x2, x0
   81694: d343fc01     	lsr	x1, x0, #3
   81698: aa0103e0     	mov	x0, x1
   8169c: d37ef400     	lsl	x0, x0, #2
   816a0: 8b010000     	add	x0, x0, x1
   816a4: d37ff800     	lsl	x0, x0, #1
   816a8: cb000041     	sub	x1, x2, x0
   816ac: 12001c20     	and	w0, w1, #0xff
   816b0: b9403fe1     	ldr	w1, [sp, #0x3c]
   816b4: 51000421     	sub	w1, w1, #0x1
   816b8: b9003fe1     	str	w1, [sp, #0x3c]
   816bc: 1100c000     	add	w0, w0, #0x30
   816c0: 12001c02     	and	w2, w0, #0xff
   816c4: b9803fe0     	ldrsw	x0, [sp, #0x3c]
   816c8: 910083e1     	add	x1, sp, #0x20
   816cc: 38206822     	strb	w2, [x1, x0]
   816d0: f9400fe1     	ldr	x1, [sp, #0x18]
   816d4: b202e7e0     	mov	x0, #-0x3333333333333334 // =-3689348814741910324
   816d8: f29999a0     	movk	x0, #0xcccd
   816dc: 9bc07c20     	umulh	x0, x1, x0
   816e0: d343fc00     	lsr	x0, x0, #3
   816e4: f9000fe0     	str	x0, [sp, #0x18]
   816e8: f9400fe0     	ldr	x0, [sp, #0x18]
   816ec: f100001f     	cmp	x0, #0x0
   816f0: 54000080     	b.eq	0x81700 <uart_send_dec64+0xb4>
   816f4: b9403fe0     	ldr	w0, [sp, #0x3c]
   816f8: 7100001f     	cmp	w0, #0x0
   816fc: 54fffc4c     	b.gt	0x81684 <uart_send_dec64+0x38>
   81700: 910083e1     	add	x1, sp, #0x20
   81704: b9803fe0     	ldrsw	x0, [sp, #0x3c]
   81708: 8b000020     	add	x0, x1, x0
   8170c: 97ffff03     	bl	0x81318 <uart_send_string>
   81710: a8c47bfd     	ldp	x29, x30, [sp], #0x40
   81714: d65f03c0     	ret

0000000000081718 <uart_read_ready>:
   81718: d2820300     	mov	x0, #0x1018             // =4120
   8171c: f2bfc400     	movk	x0, #0xfe20, lsl #16
   81720: b9400000     	ldr	w0, [x0]
   81724: 121c0000     	and	w0, w0, #0x10
   81728: 7100001f     	cmp	w0, #0x0
   8172c: 1a9f17e0     	cset	w0, eq
   81730: 12001c00     	and	w0, w0, #0xff
   81734: d65f03c0     	ret

0000000000081738 <delay_us>:
   81738: d10083ff     	sub	sp, sp, #0x20
   8173c: b9000fe0     	str	w0, [sp, #0xc]
   81740: d2860080     	mov	x0, #0x3004             // =12292
   81744: f2bfc000     	movk	x0, #0xfe00, lsl #16
   81748: b9400000     	ldr	w0, [x0]
   8174c: b9001fe0     	str	w0, [sp, #0x1c]
   81750: d503201f     	nop
   81754: d2860080     	mov	x0, #0x3004             // =12292
   81758: f2bfc000     	movk	x0, #0xfe00, lsl #16
   8175c: b9400001     	ldr	w1, [x0]
   81760: b9401fe0     	ldr	w0, [sp, #0x1c]
   81764: 4b000020     	sub	w0, w1, w0
   81768: b9400fe1     	ldr	w1, [sp, #0xc]
   8176c: 6b00003f     	cmp	w1, w0
   81770: 54ffff28     	b.hi	0x81754 <delay_us+0x1c>
   81774: d503201f     	nop
   81778: d503201f     	nop
   8177c: 910083ff     	add	sp, sp, #0x20
   81780: d65f03c0     	ret

0000000000081784 <emfi_pulse_precise>:
   81784: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   81788: 910003fd     	mov	x29, sp
   8178c: b9001fe0     	str	w0, [sp, #0x1c]
   81790: 52800021     	mov	w1, #0x1                // =1
   81794: 52800080     	mov	w0, #0x4                // =4
   81798: 97fffd83     	bl	0x80da4 <gpio_set>
   8179c: b9401fe0     	ldr	w0, [sp, #0x1c]
   817a0: 97ffffe6     	bl	0x81738 <delay_us>
   817a4: 52800001     	mov	w1, #0x0                // =0
   817a8: 52800080     	mov	w0, #0x4                // =4
   817ac: 97fffd7e     	bl	0x80da4 <gpio_set>
   817b0: d503201f     	nop
   817b4: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   817b8: d65f03c0     	ret

00000000000817bc <dcache_clean_by_va>:
   817bc: d10043ff     	sub	sp, sp, #0x10
   817c0: f90007e0     	str	x0, [sp, #0x8]
   817c4: f94007e0     	ldr	x0, [sp, #0x8]
   817c8: d50b7a20     	dc	cvac, x0
   817cc: d503201f     	nop
   817d0: 910043ff     	add	sp, sp, #0x10
   817d4: d65f03c0     	ret

00000000000817d8 <dcache_clean_invalidate_by_va>:
   817d8: d10043ff     	sub	sp, sp, #0x10
   817dc: f90007e0     	str	x0, [sp, #0x8]
   817e0: f94007e0     	ldr	x0, [sp, #0x8]
   817e4: d50b7e20     	dc	civac, x0
   817e8: d503201f     	nop
   817ec: 910043ff     	add	sp, sp, #0x10
   817f0: d65f03c0     	ret

00000000000817f4 <dcache_clean_line_by_va>:
   817f4: a9be7bfd     	stp	x29, x30, [sp, #-0x20]!
   817f8: 910003fd     	mov	x29, sp
   817fc: f9000fe0     	str	x0, [sp, #0x18]
   81800: f9400fe0     	ldr	x0, [sp, #0x18]
   81804: 97ffffee     	bl	0x817bc <dcache_clean_by_va>
   81808: d503201f     	nop
   8180c: a8c27bfd     	ldp	x29, x30, [sp], #0x20
   81810: d65f03c0     	ret

0000000000081814 <dsb_ish>:
   81814: d5033b9f     	dsb	ish
   81818: d503201f     	nop
   8181c: d65f03c0     	ret

0000000000081820 <isb>:
   81820: d5033fdf     	isb
   81824: d503201f     	nop
   81828: d65f03c0     	ret

000000000008182c <flush_dcache_range_with_trigger_every_n>:
   8182c: a9bb7bfd     	stp	x29, x30, [sp, #-0x50]!
   81830: 910003fd     	mov	x29, sp
   81834: f90017e0     	str	x0, [sp, #0x28]
   81838: f90013e1     	str	x1, [sp, #0x20]
   8183c: f9000fe2     	str	x2, [sp, #0x18]
   81840: b90017e3     	str	w3, [sp, #0x14]
   81844: f94017e0     	ldr	x0, [sp, #0x28]
   81848: 927ae400     	and	x0, x0, #0xffffffffffffffc0
   8184c: f90027e0     	str	x0, [sp, #0x48]
   81850: f94017e0     	ldr	x0, [sp, #0x28]
   81854: f94013e1     	ldr	x1, [sp, #0x20]
   81858: 8b000020     	add	x0, x1, x0
   8185c: f9001fe0     	str	x0, [sp, #0x38]
   81860: f90023ff     	str	xzr, [sp, #0x40]
   81864: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81868: 91230000     	add	x0, x0, #0x8c0
   8186c: 97fffeab     	bl	0x81318 <uart_send_string>
   81870: 14000011     	b	0x818b4 <flush_dcache_range_with_trigger_every_n+0x88>
   81874: f94027e0     	ldr	x0, [sp, #0x48]
   81878: d50b7e20     	dc	civac, x0
   8187c: f9400fe0     	ldr	x0, [sp, #0x18]
   81880: d1000401     	sub	x1, x0, #0x1
   81884: f94023e0     	ldr	x0, [sp, #0x40]
   81888: 8a000020     	and	x0, x1, x0
   8188c: f100001f     	cmp	x0, #0x0
   81890: 54000061     	b.ne	0x8189c <flush_dcache_range_with_trigger_every_n+0x70>
   81894: b94017e0     	ldr	w0, [sp, #0x14]
   81898: 97ffffbb     	bl	0x81784 <emfi_pulse_precise>
   8189c: f94027e0     	ldr	x0, [sp, #0x48]
   818a0: 91010000     	add	x0, x0, #0x40
   818a4: f90027e0     	str	x0, [sp, #0x48]
   818a8: f94023e0     	ldr	x0, [sp, #0x40]
   818ac: 91000400     	add	x0, x0, #0x1
   818b0: f90023e0     	str	x0, [sp, #0x40]
   818b4: f94027e1     	ldr	x1, [sp, #0x48]
   818b8: f9401fe0     	ldr	x0, [sp, #0x38]
   818bc: eb00003f     	cmp	x1, x0
   818c0: 54fffda3     	b.lo	0x81874 <flush_dcache_range_with_trigger_every_n+0x48>
   818c4: d5033f9f     	dsb	sy
   818c8: d5033fdf     	isb
   818cc: d503201f     	nop
   818d0: a8c57bfd     	ldp	x29, x30, [sp], #0x50
   818d4: d65f03c0     	ret

00000000000818d8 <flush_and_invalidate_dcache_range>:
   818d8: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   818dc: 910003fd     	mov	x29, sp
   818e0: f9000fe0     	str	x0, [sp, #0x18]
   818e4: f9000be1     	str	x1, [sp, #0x10]
   818e8: f9400fe0     	ldr	x0, [sp, #0x18]
   818ec: 927ae400     	and	x0, x0, #0xffffffffffffffc0
   818f0: f90017e0     	str	x0, [sp, #0x28]
   818f4: f9400fe1     	ldr	x1, [sp, #0x18]
   818f8: f9400be0     	ldr	x0, [sp, #0x10]
   818fc: 8b000020     	add	x0, x1, x0
   81900: 9100fc00     	add	x0, x0, #0x3f
   81904: 927ae400     	and	x0, x0, #0xffffffffffffffc0
   81908: f90013e0     	str	x0, [sp, #0x20]
   8190c: 14000006     	b	0x81924 <flush_and_invalidate_dcache_range+0x4c>
   81910: f94017e0     	ldr	x0, [sp, #0x28]
   81914: 97ffffb1     	bl	0x817d8 <dcache_clean_invalidate_by_va>
   81918: f94017e0     	ldr	x0, [sp, #0x28]
   8191c: 91010000     	add	x0, x0, #0x40
   81920: f90017e0     	str	x0, [sp, #0x28]
   81924: f94017e1     	ldr	x1, [sp, #0x28]
   81928: f94013e0     	ldr	x0, [sp, #0x20]
   8192c: eb00003f     	cmp	x1, x0
   81930: 54ffff03     	b.lo	0x81910 <flush_and_invalidate_dcache_range+0x38>
   81934: 97ffffb8     	bl	0x81814 <dsb_ish>
   81938: 97ffffba     	bl	0x81820 <isb>
   8193c: d503201f     	nop
   81940: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   81944: d65f03c0     	ret

0000000000081948 <test_array_fill>:
   81948: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   8194c: 910003fd     	mov	x29, sp
   81950: f9000fe0     	str	x0, [sp, #0x18]
   81954: b90017e1     	str	w1, [sp, #0x14]
   81958: 97fffa40     	bl	0x80258 <get_curr_arr_size>
   8195c: b9002be0     	str	w0, [sp, #0x28]
   81960: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   81964: 91232000     	add	x0, x0, #0x8c8
   81968: 97fffe6c     	bl	0x81318 <uart_send_string>
   8196c: b9002fff     	str	wzr, [sp, #0x2c]
   81970: 14000018     	b	0x819d0 <test_array_fill+0x88>
   81974: f9400fe0     	ldr	x0, [sp, #0x18]
   81978: b9402fe1     	ldr	w1, [sp, #0x2c]
   8197c: b94017e2     	ldr	w2, [sp, #0x14]
   81980: b8217802     	str	w2, [x0, x1, lsl #2]
   81984: b9402fe1     	ldr	w1, [sp, #0x2c]
   81988: 53057c22     	lsr	w2, w1, #5
   8198c: 528b58a0     	mov	w0, #0x5ac5             // =23237
   81990: 72a14f80     	movk	w0, #0xa7c, lsl #16
   81994: 9ba07c40     	umull	x0, w2, w0
   81998: d360fc00     	lsr	x0, x0, #32
   8199c: 53077c00     	lsr	w0, w0, #7
   819a0: 5290d402     	mov	w2, #0x86a0             // =34464
   819a4: 72a00022     	movk	w2, #0x1, lsl #16
   819a8: 1b027c00     	mul	w0, w0, w2
   819ac: 4b000020     	sub	w0, w1, w0
   819b0: 7100001f     	cmp	w0, #0x0
   819b4: 54000081     	b.ne	0x819c4 <test_array_fill+0x7c>
   819b8: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   819bc: 91236000     	add	x0, x0, #0x8d8
   819c0: 97fffe56     	bl	0x81318 <uart_send_string>
   819c4: b9402fe0     	ldr	w0, [sp, #0x2c]
   819c8: 11000400     	add	w0, w0, #0x1
   819cc: b9002fe0     	str	w0, [sp, #0x2c]
   819d0: b9402fe1     	ldr	w1, [sp, #0x2c]
   819d4: b9402be0     	ldr	w0, [sp, #0x28]
   819d8: 6b00003f     	cmp	w1, w0
   819dc: 54fffcc3     	b.lo	0x81974 <test_array_fill+0x2c>
   819e0: d5033f9f     	dsb	sy
   819e4: b0000000     	adrp	x0, 0x82000 <_estack_size+0x72000>
   819e8: 91238000     	add	x0, x0, #0x8e0
   819ec: 97fffe4b     	bl	0x81318 <uart_send_string>
   819f0: d503201f     	nop
   819f4: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   819f8: d65f03c0     	ret

00000000000819fc <test_array_fill_incremental>:
   819fc: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   81a00: 910003fd     	mov	x29, sp
   81a04: f9000fe0     	str	x0, [sp, #0x18]
   81a08: 97fffa14     	bl	0x80258 <get_curr_arr_size>
   81a0c: b9002be0     	str	w0, [sp, #0x28]
   81a10: b9002fff     	str	wzr, [sp, #0x2c]
   81a14: 14000008     	b	0x81a34 <test_array_fill_incremental+0x38>
   81a18: f9400fe0     	ldr	x0, [sp, #0x18]
   81a1c: b9402fe1     	ldr	w1, [sp, #0x2c]
   81a20: b9402fe2     	ldr	w2, [sp, #0x2c]
   81a24: b8217802     	str	w2, [x0, x1, lsl #2]
   81a28: b9402fe0     	ldr	w0, [sp, #0x2c]
   81a2c: 11000400     	add	w0, w0, #0x1
   81a30: b9002fe0     	str	w0, [sp, #0x2c]
   81a34: b9402fe1     	ldr	w1, [sp, #0x2c]
   81a38: b9402be0     	ldr	w0, [sp, #0x28]
   81a3c: 6b00003f     	cmp	w1, w0
   81a40: 54fffec3     	b.lo	0x81a18 <test_array_fill_incremental+0x1c>
   81a44: 52800020     	mov	w0, #0x1                // =1
   81a48: 97fffe4b     	bl	0x81374 <uart_line_breaks>
   81a4c: d503201f     	nop
   81a50: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   81a54: d65f03c0     	ret

0000000000081a58 <test_array_increment>:
   81a58: a9bd7bfd     	stp	x29, x30, [sp, #-0x30]!
   81a5c: 910003fd     	mov	x29, sp
   81a60: f9000fe0     	str	x0, [sp, #0x18]
   81a64: 97fff9fd     	bl	0x80258 <get_curr_arr_size>
   81a68: b9002be0     	str	w0, [sp, #0x28]
   81a6c: b9002fff     	str	wzr, [sp, #0x2c]
   81a70: 1400000b     	b	0x81a9c <test_array_increment+0x44>
   81a74: f9400fe0     	ldr	x0, [sp, #0x18]
   81a78: b9402fe1     	ldr	w1, [sp, #0x2c]
   81a7c: b8617800     	ldr	w0, [x0, x1, lsl #2]
   81a80: 11000402     	add	w2, w0, #0x1
   81a84: f9400fe0     	ldr	x0, [sp, #0x18]
   81a88: b9402fe1     	ldr	w1, [sp, #0x2c]
   81a8c: b8217802     	str	w2, [x0, x1, lsl #2]
   81a90: b9402fe0     	ldr	w0, [sp, #0x2c]
   81a94: 11000400     	add	w0, w0, #0x1
   81a98: b9002fe0     	str	w0, [sp, #0x2c]
   81a9c: b9402fe1     	ldr	w1, [sp, #0x2c]
   81aa0: b9402be0     	ldr	w0, [sp, #0x28]
   81aa4: 6b00003f     	cmp	w1, w0
   81aa8: 54fffe63     	b.lo	0x81a74 <test_array_increment+0x1c>
   81aac: d503201f     	nop
   81ab0: d503201f     	nop
   81ab4: a8c37bfd     	ldp	x29, x30, [sp], #0x30
   81ab8: d65f03c0     	ret

0000000000081abc <memzero>:
   81abc: f800841f     	str	xzr, [x0], #0x8
   81ac0: f1002021     	subs	x1, x1, #0x8
   81ac4: 54ffffcc     	b.gt	0x81abc <memzero>
   81ac8: d65f03c0     	ret

0000000000081acc <delay>:
   81acc: f1000400     	subs	x0, x0, #0x1
   81ad0: 54ffffe1     	b.ne	0x81acc <delay>
   81ad4: d65f03c0     	ret

0000000000081ad8 <put32>:
   81ad8: b9000001     	str	w1, [x0]
   81adc: d65f03c0     	ret

0000000000081ae0 <get32>:
   81ae0: b9400000     	ldr	w0, [x0]
   81ae4: d65f03c0     	ret
