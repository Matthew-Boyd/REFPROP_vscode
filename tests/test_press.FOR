c-----------------------------------------------------------------------
c  test_press.FOR - Thermodynamic property calculations
c  
c  Tests REFPROP thermodynamic property calculations for:
c    - Pure fluids (Ar)
c-----------------------------------------------------------------------
      program test_press
      
c..Include constants
      include 'CONSTS.INC'

c..Variables
      character*255 herr
      character*10000 hFld
      character*255 hpath
      double precision T, D, P
      double precision z(ncmax)
      integer ierr, i, iret
          
c..Initialize composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
          
c..Set the path to fluid files
      hpath = 'C:/Program Files (x86)/REFPROP'
      call SETPATHdll(hpath)
      
c..Initialize test suite
      call TEST_INIT('Thermodynamic Property Calculations')
      
c..Set test conditions
      T = 300.0d0
      D = 10d0
          
c..=========================================================
c..Test 1: Pure Ar
c..=========================================================
      call TEST_SECTION('Mixture')
      
      hFld = 'METHANE;ARGON'
      call SETFLUIDSdll(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS mixture - no error')
      
      if (ierr .eq. 0) then
c..Set composition for pure fluid
        z(1) = 1.0d0
      
c..Calculate thermodynamic properties
        call PRESSdll(T, D, z, P)
      
c..Check thermodynamic properties
        call ASSERT_REL_DBL(24101.753362816933d0, P, 0.001d0,
     &                      'Ar P matches reference (0.1%)')
      endif
                
c..=========================================================
c..Summary and exit
c..=========================================================
      call TEST_SUMMARY(iret)
      
c..Return non-zero exit code if any tests failed
      if (iret .ne. 0) then
        stop 1
      endif
      
      end
    