//===- P9InstrResources.td - P9 Instruction Resource Defs  -*- tablegen -*-===//
//
//                     The LLVM Compiler Infrastructure
//
// This file is distributed under the University of Illinois Open Source
// License. See LICENSE.TXT for details.
//
//===----------------------------------------------------------------------===//
//
// This file defines resources required by some of P9 instruction. This is part
// P9 processor model used for instruction scheduling. Not every instruction
// is listed here. Instructions in this file belong to itinerary classes that
// have instructions with different resource requirements.
//
// The makeup of the P9 CPU is modeled as follows:
//   - Each CPU is made up of two superslices.
//   - Each superslice is made up of two slices. Therefore, there are 4 slices
//      for each CPU.
//   - Up to 6 instructions can be dispatched to each CPU. Three per superslice.
//   - Each CPU has:
//     - One CY (Crypto) unit P9_CY_*
//     - One DFU (Decimal Floating Point and Quad Precision) unit P9_DFU_*
//     - Two PM (Permute) units. One on each superslice. P9_PM_*
//     - Two DIV (Fixed Point Divide) units. One on each superslize. P9_DIV_*
//     - Four ALU (Fixed Point Arithmetic) units. One on each slice. P9_ALU_*
//     - Four DP (Floating Point) units. One on each slice. P9_DP_*
//       This also includes fixed point multiply add.
//     - Four AGEN (Address Generation) units. One for each slice. P9_AGEN_*
//     - Four Load/Store Queues. P9_LS_*
//   - Each set of instructions will require a number of these resources.
//===----------------------------------------------------------------------===//

// Two cycle ALU vector operation that uses an entire superslice.
//  Uses both ALU units (the even ALUE and odd ALUO units), two pipelines
//  (EXECE, EXECO) and all three dispatches (DISP) to the given superslice.
def : InstRW<[P9_ALUE_2C, P9_ALUO_2C, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    VADDCUW,
    VADDUBM,
    VADDUDM,
    VADDUHM,
    VADDUWM,
    VAND,
    VANDC,
    VCMPEQUB,
    VCMPEQUD,
    VCMPEQUH,
    VCMPEQUW,
    VCMPNEB,
    VCMPNEH,
    VCMPNEW,
    VCMPNEZB,
    VCMPNEZH,
    VCMPNEZW,
    VEQV,
    VEXTSB2D,
    VEXTSB2W,
    VEXTSH2D,
    VEXTSH2W,
    VEXTSW2D,
    VRLB,
    VRLD,
    VRLDMI,
    VRLDNM,
    VRLH,
    VRLW,
    VRLWMI,
    VRLWNM,
    VSRAB,
    VSRAD,
    VSRAH,
    VSRAW,
    VSRB,
    VSRD,
    VSRH,
    VSRW,
    VSLB,
    VSLD,
    VSLH,
    VSLW,
    VMRGEW,
    VMRGOW,
    VNAND,
    VNEGD,
    VNEGW,
    VNOR,
    VOR,
    VORC,
    VPOPCNTB,
    VPOPCNTH,
    VSEL,
    VSUBUBM,
    VSUBUDM,
    VSUBUHM,
    VSUBUWM,
    VXOR,
    V_SET0B,
    V_SET0H,
    V_SET0,
    XVABSDP,
    XVABSSP,
    XVCPSGNDP,
    XVCPSGNSP,
    XVIEXPDP,
    XVNABSDP,
    XVNABSSP,
    XVNEGDP,
    XVNEGSP,
    XVXEXPDP,
    XVIEXPSP,
    XVXEXPSP,
    XXLAND,
    XXLANDC,
    XXLEQV,
    XXLNAND,
    XXLNOR,
    XXLOR,
    XXLORf,
    XXLORC,
    XXLXOR,
    XXSEL,
    XSABSQP,
    XSCPSGNQP,
    XSIEXPQP,
    XSNABSQP,
    XSNEGQP,
    XSXEXPQP
)>;

// Restricted Dispatch ALU operation for 3 cycles. The operation runs on a
//  slingle slice. However, since it is Restricted it requires all 3 dispatches
//  (DISP) for that superslice.
def : InstRW<[P9_ALU_3C, IP_EXEC_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    FCMPUS,
    FCMPUD,
    XSTSTDCDP,
    XSTSTDCSP
)>;

// Standard Dispatch ALU operation for 3 cycles. Only one slice used.
def : InstRW<[P9_ALU_3C, IP_EXEC_1C, DISP_1C, DISP_1C],
      (instrs
    XSMAXCDP,
    XSMAXDP,
    XSMAXJDP,
    XSMINCDP,
    XSMINDP,
    XSMINJDP,
    XSTDIVDP,
    XSTSQRTDP,
    XSCMPEQDP,
    XSCMPEXPDP,
    XSCMPGEDP,
    XSCMPGTDP,
    XSCMPODP,
    XSCMPUDP,
    XSXSIGDP,
    XSCVSPDPN
)>;

// Standard Dispatch ALU operation for 2 cycles. Only one slice used.
def : InstRW<[P9_ALU_2C, IP_EXEC_1C, DISP_1C, DISP_1C],
      (instrs
    ADDIStocHA,
    ADDItocL,
    MCRF,
    MCRXRX,
    SLD,
    SRD,
    SRAD,
    SRADI,
    RLDIC,
    XSNABSDP,
    XSXEXPDP,
    XSABSDP,
    XSNEGDP,
    XSCPSGNDP
)>;

// Restricted Dispatch ALU operation for 2 cycles. The operation runs on a
//  slingle slice. However, since it is Restricted it requires all 3 dispatches
//  (DISP) for that superslice.
def : InstRW<[P9_ALU_2C, IP_EXEC_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    RLDCL,
    RLDCR,
    RLDIMI,
    RLDICL,
    RLDICR,
    RLDICL_32_64,
    XSIEXPDP,
    FMR,
    FABSD,
    FABSS,
    FNABSD,
    FNABSS,
    FNEGD,
    FNEGS,
    FCPSGND,
    FCPSGNS
)>;

// Three cycle ALU vector operation that uses an entire superslice.
//  Uses both ALU units (the even ALUE and odd ALUO units), two pipelines
//  (EXECE, EXECO) and all three dispatches (DISP) to the given superslice.
def : InstRW<[P9_ALUE_3C, P9_ALUO_3C, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    VBPERMD,
    VABSDUB,
    VABSDUH,
    VABSDUW,
    VADDUBS,
    VADDUHS,
    VADDUWS,
    VAVGSB,
    VAVGSH,
    VAVGSW,
    VAVGUB,
    VAVGUH,
    VAVGUW,
    VCMPEQFP,
    VCMPEQFPo,
    VCMPGEFP,
    VCMPGEFPo,
    VCMPBFP,
    VCMPBFPo,
    VCMPGTFP,
    VCMPGTFPo,
    VCLZB,
    VCLZD,
    VCLZH,
    VCLZW,
    VCTZB,
    VCTZD,
    VCTZH,
    VCTZW,
    VADDSBS,
    VADDSHS,
    VADDSWS,
    VMINFP,
    VMINSB,
    VMINSD,
    VMINSH,
    VMINSW,
    VMINUB,
    VMINUD,
    VMINUH,
    VMINUW,
    VMAXFP,
    VMAXSB,
    VMAXSD,
    VMAXSH,
    VMAXSW,
    VMAXUB,
    VMAXUD,
    VMAXUH,
    VMAXUW,
    VPOPCNTW,
    VPOPCNTD,
    VPRTYBD,
    VPRTYBW,
    VSHASIGMAD,
    VSHASIGMAW,
    VSUBSBS,
    VSUBSHS,
    VSUBSWS,
    VSUBUBS,
    VSUBUHS,
    VSUBUWS,
    VSUBCUW,
    VCMPGTSB,
    VCMPGTSBo,
    VCMPGTSD,
    VCMPGTSDo,
    VCMPGTSH,
    VCMPGTSHo,
    VCMPGTSW,
    VCMPGTSWo,
    VCMPGTUB,
    VCMPGTUBo,
    VCMPGTUD,
    VCMPGTUDo,
    VCMPGTUH,
    VCMPGTUHo,
    VCMPGTUW,
    VCMPGTUWo,
    VCMPNEBo,
    VCMPNEHo,
    VCMPNEWo,
    VCMPNEZBo,
    VCMPNEZHo,
    VCMPNEZWo,
    VCMPEQUBo,
    VCMPEQUDo,
    VCMPEQUHo,
    VCMPEQUWo,
    XVCMPEQDP,
    XVCMPEQDPo,
    XVCMPEQSP,
    XVCMPEQSPo,
    XVCMPGEDP,
    XVCMPGEDPo,
    XVCMPGESP,
    XVCMPGESPo,
    XVCMPGTDP,
    XVCMPGTDPo,
    XVCMPGTSP,
    XVCMPGTSPo,
    XVMAXDP,
    XVMAXSP,
    XVMINDP,
    XVMINSP,
    XVTDIVDP,
    XVTDIVSP,
    XVTSQRTDP,
    XVTSQRTSP,
    XVTSTDCDP,
    XVTSTDCSP,
    XVXSIGDP,
    XVXSIGSP
)>;

// 7 cycle DP vector operation that uses an entire superslice.
//  Uses both DP units (the even DPE and odd DPO units), two pipelines
//  (EXECE, EXECO) and all three dispatches (DISP) to the given superslice.
def : InstRW<[P9_DPE_7C, P9_DPO_7C, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    VADDFP,
    VCTSXS,
    VCTSXS_0,
    VCTUXS,
    VCTUXS_0,
    VEXPTEFP,
    VLOGEFP,
    VMADDFP,
    VMHADDSHS,
    VNMSUBFP,
    VREFP,
    VRFIM,
    VRFIN,
    VRFIP,
    VRFIZ,
    VRSQRTEFP,
    VSUBFP,
    XVADDDP,
    XVADDSP,
    XVCVDPSP,
    XVCVDPSXDS,
    XVCVDPSXWS,
    XVCVDPUXDS,
    XVCVDPUXWS,
    XVCVHPSP,
    XVCVSPDP,
    XVCVSPHP,
    XVCVSPSXDS,
    XVCVSPSXWS,
    XVCVSPUXDS,
    XVCVSPUXWS,
    XVCVSXDDP,
    XVCVSXDSP,
    XVCVSXWDP,
    XVCVSXWSP,
    XVCVUXDDP,
    XVCVUXDSP,
    XVCVUXWDP,
    XVCVUXWSP,
    XVMADDADP,
    XVMADDASP,
    XVMADDMDP,
    XVMADDMSP,
    XVMSUBADP,
    XVMSUBASP,
    XVMSUBMDP,
    XVMSUBMSP,
    XVMULDP,
    XVMULSP,
    XVNMADDADP,
    XVNMADDASP,
    XVNMADDMDP,
    XVNMADDMSP,
    XVNMSUBADP,
    XVNMSUBASP,
    XVNMSUBMDP,
    XVNMSUBMSP,
    XVRDPI,
    XVRDPIC,
    XVRDPIM,
    XVRDPIP,
    XVRDPIZ,
    XVREDP,
    XVRESP,
    XVRSPI,
    XVRSPIC,
    XVRSPIM,
    XVRSPIP,
    XVRSPIZ,
    XVRSQRTEDP,
    XVRSQRTESP,
    XVSUBDP,
    XVSUBSP,
    VCFSX,
    VCFSX_0,
    VCFUX,
    VCFUX_0,
    VMHRADDSHS,
    VMLADDUHM,
    VMSUMMBM,
    VMSUMSHM,
    VMSUMSHS,
    VMSUMUBM,
    VMSUMUHM,
    VMSUMUHS,
    VMULESB,
    VMULESH,
    VMULESW,
    VMULEUB,
    VMULEUH,
    VMULEUW,
    VMULOSB,
    VMULOSH,
    VMULOSW,
    VMULOUB,
    VMULOUH,
    VMULOUW,
    VMULUWM,
    VSUM2SWS,
    VSUM4SBS,
    VSUM4SHS,
    VSUM4UBS,
    VSUMSWS
)>;

// 7 cycle Restricted DP operation. One DP unit, one EXEC pipeline and all three
//  dispatch units for the superslice.
def : InstRW<[P9_DP_7C, IP_EXEC_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    FRSP,
    FRIND,
    FRINS,
    FRIPD,
    FRIPS,
    FRIZD,
    FRIZS,
    FRIMD,
    FRIMS,
    FRE,
    FRES,
    FRSQRTE,
    FRSQRTES,
    FMADDS,
    FMADD,
    FMSUBS,
    FMSUB,
    FNMADDS,
    FNMADD,
    FNMSUBS,
    FNMSUB,
    FSELD,
    FSELS,
    FADDS,
    FMULS,
    FMUL,
    FSUBS,
    FCFID,
    FCTID,
    FCTIDZ,
    FCFIDU,
    FCFIDS,
    FCFIDUS,
    FCTIDUZ,
    FCTIWUZ,
    FCTIW,
    FCTIWZ,
    XSMADDADP,
    XSMADDASP,
    XSMADDMDP,
    XSMADDMSP,
    XSMSUBADP,
    XSMSUBASP,
    XSMSUBMDP,
    XSMSUBMSP,
    XSMULDP,
    XSMULSP,
    XSNMADDADP,
    XSNMADDASP,
    XSNMADDMDP,
    XSNMADDMSP,
    XSNMSUBADP,
    XSNMSUBASP,
    XSNMSUBMDP,
    XSNMSUBMSP
)>;

// 7 cycle DP operation. One DP unit, one EXEC pipeline and two dispatch units.
def : InstRW<[P9_DP_7C, IP_EXEC_1C, DISP_1C, DISP_1C],
      (instrs
    XSADDDP,
    XSADDSP,
    XSCVDPHP,
    XSCVDPSP,
    XSCVDPSXDS,
    XSCVDPSXDSs,
    XSCVDPSXWS,
    XSCVDPUXDS,
    XSCVDPUXDSs,
    XSCVDPUXWS,
    XSCVHPDP,
    XSCVSPDP,
    XSCVSXDDP,
    XSCVSXDSP,
    XSCVUXDDP,
    XSCVUXDSP,
    XSRDPI,
    XSRDPIC,
    XSRDPIM,
    XSRDPIP,
    XSRDPIZ,
    XSREDP,
    XSRESP,
    //XSRSP,
    XSRSQRTEDP,
    XSRSQRTESP,
    XSSUBDP,
    XSSUBSP,
    XSCVDPSPN
)>;

// Three Cycle PM operation. Only one PM unit per superslice so we use the whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_PM_3C, IP_EXECO_1C, IP_EXECE_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    VBPERMQ,
    VCLZLSBB,
    VCTZLSBB,
    VEXTRACTD,
    VEXTRACTUB,
    VEXTRACTUH,
    VEXTRACTUW,
    VEXTUBLX,
    VEXTUBRX,
    VEXTUHLX,
    VEXTUHRX,
    VEXTUWLX,
    VEXTUWRX,
    VGBBD,
    VINSERTB,
    VINSERTD,
    VINSERTH,
    VINSERTW,
    VMRGHB,
    VMRGHH,
    VMRGHW,
    VMRGLB,
    VMRGLH,
    VMRGLW,
    VPERM,
    VPERMR,
    VPERMXOR,
    VPKPX,
    VPKSDSS,
    VPKSDUS,
    VPKSHSS,
    VPKSHUS,
    VPKSWSS,
    VPKSWUS,
    VPKUDUM,
    VPKUDUS,
    VPKUHUM,
    VPKUHUS,
    VPKUWUM,
    VPKUWUS,
    VPRTYBQ,
    VSL,
    VSLDOI,
    VSLO,
    VSLV,
    VSPLTB,
    VSPLTBs,
    VSPLTH,
    VSPLTHs,
    VSPLTISB,
    VSPLTISH,
    VSPLTISW,
    VSPLTW,
    VSR,
    VSRO,
    VSRV,
    VUPKHPX,
    VUPKHSB,
    VUPKHSH,
    VUPKHSW,
    VUPKLPX,
    VUPKLSB,
    VUPKLSH,
    VUPKLSW,
    XXBRD,
    XXBRH,
    XXBRQ,
    XXBRW,
    XXEXTRACTUW,
    XXINSERTW,
    XXMRGHW,
    XXMRGLW,
    XXPERM,
    XXPERMR,
    XXSLDWI,
    XXSPLTIB,
    XXSPLTW,
    XXSPLTWs,
    XXPERMDI,
    XXPERMDIs,
    VADDCUQ,
    VADDECUQ,
    VADDEUQM,
    VADDUQM,
    VMUL10CUQ,
    VMUL10ECUQ,
    VMUL10EUQ,
    VMUL10UQ,
    VSUBCUQ,
    VSUBECUQ,
    VSUBEUQM,
    VSUBUQM,
    XSCMPEXPQP,
    XSCMPOQP,
    XSCMPUQP,
    XSTSTDCQP,
    XSXSIGQP
)>;

// 12 Cycle DFU operation. Only one DFU unit per CPU so we use a whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DFU_12C, IP_EXECE_1C, IP_EXECO_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XSADDQP,
    XSADDQPO,
    XSCVDPQP,
    XSCVQPDP,
    XSCVQPDPO,
    XSCVQPSDZ,
    XSCVQPSWZ,
    XSCVQPUDZ,
    XSCVQPUWZ,
    XSCVSDQP,
    XSCVUDQP,
    XSRQPI,
    XSRQPXP,
    XSSUBQP,
    XSSUBQPO
)>;

// 24 Cycle DFU operation. Only one DFU unit per CPU so we use a whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DFU_24C, IP_EXECE_1C, IP_EXECO_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XSMADDQP,
    XSMADDQPO,
    XSMSUBQP,
    XSMSUBQPO,
    XSMULQP,
    XSMULQPO,
    XSNMADDQP,
    XSNMADDQPO,
    XSNMSUBQP,
    XSNMSUBQPO
)>;

// 58 Cycle DFU operation. Only one DFU unit per CPU so we use a whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DFU_58C, IP_EXECE_1C, IP_EXECO_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XSDIVQP,
    XSDIVQPO
)>;

// 76 Cycle DFU operation. Only one DFU unit per CPU so we use a whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DFU_76C, IP_EXECE_1C, IP_EXECO_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XSSQRTQP,
    XSSQRTQPO
)>;

// 5 Cycle load uses a single slice.
def : InstRW<[P9_LS_5C, IP_AGEN_1C, DISP_1C, DISP_1C],
      (instrs
    LXSDX,
    LXVD2X,
    LXSIWZX,
    LXV,
    LXVX,
    LXSD,
    DFLOADf64
)>;

// 4 Cycle load uses a single slice.
def : InstRW<[P9_LS_4C, IP_AGEN_1C, DISP_1C, DISP_1C],
      (instrs
    COPY
)>;

// 4 Cycle Restricted load uses a single slice but the dispatch for the whole
//  superslice.
def : InstRW<[P9_LS_4C, IP_AGEN_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LFIWZX,
    LFDX,
    LFD
)>;

// Cracked Restricted Load instruction.
// Requires consecutive Load and ALU pieces totaling 6 cycles. The Load and ALU
//  operations cannot be done at the same time and so their latencies are added.
// Full 6 dispatches are required as this is both cracked and restricted.
def : InstRW<[P9_LoadAndALUOp_6C, IP_EXEC_1C, IP_AGEN_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LFIWAX,
    LFSX,
    LFS
)>;

// Cracked Load instruction.
// Requires consecutive Load and ALU pieces totaling 7 cycles. The Load and ALU
//  operations cannot be done at the same time and so their latencies are added.
// Full 4 dispatches are required as this is a cracked instruction.
def : InstRW<[P9_LoadAndALUOp_7C, IP_AGEN_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LXSSPX,
    LXSIWAX,
    LXSSP,
    DFLOADf32
)>;

// Cracked Load that requires the PM resource.
// Since the Load and the PM cannot be done at the same time the latencies are
//  added. Requires 8 cycles.
// Since the PM requires the full superslice we need both EXECE, EXECO pipelines
//  as well as 3 dispatches for the PM. The Load requires the remaining 2
//  dispatches.
def : InstRW<[P9_LoadAndPMOp_8C, IP_AGEN_1C, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LXVDSX,
    LXVWSX,
    LXVW4X
)>;

// Single slice Restricted store operation. The restricted operation requires
//  all three dispatches for the superslice.
def : InstRW<[P9_LS_1C, IP_EXEC_1C, IP_AGEN_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    STFS,
    STFD,
    STFIWX,
    STFSX,
    STFDX,
    STXSDX,
    STXSSPX,
    STXSIWX,
    DFSTOREf32,
    DFSTOREf64
)>;

// Store operation that requires the whole superslice.
def : InstRW<[P9_LS_1C, IP_EXECE_1C, IP_EXECO_1C, IP_AGEN_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    STXVD2X,
    STXVW4X
)>;


// 16 Cycle DIV operation. Only one DIV unit per superslice so we use the whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DIV_16C_8, IP_EXECO_1C, IP_EXECE_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    DIVW,
    DIVWU,
    MODSW
)>;

// 24 Cycle DIV operation. Only one DIV unit per superslice so we use the whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DIV_24C_8, IP_EXECO_1C, IP_EXECE_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    DIVWE,
    DIVD,
    DIVWEU,
    DIVDU,
    MODSD,
    MODUD,
    MODUW
)>;

// 40 Cycle DIV operation. Only one DIV unit per superslice so we use the whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_DIV_40C_8, IP_EXECO_1C, IP_EXECE_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    DIVDE,
    DIVDEU
)>;

// Cracked DIV and ALU operation. Requires one full slice for the ALU operation
//  and one full superslice for the DIV operation since there is only one DIV
//  per superslice. Latency of DIV plus ALU is 26.
def : InstRW<[P9_IntDivAndALUOp_26C_8, IP_EXECE_1C, IP_EXECO_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    DIVWEo,
    DIVWEUo
)>;

// Cracked DIV and ALU operation. Requires one full slice for the ALU operation
//  and one full superslice for the DIV operation since there is only one DIV
//  per superslice. Latency of DIV plus ALU is 42.
def : InstRW<[P9_IntDivAndALUOp_42C_8, IP_EXECE_1C, IP_EXECO_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    DIVDEo,
    DIVDEUo
)>;

// CR access instructions in _BrMCR, IIC_BrMCRX.

// Cracked, restricted, ALU operations.
// Here the two ALU ops can actually be done in parallel and therefore the
//  latencies are not added together. Otherwise this is like having two
//  instructions running together on two pipelines and 6 dispatches.
// ALU ops are 2 cycles each.
def : InstRW<[P9_ALU_2C, P9_ALU_2C, IP_EXEC_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    MTOCRF,
    MTOCRF8,
    MTCRF,
    MTCRF8
)>;

// Cracked, restricted, ALU operations.
// Here the two ALU ops can actually be done in parallel and therefore the
//  latencies are not added together. Otherwise this is like having two
//  instructions running together on two pipelines and 6 dispatches.
// ALU ops are 3 cycles each.
def : InstRW<[P9_ALU_3C, P9_ALU_3C, IP_EXEC_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    MCRFS
)>;

// FP Div instructions in IIC_FPDivD and IIC_FPDivS.

// 33 Cycle DP Instruction Restricted. Takes one slice and 3 dispatches.
def : InstRW<[P9_DP_33C_8, IP_EXEC_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    FDIV
)>;

// 33 Cycle DP Instruction. Takes one slice and 2 dispatches.
def : InstRW<[P9_DP_33C_8, IP_EXEC_1C, DISP_1C, DISP_1C],
      (instrs
    XSDIVDP
)>;

// 22 Cycle DP Instruction Restricted. Takes one slice and 3 dispatches.
def : InstRW<[P9_DP_22C_5, IP_EXEC_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    FDIVS
)>;

// 22 Cycle DP Instruction. Takes one slice and 2 dispatches.
def : InstRW<[P9_DP_22C_5, IP_EXEC_1C, DISP_1C, DISP_1C],
      (instrs
    XSDIVSP
)>;

// 24 Cycle DP Vector Instruction. Takes one full superslice.
// Includes both EXECE, EXECO pipelines and all 3 dispatches for the given
//  superslice.
def : InstRW<[P9_DPE_24C_8, P9_DPO_24C_8, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XVDIVSP
)>;

// 33 Cycle DP Vector Instruction. Takes one full superslice.
// Includes both EXECE, EXECO pipelines and all 3 dispatches for the given
//  superslice.
def : InstRW<[P9_DPE_33C_8, P9_DPO_33C_8, IP_EXECE_1C, IP_EXECO_1C,
              DISP_1C, DISP_1C, DISP_1C],
      (instrs
    XVDIVDP
)>;

// Load instructions in IIC_LdStLFDU and IIC_LdStLFDUX.

// Instruction cracked into three pieces. One Load and two ALU operations.
// The Load and one of the ALU ops cannot be run at the same time and so the
//  latencies are added together for 6 cycles. The remainaing ALU is 2 cycles.
// Both the load and the ALU that depends on it are restricted and so they take
//  a total of 6 dispatches. The final 2 dispatches come from the second ALU op.
// The two EXEC pipelines are for the 2 ALUs while the AGEN is for the load.
def : InstRW<[P9_LoadAndALUOp_6C, P9_ALU_2C,
              IP_AGEN_1C, IP_EXEC_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LFSU,
    LFSUX
)>;

// Cracked instruction made up of a Load and an ALU. The ALU does not depend on
//  the load and so it can be run at the same time as the load. The load is also
//  restricted. 3 dispatches are from the restricted load while the other two
//  are from the ALU. The AGEN pipeline is from the load and the EXEC pipeline
//  is required for the ALU.
def : InstRW<[P9_LS_4C, P9_ALU_2C, IP_AGEN_1C, IP_EXEC_1C,
              DISP_1C, DISP_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
    LFDU,
    LFDUX
)>;

// Crypto Instructions

// 6 Cycle CY operation. Only one CY unit per CPU so we use a whole
//  superslice. That includes both exec pipelines (EXECO, EXECE) and all three
//  dispatches.
def : InstRW<[P9_CY_6C, IP_EXECO_1C, IP_EXECE_1C, DISP_1C, DISP_1C, DISP_1C],
      (instrs
  VPMSUMB,
  VPMSUMD,
  VPMSUMH,
  VPMSUMW,
  VCIPHER,
  VCIPHERLAST,
  VNCIPHER,
  VNCIPHERLAST,
  VSBOX
)>;
