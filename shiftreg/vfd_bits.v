`ifndef _VFD_PINS_H_
`define _VFD_PINS_H_

// segments
parameter A  = (1 << 31);
parameter B  = (1 << 29);
parameter C  = (1 << 22);
parameter D  = (1 << 17);
parameter E  = (1 << 10);
parameter F  = (1 <<  7);
parameter G  = (1 << 27);
parameter H  = (1 << 28);
parameter I  = (1 << 24);
parameter J  = (1 << 16);
parameter K  = (1 << 14);
parameter L  = (1 << 11);
parameter M  = (1 <<  9);
parameter N  = (1 << 25);
parameter O  = (1 << 19);
parameter P  = (1 << 13);

// grids
parameter G1 = (1 <<  8);
parameter G2 = (1 << 12);
parameter G3 = (1 << 15);
parameter G4 = (1 << 18);
parameter G5 = (1 << 20);
parameter G6 = (1 << 21);
parameter G7 = (1 << 23);
parameter G8 = (1 << 26);
parameter G9 = (1 << 30);

// letters
parameter letter_a = (A | B | C | E | F | I | M);
parameter letter_b = (A | B | C | D | I | K | G);
parameter letter_c = (A | D | E | F            );
parameter letter_d = (A | B | C | D | K | G    );
parameter letter_e = (A | D | E | F | M        );
parameter letter_f = (A | E | F | M            );
parameter letter_g = (A | C | D | E | F | I    );
parameter letter_h = (B | C | E | F | I | M    );
parameter letter_i = (A | G | K | D            );
parameter letter_j = (B | C | D | E            );
parameter letter_k = (E | F | M | H | J        );
parameter letter_l = (D | E | F                );
parameter letter_m = (B | C | E | F | H | N    );
parameter letter_n = (B | C | E | F | J | N    );
parameter letter_o = (A | B | C | D | E | F    );
parameter letter_p = (A | B | I | M | E | F    );
parameter letter_q = (A | B | C | D | E | F | J);
parameter letter_r = (A | B | I | M | E | F | J);
parameter letter_s = (A | F | M | I | C | D    );
parameter letter_t = (A | G | K                );
parameter letter_u = (B | C | D | E | F        );
parameter letter_v = (E | F | H | L            );
parameter letter_w = (B | C | E | F | J | L    );
parameter letter_x = (H | J | L | N            );
parameter letter_y = (F | M | J | B | C | D    );
parameter letter_z = (A | H | L | D            );

`endif // _VFD_PINS_H_
