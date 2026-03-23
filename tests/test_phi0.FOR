c-----------------------------------------------------------------------
c  test_phi0.FOR - Phi0 calculation tests
c  
c  Tests REFPROP Phi0 calculations for:
c    - Pure fluids (ARGON)
c-----------------------------------------------------------------------

      program test_phi0
      
c..Include constants
      include 'CONSTS.INC'
          
c..Variables
      character*255 herr
      character*10000 hFld
      character*255 hpath
      double precision T, D, phi00
      double precision z(ncmax)
      integer itau, idel,ierr, i, iret
          
c..Initialize composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
          
c..Set the path to fluid files
      hpath = 'C:/Program Files (x86)/REFPROP'
      call SETPATHdll(hpath)
      
c..Initialize test suite
      call TEST_INIT('Enthalpy Calculations')
      
c..Set test conditions
      itau = 0
      idel = 0
      T = 300.0d0
      D = 10.0d0
          
c..=========================================================
c..Test 1: Pure ARGON
c..=========================================================
      call TEST_SECTION('Pure Argon')
      
      hFld = 'ARGON'
      call SETFLUIDSdll(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS ARGON - no error')
      
      if (ierr .eq. 0) then
c..Set composition for pure fluid
        z(1) = 1.0d0
      
c..Calculate Phi0
        call PHI0dll(itau, idel, T, D, z, phi00)
      
c..Check Phi0
        call ASSERT_REL_DBL(-11.620d0, phi00, 0.001d0,
     &                      'ARGON phi00 matches reference (0.1%)')
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
    