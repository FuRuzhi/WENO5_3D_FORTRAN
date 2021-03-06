subroutine set_boundary(q,x,y,z,n_x,n_y,n_z,Cv,case_id)
  implicit none
  real, dimension(n_x,n_y,n_z,5) :: q
  real,dimension(n_x,n_y,n_z) :: rho,u,v,w,E,p,a
  real, parameter :: PI = 4.0*ATAN(1.0)
  real, dimension(n_x) :: x
  real, dimension(n_y) :: y
  real, dimension(n_z) :: z
  real :: Cv, gamma=1.4
  integer :: n_x,n_y,n_z,case_id, temp,skipend=0

  call primitives(q,n_x,n_y,n_z,rho,u,v,w,E,p,a)

  select case (case_id)

  case(1)              ! Reimann Problem
    ! X-direction
    q(1,:,:,:)=q(2,:,:,:)
    q(n_x,:,:,:)=q(n_x-1,:,:,:)
    ! Y-direction
    q(:,1,:,:)=q(:,2,:,:)
    q(:,n_y,:,:)=q(:,n_y-1,:,:)
    !Z-direction
    q(:,:,1,:)=q(:,:,2,:)
    q(:,:,n_z,:)=q(:,:,n_z-1,:)
    skipend = 1

  case(2)              ! 3D Reimann
    q(1,:,:,:)=q(2,:,:,:)
    ! q(n_x,:,:,:)=q(n_x-1,:,:,:)
    ! Y-direction
    q(:,1,:,:)=q(:,2,:,:)
    ! q(:,n_y,:,:)=q(:,n_y-1,:,:)

    call primitives(q,n_x,n_y,n_z,rho,u,v,w,E,p,a)
    ! u(1,:,:) = 0.0
    ! v(:,1,:) = 0.0
    w(:,:,1) = 0.0
    w(:,:,n_z) = 0.0

    !Z-direction
    ! q(:,:,1,:)=q(:,:,2,:)
    ! q(:,:,n_z,:)=q(:,:,n_z-1,:)


    ! skipend = 1

  case(4)                 ! 2D Viscous shock tube SWBLI
    ! Symmetry
    u(:,n_y,:) = u(:,n_y-1,:)
    v(:,n_y,:) = v(:,n_y-1,:)
    p(:,n_y,:) = p(:,n_y-1,:)
    rho(:,n_y,:) = rho(:,n_y-1,:)

    ! Noslip
    u(1,:,:) = 0
    v(1,:,:) = 0
    u(n_x,:,:) = 0
    v(n_x,:,:) = 0
    u(:,1,:) = 0
    v(:,1,:) = 0

    !Adiabatic
    p(1,:,:) = (p(2,:,:)/rho(2,:,:))*rho(1,:,:)
    p(n_x,:,:) = (p(n_x-1,:,:)/rho(n_x-1,:,:))*rho(n_x,:,:)
    p(:,1,:) = (p(:,2,:)/rho(:,2,:))*rho(:,1,:)


  end select

  if(skipend==0) then
    E = p/((gamma-1.0)*rho) + 0.5*(u**2+v**2+w**2)
    q(:,:,:,1) = rho(:,:,:)
    q(:,:,:,2) = rho(:,:,:)*u(:,:,:)
    q(:,:,:,3) = rho(:,:,:)*v(:,:,:)
    q(:,:,:,4) = rho(:,:,:)*w(:,:,:)
    q(:,:,:,5) = rho(:,:,:)*E(:,:,:)
  endif




end subroutine set_boundary
