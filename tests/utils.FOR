c-----------------------------------------------------------------------
c  utils.FOR - Simple Fortran Test Harness
c  
c  Provides basic assertion routines for unit testing.
c  Compatible with F77/F90 hybrid code style.
c-----------------------------------------------------------------------

c-----------------------------------------------------------------------
c  TEST_INIT - Initialize a test suite
c-----------------------------------------------------------------------
      subroutine TEST_INIT(testname)
      character*(*) testname
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      npass = 0
      nfail = 0
      ntotal = 0
      write(*,*)
      write(*,*) '========================================='
      write(*,*) 'Test Suite: ', testname
      write(*,*) '========================================='
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_EQ_DBL - Assert two double precision values are equal
c                  within a tolerance
c-----------------------------------------------------------------------
      subroutine ASSERT_EQ_DBL(expected, actual, tol, msg)
      double precision expected, actual, tol
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
      if (abs(expected - actual) .le. tol) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
        write(*,'(A,E15.8)') '    Expected: ', expected
        write(*,'(A,E15.8)') '    Actual:   ', actual
        write(*,'(A,E15.8)') '    Diff:     ', abs(expected-actual)
        write(*,'(A,E15.8)') '    Tol:      ', tol
      endif
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_REL_DBL - Assert two double precision values are equal
c                   within a relative tolerance (percentage)
c-----------------------------------------------------------------------
      subroutine ASSERT_REL_DBL(expected, actual, reltol, msg)
      double precision expected, actual, reltol, diff, abstol
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
c..Calculate absolute tolerance from relative tolerance
      if (abs(expected) .gt. 1.0d-30) then
        abstol = abs(expected) * reltol
      else
        abstol = reltol
      endif
      
      diff = abs(expected - actual)
      if (diff .le. abstol) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
        write(*,'(A,E15.8)') '    Expected: ', expected
        write(*,'(A,E15.8)') '    Actual:   ', actual
        write(*,'(A,E15.8)') '    Diff:     ', diff
        write(*,'(A,F10.4,A)') '    RelTol:   ', reltol*100.0d0, '%'
      endif
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_EQ_INT - Assert two integers are equal
c-----------------------------------------------------------------------
      subroutine ASSERT_EQ_INT(expected, actual, msg)
      integer expected, actual
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
      if (expected .eq. actual) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
        write(*,'(A,I10)') '    Expected: ', expected
        write(*,'(A,I10)') '    Actual:   ', actual
      endif
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_TRUE - Assert a condition is true
c-----------------------------------------------------------------------
      subroutine ASSERT_TRUE(condition, msg)
      logical condition
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
      if (condition) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
      endif
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_FALSE - Assert a condition is false
c-----------------------------------------------------------------------
      subroutine ASSERT_FALSE(condition, msg)
      logical condition
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
      if (.not. condition) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
      endif
      return
      end

c-----------------------------------------------------------------------
c  ASSERT_NOERR - Assert ierr equals 0 (no error)
c-----------------------------------------------------------------------
      subroutine ASSERT_NOERR(ierr, msg)
      integer ierr
      character*(*) msg
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      ntotal = ntotal + 1
      if (ierr .eq. 0) then
        npass = npass + 1
        write(*,'(A,A)') '  [PASS] ', msg
      else
        nfail = nfail + 1
        write(*,'(A,A)') '  [FAIL] ', msg
        write(*,'(A,I6)') '    Error code: ', ierr
      endif
      return
      end

c-----------------------------------------------------------------------
c  TEST_SECTION - Print a section header
c-----------------------------------------------------------------------
      subroutine TEST_SECTION(secname)
      character*(*) secname
      
      write(*,*)
      write(*,'(A,A)') '--- ', secname
      return
      end

c-----------------------------------------------------------------------
c  TEST_SUMMARY - Print test summary and return exit code
c  Returns: iret = 0 if all passed, 1 if any failed
c-----------------------------------------------------------------------
      subroutine TEST_SUMMARY(iret)
      integer iret
      common /testcnt/ npass, nfail, ntotal
      integer npass, nfail, ntotal
      
      write(*,*)
      write(*,*) '========================================='
      write(*,'(A,I4,A,I4,A)') ' Results: ', npass, ' / ', ntotal, 
     &                         ' tests passed'
      if (nfail .gt. 0) then
        write(*,'(A,I4,A)') ' FAILED:  ', nfail, ' tests'
        write(*,*) '========================================='
        iret = 1
      else
        write(*,*) ' ALL TESTS PASSED'
        write(*,*) '========================================='
        iret = 0
      endif
      return
      end

c-----------------------------------------------------------------------
c  End of utils.FOR
c-----------------------------------------------------------------------
