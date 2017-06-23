9000 // PC keyboard interface constants
9001 
9002 #define KBSTATP         0x64    // kbd controller status port(I)
9003 #define KBS_DIB         0x01    // kbd data in buffer
9004 #define KBDATAP         0x60    // kbd data port(I)
9005 
9006 #define NO              0
9007 
9008 #define SHIFT           (1<<0)
9009 #define CTL             (1<<1)
9010 #define ALT             (1<<2)
9011 
9012 #define CAPSLOCK        (1<<3)
9013 #define NUMLOCK         (1<<4)
9014 #define SCROLLLOCK      (1<<5)
9015 
9016 #define E0ESC           (1<<6)
9017 
9018 // Special keycodes
9019 #define KEY_HOME        0xE0
9020 #define KEY_END         0xE1
9021 #define KEY_UP          0xE2
9022 #define KEY_DN          0xE3
9023 #define KEY_LF          0xE4
9024 #define KEY_RT          0xE5
9025 #define KEY_PGUP        0xE6
9026 #define KEY_PGDN        0xE7
9027 #define KEY_INS         0xE8
9028 #define KEY_DEL         0xE9
9029 
9030 // C('A') == Control-A
9031 #define C(x) (x - '@')
9032 
9033 static uchar shiftcode[256] =
9034 {
9035   [0x1D] CTL,
9036   [0x2A] SHIFT,
9037   [0x36] SHIFT,
9038   [0x38] ALT,
9039   [0x9D] CTL,
9040   [0xB8] ALT
9041 };
9042 
9043 static uchar togglecode[256] =
9044 {
9045   [0x3A] CAPSLOCK,
9046   [0x45] NUMLOCK,
9047   [0x46] SCROLLLOCK
9048 };
9049 
9050 static uchar normalmap[256] =
9051 {
9052   NO,   0x1B, '1',  '2',  '3',  '4',  '5',  '6',  // 0x00
9053   '7',  '8',  '9',  '0',  '-',  '=',  '\b', '\t',
9054   'q',  'w',  'e',  'r',  't',  'y',  'u',  'i',  // 0x10
9055   'o',  'p',  '[',  ']',  '\n', NO,   'a',  's',
9056   'd',  'f',  'g',  'h',  'j',  'k',  'l',  ';',  // 0x20
9057   '\'', '`',  NO,   '\\', 'z',  'x',  'c',  'v',
9058   'b',  'n',  'm',  ',',  '.',  '/',  NO,   '*',  // 0x30
9059   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
9060   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
9061   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
9062   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
9063   [0x9C] '\n',      // KP_Enter
9064   [0xB5] '/',       // KP_Div
9065   [0xC8] KEY_UP,    [0xD0] KEY_DN,
9066   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
9067   [0xCB] KEY_LF,    [0xCD] KEY_RT,
9068   [0x97] KEY_HOME,  [0xCF] KEY_END,
9069   [0xD2] KEY_INS,   [0xD3] KEY_DEL
9070 };
9071 
9072 static uchar shiftmap[256] =
9073 {
9074   NO,   033,  '!',  '@',  '#',  '$',  '%',  '^',  // 0x00
9075   '&',  '*',  '(',  ')',  '_',  '+',  '\b', '\t',
9076   'Q',  'W',  'E',  'R',  'T',  'Y',  'U',  'I',  // 0x10
9077   'O',  'P',  '{',  '}',  '\n', NO,   'A',  'S',
9078   'D',  'F',  'G',  'H',  'J',  'K',  'L',  ':',  // 0x20
9079   '"',  '~',  NO,   '|',  'Z',  'X',  'C',  'V',
9080   'B',  'N',  'M',  '<',  '>',  '?',  NO,   '*',  // 0x30
9081   NO,   ' ',  NO,   NO,   NO,   NO,   NO,   NO,
9082   NO,   NO,   NO,   NO,   NO,   NO,   NO,   '7',  // 0x40
9083   '8',  '9',  '-',  '4',  '5',  '6',  '+',  '1',
9084   '2',  '3',  '0',  '.',  NO,   NO,   NO,   NO,   // 0x50
9085   [0x9C] '\n',      // KP_Enter
9086   [0xB5] '/',       // KP_Div
9087   [0xC8] KEY_UP,    [0xD0] KEY_DN,
9088   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
9089   [0xCB] KEY_LF,    [0xCD] KEY_RT,
9090   [0x97] KEY_HOME,  [0xCF] KEY_END,
9091   [0xD2] KEY_INS,   [0xD3] KEY_DEL
9092 };
9093 
9094 
9095 
9096 
9097 
9098 
9099 
9100 static uchar ctlmap[256] =
9101 {
9102   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
9103   NO,      NO,      NO,      NO,      NO,      NO,      NO,      NO,
9104   C('Q'),  C('W'),  C('E'),  C('R'),  C('T'),  C('Y'),  C('U'),  C('I'),
9105   C('O'),  C('P'),  NO,      NO,      '\r',    NO,      C('A'),  C('S'),
9106   C('D'),  C('F'),  C('G'),  C('H'),  C('J'),  C('K'),  C('L'),  NO,
9107   NO,      NO,      NO,      C('\\'), C('Z'),  C('X'),  C('C'),  C('V'),
9108   C('B'),  C('N'),  C('M'),  NO,      NO,      C('/'),  NO,      NO,
9109   [0x9C] '\r',      // KP_Enter
9110   [0xB5] C('/'),    // KP_Div
9111   [0xC8] KEY_UP,    [0xD0] KEY_DN,
9112   [0xC9] KEY_PGUP,  [0xD1] KEY_PGDN,
9113   [0xCB] KEY_LF,    [0xCD] KEY_RT,
9114   [0x97] KEY_HOME,  [0xCF] KEY_END,
9115   [0xD2] KEY_INS,   [0xD3] KEY_DEL
9116 };
9117 
9118 
9119 
9120 
9121 
9122 
9123 
9124 
9125 
9126 
9127 
9128 
9129 
9130 
9131 
9132 
9133 
9134 
9135 
9136 
9137 
9138 
9139 
9140 
9141 
9142 
9143 
9144 
9145 
9146 
9147 
9148 
9149 
