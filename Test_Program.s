# -------------------------------
	# RISC-V Test Program
	# Instructions: add, addi, sub, or, and, lw, sw, j
	# -------------------------------

		addi x1, x0, 5       # x1 = 5
		addi x2, x0, 10      # x2 = 10
		add  x3, x1, x2      # x3 = x1 + x2 = 15
		sub  x4, x3, x1      # x4 = x3 - x1 = 10
		or   x5, x1, x2      # x5 = x1 | x2 = 15
		and  x6, x1, x2      # x6 = x1 & x2 = 0
		sw   x3, 0(x0)       # MEM[0] = x3 = 15
		lw   x7, 0(x0)       # x7 = MEM[0] = 15
		j    end             # jump to end
		addi x8, x0, 1       # skipped instruction (just for demo)
	end:
		addi x9, x0, 9       # x9 = 9
