8050 // See MultiProcessor Specification Version 1.[14]
8051 
8052 struct mp {             // floating pointer
8053   uchar signature[4];           // "_MP_"
8054   void *physaddr;               // phys addr of MP config table
8055   uchar length;                 // 1
8056   uchar specrev;                // [14]
8057   uchar checksum;               // all bytes must add up to 0
8058   uchar type;                   // MP system config type
8059   uchar imcrp;
8060   uchar reserved[3];
8061 };
8062 
8063 struct mpconf {         // configuration table header
8064   uchar signature[4];           // "PCMP"
8065   ushort length;                // total table length
8066   uchar version;                // [14]
8067   uchar checksum;               // all bytes must add up to 0
8068   uchar product[20];            // product id
8069   uint *oemtable;               // OEM table pointer
8070   ushort oemlength;             // OEM table length
8071   ushort entry;                 // entry count
8072   uint *lapicaddr;              // address of local APIC
8073   ushort xlength;               // extended table length
8074   uchar xchecksum;              // extended table checksum
8075   uchar reserved;
8076 };
8077 
8078 struct mpproc {         // processor table entry
8079   uchar type;                   // entry type (0)
8080   uchar apicid;                 // local APIC id
8081   uchar version;                // local APIC verison
8082   uchar flags;                  // CPU flags
8083     #define MPBOOT 0x02           // This proc is the bootstrap processor.
8084   uchar signature[4];           // CPU signature
8085   uint feature;                 // feature flags from CPUID instruction
8086   uchar reserved[8];
8087 };
8088 
8089 struct mpioapic {       // I/O APIC table entry
8090   uchar type;                   // entry type (2)
8091   uchar apicno;                 // I/O APIC id
8092   uchar version;                // I/O APIC version
8093   uchar flags;                  // I/O APIC flags
8094   uint *addr;                  // I/O APIC address
8095 };
8096 
8097 
8098 
8099 
8100 // Table entry types
8101 #define MPPROC    0x00  // One per processor
8102 #define MPBUS     0x01  // One per bus
8103 #define MPIOAPIC  0x02  // One per I/O APIC
8104 #define MPIOINTR  0x03  // One per bus interrupt source
8105 #define MPLINTR   0x04  // One per system interrupt source
8106 
8107 
8108 
8109 
8110 
8111 
8112 
8113 
8114 
8115 
8116 
8117 
8118 
8119 
8120 
8121 
8122 
8123 
8124 
8125 
8126 
8127 
8128 
8129 
8130 
8131 
8132 
8133 
8134 
8135 
8136 
8137 
8138 
8139 
8140 
8141 
8142 
8143 
8144 
8145 
8146 
8147 
8148 
8149 
8150 // Blank page.
8151 
8152 
8153 
8154 
8155 
8156 
8157 
8158 
8159 
8160 
8161 
8162 
8163 
8164 
8165 
8166 
8167 
8168 
8169 
8170 
8171 
8172 
8173 
8174 
8175 
8176 
8177 
8178 
8179 
8180 
8181 
8182 
8183 
8184 
8185 
8186 
8187 
8188 
8189 
8190 
8191 
8192 
8193 
8194 
8195 
8196 
8197 
8198 
8199 
