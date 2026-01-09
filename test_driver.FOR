c-----------------------------------------------------------------------
c  Test driver program for REFPROP debugging
c-----------------------------------------------------------------------

      program test_driver
      
c..Include constants
      include 'CONSTS.INC'
      
c..Variables for REFPROP call
      character*10000 hFld
      character*255 hIn, hOut, hUnits, herr
      integer iUnits, iMass, iFlag, iUCode, ierr
      double precision a, b, q
      double precision z(ncmax), Output(iPropMax)
      double precision x(ncmax), y(ncmax), x3(ncmax)
      integer i
      
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
      call SETPATH('E:\Refprop\REFPROP_V10\FLUIDS\')
      
c..Example: Calculate properties of nitrogen at 300 K and 1 atm
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
      write(*,*) '========================================='
      write(*,*) 'REFPROP Test - Nitrogen at 300 K, 1 atm'
      write(*,*) '========================================='
      write(*,*) 'Calling REFPROP...'
      
      call REFPROP(hFld, hIn, hOut, iUnits, iMass, iFlag, a, b, z,
     &             Output, hUnits, iUCode, x, y, x3, q, ierr, herr)
      
c..Check for errors
      if (ierr .ne. 0) then
        write(*,*) 'Error code: ', ierr
        write(*,*) 'Error message: ', herr(1:80)
      else
        write(*,*) 'Calculation successful!'
        write(*,*) ''
        write(*,*) 'Results:'
        write(*,'(A,F12.6,A)') '  Density:         ', Output(1),
     &                         ' kg/m^3'
        write(*,'(A,F12.3,A)') '  Enthalpy:        ', Output(2),
     &                         ' J/mol'
        write(*,'(A,F12.6,A)') '  Entropy:         ', Output(3),
     &                         ' J/(mol-K)'
        write(*,'(A,F12.6,A)') '  Cv:              ', Output(4),
     &                         ' J/(mol-K)'
        write(*,'(A,F12.6,A)') '  Cp:              ', Output(5),
     &                         ' J/(mol-K)'
        write(*,'(A,F12.3,A)') '  Speed of sound:  ', Output(6),
     &                         ' m/s'
      endif
      
      write(*,*) ''
      write(*,*) 'Test complete.'
      
      end program test_driver
