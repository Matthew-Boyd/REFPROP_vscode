c-----------------------------------------------------------------------
c  Test program for REFPROP enthalpy calculations
c  Mimics the Python test:
c    fluids = ["ARGON", "METHANE;ARGON"]
c    T = 300 K, D = 10 mol/L
c    zs = [[1.0], [0.5, 0.5]]
c-----------------------------------------------------------------------

      program test_enthalpy
      
c..Include constants
      include 'CONSTS.INC'
      
c..Variables
      character*255 hVersion, herr
      character*255 hFld
      double precision T, D, h
      double precision z(ncmax)
      integer ierr, i
      
c..Initialize composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
      
c..Set the path to fluid files
      call SETPATH('C:\Program Files (x86)\REFPROP\FLUIDS\')
      
c..Get REFPROP version
      call RPVersion(hVersion)
      write(*,*) 'REFPROP version: ', TRIM(hVersion)
      write(*,*) ''
      
c..Set test conditions
      T = 300.0d0      ! Temperature [K]
      D = 10.0d0       ! Density [mol/L]
      
c..=========================================================
c..Test 1: Pure ARGON
c..=========================================================
      hFld = 'ARGON'
      call SETFLUIDS(hFld, ierr)
      if (ierr .ne. 0) then
        call ERRMSG(ierr, herr)
        write(*,*) 'Error setting fluids: ', TRIM(herr)
        stop
      endif
      
c..Set composition for pure fluid
      z(1) = 1.0d0
      
c..Calculate enthalpy - SET BREAKPOINT HERE
      call ENTHAL(T, D, z, h)
      
      write(*,'(A,A,F12.3,A)') 'ARGON           ', 'h = ', h, ' J/mol'
      
c..=========================================================
c..Test 2: METHANE;ARGON mixture (50/50)
c..=========================================================
c..Reset composition array
      do i=1,ncmax
        z(i) = 0.0d0
      enddo
      
      hFld = 'METHANE;ARGON'
      call SETFLUIDS(hFld, ierr)
      if (ierr .ne. 0) then
        call ERRMSG(ierr, herr)
        write(*,*) 'Error setting fluids: ', TRIM(herr)
        stop
      endif
      
c..Set composition for 50/50 mixture
      z(1) = 0.5d0     ! Methane mole fraction
      z(2) = 0.5d0     ! Argon mole fraction
      
c..Calculate enthalpy - SET BREAKPOINT HERE
      call ENTHAL(T, D, z, h)
      
      write(*,'(A,A,F12.3,A)') 'METHANE;ARGON   ', 'h = ', h, ' J/mol'
      
      write(*,*) ''
      write(*,*) 'Test complete.'
      
      end program test_enthalpy
