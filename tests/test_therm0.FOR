c-----------------------------------------------------------------------
c  test_therm0.FOR - Thermodynamic property calculations
c  
c  Tests REFPROP thermodynamic property calculations for:
c    - Pure fluids (CO)
c-----------------------------------------------------------------------
      program test_therm0
      
c..Include constants
      include 'CONSTS.INC'

c..Variables
      character*255 herr
      character*10000 hFld
      character*255 hpath
      double precision T, D, P0, e0, h0, s0, Cv0, Cp00, w0, a0, g0
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
      T = 500.0d0
      D = 3.76d0
          
c..=========================================================
c..Test 1: Pure CO
c..=========================================================
      call TEST_SECTION('Pure CO')
      
      hFld = 'CO'
      call SETFLUIDSdll(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS CO - no error')
      
      if (ierr .eq. 0) then
c..Set composition for pure fluid
        z(1) = 1.0d0
      
c..Calculate thermodynamic properties
        call THERM0dll(T, D, z, P0, e0, h0, s0, Cv0, Cp00, w0, a0, g0)
      
c..Check thermodynamic properties
        call ASSERT_REL_DBL(101325.0d0, P0, 0.001d0,
     &                      'CO P0 matches reference (0.1%)')
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
    