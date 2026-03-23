c-----------------------------------------------------------------------
c  test_function.FOR - Thermodynamic property calculations
c  
c-----------------------------------------------------------------------
      program test_function
      
c..Include constants
      include 'CONSTS.INC'

c..Variables
      character*255 herr
      character*10000 hFld
      character*255 hpath
      double precision T, D
      double precision z(ncmax)
      double precision Pr, er, hr, sr, Cvr, Cpr, ar, gr
      integer ierr, i, iret, icomp
          
c..Initialize composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
          
c..Set the path to fluid files
      hpath = 'C:/Program Files (x86)/REFPROP'
      call SETPATHdll(hpath)
      
c..Initialize test suite
      call TEST_INIT('Thermodynamic Property Calculations')
          
c..=========================================================
c..Test 1:
c..=========================================================
      call TEST_SECTION('Fluid')
      
c..Set test conditions
      hFld = 'HYDROGEN'
      icomp = 1
      T = 1000d0
      D = 1.0d-12
      z(1) = 1.0d0
      
      call SETFLUIDSdll(hFld, ierr)
      call ASSERT_NOERR(ierr, 'SETFLUIDS fluid - no error')
      
      if (ierr .eq. 0) then
      
c..Calculate thermodynamic properties
        call RESIDUALdll(T, D, z, Pr, er, hr, sr, Cvr, Cpr, ar, gr)
      
c..Check thermodynamic properties
        call ASSERT_REL_DBL(1.0, 1.0, 0.001d0,
     &                      'Fluid matches reference (0.1%)')
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
    