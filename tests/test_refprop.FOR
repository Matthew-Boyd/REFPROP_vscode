c-----------------------------------------------------------------------
c  test_refprop.FOR - REFPROP main subroutine tests
c  
c  Tests the high-level REFPROP subroutine for:
c    - Temperature-Pressure calculations
c    - Property retrieval (D, H, S, CV, CP, W)
c-----------------------------------------------------------------------

      program test_refprop
      
c..Include constants
      include 'CONSTS.INC'
      
c..Variables for REFPROP call
      character*10000 hFld
      character*255 hIn, hOut, hUnits, herr
      integer iUnits, iMass, iFlag, iUCode, ierr
      double precision a, b, q
      double precision z(ncmax), Output(iPropMax)
      double precision x(ncmax), y(ncmax), x3(ncmax)
      integer i, iret
      
c..Initialize arrays
      do i=1,ncmax
        z(i) = 0.0d0
        x(i) = 0.0d0
        y(i) = 0.0d0
        x3(i) = 0.0d0
      enddo
      do i=1,iPropMax
        Output(i) = 0.0d0
      enddo
      
c..Set the path to fluid files (adjust as needed)
      call SETPATH('C:\Program Files (x86)\REFPROP\FLUIDS\')
      
c..Initialize test suite
      call TEST_INIT('REFPROP Subroutine Tests')
      
c..=========================================================
c..Test 1: Nitrogen at 300 K and 1 atm
c..=========================================================
      call TEST_SECTION('Nitrogen at 300 K, 1 atm')
      
      hFld = 'NITROGEN'
      hIn = 'TP'
      hOut = 'D,H,S,CV,CP,W'
      iUnits = 21
      iMass = 0
      iFlag = 0
      
      a = 300.0d0
      b = 101.325d0
      z(1) = 1.0d0
      
c..Call REFPROP
      call REFPROP(hFld, hIn, hOut, iUnits, iMass, iFlag, a, b, z,
     &             Output, hUnits, iUCode, x, y, x3, q, ierr, herr)
      
      call ASSERT_NOERR(ierr, 'REFPROP call - no error')
      
      if (ierr .eq. 0) then
c..Density should be around 40-41 mol/m^3 for N2 at 300K, 1 atm
        call ASSERT_TRUE(Output(1) .gt. 30.0d0,
     &                   'Density > 30 mol/m^3')
        call ASSERT_TRUE(Output(1) .lt. 50.0d0,
     &                   'Density < 50 mol/m^3')
      
c..Enthalpy should be positive
        call ASSERT_TRUE(Output(2) .gt. 0.0d0,
     &                   'Enthalpy > 0 J/mol')
      
c..Entropy should be positive
        call ASSERT_TRUE(Output(3) .gt. 0.0d0,
     &                   'Entropy > 0 J/(mol-K)')
      
c..Heat capacities should be positive
        call ASSERT_TRUE(Output(4) .gt. 0.0d0,
     &                   'Cv > 0 J/(mol-K)')
        call ASSERT_TRUE(Output(5) .gt. 0.0d0,
     &                   'Cp > 0 J/(mol-K)')
      
c..Cp should be greater than Cv
        call ASSERT_TRUE(Output(5) .gt. Output(4),
     &                   'Cp > Cv')
      
c..Speed of sound should be reasonable (300-400 m/s for N2)
        call ASSERT_TRUE(Output(6) .gt. 300.0d0,
     &                   'Speed of sound > 300 m/s')
        call ASSERT_TRUE(Output(6) .lt. 400.0d0,
     &                   'Speed of sound < 400 m/s')
      endif

c..=========================================================
c..Test 2: Water at 373 K (boiling point) and 1 atm
c..=========================================================
      call TEST_SECTION('Water at 373.15 K, 1 atm')
      
c..Reset arrays
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
      do i=1,iPropMax
        Output(i) = 0.0d0
      enddo
      
      hFld = 'WATER'
      hIn = 'TP'
      hOut = 'D,H,S'
      iUnits = 21
      iMass = 0
      iFlag = 0
      
      a = 373.15d0
      b = 101.325d0
      z(1) = 1.0d0
      
      call REFPROP(hFld, hIn, hOut, iUnits, iMass, iFlag, a, b, z,
     &             Output, hUnits, iUCode, x, y, x3, q, ierr, herr)
      
      call ASSERT_NOERR(ierr, 'REFPROP call for water - no error')
      
      if (ierr .eq. 0) then
c..At boiling point, we should get vapor phase
c..Density should be low (vapor)
        call ASSERT_TRUE(Output(1) .gt. 0.0d0,
     &                   'Water density > 0')
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
