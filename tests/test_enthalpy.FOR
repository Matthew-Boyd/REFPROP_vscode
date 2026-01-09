c-----------------------------------------------------------------------
c  test_enthalpy.FOR - Enthalpy calculation tests
c  
c  Tests REFPROP enthalpy calculations for:
c    - Pure fluids (ARGON)
c    - Binary mixtures (METHANE;ARGON)
c-----------------------------------------------------------------------

      program test_enthalpy
      
c..Include constants
      include 'CONSTS.INC'
      
c..Variables
      character*255 herr
      character*255 hFld
      double precision T, D, h
      double precision z(ncmax)
      integer ierr, i, iret
      
c..Initialize composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
      
c..Set the path to fluid files
      call SETPATH('C:\Program Files (x86)\REFPROP\FLUIDS\')
      
c..Initialize test suite
      call TEST_INIT('Enthalpy Calculations')
      
c..Set test conditions
      T = 300.0d0
      D = 10.0d0
      
c..=========================================================
c..Test 1: Pure ARGON
c..=========================================================
      call TEST_SECTION('Pure Argon')
      
      hFld = 'ARGON'
      call SETFLUIDS(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS ARGON - no error')
      
      if (ierr .eq. 0) then
c..Set composition for pure fluid
        z(1) = 1.0d0
      
c..Calculate enthalpy
        call ENTHAL(T, D, z, h)
      
c..Check enthalpy is in reasonable range for Ar at 300K, 10 mol/L
c..Expected approximately 6000-7000 J/mol
        call ASSERT_TRUE(h .gt. 5000.0d0, 
     &                   'ARGON h > 5000 J/mol')
        call ASSERT_TRUE(h .lt. 8000.0d0, 
     &                   'ARGON h < 8000 J/mol')
      
c..If you have a reference value, use ASSERT_REL_DBL:
c       call ASSERT_REL_DBL(6267.123d0, h, 0.001d0, 
c    &                      'ARGON h matches reference (0.1%)')
      endif
      
c..=========================================================
c..Test 2: METHANE;ARGON mixture (50/50)
c..=========================================================
      call TEST_SECTION('Methane-Argon Mixture (50/50)')
      
c..Reset composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
      
      hFld = 'METHANE;ARGON'
      call SETFLUIDS(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS mixture - no error')
      
      if (ierr .eq. 0) then
c..Set composition for 50/50 mixture
        z(1) = 0.5d0
        z(2) = 0.5d0
      
c..Calculate enthalpy
        call ENTHAL(T, D, z, h)
      
c..Check enthalpy is in reasonable range
        call ASSERT_TRUE(h .gt. 0.0d0, 
     &                   'Mixture h > 0 J/mol')
        call ASSERT_TRUE(h .lt. 20000.0d0, 
     &                   'Mixture h < 20000 J/mol')
      
c..If you have a reference value, use ASSERT_REL_DBL:
c       call ASSERT_REL_DBL(12345.678d0, h, 0.001d0, 
c    &                      'Mixture h matches reference (0.1%)')
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
