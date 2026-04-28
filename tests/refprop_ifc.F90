! refprop_ifc.F90 - Explicit interfaces for REFPROP DLL entry points.
! Required by Intel Fortran (ifx/ifort) when calling STDCALL-attributed
! subroutines declared in PASS_FTN.FOR. gfortran ignores !DEC$ lines.
! Add new subroutines here as needed; use with: use refprop_ifc

module refprop_ifc
  implicit none
  interface

    subroutine SETPATHdll(hpth)
!DEC$ ATTRIBUTES STDCALL,REFERENCE,Alias:"SETPATHdll"::SETPATHdll
      character*255, intent(in) :: hpth
    end subroutine

    subroutine SETFLUIDSdll(hFld, ierr)
!DEC$ ATTRIBUTES STDCALL,REFERENCE,Alias:"SETFLUIDSdll"::SETFLUIDSdll
      character*10000, intent(in) :: hFld
      integer, intent(out) :: ierr
    end subroutine

    subroutine SETMIXTUREdll(hMixNme, z, ierr)
!DEC$ ATTRIBUTES STDCALL,REFERENCE,Alias:"SETMIXTUREdll"::SETMIXTUREdll
      character*10000, intent(in) :: hMixNme
      double precision, intent(out) :: z(*)
      integer, intent(out) :: ierr
    end subroutine

    subroutine TRNPRPdll(T, D, z, eta, tcx, ierr, herr)
!DEC$ ATTRIBUTES STDCALL,REFERENCE,Alias:"TRNPRPdll"::TRNPRPdll
      double precision, intent(in) :: T, D, z(*)
      double precision, intent(out) :: eta, tcx
      integer, intent(out) :: ierr
      character*255, intent(out) :: herr
    end subroutine

  end interface
end module refprop_ifc
