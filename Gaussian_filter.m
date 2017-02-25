x = 0:1:800;
I = cos(x/100);
plot(x,I, 'g-', 'linewidth', 3)
thresh = 0.002
%Applying Gaussian Filter
Ix = imgaussfilt(I, 1.5);
figure, plot(Ix,'b-','linewidth', 3);

%Finding derivative of Gaussian
Mag = diff(Ix);
z = 1:780;
figure, plot(z, Mag(z),'r-','linewidth', 3)

%Finding double derivative test
Mag1 = diff(Mag);
% Satisfying conditions of local maxima and threshold value.
A = zeros(1,800);
 for z = 2:799
    if  Mag1(z) <0 && Mag(z) >thresh
        A(z) = 1;           
    end
 end
%Double derivative test is done to check local maxima and threshold value
%can be set to any required value and compared with the magnitude of
%derivative. Every time the condition is satisfied, 1 will be stored in the
%specific index of matrix A. Since it is a periodic function with period
%pi/2, maxima will occur at an interval of every pi/2 and thus and edge
%will occur there.