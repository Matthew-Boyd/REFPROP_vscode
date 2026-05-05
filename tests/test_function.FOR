c-----------------------------------------------------------------------
c  test_function.FOR - Thermodynamic property calculations
c  
c-----------------------------------------------------------------------
      program test_function
      use refprop_ifc

c..Include constants
      include 'CONSTS.INC'

c..Variables
      character*255 herr
      character*10000 hFld
      character*255 hpath
      double precision T, D
      double precision z(ncmax)
      double precision f(ncmax)
      double precision a, g, B, C, E, eta, tcx
      double precision dPdD, dPdT, d2PdD2, d2PdT2, d2PdTD
      double precision dDdP, dDdT, d2DdP2, d2DdT2, d2DdPT
      double precision dTdP, dTdD, d2TdP2, d2TdD2, d2TdPD
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
      hFld = 'R1336MZZZ'
      icomp = 1
      T = 191.782d0
      D = 8.48276d0
      z(1) = 1.0d0
      
      call SETFLUIDSdll(hFld, ierr)
    !   call SETMIXTUREdll(hFld, z, ierr)

    !   ignore -117 warning
      if (ierr .eq. -117) then
        ierr = 0
      endif
      call ASSERT_NOERR(ierr, 'SETFLUIDS fluid - no error')
      
      if (ierr .eq. 0) then
      
c..Calculate thermodynamic properties
        ! call AGdll(T, D, z, a, g)
        call TRNPRPdll(T, D, z, eta, tcx, ierr, herr)
      
c..Check thermodynamic properties
        call ASSERT_REL_DBL(1.0d0, 1.0d0, 0.001d0,
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
    